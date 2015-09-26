# ABSTRACT: Scalar Object Role for Perl 5
package Data::Object::Role::Scalar;

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
    Data::Object::Role::Value
);

# VERSION

method defined () {

    return 1;

}

method eq {

    $self->throw("The eq() comparison operation is not supported");

    return;

}

method gt {

    $self->throw("The gt() comparison operation is not supported");

    return;

}

method ge {

    $self->throw("The ge() comparison operation is not supported");

    return;

}

method lt {

    $self->throw("The lt() comparison operation is not supported");

    return;

}

method le {

    $self->throw("The le() comparison operation is not supported");

    return;

}

method ne {

    $self->throw("The ne() comparison operation is not supported");

    return;

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Scalar;

=cut

=head1 DESCRIPTION

Data::Object::Role::Scalar provides routines for operating on Perl 5 scalar
objects.

=cut

=head1 ROLES

This package is comprised of the following roles.

=over 4

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

    # given $scalar

    $scalar->data; # original value

The data method returns the original and underlying value contained by the
object. This method is an alias to the detract method.

=cut

=method defined

    # given $scalar

    $scalar->defined; # 1

The defined method returns true if the object represents a value that meets the
criteria for being defined, otherwise it returns false. This method returns a
number object.

=cut

=method detract

    # given $scalar

    $scalar->detract; # original value

The detract method returns the original and underlying value contained by the
object.

=cut

=method dump

    # given $scalar

    $scalar->dump;

The dump method returns returns a string representation of the object.
This method returns a string value.

=cut

=method eq

    # given $scalar

    $scalar->eq; # exception thrown

This method is a consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method ge

    # given $scalar

    $scalar->ge; # exception thrown

This method is a consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method gt

    # given $scalar

    $scalar->gt; # exception thrown

This method is a consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method le

    # given $scalar

    $scalar->le; # exception thrown

This method is a consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method lt

    # given $scalar

    $scalar->lt; # exception thrown

This method is a consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method methods

    # given $scalar

    $scalar->methods;

The methods method returns the list of methods attached to object. This method
returns an array value.

=cut

=method ne

    # given $scalar

    $scalar->ne; # exception thrown

This method is a consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method new

    # given \12345

    my $scalar = Data::Object::Scalar->new(\12345);

The new method expects a scalar reference and returns a new class instance.

=cut

=method print

    # given $scalar

    $scalar->print;

The print method outputs the value represented by the object to STDOUT and
returns true. This method returns a number value.

=cut

=method roles

    # given $scalar

    $scalar->roles;

The roles method returns the list of roles attached to object. This method
returns an array value.

=cut

=method say

    # given $scalar

    $scalar->say;

The say method outputs the value represented by the object appended with a
newline to STDOUT and returns true. This method returns a L<Data::Object::Number>
object.

=cut

=method throw

    # given $scalar

    $scalar->throw;

The throw method terminates the program using the core die keyword, passing the
object to the L<Data::Object::Exception> class as the named parameter C<object>.
If captured this method returns an exception value.

=cut

=method type

    # given $scalar

    $scalar->type; # SCALAR

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

L<Data::Object::Library>

=item *

L<Data::Object::Prototype>

=item *

L<Data::Object::Signatures>

=back

=cut

