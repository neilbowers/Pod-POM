use 5.005;
use inc::Module::Install;

my %opts = (
    'NAME'	   => 'Pod::POM',
    'VERSION_FROM' => 'lib/Pod/POM.pm',
    'EXE_FILES'    => [ 'bin/pom2', 'bin/podlint', 'bin/pomdump' ],
    'PREREQ_PM'    => { 
        'Text::Wrap' => 0,

        # Required for testing
        'File::Slurp'       => 0,
        'Test::More'        => 0,
        'Test::Differences' => 0,
        'YAML::Any'         => 0,
    },
    'dist'         => {
	'COMPRESS' => 'gzip',
	'SUFFIX'   => 'gz',
    },
);

if ($ExtUtils::MakeMaker::VERSION >= 5.43) {
    $opts{ AUTHOR }   = 'Andy Wardley <abw@kfs.org>';
    $opts{ ABSTRACT } = 'POD Object Model',
}

if ($ExtUtils::MakeMaker::VERSION >= 6.31) {
    $opts{ LICENSE } = 'perl';
} 

if ($ExtUtils::MakeMaker::VERSION >= 6.48) {
    $opts{ MIN_PERL_VERSION } = '5.005';
}

WriteMakefile( %opts );

