#============================================================= -*-Perl-*-
#
# Pod::POM::Constants
#
# DESCRIPTION
#   Constants used by Pod::POM.
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
#   $Id: Constants.pm,v 1.1.1.1 2001/05/17 08:49:34 abw Exp $
#
#========================================================================

package Pod::POM::Constants;

require 5.004;

use strict;
use vars qw( $VERSION @SEQUENCE @STATUS @EXPORT_OK %EXPORT_TAGS );
use base qw( Exporter );

$VERSION   = sprintf("%d.%02d", q$Revision: 1.1.1.1 $ =~ /(\d+)\.(\d+)/);
@SEQUENCE  = qw( CMD LPAREN RPAREN FILE LINE CONTENT );
@STATUS    = qw( IGNORE REDUCE REJECT );
@EXPORT_OK = ( @SEQUENCE, @STATUS );
%EXPORT_TAGS = ( 
    status => [ @STATUS ], 
    seq    => [ @SEQUENCE ],
    all    => [ @STATUS, @SEQUENCE ], 
);

# sequence items
use constant CMD     => 0;
use constant LPAREN  => 1;
use constant RPAREN  => 2;
use constant FILE    => 3;
use constant LINE    => 4;
use constant CONTENT => 5;

# node add return values
use constant IGNORE => 0;
use constant REDUCE => 1;
use constant REJECT => 2;


1;
