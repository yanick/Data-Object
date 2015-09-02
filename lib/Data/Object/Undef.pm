# ABSTRACT: Undef Object for Perl 5
package Data::Object::Undef;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Class;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

with 'Data::Object::Role::Undef';

# VERSION

method new ($class: @args) {

    my $arg  = $args[0];
    my $role = 'Data::Object::Role::Type';

    $arg = $arg->data if Scalar::Util::blessed($arg)
        and $arg->can('does')
        and $arg->does($role);

    Data::Object::throw('Type Instantiation Error: Not an Undefined value')
        if defined $arg;

    return bless \$arg, $class;

}

our @METHODS = @{ __PACKAGE__->methods };

my  $exclude = qr/^data|detract|new$/;

around [ grep { !/$exclude/ } @METHODS ] => fun ($orig, $self, @args) {

    my $results = $self->$orig(@args);

    return Data::Object::deduce_deep($results);

};

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Undef;

    my $undef = Data::Object::Undef->new(undef);

=cut

=head1 DESCRIPTION

Data::Object::Undef provides routines for operating on Perl 5 undefined
data. Undef methods work on undefined values.

=cut

=head1 COMPOSITION

This package inherits all functionality from the L<Data::Object::Role::Undef>
role and implements proxy methods as documented herewith.

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

    # given $undef

    $undef->data; # original value

The data method returns the original and underlying value contained by the
object. This method is an alias to the detract method.

=cut

=method defined

    # given undef

    $undef->defined ? 'Yes' : 'No'; # No

The defined method always returns false. This method returns a
L<Data::Object::Number> object.

=cut

=method detract

    # given $undef

    $undef->detract; # original value

The detract method returns the original and underlying value contained by the
object.

=cut

=method dump

    # given $undef

    $undef->dump; # 'undef'

The dump method returns returns a string string representation of the object.
This method returns a L<Data::Object::String> object.

=cut

=method eq

    # given $undef

    $undef->eq; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method ge

    # given $undef

    $undef->ge; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method gt

    # given $undef

    $undef->gt; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method le

    # given $undef

    $undef->le; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method lt

    # given $undef

    $undef->lt; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method methods

    # given $undef

    $undef->methods;

The methods method returns the list of methods attached to object. This method
returns a L<Data::Object::Array> object.

=cut

=method ne

    # given $undef

    $undef->ne; # exception thrown

This method is consumer requirement but has no function and is not implemented.
This method will throw an exception if called.

=cut

=method new

    # given undef

    my $undef = Data::Object::Undef->new(undef);

The new method expects an undefined value and returns a new class instance.

=cut

=method print

    # given $undef

    $undef->print; # 'undef'

The print method outputs the value represented by the object to STDOUT and
returns true. This method returns a L<Data::Object::Number> object.

=cut

=method roles

    # given $undef

    $undef->roles;

The roles method returns the list of roles attached to object. This method
returns a L<Data::Object::Array> object.

=cut

=method say

    # given $undef

    $undef->say; # 'undef\n'

The say method outputs the value represented by the object appeneded with a
newline to STDOUT and returns true. This method returns a L<Data::Object::Number>
object.

=cut

=method throw

    # given $undef

    $undef->throw;

The throw method terminates the program using the core die keyword passing the
object to the L<Data::Object::Exception> class as the named parameter C<object>.
If captured this method returns a L<Data::Object::Exception> object.

=cut

=method type

    # given $undef

    $undef->type; # UNDEF

The type method returns a string representing the internal data type object name.
This method returns a L<Data::Object::String> object.

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

