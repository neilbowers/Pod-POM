#============================================================= -*-Perl-*-
#
# Pod::POM::View::Text
#
# DESCRIPTION
#   Text view of a Pod Object Model.
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
#   $Id: Text.pm,v 1.2 2002/01/31 09:04:41 abw Exp $
#
#========================================================================

package Pod::POM::View::Text;

require 5.004;

use strict;
use Pod::POM::View;
use base qw( Pod::POM::View );
use vars qw( $VERSION $DEBUG $ERROR $AUTOLOAD $INDENT );
use Text::Wrap;

$VERSION = sprintf("%d.%02d", q$Revision: 1.2 $ =~ /(\d+)\.(\d+)/);
$DEBUG   = 0 unless defined $DEBUG;
$INDENT  = 0;


sub new {
    my $class = shift;
    my $args  = ref $_[0] eq 'HASH' ? shift : { @_ };
    bless { 
	INDENT => 0,
	%$args,
    }, $class;
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


sub view_head1 {
    my ($self, $head1) = @_;
    my $indent = ref $self ? \$self->{ INDENT } : \$INDENT;
    my $pad = ' ' x $$indent;
    my $title = wrap($pad, $pad, 
		     $head1->title->present($self));
    
    $$indent += 4;
    my $output = "$title\n" . $head1->content->present($self);
    $$indent -= 4;

    return $output;
}


sub view_head2 {
    my ($self, $head2) = @_;
    my $indent = ref $self ? \$self->{ INDENT } : \$INDENT;
    my $pad = ' ' x $$indent;
    my $title = wrap($pad, $pad, 
		     $head2->title->present($self));

    $$indent += 4;
    my $output = "$title\n" . $head2->content->present($self);
    $$indent -= 4;

    return $output;
}


sub view_head3 {
    my ($self, $head3) = @_;
    my $indent = ref $self ? \$self->{ INDENT } : \$INDENT;
    my $pad = ' ' x $$indent;
    my $title = wrap($pad, $pad, 
		     $head3->title->present($self));

    $$indent += 4;
    my $output = "$title\n" . $head3->content->present($self);
    $$indent -= 4;

    return $output;
}


sub view_head4 {
    my ($self, $head4) = @_;
    my $indent = ref $self ? \$self->{ INDENT } : \$INDENT;
    my $pad = ' ' x $$indent;
    my $title = wrap($pad, $pad, 
		     $head4->title->present($self));

    $$indent += 4;
    my $output = "$title\n" . $head4->content->present($self);
    $$indent -= 4;

    return $output;
}


sub view_item {
    my ($self, $item) = @_;
    my $indent = ref $self ? \$self->{ INDENT } : \$INDENT;
    my $pad = ' ' x $$indent;
    my $title = wrap($pad . '* ', $pad . '  ', 
		     $item->title->present($self));

    $$indent += 2;
    my $content = $item->content->present($self);
    $$indent -= 2;
    
    return "$title\n\n$content";
}


sub view_for {
    my ($self, $for) = @_;
    return '' unless $for->format() =~ /\btext\b/;
    return $for->text()
	. "\n\n";
}

    
sub view_begin {
    my ($self, $begin) = @_;
    return '' unless $begin->format() =~ /\btext\b/;
    return $begin->content->present($self);
}

    
sub view_textblock {
    my ($self, $text) = @_;
    my $indent = ref $self ? \$self->{ INDENT } : \$INDENT;
    $text =~ s/\s+/ /mg;

    $$indent ||= 0;
    my $pad = ' ' x $$indent;
    return wrap($pad, $pad, $text) . "\n\n";
}


sub view_verbatim {
    my ($self, $text) = @_;
    my $indent = ref $self ? \$self->{ INDENT } : \$INDENT;
    my $pad = ' ' x $$indent;
    $text =~ s/^/$pad/mg;
    return "$text\n\n";
}


sub view_seq_bold {
    my ($self, $text) = @_;
    return "*$text*";
}


sub view_seq_italic {
    my ($self, $text) = @_;
    return "_${text}_";
}


sub view_seq_code {
    my ($self, $text) = @_;
    return "'$text'";
}


my $entities = {
    gt   => '>',
    lt   => '<',
    amp  => '&',
    quot => '"',
};


sub view_seq_entity {
    my ($self, $entity) = @_;
    return $entities->{ $entity } || $entity;
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




