# ABSTRACT: An Undef Object Role for Perl 5
package Data::Object::Role::Undef;

use 5.010;
use Data::Object::Role;

map with($_), our @ROLES = qw(
    Data::Object::Role::Detract
    Data::Object::Role::Output
    Data::Object::Role::Type
);

# VERSION

sub defined {
    return 0;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Undef;

=head1 DESCRIPTION

Data::Object::Role::Undef provides functions  for operating on Perl 5 undefined
data.

=cut

=head1 ROLES

This role is composed of the following roles.

=over 4

=item *

L<Data::Object::Role::Detract>

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

L<Data::Object::Role::Regexp>

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
