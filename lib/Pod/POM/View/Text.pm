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
#   $Id$
#
#========================================================================

package Pod::POM::View::Text;

require 5.004;

use strict;
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

sub view_head1 {
    my ($self, $head1) = @_;
    my $title = $head1->title->present($self);
    return "$title\n" 
	. wrap('    ', '    ', $head1->content->present($self));
}

sub view_head2 {
    my ($self, $head2) = @_;
    my $title = $head2->title->present($self);
    return "$title\n"
	. wrap('    ', '    ', $head2->content->present($self));
}

sub view_item {
    my ($self, $item) = @_;
    return '* ' 
	. $item->title->present($self) 
	. "\n\n"
	. wrap('  ', '  ', $item->content->present($self));
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
    return wrap('', '', $text) . "\n\n";
}

sub view_verbatim {
    my ($self, $text) = @_;
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




