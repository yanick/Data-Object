# ABSTRACT: Universal Object Role for Perl 5
package Data::Object::Role::Universal;

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

    use Data::Object::Role::Universal;

=cut

=head1 DESCRIPTION

Data::Object::Role::Universal provides routines for operating on any Perl 5
data types.

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

    # given $object

    $object->data; # original value

The data method returns the original and underlying value contained by the
object. This method is an alias to the detract method.

=cut

=method defined

    # given $object

    $object->defined; # 1

The defined method returns true if the object represents a value that meets the
criteria for being defined, otherwise it returns false. This method returns a
number object.

=cut

=method detract

    # given $object

    $object->detract; # original value

The detract method returns the original and underlying value contained by the
object.

=cut

=method dump

    # given 0

    $object->dump; # 0

The dump method returns returns a string string representation of the object.
This method returns a string object.

=cut

=method eq

    # given $object

    $object->eq; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method ge

    # given $object

    $object->ge; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method gt

    # given $object

    $object->gt; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method le

    # given $object

    $object->le; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method lt

    # given $object

    $object->lt; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method methods

    # given $object

    $object->methods;

The methods method returns the list of methods attached to object. This method
returns an array object.

=cut

=method ne

    # given $object

    $object->ne; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method new

    # given $scalar

    my $object = Data::Object::Universal->new($scalar);

The new method expects a scalar reference and returns a new class instance.

=cut

=method print

    # given 0

    $object->print; # 0

The print method outputs the value represented by the object to STDOUT and
returns true. This method returns a number object.

=cut

=method roles

    # given $object

    $object->roles;

The roles method returns the list of roles attached to object. This method
returns an array object.

=cut

=method say

    # given 0

    $object->say; # '0\n'

The say method outputs the value represented by the object appeneded with a
newline to STDOUT and returns true. This method returns a L<Data::Object::Number>
object.

=cut

=method throw

    # given $object

    $object->throw;

The throw method terminates the program using the core die keyword passing the
object to the L<Data::Object::Exception> class as the named parameter C<object>.
If captured this method returns an exception object.

=cut

=method type

    # given $object

    $object->type; # UNIVERSAL

The type method returns a string representing the internal data type object name.
This method returns a string object.

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

