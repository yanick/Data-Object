# ABSTRACT: An Undef Object Role for Perl 5
package Data::Object::Role::Undef;

use 5.10.0;
use Moo::Role;

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

=back

=cut
