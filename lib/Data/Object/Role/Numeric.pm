# ABSTRACT: Numeric Object Role for Perl 5
package Data::Object::Role::Numeric;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Role;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

# VERSION

method downto ($arg1) {

    return [ CORE::reverse( CORE::int("$arg1")..CORE::int("$self") ) ];

}

method eq ($arg1) {

    return "$self" == "$arg1" ? 1 : 0;

}

method gt ($arg1) {

    return "$self" > "$arg1" ? 1 : 0;

}

method ge ($arg1) {

    return "$self" >= "$arg1" ? 1 : 0;

}

method lt ($arg1) {

    return "$self" < "$arg1" ? 1 : 0;

}

method le ($arg1) {

    return "$self" <= "$arg1" ? 1 : 0;

}

method ne ($arg1) {

    return "$self" != "$arg1" ? 1 : 0;

}

method to ($arg1) {

    return [ CORE::int("$self")..CORE::int("$arg1") ] if "$self" <= "$arg1";

    return [ CORE::reverse(CORE::int("$arg1")..CORE::int("$self")) ];

}

method upto ($arg1) {

    return [ CORE::int("$self")..CORE::int("$arg1") ];

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Numeric;

=cut

=head1 DESCRIPTION

Data::Object::Role::Numeric provides routines for operating on Perl 5
numeric data.

=cut

=method downto

    # given 5

    my $array = $numeric->downto(1); # [5,4,3,2,1]

The downto method returns a ...

=cut

=method eq

    # given 1

    $numeric->eq(0); # 0

The eq method returns true if the argument provided is equal to the value
represented by the object. This method returns a number value.

=cut

=method ge

    # given 1

    $numeric->ge(0); # 1

The ge method returns true if the argument provided is greater-than or equal-to
the value represented by the object. This method returns a Data::Object::Number
object.

=cut

=method gt

    # given 1

    $numeric->gt(0); # 1

The gt method returns true if the argument provided is greater-than the value
represented by the object. This method returns a number value.

=cut

=method le

    # given 1

    $numeric->le(0); # 0

The le method returns true if the argument provided is less-than or equal-to
the value represented by the object. This method returns a Data::Object::Number
object.

=cut

=method lt

    # given 1

    $numeric->lt(0); # 0

The lt method returns true if the argument provided is less-than the value
represented by the object. This method returns a number value.

=cut

=method ne

    # given 1

    $numeric->ne(0); # 1

The ne method returns true if the argument provided is not equal to the value
represented by the object. This method returns a number value.

=cut

=method to

    # given 5

    my $object = $numeric->to(-5); # [5,4,3,2,1,0,-1,2,3,4,5]

The to method returns an array reference containing integer increasing or
decreasing values to and including the limit in ascending or descending order
based on the value of the floating-point object. This method returns an array
value.

=cut

=method upto

    # given 23

    my $object = $numeric->upto(25); # [23,24,25]

The upto method returns an array reference containing integer increasing values
up to and including the limit. This method returns an array value.

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

