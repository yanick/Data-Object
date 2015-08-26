# ABSTRACT: Undef Object Role for Perl 5
package Data::Object::Role::Undef;

use 5.014;
use Type::Tiny;
use Type::Tiny::Signatures;

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
