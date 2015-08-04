# ABSTRACT: A Generic Role Framework for Perl 5
package Data::Object::Role;

use 5.010;
use parent 'Moo::Role';

# VERSION

1;

=encoding utf8

=head1 SYNOPSIS

    package Persona;

    use Data::Object::Role;

    extends 'Entity';
    with    'Identity';

    has firstname => ( is => 'ro' );
    has lastname  => ( is => 'ro' );

    1;

=head1 DESCRIPTION

Data::Object::Role inherits all methods and behaviour from L<Moo::Role>. Please
see that documentation for more usage information. Additionally, see
L<Data::Object::Role::Syntax> which provides a DSL that makes declaring roles
easier and more fun.

=cut

