#============================================================= -*-Perl-*-
#
# Pod::POM::View::Pod
#
# DESCRIPTION
#   Pod view of a Pod Object Model.
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
#   $Id: Pod.pm,v 1.2 2002/01/31 09:04:41 abw Exp $
#
#========================================================================

package Pod::POM::View::Pod;

require 5.004;

use strict;
use Pod::POM::Nodes;
use Pod::POM::View;
use base qw( Pod::POM::View );
use vars qw( $VERSION $DEBUG $ERROR $AUTOLOAD $MARKUP );

$VERSION = sprintf("%d.%02d", q$Revision: 1.2 $ =~ /(\d+)\.(\d+)/);
$DEBUG   = 0 unless defined $DEBUG;

# create reverse lookup table mapping method name to original sequence
$MARKUP = {
    map { ( $Pod::POM::Node::Sequence::NAME{ $_ } => $_ ) } 
       keys %Pod::POM::Node::Sequence::NAME,
};


sub view {
    my ($self, $type, $item) = @_;

#    my ($pkg, $file, $line) = caller;
#    print STDERR "called view ($type) from $file line $line\n";

    if ($type =~ s/^seq_//) {
	if ($type eq 'text') {
	    return "$item";
	}
	if ($type = $MARKUP->{ $type }) {
	    return "$type<$item>";
	}
    }
    elsif (ref $item eq 'HASH') {
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
#    return "=pod\n\n" . $pod->content->present($self) . "=cut\n\n";
    return $pod->content->present($self);
}


sub view_head1 {
    my ($self, $head1) = @_;
    return '=head1 ' 
	. $head1->title->present($self) 
	. "\n\n"    
	. $head1->content->present($self);
}


sub view_head2 {
    my ($self, $head2) = @_;
    return '=head2 ' 
	. $head2->title->present($self) 
	. "\n\n" 
	. $head2->content->present($self);
}


sub view_head3 {
    my ($self, $head3) = @_;
    return '=head3 ' 
	. $head3->title->present($self) 
	. "\n\n" 
	. $head3->content->present($self);
}


sub view_head4 {
    my ($self, $head4) = @_;
    return '=head4 ' 
	. $head4->title->present($self) 
	. "\n\n" 
	. $head4->content->present($self);
}


sub view_over {
    my ($self, $over) = @_;
    return '=over ' 
	. $over->indent() 
	. "\n\n" 
	. $over->content->present($self) 
	. "=back\n\n";
}


sub view_item {
    my ($self, $item) = @_;
    return '=item ' 
	. $item->title->present($self) 
	. "\n\n"
	. $item->content->present($self);
}

sub view_for {
    my ($self, $for) = @_;
    return '=for ' 
	. $for->format . ' ' 
	. $for->text() 
	. "\n\n"
	. $for->content->present($self);
}
    

sub view_begin {
    my ($self, $begin) = @_;
    return '=begin ' 
	. $begin->format() 
	. "\n\n"
	. $begin->content->present($self)
        . "=end\n\n";
}
    

sub view_textblock {
    my ($self, $text) = @_;
    return "$text\n\n";
}


sub view_verbatim {
    my ($self, $text) = @_;
    return "$text\n\n";
}


sub view_meta {
    my ($self, $meta) = @_;
    return '=meta '
	. $meta->name()
	. "\n\n"
	. $meta->content->present($self)
        . "=end\n\n";
}


1;




