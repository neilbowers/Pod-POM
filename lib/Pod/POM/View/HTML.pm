#============================================================= -*-Perl-*-
#
# Pod::POM::View::HTML
#
# DESCRIPTION
#   HTML view of a Pod Object Model.
#
# AUTHOR
#   Andy Wardley   <abw@kfs.org>
#
# COPYRIGHT
#   Copyright (C) 2000 Andy Wardley.  All Rights Reserved.
#
#   This module is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
# REVISION
#   $Id: HTML.pm,v 1.4 2002/02/06 16:45:23 abw Exp $
#
#========================================================================

package Pod::POM::View::HTML;

require 5.004;

use strict;
use Pod::POM::View;
use base qw( Pod::POM::View );
use vars qw( $VERSION $DEBUG $ERROR $AUTOLOAD );
use Text::Wrap;

$VERSION = sprintf("%d.%02d", q$Revision: 1.4 $ =~ /(\d+)\.(\d+)/);
$DEBUG   = 0 unless defined $DEBUG;
my $HTML_PROTECT = 0;
my @OVER;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_)
	|| return;

    # initalise stack for maintaining info for nested lists
    $self->{ OVER } = [];

    return $self;
}


sub view {
    my ($self, $type, $item) = @_;

    if ($type =~ s/^seq_//) {
	return $item;
    }
    elsif (UNIVERSAL::isa($item, 'HASH')) {
	if (defined $item->{ content }) {
	    return $item->{ content }->present($self);
	}
	elsif (defined $item->{ text }) {
	    my $text = $item->{ text };
	    return ref $text ? $text->present($self) : $text;
	}
	else {
	    return '';
	}
    }
    elsif (! ref $item) {
	return $item;
    }
    else {
	return '';
    }
}


sub view_pod {
    my ($self, $pod) = @_;
    return "<html><body bgcolor=\"#ffffff\">\n"
 	. $pod->content->present($self)
        . "</body></html>\n";
}


sub view_head1 {
    my ($self, $head1) = @_;
    my $title = $head1->title->present($self);
    return "<h1>$title</h1>\n\n"
	. $head1->content->present($self);
}


sub view_head2 {
    my ($self, $head2) = @_;
    my $title = $head2->title->present($self);
    return "<h2>$title</h2>\n"
	. $head2->content->present($self);
}


sub view_head3 {
    my ($self, $head3) = @_;
    my $title = $head3->title->present($self);
    return "<h3>$title</h3>\n"
	. $head3->content->present($self);
}


sub view_head4 {
    my ($self, $head4) = @_;
    my $title = $head4->title->present($self);
    return "<h4>$title</h4>\n"
	. $head4->content->present($self);
}


sub view_over {
    my ($self, $over) = @_;
    my ($start, $end, $strip);

    my $items = $over->item();
    return "" unless @$items;

    my $first_title = $items->[0]->title();

    if ($first_title =~ /^\s*\*\s*/) {
	# '=item *' => <ul>
	$start = "<ul>\n";
	$end   = "</ul>\n";
	$strip = qr/^\s*\*\s*/;
    }
    elsif ($first_title =~ /^\s*\d+\.?\s*/) {
	# '=item 1.' or '=item 1 ' => <ol>
	$start = "<ol>\n";
	$end   = "</ol>\n";
	$strip = qr/^\s*\d+\.?\s*/;
    }
    else {
	$start = "<ul>\n";
	$end   = "</ul>\n";
	$strip = '';
    }

    my $overstack = ref $self ? $self->{ OVER } : \@OVER;
    push(@$overstack, $strip);
    my $content = $over->content->present($self);
    pop(@$overstack);
    
    return $start
	 . $content
         . $end;
}


sub view_item {
    my ($self, $item) = @_;

    my $over  = ref $self ? $self->{ OVER } : \@OVER;
    my $title = $item->title();
    my $strip = $over->[-1];

    if (defined $title) {
        $title = $title->present($self) if ref $title;
        $title =~ s/$strip// if $strip;
        $title = "<b>$title</b>\n" if $title;
    }

    return '<li>'
	 . $title
	 . $item->content->present($self)
         . "</li>\n";
}


sub view_for {
    my ($self, $for) = @_;
    return '' unless $for->format() =~ /\bhtml\b/;
    return $for->text()
	. "\n\n";
}
    

sub view_begin {
    my ($self, $begin) = @_;
    return '' unless $begin->format() =~ /\bhtml\b/;
    $HTML_PROTECT++;
    my $output = $begin->content->present($self);
    $HTML_PROTECT--;
    return $output;
}
    

sub view_textblock {
    my ($self, $text) = @_;
    return "<p>$text</p>\n";
}


sub view_verbatim {
    my ($self, $text) = @_;
    for ($text) {
	s/&/&amp;/g;
	s/</&lt;/g;
	s/>/&gt;/g;
    }
    return "<pre>$text</pre>\n\n";
}


sub view_seq_bold {
    my ($self, $text) = @_;
    return "<b>$text</b>";
}


sub view_seq_italic {
    my ($self, $text) = @_;
    return "<i>$text</i>";
}


sub view_seq_code {
    my ($self, $text) = @_;
    return "<code>$text</code>";
}


sub view_seq_space {
    my ($self, $text) = @_;
    $text =~ s/\s/&nbsp;/g;
    return $text;
}


sub view_seq_entity {
    my ($self, $entity) = @_;
    return "&$entity;"
}


sub view_seq_link {
    my ($self, $link) = @_;
    if ($link =~ s/^.*?\|//) {
	return $link;
    }
    else {
	return "the $link manpage";
    }
}

# this code has been borrowed from Pod::Html
my $urls = '(' . join ('|', 
    qw{
      http
      telnet
      mailto
      news
      gopher
      file
      wais
      ftp
    } ) . ')';	
my $ltrs = '\w';
my $gunk = '/#~:.?+=&%@!\-';
my $punc = '.:?\-';
my $any  = "${ltrs}${gunk}${punc}";

sub view_seq_text {
    my ($self, $text) = @_;

    unless ($HTML_PROTECT) {
	for ($text) {
	    s/&/&amp;/g;
	    s/</&lt;/g;
	    s/>/&gt;/g;
	}
    }

    $text =~  s{
        \b                          # start at word boundary
        (                           # begin $1  {
          $urls     :               # need resource and a colon
	  (?!:)                     # Ignore File::, among others.
          [$any] +?                 # followed by on or more
                                    #  of any valid character, but
                                    #  be conservative and take only
                                    #  what you need to....
        )                           # end   $1  }
        (?=                         # look-ahead non-consumptive assertion
                [$punc]*            # either 0 or more puntuation
                [^$any]             #   followed by a non-url char
            |                       # or else
                $                   #   then end of the string
        )
      }{<a href="$1">$1</a>}igox;

    return $text;
}

1;




