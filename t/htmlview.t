#!/usr/bin/perl -w                                         # -*- perl -*-

use strict;
use lib qw( ./lib ../lib );
use Pod::POM;
use Pod::POM::View::HTML;
use Pod::POM::Test;

ntests(2);

$Pod::POM::DEFAULT_VIEW = 'Pod::POM::View::HTML';

my $text;
{   local $/ = undef;
    $text = <DATA>;
}
my ($test, $expect) = split(/\s*-------+\s*/, $text);

my $parser = Pod::POM->new();

my $pom = $parser->parse_text($test);

assert( $pom );

my $result = "$pom";

for ($result, $expect) {
    s/^\s*//;
    s/\s*$//;
}

match($result, $expect);
#print $pom;

__DATA__
=head1 NAME

Test

=head1 SYNOPSIS

    use My::Module;

    my $module = My::Module->new();

=head1 DESCRIPTION

This is the description.

    Here is a verbatim section.

This is some more regular text.

Here is some B<bold> text, some I<italic> and something that looks 
like an E<lt>htmlE<gt> tag.  This is some C<$code($arg1)>.

This C<text contains embedded B<bold> and I<italic> tags>.  These can 
be nested, allowing B<bold and I<bold E<amp> italic> text>.  The module also
supports the extended B<< syntax >> and permits I<< nested tags E<amp>
other B<<< cool >>> stuff >>

=head1 METHODS =E<gt> OTHER STUFF

Here is a list of methods

=head2 new()

Constructor method.  Accepts the following config options:

=over 4

=item foo

The foo item.

=item bar

The bar item.

=over 4

This is a list within a list 

=item *

The wiz item.

=item *

The waz item.

=back

=item baz

The baz item.

=back

=head2 old()

Destructor method

=head1 TESTING FOR AND BEGIN

=for html    <br>
<p>
blah blah
</p>

intermediate text

=begin html

<more>
HTML
</more>

some text

=end

=head1 SEE ALSO

See also L<pod2|Test Page 2>, L<Your::Module>, 
L<Their::Module> and the other interesting file 
F</usr/local/my/module/rocks> as well.

=cut

------------------------------------------------------------------------

<html><body bgcolor="#ffffff">
<h1>NAME</h1>

<p>Test</p>
<h1>SYNOPSIS</h1>

<pre>    use My::Module;</pre>

<pre>    my $module = My::Module-&gt;new();</pre>

<h1>DESCRIPTION</h1>

<p>This is the description.</p>
<pre>    Here is a verbatim section.</pre>

<p>This is some more regular text.</p>
<p>Here is some <b>bold</b> text, some <i>italic</i> and something that looks 
like an &lt;html&gt; tag.  This is some '<code>$code($arg1)</code>'.</p>
<p>This '<code>text contains embedded <b>bold</b> and <i>italic</i> tags</code>'.  These can 
be nested, allowing <b>bold and <i>bold &amp; italic</i> text</b>.  The module also
supports the extended <b>syntax</b> and permits <i>nested tags &amp;
other <b>cool</b> stuff</i></p>
<h1>METHODS =&gt; OTHER STUFF</h1>

<p>Here is a list of methods</p>
<h2>new()</h2>
<p>Constructor method.  Accepts the following config options:</p>
<ul>
<li><b>foo</b>
<p>The foo item.</p>
</li>
<li><b>bar</b>
<p>The bar item.</p>
<ul>
<p>This is a list within a list </p>
<li><p>The wiz item.</p>
</li>
<li><p>The waz item.</p>
</li>
</ul>
</li>
<li><b>baz</b>
<p>The baz item.</p>
</li>
</ul>
<h2>old()</h2>
<p>Destructor method</p>
<h1>TESTING FOR AND BEGIN</h1>

<br>
<p>
blah blah
</p>

<p>intermediate text</p>
<p><more>
HTML
</more></p>
<p>some text</p>
<h1>SEE ALSO</h1>

<p>See also Test Page 2, the Your::Module manpage, 
the Their::Module manpage and the other interesting file 
/usr/local/my/module/rocks as well.</p>
</body></html>

