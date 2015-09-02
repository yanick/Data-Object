# ABSTRACT: Alphabetic Object Role for Perl 5
package Data::Object::Role::Alphabetic;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Role;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

# VERSION

method eq ($arg1) {

    return "$self" eq "$arg1" ? 1 : 0;

}

method gt ($arg1) {

    return "$self" gt "$arg1" ? 1 : 0;

}

method ge ($arg1) {

    return "$self" ge "$arg1" ? 1 : 0;

}

method lt ($arg1) {

    return "$self" lt "$arg1" ? 1 : 0;

}

method le ($arg1) {

    return "$self" le "$arg1" ? 1 : 0;

}

method ne ($arg1) {

    return "$self" ne "$arg1" ? 1 : 0;

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Alphabetic;

=cut

=head1 DESCRIPTION

Data::Object::Role::Alphabetic provides routines for operating on Perl 5
alpha-numeric data.

=cut

=method eq

    # given $alphabetic

    $alphabetic->eq; # (...)

The eq method returns true if the argument provided is equal to the value
represented by the object. This method returns a number object.

=cut

=method ge

    # given $alphabetic

    $alphabetic->ge; # (...)

The ge method returns true if the argument provided is greater-than or equal-to
the value represented by the object. This method returns a Data::Object::Number
object.

=cut

=method gt

    # given $alphabetic

    $alphabetic->gt; # (...)

The gt method returns true if the argument provided is greater-than the value
represented by the object. This method returns a number object.

=cut

=method le

    # given $alphabetic

    $alphabetic->le; # (...)

The le method returns true if the argument provided is less-than or equal-to
the value represented by the object. This method returns a Data::Object::Number
object.

=cut

=method lt

    # given $alphabetic

    $alphabetic->lt; # (...)

The lt method returns true if the argument provided is less-than the value
represented by the object. This method returns a number object.

=cut

=method ne

    # given $alphabetic

    $alphabetic->ne; # (...)

The ne method returns true if the argument provided is not equal to the value
represented by the object. This method returns a number object.

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

