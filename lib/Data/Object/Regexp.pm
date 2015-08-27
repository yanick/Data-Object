# ABSTRACT: Regexp Object for Perl 5
package Data::Object::Regexp;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object;
use Data::Object::Regexp::Result;
use Scalar::Util;

use Data::Object::Class 'with';

with 'Data::Object::Role::Regexp';

# VERSION

sub data {
    goto &detract;
}

sub detract {
    return Data::Object::detract_deep(shift);
}

sub new {
    my $class = shift;
    my $args  = shift;
    my $role  = 'Data::Object::Role::Type';

    $args = $args->data if Scalar::Util::blessed($args)
        and $args->can('does')
        and $args->does($role);

    Data::Object::throw('Type Instantiation Error: Not a RegexpRef')
        unless defined($args) && !! re::is_regexp($args);

    return bless \$args, $class;
}

around 'search' => sub {
    my ($orig, $self, @args) = @_;
    return Data::Object::Regexp::Result->new(
        $self->$orig(@args)
    );
};

around 'replace' => sub {
    my ($orig, $self, @args) = @_;
    return Data::Object::Regexp::Result->new(
        $self->$orig(@args)
    );
};

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Regexp;

    my $re = Data::Object::Regexp->new(qr(something to match against));

=head1 DESCRIPTION

Data::Object::Regexp provides common methods for operating on Perl 5 regular
expressions. Data::Object::Regexp methods work on data that meets the criteria
for being a regular expression.

=head1 COMPOSITION

This class inherits all functionality from the L<Data::Object::Role::Regexp>
role and implements proxy methods as documented herewith.

=cut

=method new

    # given qr(something to match against)

    my $re = Data::Object::Regexp->new(qr(something to match against));

The new method expects a regular-expression object and returns a new class
instance.

=cut

=method search

    # given qr((test))

    $re->search('this is a test');
    $re->search('this does not match', 'gi');

The search method performs a regular expression match against the given string
This method will always return a L<Data::Object::Regexp::Result> object which
can be used to introspect the result of the operation.

=cut

=method replace

    # given qr(test)

    $re->replace('this is a test', 'drill');
    $re->replace('test 1 test 2 test 3', 'drill', 'gi');

The replace method performs a regular expression substitution on the given
string. The first argument is the string to match against.  The second argument
is the replacement string.  The optional third argument might be a string
representing flags to append to the s///x operator, such as 'g' or 'e'.  This
method will always return a L<Data::Object::Regexp::Result> object which can be
used to introspect the result of the operation.

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
