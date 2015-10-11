# ABSTRACT: List Object Role for Perl 5
package Data::Object::Role::List;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Role;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

map with($_), our @ROLES = qw(
    Data::Object::Role::Comparison
    Data::Object::Role::Output
);

requires 'grep';
requires 'head';
requires 'join';
requires 'length';
requires 'list';
requires 'map';
requires 'reverse';
requires 'sort';
requires 'tail';
requires 'values';

# VERSION

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::List;

=cut

=head1 DESCRIPTION

Data::Object::Role::List provides routines for operating on Perl 5 data
objects which meet the criteria for being considered lists.

=cut

=head1 ROLES

This package is comprised of the following roles.

=over 4

=item *

L<Data::Object::Role::Comparison>

=item *

L<Data::Object::Role::Output>

=back

=cut

=head1 REQUIRES

This package requires the consumer to implement the following methods.

=over 4


=item *

grep

=item *

head

=item *

join

=item *

length

=item *

list

=item *

map

=item *

reverse

=item *

sort

=item *

tail

=item *

values

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
