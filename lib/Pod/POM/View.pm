#============================================================= -*-Perl-*-
#
# Pod::POM::View
#
# DESCRIPTION
#   Visitor class for creating a view of all or part of a Pod Object 
#   Model.
#
# AUTHOR
#   Andy Wardley   <abw@kfs.org>
#
# COPYRIGHT
#   Copyright (C) 2000, 2001 Andy Wardley.  All Rights Reserved.
#
#   This module is free software; you can redistribute it and/or
#   modify it under the same terms as Perl itself.
#
# REVISION
#   $Id$
#
#========================================================================

package Pod::POM::View;

require 5.004;

use strict;
use vars qw( $VERSION $DEBUG $ERROR $AUTOLOAD );

$VERSION = sprintf("%d.%02d", q$Revision: 1.1.1.1 $ =~ /(\d+)\.(\d+)/);
$DEBUG   = 0 unless defined $DEBUG;


#------------------------------------------------------------------------
# new($pom)
#------------------------------------------------------------------------

sub new {
    my $class = shift;
    my $args  = ref $_[0] eq 'HASH' ? shift : { @_ };
    bless { %$args }, $class;
}


sub print {
    my ($self, $item) = @_;
    return UNIVERSAL::can($item, 'present')
	? $item->present($self) : $item;
}
    

sub view {
    my ($self, $type, $node) = @_;
    return $node;
}


sub AUTOLOAD {
    my $self = shift;
    my $name = $AUTOLOAD;
    my $item;

    $name =~ s/.*:://;
    return if $name eq 'DESTROY';

#    my ($pkg, $file, $line) = caller;
#    print STDERR "called AUTOLOAD $name from $file line $line\n";

    if ($name =~ s/^view_//) {
	return $self->view($name, @_);
    }
    elsif (! ref $self) {
	die "can't access $name in $self\n";
    }
    else {
	die "no such method for $self: $name ($AUTOLOAD)"
	    unless defined ($item = $self->{ $name });

	return wantarray ? ( ref $item eq 'ARRAY' ? @$item : $item ) : $item;
    }
}


1;




