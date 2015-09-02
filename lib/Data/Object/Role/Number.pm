# ABSTRACT: Number Object Role for Perl 5
package Data::Object::Role::Number;

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
    Data::Object::Role::Numeric
    Data::Object::Role::Value
);

# VERSION

method abs () {

    return CORE::abs($self);

}

method atan2 ($arg) {

    return CORE::atan2($self, $arg);

}

method cos () {

    return CORE::cos($self);

}

method decr ($arg) {

    return $self - ($arg || 1);

}

method defined () {

    return 1;

}

method exp () {

    return CORE::exp($self);

}

method hex () {

    return sprintf '%#x', $self;

}

method incr ($arg) {

    return $self + ($arg || 1);

}

method int () {

    return CORE::int($self);

}

method log () {

    return CORE::log($self);

}

method mod ($arg) {

    return $self % $arg;

}

method neg () {

    return -$self;

}

method pow ($arg) {

    return $self ** $arg;

}

method sin () {

    return CORE::sin($self);

}

method sqrt () {

    return CORE::sqrt($self);

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Number;

=cut

=head1 DESCRIPTION

Data::Object::Role::Number provides routines for operating on Perl 5 numeric
data.

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

L<Data::Object::Role::Numeric>

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

=method abs

    # given 12

    $number->abs; # 12

    # given -12

    $number->abs; # 12

The abs method returns the absolute value of the number. This method returns a
number object.

=cut

=method atan2

    # given 1

    $number->atan2(1); # 0.785398163397448

The atan2 method returns the arctangent of Y/X in the range -PI to PI This
method returns a float object.

=cut

=method cos

    # given 12

    $number->cos; # 0.843853958732492

The cos method computes the cosine of the number (expressed in radians). This
method returns a float object.

=cut

=method data

    # given $number

    $number->data; # original value

The data method returns the original and underlying value contained by the
object. This method is an alias to the detract method.

=cut

=method decr

    # given 123456789

    $number->decr; # 123456788

The decr method returns the numeric number decremented by 1. This method returns
a data type object to be determined after execution.

=cut

=method defined

    # given $number

    $number->defined; # 1

The defined method returns true if the object represents a value that meets the
criteria for being defined, otherwise it returns false. This method returns a
number object.

=cut

=method detract

    # given $number

    $number->detract; # original value

The detract method returns the original and underlying value contained by the
object.

=cut

=method downto

    # given 10

    $number->downto(5); # [10,9,8,7,6,5]

The downto method returns an array reference containing integer decreasing
values down to and including the limit. This method returns a
array object.

=cut

=method dump

    # given 12345

    $number->dump; # '12345'

The dump method returns returns a string string representation of the object.
This method returns a string object.

=cut

=method eq

    # given 12345

    $number->eq(12346); # 0

The eq method performs a numeric equality operation. This method returns a
number object representing a boolean.

=cut

=method exp

    # given 0

    $number->exp; # 1

    # given 1

    $number->exp; # 2.71828182845905

    # given 1.5

    $number->exp; # 4.48168907033806

The exp method returns e (the natural logarithm base) to the power of the
number. This method returns a float object.

=cut

=method ge

    # given 0

    $number->ge(0); # 1

The ge method returns true if the argument provided is greater-than or equal-to
the value represented by the object. This method returns a Data::Object::Number
object.

=cut

=method gt

    # given 99

    $number->gt(50); # 1

The gt method performs a numeric greater-than comparison. This method returns a
number object representing a boolean.

=cut

=method hex

    # given 175

    $number->hex; # 0xaf

The hex method returns a hex string representing the value of the number. This
method returns a string object.

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
method for rounding. This method returns a number object.

=cut

=method le

    # given 0

    $number->le; # 0

The le method returns true if the argument provided is less-than or equal-to
the value represented by the object. This method returns a Data::Object::Number
object.

=cut

=method log

    # given 12345

    $number->log; # 9.42100640177928

The log method returns the natural logarithm (base e) of the number. This method
returns a float object.

=cut

=method lt

    # given 86

    $number->lt(88); # 1

The lt method performs a numeric less-than comparison. This method returns a
number object representing a boolean.

=cut

=method methods

    # given $number

    $number->methods;

The methods method returns the list of methods attached to object. This method
returns an array object.

=cut

=method mod

    # given 12

    $number->mod(1); # 0
    $number->mod(2); # 0
    $number->mod(3); # 0
    $number->mod(4); # 0
    $number->mod(5); # 2

The mod method returns the division remainder of the number divided by the
argment. This method returns a number object.

=cut

=method ne

    # given -100

    $number->ne(100); # 1

The ne method performs a numeric equality operation. This method returns a
number object representing a boolean.

=cut

=method neg

    # given 12345

    $number->neg; # -12345

The neg method returns a negative version of the number. This method returns a
integer object.

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
number object.

=cut

=method print

    # given 12345

    $number->print; # '12345'

The print method outputs the value represented by the object to STDOUT and
returns true. This method returns a number object.

=cut

=method roles

    # given $number

    $number->roles;

The roles method returns the list of roles attached to object. This method
returns an array object.

=cut

=method say

    # given 12345

    $number->say; # '12345\n'

The say method outputs the value represented by the object appeneded with a
newline to STDOUT and returns true. This method returns a L<Data::Object::Number>
object.

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

=method throw

    # given $number

    $number->throw;

The throw method terminates the program using the core die keyword passing the
object to the L<Data::Object::Exception> class as the named parameter C<object>.
If captured this method returns an exception object.

=cut

=method to

    # given 5

    $number->to(9); # [5,6,7,8,9]
    $number->to(1); # [5,4,3,2,1]

The to method returns an array reference containing integer increasing or
decreasing values to and including the limit in ascending or descending order
based on the value of the floating-point object. This method returns a
array object.

=cut

=method type

    # given $number

    $number->type; # NUMBER

The type method returns a string representing the internal data type object name.
This method returns a string object.

=cut

=method upto

    # given 23

    $number->upto(25); # [23,24,25]

The upto method returns an array reference containing integer increasing
values up to and including the limit. This method returns a
array object.

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

