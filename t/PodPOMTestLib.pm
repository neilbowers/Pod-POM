# $Id: TestUtils.pm 4100 2009-02-25 22:20:47Z andrew $

package PodPOMTestLib;

use strict;
use vars qw(@EXPORT);

use base 'Exporter';

use Pod::POM;
use Test::More;
use Test::Differences;
use File::Slurp;
use YAML::Any;

# use Data::Dumper; # for debugging


@EXPORT = qw(run_tests get_tests);


#------------------------------------------------------------------------
# run_tests()
#
# Runs all the tests of the specified type/subtype (e.g. Pom => 'dump', 
# or View => $view
#------------------------------------------------------------------------

sub run_tests {
    my ($type, $subtype) = @_;
    my $view;

    my @tests = get_tests(@_);

    my $pod_parser = Pod::POM->new();

    if (lc $type eq 'view') {
        $view = "Pod::POM::View::$subtype";
        eval "use $view;";
        if ($@) {
            plan skip_all => "couldn't load $view";
            exit(0);
        }
    }

    plan tests => int @tests;

    foreach my $test (@tests) {
      TODO:
        eval {
            local $TODO;
            $TODO = $test->options->{todo} || '';

            my $pom    = $pod_parser->parse_text($test->input);
            my $result = $view ? $pom->present($view) : $pom->dump;

            eq_or_diff $result, $test->expect, $test->title;
        };
        if ($@) {
            fail($test->title);
        }
    }
}

#------------------------------------------------------------------------
# get_tests()
#
# Finds all the tests of the specified type/subtype
#------------------------------------------------------------------------

sub get_tests {
    my ($type, $subtype) = @_;
    (my $testcasedir = $0) =~ s{([^/]+)\.t}{testcases/};
    my (@tests, $testno);

    my $expect_ext = $type;
    $expect_ext .= "-$subtype" if $subtype;
    $expect_ext = lc $expect_ext;

    foreach my $podfile (sort <$testcasedir/*.pod>) {
	$testno++;
	(my $basepath = $podfile) =~ s/\.pod$//;
        (my $basename = $basepath) =~ s{.*/}{};
	next unless -f "${basepath}.$expect_ext";
	my ($title, $options);
	my $podtext = read_file($podfile);
	my $expect  = read_file("${basepath}.$expect_ext");

        # fetch options from YAML files - need to work out semantics

	if (my $ymltext = -f "${basepath}.yml" && read_file("${basepath}.yml")) {
	    my $data = Load $ymltext;
	    $title   = $data->{title};
            if (exists $data->{$expect_ext}) {
                $options = $data->{$expect_ext};
            }
        }
        
        push @tests, PodPOMTestCase->new( { input   => $podtext,
                                            options => $options || {},
                                            expect  => $expect,
                                            title   => $title || $basename } );

    }

    return @tests;
}

1;

package PodPOMTestCase;
use strict;
use base 'Class::Accessor';

__PACKAGE__->mk_accessors( qw(input options expect title) );

1;
