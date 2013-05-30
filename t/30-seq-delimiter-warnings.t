#!/usr/bin/perl

use Test::More tests => 1;
use Pod::POM qw();

my $parser = Pod::POM->new;

diag "checking [rt.cpan.org #48812]";
my $pom = $parser->parse_text('=head2 clone

C<< $obj->clone >> makes a deep copy of the object.');

TODO: {
    local $TODO = 'known parser bug';

    ok !$parser->warnings, q(should not emit warning "expected '>>' not '>'");
}

exit(0);
