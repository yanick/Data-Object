# ABSTRACT: An Array Object Role for Perl 5
package Data::Object::Role::Array;

use 5.010;
use Moo::Role;

use Scalar::Util 'looks_like_number';

# VERSION

my $codify = sub {
    return(eval(
    CORE::sprintf('sub{%sdo{%s}}',
    CORE::sprintf('my($%s)=@_;',
    CORE::join   (',$', 'a'..'z')),
    CORE::shift // 'return(@_)')) or die $@);
};

sub all {
    my ($array, $code, @arguments) = @_;

    $code = $code->$codify if !ref $code;
    my $found = CORE::grep { $code->($_, @arguments) } @$array;

    return $found == @$array ? 1 : 0;
}

sub any {
    my ($array, $code, @arguments) = @_;

    $code = $code->$codify if !ref $code;
    my $found = CORE::grep { $code->($_, @arguments) } @$array;

    return $found ? 1 : 0;
}

sub clear {
    goto &empty;
}

sub count {
    goto &length;
}

sub defined {
    my ($array, $index) = @_;
    return CORE::defined $array->[$index];
}

sub delete {
    my ($array, $index) = @_;
    return CORE::delete $array->[$index];
}

sub each {
    my ($array, $code, @arguments) = @_;

    my $i=0;
    $code = $code->$codify if !ref $code;
    foreach my $value (@$array) {
        $code->($i, $value, @arguments); $i++;
    }

    return $array;
}

sub each_key {
    my ($array, $code, @arguments) = @_;

    $code = $code->$codify if !ref $code;
    $code->($_, @arguments) for (0..$#{$array});

    return $array;
}

sub each_n_values {
    my ($array, $number, $code, @arguments) = @_;

    my @values = @$array;
    $code = $code->$codify if !ref $code;
    $code->(splice(@values, 0, $number), @arguments) while @values;

    return $array;
}

sub each_value {
    my ($array, $code, @arguments) = @_;

    $code = $code->$codify if !ref $code;
    $code->($array->[$_], @arguments) for (0..$#{$array});

    return $array;
}

sub empty {
    my ($array) = @_;
    $#$array = -1;
    return $array;
}

sub exists {
    my ($array, $index) = @_;
    return $index <= $#{$array};
}

sub first {
    my ($array) = @_;
    return $array->[0];
}

sub get {
    my ($array, $index) = @_;
    return $array->[$index];
}

sub grep {
    my ($array, $code, @arguments) = @_;
    $code = $code->$codify if !ref $code;
    return $array->new([CORE::grep { $code->($_, @arguments) } @$array]);
}

sub hashify {
    my ($array) = @_;

    my $data = {};
    for (CORE::grep { CORE::defined $_ } @$array) {
        $data->{$_} = 1;
    }

    return $data;
}

sub head {
    my ($array) = @_;
    return $array->[0];
}

sub iterator {
    my ($array) = @_;
    my $i=0;

    return sub {
        return undef if $i > $#{$array};
        return $array->[$i++];
    }
}

sub join {
    my ($array, $separator) = @_;
    return join $separator // '', @$array;
}

sub keyed {
    my ($array, @keys) = @_;

    my $i=0;
    return { map { $_ => $array->[$i++] } @keys };
}

sub keys {
    my ($array) = @_;
    return $array->new([0 .. $#{$array}]);
}

sub last {
    my ($array) = @_;
    return $array->[-1];
}

sub length {
    my ($array) = @_;
    return scalar @$array;
}

sub map {
    my ($array, $code, @arguments) = @_;
    $code = $code->$codify if !ref $code;
    return [map { $code->($_, @arguments) } @$array];
}

sub max {
    my ($array) = @_;

    my $max;
    for my $val (@$array) {
        next if ref($val);
        next if ! CORE::defined($val);
        next if ! looks_like_number($val);
        $max //= $val;
        $max = $val if $val > $max;
    }

    return $max;
}

sub min {
    my ($array) = @_;

    my $min;
    for my $val (@$array) {
        next if ref($val);
        next if ! CORE::defined($val);
        next if ! looks_like_number($val);
        $min //= $val;
        $min = $val if $val < $min;
    }

    return $min;
}

sub none {
    my ($array, $code, @arguments) = @_;
    $code = $code->$codify if !ref $code;
    my $found = CORE::grep { $code->($_, @arguments) } @$array;
    return $found ? 0 : 1;
}

sub nsort {
    my ($array) = @_;
    return [sort { $a <=> $b } @$array];
}

sub one {
    my ($array, $code, @arguments) = @_;
    $code = $code->$codify if !ref $code;
    my $found = CORE::grep { $code->($_, @arguments) } @$array;
    return $found == 1 ? 1 : 0;
}

sub pairs {
    goto &pairs_array;
}

sub pairs_array {
    my ($array) = @_; my $i=0;
    return [map +[$i++, $_], @$array];
}

sub pairs_hash {
    my ($array) = @_; my $i=0;
    return {map {$i++ => $_} @$array};
}

sub part {
    my ($array, $code, @arguments) = @_;
    $code = $code->$codify if !ref $code;

    my $result = [[],[]];
    foreach my $value (@$array) {
        my $slot = $code->($value, @arguments) ?
            $$result[0] : $$result[1]
        ;
        push @$slot, $value;
    }

    return $result;
}

sub pop {
    my ($array) = @_;
    return pop @$array;
}

sub push {
    my ($array, @arguments) = @_;
    push @$array, @arguments;
    return $array;
}

sub random {
    my ($array) = @_;
    return @$array[rand(1+$#{$array})];
}

sub reverse {
    my ($array) = @_;
    return [reverse @$array];
}

sub rotate {
    my ($array) = @_;
    CORE::push @$array, CORE::shift @$array;
    return $array;
}

sub rnsort {
    my ($array) = @_;
    return [sort { $b <=> $a } @$array];
}

sub rsort {
    my ($array) = @_;
    return [sort { $b cmp $a } @$array];
}

sub set {
    my ($array, $index, $value) = @_;
    return $array->[$index] = $value;
}

sub shift {
    my ($array) = @_;
    return CORE::shift @$array;
}

sub size {
    goto &length;
}

sub slice {
    my ($array, @arguments) = @_;
    return [@$array[@arguments]];
}

sub sort {
    my ($array) = @_;
    return [sort { $a cmp $b } @$array];
}

sub sum {
    my ($array) = @_;

    my $sum = 0;
    for my $val (@$array) {
        next if ref($val);
        next if !CORE::defined($val);
        next if !looks_like_number($val);
        $sum += $val;
    }

    return $sum;
}

sub tail {
    my ($array) = @_;
    return [@$array[1 .. $#$array]];
}

sub unique {
    my ($array) = @_; my %seen;
    return [CORE::grep { not $seen{$_}++ } @$array];
}

sub unshift {
    my ($array, @arguments) = @_;
    CORE::unshift @$array, @arguments;
    return $array;
}

sub values {
    my ($array) = @_;
    return [@$array];
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Array;

=head1 DESCRIPTION

Data::Object::Role::Array provides functions for operating on Perl 5 array
references.

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

=item *

L<Data::Object::Autobox>

=back

=cut
