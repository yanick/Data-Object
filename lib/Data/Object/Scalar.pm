# ABSTRACT: Scalar Object for Perl 5
package Data::Object::Scalar;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object;
use Data::Object::Class;
use Scalar::Util;

with 'Data::Object::Role::Scalar';

# VERSION

method data () {

    @_ = $self and goto &detract;

}

method detract () {

    return Data::Object::detract_deep($self);

}

method new (ClassName $class: ("Ref | InstanceOf['Data::Object::Scalar']") $data) {

    my $role  = 'Data::Object::Role::Type';

    $data = $data->data if Scalar::Util::blessed($data)
        and $data->can('does')
        and $data->does($role);

    if (Scalar::Util::blessed($data) && $data->isa('Regexp') && $^V <= v5.12.0) {
        $data = do {\(my $q = qr/$data/)};
    }

    return bless ref($data) ? $data : \$data, $class;

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

=method new

    # given \12345

    my $scalar = Data::Object::Scalar->new(\12345);

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
