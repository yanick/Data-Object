# ABSTRACT: Regexp Object Role for Perl 5
package Data::Object::Role::Regexp;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Role;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

map with($_), our @ROLES = qw(
    Data::Object::Role::Item
    Data::Object::Role::Alphabetic
    Data::Object::Role::Value
);

# VERSION

method defined () {

    return 1;

}

method search ($string, $flags) {

    my $captures;
    my @matches;

    my $result = "$self";
    my $op     = '$string =~ m/$result/';
    my $capt   = '$captures = (' . $op . ($flags // '') . ')';
    my $mtch   = '@matches  = ([@-], [@+], {%-})';
    my $expr   = join ';', $capt, $mtch;

    my $error = do { local $@; eval $expr; $@ };

    Data::Object::throw($error) if $error;

    return [$result, $string, $captures, @matches, $string];

}

method replace ($string, $replacement, $flags) {

    my $captures;
    my @matches;

    my $result = "$self";
    my $op     = '$string =~ s/$result/$replacement/';
    my $capt   = '$captures = (' . $op . ($flags // '') . ')';
    my $mtch   = '@matches  = ([@-], [@+], {%-})';
    my $expr   = join ';', $capt, $mtch;

    my $initial = $string;

    my $error = do { local $@; eval $expr; $@ };

    Data::Object::throw($error) if $error;

    return [$result, $string, $captures, @matches, $initial];

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Regexp;

=cut

=head1 DESCRIPTION

Data::Object::Role::Regexp provides routines for operating on Perl 5 regular
expressions.

=cut

=head1 ROLES

This package is comprised of the following roles.

=over 4

=item *

L<Data::Object::Role::Alphabetic>

=item *

L<Data::Object::Role::Comparison>

=item *

L<Data::Object::Role::Defined>

=item *

L<Data::Object::Role::Detract>

=item *

L<Data::Object::Role::Dumper>

=item *

L<Data::Object::Role::Item>

=item *

L<Data::Object::Role::Output>

=item *

L<Data::Object::Role::Throwable>

=item *

L<Data::Object::Role::Type>

=item *

L<Data::Object::Role::Value>

=back

=cut

=method data

    # given $regexp

    $regexp->data; # original value

The data method returns the original and underlying value contained by the
object. This method is an alias to the detract method.

=cut

=method defined

    # given $regexp

    $regexp->defined; # 1

The defined method returns true if the object represents a value that meets the
criteria for being defined, otherwise it returns false. This method returns a
number object.

=cut

=method detract

    # given $regexp

    $regexp->detract; # original value

The detract method returns the original and underlying value contained by the
object.

=cut

=method dump

    # given qr(test)

    $regexp->dump; # qr/(?^u:test)/

The dump method returns returns a string representation of the object.
This method returns a string value.

=cut

=method eq

    # given qr(test)

    $regexp->eq(qr(test)); # 1

The eq method returns true if the argument provided is equal to the value
represented by the object. This method returns a number value.

=cut

=method ge

    # given qr(test)

    $regexp->ge(qr(test)); # 1

The ge method returns true if the argument provided is greater-than or equal-to
the value represented by the object. This method returns a Data::Object::Number
object.

=cut

=method gt

    # given qr(test)

    $regexp->gt(qr(test)); # 0

The gt method returns true if the argument provided is greater-than the value
represented by the object. This method returns a number value.

=cut

=method le

    # given qr(test)

    $regexp->le(qr(test)); # 1

The le method returns true if the argument provided is less-than or equal-to
the value represented by the object. This method returns a Data::Object::Number
object.

=cut

=method lt

    # given qr(test)

    $regexp->lt(qr(test)); # 0

The lt method returns true if the argument provided is less-than the value
represented by the object. This method returns a number value.

=cut

=method methods

    # given $regexp

    $regexp->methods;

The methods method returns the list of methods attached to object. This method
returns an array value.

=cut

=method ne

    # given qr(test)

    $regexp->ne(qr(test)); # 1

The ne method returns true if the argument provided is not equal to the value
represented by the object. This method returns a number value.

=cut

=method new

    # given qr(something to match against)

    my $re = Data::Object::Regexp->new(qr(something to match against));

The new method expects a regular-expression object and returns a new class
instance.

=cut

=method print

    # given qr(test)

    $regexp->print; # 'qr/(?^u:test)/'

The print method outputs the value represented by the object to STDOUT and
returns true. This method returns a number value.

=cut

=method replace

    # given qr(test)

    $re->replace('this is a test', 'drill');
    $re->replace('test 1 test 2 test 3', 'drill', 'gi');

The replace method performs a regular expression substitution on the given
string. The first argument is the string to match against.  The second argument
is the replacement string.  The optional third argument might be a string
representing flags to append to the s///x operator, such as 'g' or 'e'.  This
method will always return a regexp::Result object which can be
used to introspect the result of the operation.

=cut

=method roles

    # given $regexp

    $regexp->roles;

The roles method returns the list of roles attached to object. This method
returns an array value.

=cut

=method say

    # given qr(test)

    $regexp->say; # 'qr/(?^u:test)/\n'

The say method outputs the value represented by the object appended with a
newline to STDOUT and returns true. This method returns a L<Data::Object::Number>
object.

=cut

=method search

    # given qr((test))

    $re->search('this is a test');
    $re->search('this does not match', 'gi');

The search method performs a regular expression match against the given string
This method will always return a regexp::Result object which
can be used to introspect the result of the operation.

=cut

=method throw

    # given $regexp

    $regexp->throw;

The throw method terminates the program using the core die keyword, passing the
object to the L<Data::Object::Exception> class as the named parameter C<object>.
If captured this method returns an exception value.

=cut

=method type

    # given $regexp

    $regexp->type; # REGEXP

The type method returns a string representing the internal data type object name.
This method returns a string value.

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object::Array>

=item *

L<Data::Object::Class>

=item *

L<Data::Object::Class::Syntax>

=item *

L<Data::Object::Code>

=item *

L<Data::Object::Float>

=item *

L<Data::Object::Hash>

=item *

L<Data::Object::Integer>

=item *

L<Data::Object::Number>

=item *

L<Data::Object::Role>

=item *

L<Data::Object::Role::Syntax>

=item *

L<Data::Object::Regexp>

=item *

L<Data::Object::Scalar>

=item *

L<Data::Object::String>

=item *

L<Data::Object::Undef>

=item *

L<Data::Object::Universal>

=item *

L<Data::Object::Autobox>

=item *

L<Data::Object::Immutable>

=item *

L<Data::Object::Library>

=item *

L<Data::Object::Prototype>

=item *

L<Data::Object::Signatures>

=back

=cut

