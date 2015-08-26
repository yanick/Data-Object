# ABSTRACT: Number Object for Perl 5
package Data::Object::Number;

use 5.014;
use Type::Tiny;
use Type::Tiny::Signatures;

use Scalar::Util 'blessed', 'looks_like_number';
use Data::Object 'deduce_deep', 'detract_deep', 'throw';
use Data::Object::Class 'with';

with 'Data::Object::Role::Number';

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

    throw 'Type Instantiation Error: Not a Number'
        unless defined($args) && !ref($args)
            && looks_like_number($args);

    return bless \$args, $class;
}

around 'abs' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'atan2' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'cos' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

sub data {
    goto &detract;
}

sub detract {
    return detract_deep shift;
}

around 'decr' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

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

around 'exp' => sub {
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

around 'hex' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'incr' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'int' => sub {
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

around 'log' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'mod' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'ne' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'neg' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'pow' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'sin' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'sqrt' => sub {
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

    use Data::Object::Number;

    my $number = Data::Object::Number->new(1_000_000);

=head1 DESCRIPTION

Data::Object::Number provides common methods for operating on Perl 5 numeric
data. Number methods work on data that meets the criteria for being a number. A
number holds and manipulates an arbitrary sequence of bytes, typically
representing numberic characters (0-9). Users of numbers should be aware of the
methods that modify the number itself as opposed to returning a new number.
Unless stated, it may be safe to assume that the following methods copy, modify
and return new numbers based on their function.

=head1 COMPOSITION

This class inherits all functionality from the L<Data::Object::Role::Number>
role and implements proxy methods as documented herewith.

=cut

=method abs

    # given 12

    $number->abs; # 12

    # given -12

    $number->abs; # 12

The abs method returns the absolute value of the number. This method returns a
L<Data::Object::Number> object.

=cut

=method atan2

    # given 1

    $number->atan2(1); # 0.785398163397448

The atan2 method returns the arctangent of Y/X in the range -PI to PI This
method returns a L<Data::Object::Float> object.

=cut

=method cos

    # given 12

    $number->cos; # 0.843853958732492

The cos method computes the cosine of the number (expressed in radians). This
method returns a L<Data::Object::Float> object.

=cut

=method decr

    # given 123456789

    $number->decr; # 123456788

The decr method returns the numeric number decremented by 1. This method returns
a data type object to be determined after execution.

=cut

=method downto

    # given 10

    $number->downto(5); # [10,9,8,7,6,5]

The downto method returns an array reference containing integer decreasing
values down to and including the limit. This method returns a
L<Data::Object::Array> object.

=cut

=method eq

    # given 12345

    $number->eq(12346); # 0

The eq method performs a numeric equality operation. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method exp

    # given 0

    $number->exp; # 1

    # given 1

    $number->exp; # 2.71828182845905

    # given 1.5

    $number->exp; # 4.48168907033806

The exp method returns e (the natural logarithm base) to the power of the
number. This method returns a L<Data::Object::Float> object.

=cut

=method gt

    # given 99

    $number->gt(50); # 1

The gt method performs a numeric greater-than comparison. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method gte

    # given 100

    $number->gte(100); # 1

The gte method performs a numeric greater-than-or-equal-to comparison. This
method returns a L<Data::Object::Number> object representing a boolean.

=cut

=method hex

    # given 175

    $number->hex; # 0xaf

The hex method returns a hex string representing the value of the number. This
method returns a L<Data::Object::String> object.

=cut

=method incr

    # given 123456789

    $number->incr; # 123456790

The incr method returns the numeric number incremented by 1. This method returns
a data type object to be determined after execution.

=cut

=method int

    # given 12.5

    $number->int; # 12

The int method returns the integer portion of the number. Do not use this
method for rounding. This method returns a L<Data::Object::Number> object.

=cut

=method log

    # given 12345

    $number->log; # 9.42100640177928

The log method returns the natural logarithm (base e) of the number. This method
returns a L<Data::Object::Float> object.

=cut

=method lt

    # given 86

    $number->lt(88); # 1

The lt method performs a numeric less-than comparison. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method lte

    # given 50

    $number->lte(50); # 1

The lte method performs a numeric less-than-or-equal-to comparison. This
method returns a L<Data::Object::Number> object representing a boolean.

=cut

=method mod

    # given 12

    $number->mod(1); # 0
    $number->mod(2); # 0
    $number->mod(3); # 0
    $number->mod(4); # 0
    $number->mod(5); # 2

The mod method returns the division remainder of the number divided by the
argment. This method returns a L<Data::Object::Number> object.

=cut

=method ne

    # given -100

    $number->ne(100); # 1

The ne method performs a numeric equality operation. This method returns a
L<Data::Object::Number> object representing a boolean.

=cut

=method neg

    # given 12345

    $number->neg; # -12345

The neg method returns a negative version of the number. This method returns a
L<Data::Object::Integer> object.

=cut

=method new

    # given 1_000_000

    my $number = Data::Object::Number->new(1_000_000);

The new method expects a number and returns a new class instance.

=cut

=method pow

    # given 12345

    $number->pow(3); # 1881365963625

The pow method returns a number, the result of a math operation, which is the
number to the power of the argument. This method returns a
L<Data::Object::Number> object.

=cut

=method sin

    # given 12345

    $number->sin; # -0.993771636455681

The sin method returns the sine of the number (expressed in radians). This
method returns a data type object to be determined after execution.

=cut

=method sqrt

    # given 12345

    $number->sqrt; # 111.108055513541

The sqrt method returns the positive square root of the number. This method
returns a data type object to be determined after execution.

=cut

=method to

    # given 5

    $number->to(9); # [5,6,7,8,9]
    $number->to(1); # [5,4,3,2,1]

The to method returns an array reference containing integer increasing or
decreasing values to and including the limit in ascending or descending order
based on the value of the floating-point object. This method returns a
L<Data::Object::Array> object.

=cut

=method upto

    # given 23

    $number->upto(25); # [23,24,25]

The upto method returns an array reference containing integer increasing
values up to and including the limit. This method returns a
L<Data::Object::Array> object.

=cut

=head1 OPERATORS

This class overloads the following operators for your convenience.

=operator bool

    !!$number

    # equivilent to

    $number->data

=operator string

    "$number"

    # equivilent to

    $number->data

=operator smartmatch

    $value ~~ $number

    # equivilent to

    $number->data

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
