# ABSTRACT: Class Declaration for Perl 5
package Data::Object::Class;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Scalar::Util;

use parent 'Moo';

# VERSION

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object;

    # returns a code object
    my $object = Data::Object->new(sub{
        join ' ', @_
    });

    # returns true
    $object->isa('Data::Object::Code');

    # returns a string object
    my $string = $code->call('Hello', 'World');

    # returns a new string object
    $string = $string->split('')->reverse->join('')->uppercase;

    # returns a number object (returns true) and outputs "DLROW OLLEH"
    my $result = $string->say;

    # returns true
    $result->isa('Data::Object::Number');

=cut

=head1 DESCRIPTION

Data::Object::Class inherits all methods and behaviour from L<Moo>. Please see
that documentation for more usage information. Additionally, see
L<Data::Object::Class::Syntax> which provides a DSL that makes declaring
classes easier and more fun.

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

