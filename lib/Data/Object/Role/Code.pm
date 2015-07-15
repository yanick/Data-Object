# ABSTRACT: A Code Object Role for Perl 5
package Data::Object::Role::Code;

use 5.010;
use Data::Object::Role;

use Data::Object 'codify';

map with($_), our @ROLES = qw(
    Data::Object::Role::Defined
    Data::Object::Role::Detract
    Data::Object::Role::Output
    Data::Object::Role::Ref
    Data::Object::Role::Type
);

# VERSION

sub call {
    my ($code, @arguments) = @_;
    return $code->(@arguments);
}

sub curry {
    my ($code, @arguments) = @_;
    return sub { $code->(@arguments, @_) };
}

sub rcurry {
    my ($code, @arguments) = @_;
    return sub { $code->(@_, @arguments) };
}

sub compose {
    my ($code, $next, @arguments) = @_;
    $next = codify $next if !ref $next;
    return curry(sub { $next->($code->(@_)) }, @arguments);
}

sub disjoin {
    my ($code, $next) = @_;
    $next = codify $next if !ref $next;
    return sub { $code->(@_) || $next->(@_) };
}

sub conjoin {
    my ($code, $next) = @_;
    $next = codify $next if !ref $next;
    return sub { $code->(@_) && $next->(@_) };
}

sub next {
    goto &call;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Code;

=head1 DESCRIPTION

Data::Object::Role::Code provides functions for operating on Perl 5 code
references.

=cut

=head1 ROLES

This role is composed of the following roles.

=over 4

=item *

L<Data::Object::Role::Defined>

=item *

L<Data::Object::Role::Detract>

=item *

L<Data::Object::Role::Output>

=item *

L<Data::Object::Role::Ref>

=back

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object::Role::Array>

=item *

L<Data::Object::Role::Code>

=item *

L<Data::Object::Role::Float>

=item *

L<Data::Object::Role::Hash>

=item *

L<Data::Object::Role::Integer>

=item *

L<Data::Object::Role::Number>

=item *

L<Data::Object::Role::Regexp>

=item *

L<Data::Object::Role::Scalar>

=item *

L<Data::Object::Role::String>

=item *

L<Data::Object::Role::Undef>

=item *

L<Data::Object::Role::Universal>

=item *

L<Data::Object::Autobox>

=item *

L<Data::Object::Library>

=item *

L<Data::Object::Signatures>

=back

=cut
