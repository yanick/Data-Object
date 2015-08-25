# ABSTRACT: Undef Object for Perl 5
package Data::Object::Undef;

use 5.010;

use Scalar::Util 'blessed';
use Data::Object 'deduce_deep', 'detract_deep', 'throw';
use Data::Object::Class 'with';

with 'Data::Object::Role::Undef';

use overload (
    'bool'   => 'data',
    '""'     => 'data',
    '~~'     => 'data',
    fallback => 1,
);

# VERSION

sub new {
    my $class = shift;
    my $args  = shift;
    my $role  = 'Data::Object::Role::Type';

    $args = $args->data if blessed($args)
        and $args->can('does')
        and $args->does($role);

    throw 'Type Instantiation Error: Not an Undefined value'
        if defined $args;

    return bless \$args, $class;
}

sub data {
    goto &detract;
}

around 'defined' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

sub detract {
    return detract_deep shift;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Undef;

    my $undef = Data::Object::Undef->new(undef);

=head1 DESCRIPTION

Data::Object::Undef provides common methods for operating on Perl 5 undefined
data. Undef methods work on undefined values.

=head1 COMPOSITION

This class inherits all functionality from the L<Data::Object::Role::Undef>
role and implements proxy methods as documented herewith.

=cut

=method defined

    # given undef

    $undef->defined ? 'Yes' : 'No'; # No

The defined method always returns false. This method returns a
L<Data::Object::Number> object.

=cut

=method new

    # given undef

    my $undef = Data::Object::Undef->new(undef);

The new method expects an undefined value and returns a new class instance.

=cut

=head1 OPERATORS

This class overloads the following operators for your convenience.

=operator bool

    !!$undef

    # equivilent to

    $undef->data

=operator string

    "$undef"

    # equivilent to

    $undef->data

=operator smartmatch

    $value ~~ $undef

    # equivilent to

    $undef->data

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

L<Data::Object::Signatures>

=back

=cut
