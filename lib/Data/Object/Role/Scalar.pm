# ABSTRACT: Scalar Object Role for Perl 5
package Data::Object::Role::Scalar;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object::Role;

map with($_), our @ROLES = qw(
    Data::Object::Role::Defined
    Data::Object::Role::Detract
    Data::Object::Role::Output
    Data::Object::Role::Ref
    Data::Object::Role::Type
);

# VERSION

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
