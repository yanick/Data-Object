# ABSTRACT: A Generic OO Class Famework for Perl 5
package Data::Object::Class;

use 5.010;
use parent 'Moo';

# VERSION

1;

=encoding utf8

=head1 SYNOPSIS

    package Person;

    use Data::Object::Class;

    extends 'Entity';
    with    'Identity';

    has firstname => ( is => 'ro' );
    has lastname  => ( is => 'ro' );

    1;

=head1 DESCRIPTION

Data::Object::Class inherits all methods and behaviour from L<Moo>. Please see
that documentation for more usage information.

=cut

