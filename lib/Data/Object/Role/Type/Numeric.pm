# A Numeric Data Type Role for Perl 5
package Data::Object::Role::Type::Numeric;

use 5.010;
use Moo::Role;

# VERSION

sub downto {
    my ($integer, $argument) = @_;
    return [reverse $argument..$integer];
}

sub eq {
    my ($integer, $argument) = @_;
    return $integer == $argument ? 1 : 0;
}

sub gt {
    my ($integer, $argument) = @_;
    return $integer > $argument ? 1 : 0;
}

sub gte {
    my ($integer, $argument) = @_;
    return $integer >= $argument ? 1 : 0;
}

sub lt {
    my ($integer, $argument) = @_;
    return $integer < $argument ? 1 : 0;
}

sub lte {
    my ($integer, $argument) = @_;
    return $integer <= $argument ? 1 : 0;
}

sub ne {
    my ($integer, $argument) = @_;
    return $integer != $argument ? 1 : 0;
}

sub to {
    my ($integer, $argument) = @_;
    return [$integer..$argument] if $integer <= $argument;
    return [reverse($argument..$integer)];
}

sub upto {
    my ($integer, $argument) = @_;
    return [$integer..$argument];
}

1;
