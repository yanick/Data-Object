# ABSTRACT: Detract Object Role for Perl 5
package Data::Object::Role::Detract;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Role;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

# VERSION

use overload (
    '0+'     => 'data',
    '""'     => 'data',
    '~~'     => 'data',
    'bool'   => 'data',
    'qr'     => 'data',
    fallback => 1,
);

method data () {

    return $self->detract;

}

method detract () {

    return Data::Object::detract_deep($self);

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Detract;

=cut

=head1 DESCRIPTION

Data::Object::Role::Detract provides routines for operating on Perl 5
data objects which meet the criteria for being detractable.

=cut

=method data

    # given $detract

    $detract->data; # original value

The data method returns the original and underlying value contained by the
object. This method is an alias to the detract method.

=cut

=method detract

    # given $detract

    $detract->detract; # original value

The detract method returns the original and underlying value contained by the
object.

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

L<Data::Object::Prototype>

=item *

L<Data::Object::Signatures>

=back

=cut

