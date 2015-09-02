# ABSTRACT: Class Declaration DSL for Perl 5
package Data::Object::Class::Syntax;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Syntax;
use Scalar::Util;

use parent 'Exporter';

# VERSION

our @EXPORT = @Data::Object::Syntax::EXPORT;

*import = *Data::Object::Syntax::import;

1;

=encoding utf8

=head1 SYNOPSIS

    package Person;

    use namespace::autoclean;

    use Data::Object::Class;
    use Data::Object::Class::Syntax;
    use Data::Object::Library ':types';

    # ATTRIBUTES

    has firstname  => ro;
    has lastname   => ro;
    has address1   => rw;
    has address2   => rw;
    has city       => rw;
    has state      => rw;
    has zip        => rw;
    has telephone  => rw;
    has occupation => rw;

    # CONSTRAINTS

    req firstname  => Str;
    req lastname   => Str;
    req address1   => Str;
    opt address2   => Str;
    req city       => Str;
    req state      => StrMatch[qr/^[A-Z]{2}$/];
    req zip        => Int;
    opt telephone  => StrMatch[qr/^\d{10,30}$/];
    opt occupation => Str;

    # DEFAULTS

    def occupation => 'Unassigned';
    def city       => 'San Franscisco';
    def state      => 'CA';

    1;

=cut

=head1 DESCRIPTION

Data::Object::Class::Syntax exports a collection of functions that provide a
DSL (syntactic sugar) for declaring and describing Data::Object::Class classes.
It is highly recommended that you also use the L<namespace::autoclean> library
to automatically cleanup the functions exported by this library and avoid
method name collisions.

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

