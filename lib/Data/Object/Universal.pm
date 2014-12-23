# ABSTRACT: A Universal Object for Perl 5
package Data::Object::Universal;

use 5.010;

use Moo 'with';
use Data::Object 'detract_deep';

with 'Data::Object::Role::Constructor';
with 'Data::Object::Role::Universal';
with 'Data::Object::Role::Detract';
with 'Data::Object::Role::Output';

# VERSION

sub data {
    goto &detract;
}

sub detract {
    return detract_deep shift;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Universal;

    my $object = Data::Object::Universal->new($scalar);

=head1 DESCRIPTION

Data::Object::Universal provides common methods for operating on any Perl 5 data
types.

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object::Array>

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

L<Data::Object::Scalar>

=item *

L<Data::Object::String>

=item *

L<Data::Object::Undef>

=item *

L<Data::Object::Universal>

=item *

L<Data::Object::Autobox>

=back

=cut
