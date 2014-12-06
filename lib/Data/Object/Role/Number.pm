# ABSTRACT: A Number Object Role for Perl 5
package Data::Object::Role::Number;

use 5.10.0;
use Moo::Role;

# VERSION

sub abs {
    my ($number) = @_;
    return CORE::abs $number;
}

sub atan2 {
    my ($number, $x) = @_;
    return CORE::atan2 $number, $x;
}

sub cos {
    my ($number) = @_;
    return CORE::cos $number;
}

sub decr {
    my ($number, $n) = @_;
    return $number - ($n || 1);
}

sub exp {
    my ($number) = @_;
    return CORE::exp $number;
}

sub hex {
    my ($number) = @_;
    return sprintf '%#x', $number;
}

sub incr {
    my ($number, $n) = @_;
    return $number + ($n || 1);
}

sub int {
    my ($number) = @_;
    return CORE::int $number;
}

sub log {
    my ($number) = @_;
    return CORE::log $number;
}

sub mod {
    my ($number, $divisor) = @_;
    return $number % $divisor;
}

sub neg {
    my ($number) = @_;
    return -$number;
}

sub pow {
    my ($number, $n) = @_;
    return $number ** $n;
}

sub sin {
    my ($number) = @_;
    return CORE::sin $number;
}

sub sqrt {
    my ($number) = @_;
    return CORE::sqrt $number;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Number;

=head1 DESCRIPTION

Data::Object::Role::Number provides functions for operating on Perl 5 numeric
data.

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

L<Data::Object::Role::Scalar>

=item *

L<Data::Object::Role::String>

=item *

L<Data::Object::Role::Undef>

=item *

L<Data::Object::Role::Universal>

=back

=cut
