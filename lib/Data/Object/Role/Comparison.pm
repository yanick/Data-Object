# ABSTRACT: Comparison Object Role for Perl 5
package Data::Object::Role::Comparison;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Role;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

requires 'eq';
requires 'gt';
requires 'ge';
requires 'lt';
requires 'le';
requires 'ne';

# VERSION

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Class;

    with 'Data::Object::Role::Comparison';

=cut

=head1 DESCRIPTION

Data::Object::Role::Comparison provides routines for operating on Perl 5 data
objects which meet the criteria for being comparable.

=cut

=head1 REQUIRES

This package requires the consumer to implement the following methods.

=over 4

=item *

eq

=item *

ge

=item *

gt

=item *

le

=item *

lt

=item *

ne

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

L<Data::Object::Immutable>

=item *

L<Data::Object::Library>

=item *

L<Data::Object::Prototype>

=item *

L<Data::Object::Signatures>

=back

=cut
