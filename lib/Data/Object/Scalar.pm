# ABSTRACT: A Scalar Object for Perl 5
package Data::Object::Scalar;

use 5.010;

use Scalar::Util 'blessed';
use Data::Object 'deduce_deep', 'detract_deep', 'throw';
use Data::Object::Class 'with';

with 'Data::Object::Role::Scalar';

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

    use Data::Object::Scalar;

    my $scalar = Data::Object::Scalar->new(\12345);

=head1 DESCRIPTION

Data::Object::Scalar provides common methods for operating on Perl 5 scalar
objects. Scalar methods work on data that meets the criteria for being a scalar.

=head1 COMPOSITION

This class inherits all functionality from the L<Data::Object::Role::Scalar>
role and implements proxy methods as documented herewith.

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
