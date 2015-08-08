# ABSTRACT: A Float Object Role for Perl 5
package Data::Object::Role::Float;

use 5.010;
use Data::Object::Role;

map with($_), our @ROLES = qw(
    Data::Object::Role::Defined
    Data::Object::Role::Detract
    Data::Object::Role::Numeric
    Data::Object::Role::Output
    Data::Object::Role::Type
);

# VERSION

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Float;

=head1 DESCRIPTION

Data::Object::Role::Float provides functions for operating on Perl 5
floating-point data.

=cut

=head1 ROLES

This role is composed of the following roles.

=over 4

=item *

L<Data::Object::Role::Defined>

=item *

L<Data::Object::Role::Detract>

=item *

L<Data::Object::Role::Numeric>

=item *

L<Data::Object::Role::Output>

=back

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
