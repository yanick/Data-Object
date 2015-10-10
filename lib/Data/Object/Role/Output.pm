# ABSTRACT: Output Object Role for Perl 5
package Data::Object::Role::Output;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Role;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

map with($_), our @ROLES = qw(
    Data::Object::Role::Dumper
);

# VERSION

method print () {

    my @result = Data::Object::Role::Dumper::dump($self);

    return CORE::print(@result);

}

method say () {

    my @result = Data::Object::Role::Dumper::dump($self);

    return CORE::print(@result, "\n");

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Output;

=cut

=head1 DESCRIPTION

Data::Object::Role::Output provides routines for operating on Perl 5 data
objects which meet the criteria for being output.

=cut

=head1 ROLES

This package is comprised of the following roles.

=over 4

=item *

L<Data::Object::Role::Dumper>

=back

=cut

=method print

    # given $output

    $output->print;

The print method outputs the value represented by the object to STDOUT and
returns true. This method returns a number value.

=cut

=method say

    # given $output

    $output->say;

The say method outputs the value represented by the object appended with a
newline to STDOUT and returns true. This method returns a L<Data::Object::Number>
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

