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
#   $Id$
#
#========================================================================

package Pod::POM::View::HTML;

require 5.004;

use strict;
use Pod::POM::View;
use base qw( Pod::POM::View );
use vars qw( $VERSION $DEBUG $ERROR $AUTOLOAD );
use Text::Wrap;

$VERSION = sprintf("%d.%02d", q$Revision$ =~ /(\d+)\.(\d+)/);
$DEBUG   = 0 unless defined $DEBUG;


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
    return "<h2>$title</h2>\n"
	. "<ul>\n" 
	. $head1->content->present($self)
	. "</ul>\n";
}

sub view_head2 {
    my ($self, $head2) = @_;
    my $title = $head2->title->present($self);
    return "<h3>$title</h3>\n"
	. $head2->content->present($self);
}

sub view_over {
    my ($self, $over) = @_;
    return "<ul>\n"
	. $over->content->present($self)
        . "</ul>\n";
}

sub view_item {
    my ($self, $item) = @_;
    my $title = $item->title();
    $title = '<b>' . $title->present($self) . "</b>\n"
	if $title;
    return "<li>$title\n"
	. $item->content->present($self);
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
    return $begin->content->present($self);
}
    
sub view_textblock {
    my ($self, $text) = @_;
    return "<p>$text</p>\n";
}

sub view_verbatim {
    my ($self, $text) = @_;
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
    return "'<code>$text</code>'";
}

sub view_seq_space {
    my ($self, $text) = @_;
    $text =~ s/\s/&nbsp;/g;
    return $text;
}

#my $entities = {
#    gt   => '>',
#    lt   => '<',
#    amp  => '&',
#    quot => '"',
#};

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
	
    

1;




