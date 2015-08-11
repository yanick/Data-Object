# ABSTRACT: Float Object for Perl 5
package Data::Object::Float;

use 5.010;

use Scalar::Util 'blessed', 'looks_like_number';
use Data::Object 'deduce_deep', 'detract_deep', 'throw';
use Data::Object::Class 'with';

with 'Data::Object::Role::Float';

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

    $args =~ s/^\+//; # not keen on this but ...

    throw 'Type Instantiation Error: Not a Float or Number'
        unless defined($args) && !ref($args)
            && looks_like_number($args);

    return bless \$args, $class;
}

sub data {
    goto &detract;
}

sub detract {
    return detract_deep shift;
}

around 'downto' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'eq' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'gt' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'gte' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'lt' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'lte' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'ne' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'to' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'upto' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Float;

    my $float = Data::Object::Float->new(9.9999);

=head1 DESCRIPTION

Data::Object::Float provides common methods for operating on Perl 5
floating-point data. Float methods work on data that meets the criteria for
being a floating-point number. A float holds and manipulates an arbitrary
sequence of bytes, typically representing numberic characters with decimals.
Users of floats should be aware of the methods that modify the float itself as
opposed to returning a new float. Unless stated, it may be safe to assume that
the following methods copy, modify and return new floats based on their
function.

=head1 COMPOSITION

This class inherits all functionality from the L<Data::Object::Role::Float>
role and implements proxy methods as documented herewith.

=cut

=method downto

    # given 1.23

    $float->downto(0); # [1,0]

The downto method returns an array reference containing integer decreasing
values down to and including the limit. This method returns a
L<Data::Object::Array> object.

=cut

=method eq

    # given 1.23

    $float->eq(1); # 0

The eq method performs a numeric equality operation. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method gt

    # given 1.23

    $float->gt(1); # 1

The gt method performs a numeric greater-than comparison. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method gte

    # given 1.23

    $float->gte(1.23); # 1

The gte method performs a numeric greater-than-or-equal-to comparison. This
method returns a L<Data::Object::Number> object representing a boolean.

=cut

=method lt

    # given 1.23

    $float->lt(1.24); # 1

The lt method performs a numeric less-than comparison. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method lte

    # given 1.23

    $float->lte(1.23); # 1

The lte method performs a numeric less-than-or-equal-to comparison. This
method returns a L<Data::Object::Number> object representing a boolean.

=cut

=method ne

    # given 1.23

    $float->ne(1); # 1

The ne method performs a numeric equality operation. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method to

    # given 1.23

    $float->to(2); # [1,2]
    $float->to(0); # [1,0]

The to method returns an array reference containing integer increasing or
decreasing values to and including the limit in ascending or descending order
based on the value of the floating-point object. This method returns a
L<Data::Object::Array> object.

=cut

=method upto

    # given 1.23

    $float->upto(2); # [1,2]

The upto method returns an array reference containing integer increasing
values up to and including the limit. This method returns a
L<Data::Object::Array> object.

=cut

=head1 OPERATORS

This class overloads the following operators for your convenience.

=operator bool

    !!$float

    # equivilent to

    $float->data

=operator string

    "$float"

    # equivilent to

    $float->data

=operator smartmatch

    $value ~~ $float

    # equivilent to

    $float->data

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
