# ABSTRACT: A Scalar Object Role for Perl 5
package Data::Object::Role::Scalar;

use 5.010;
use Moo::Role;

map with($_), our @ROLES = qw(
    Data::Object::Role::Constructor
    Data::Object::Role::Defined
    Data::Object::Role::Detract
    Data::Object::Role::Output
    Data::Object::Role::Ref
);

# VERSION

sub and {
    return $_[0] && $_[1];
}

sub not {
    return ! shift;
}

sub or {
    return $_[0] || $_[1];
}

sub xor {
    return ($_[0] xor $_[1]) ? 1 : 0;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Scalar;

=head1 DESCRIPTION

Data::Object::Role::Scalar provides functions for operating on Perl 5 scalar
objects.

=cut

=head1 ROLES

This role is composed of the following roles.

=over 4

=item *

L<Data::Object::Role::Constructor>

=item *

L<Data::Object::Role::Defined>

=item *

L<Data::Object::Role::Detract>

=item *

L<Data::Object::Role::Output>

=item *

L<Data::Object::Role::Ref>

=back

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object::Role::Array>

=item *

L<Data::Object::Role::Code>

=item *

L<Data::Object::Role::Float>

=item *

L<Data::Object::Role::Hash>

=item *

L<Data::Object::Role::Integer>

=item *

L<Data::Object::Role::Number>

=item *

L<Data::Object::Role::Scalar>

=item *

L<Data::Object::Role::String>

=item *

L<Data::Object::Role::Undef>

=item *

L<Data::Object::Role::Universal>

=item *

L<Data::Object::Autobox>

=back

=cut
