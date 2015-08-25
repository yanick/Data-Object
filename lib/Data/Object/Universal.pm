# ABSTRACT: Universal Object for Perl 5
package Data::Object::Universal;

use 5.010;

use Scalar::Util 'blessed';
use Data::Object 'deduce_deep', 'detract_deep', 'throw';
use Data::Object::Class 'with';

with 'Data::Object::Role::Universal';

# VERSION

sub new {
    my $class = shift;
    my $data  = shift;
    my $role  = 'Data::Object::Role::Type';

    $data = $data->data if blessed($data)
        and $data->can('does')
        and $data->does($role);

    if (blessed($data) && $data->isa('Regexp') && $^V <= v5.12.0) {
        $data = do {\(my $q = qr/$data/)};
    }

    return bless ref($data) ? $data : \$data, $class;
}

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

=head1 COMPOSITION

This class inherits all functionality from the L<Data::Object::Role::Universal>
role and implements proxy methods as documented herewith.

=cut

=method new

    # given $scalar

    my $object = Data::Object::Universal->new($scalar);

The new method expects a scalar reference and returns a new class instance.

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
