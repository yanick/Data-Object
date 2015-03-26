# ABSTRACT: An Integer Object for Perl 5
package Data::Object::Integer;

use 5.010;

use Carp         'confess';
use Data::Object 'deduce_deep', 'detract_deep';
use Moo          'with';
use Scalar::Util 'blessed', 'looks_like_number';

with 'Data::Object::Role::Integer';

use overload (
    'bool'   => 'data',
    '""'     => 'data',
    '~~'     => 'data',
    fallback => 1,
);

# VERSION

sub new {
    my $class = shift;
    my $data  = shift;

    $data =~ s/^\+//; # not keen on this but ...

    $class = ref($class) || $class;
    unless (blessed($data) && $data->isa($class)) {
        confess 'Type Instantiation Error: Not an Integer'
            unless defined($data) && !ref($data)
            && looks_like_number($data);
    }

    return bless \$data, $class;
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

    use Data::Object::Integer;

    my $integer = Data::Object::Integer->new(9);

=head1 DESCRIPTION

Data::Object::Integer provides common methods for operating on Perl 5 integer
data. Integer methods work on data that meets the criteria for being an integer.
An integer holds and manipulates an arbitrary sequence of bytes, typically
representing numeric characters. Users of integers should be aware of the
methods that modify the integer itself as opposed to returning a new integer.
Unless stated, it may be safe to assume that the following methods copy, modify
and return new integers based on their function.

=head1 COMPOSITION

This class inherits all functionality from the L<Data::Object::Role::Integer>
role and implements proxy methods as documented herewith.

=cut

=method downto

    # given 1

    $integer->downto(0); # [1,0]

The downto method returns an array reference containing integer decreasing
values down to and including the limit. This method returns a
L<Data::Object::Array> object.

=cut

=method eq

    # given 1

    $integer->eq(1); # 1

The eq method performs a numeric equality operation. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method gt

    # given 1

    $integer->gt(1); # 0

The gt method performs a numeric greater-than comparison. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method gte

    # given 1

    $integer->gte(1); # 1

The gte method performs a numeric greater-than-or-equal-to comparison. This
method returns a L<Data::Object::Number> object representing a boolean.

=cut

=method lt

    # given 1

    $integer->lt(1); # 0

The lt method performs a numeric less-than comparison. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method lte

    # given 1

    $integer->lte(1); # 1

The lte method performs a numeric less-than-or-equal-to comparison. This
method returns a L<Data::Object::Number> object representing a boolean.

=cut

=method ne

    # given 1

    $integer->ne(0); # 1

The ne method performs a numeric equality operation. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method to

    # given 1

    $integer->to(2); # [1,2]
    $integer->to(0); # [1,0]

The to method returns an array reference containing integer increasing or
decreasing values to and including the limit in ascending or descending order
based on the value of the floating-point object. This method returns a
L<Data::Object::Array> object.

=cut

=method upto

    # given 1

    $integer->upto(2); # [1,2]

The upto method returns an array reference containing integer increasing
values up to and including the limit. This method returns a
L<Data::Object::Array> object.

=cut

=head1 OPERATORS

This class overloads the following operators for your convenience.

=operator bool

    !!$integer

    # equivilent to

    $integer->data

=operator string

    "$integer"

    # equivilent to

    $integer->data

=operator smartmatch

    $value ~~ $integer

    # equivilent to

    $integer->data

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object::Array>

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

=back

=cut
