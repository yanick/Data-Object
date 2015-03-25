# ABSTRACT: An Integer Object Role for Perl 5
package Data::Object::Role::Integer;

use 5.010;
use Moo::Role;

map with($_), our @ROLES = qw(
    Data::Object::Role::Defined
    Data::Object::Role::Detract
    Data::Object::Role::Numeric
    Data::Object::Role::Output
);

# VERSION

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Integer;

=head1 DESCRIPTION

Data::Object::Role::Integer provides functions for operating on Perl 5 integer
data.

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
