# ABSTRACT: A Hash Object Role for Perl 5
package Data::Object::Role::Hash;

use 5.010;
use Moo::Role;

use Data::Object 'codify';
use Scalar::Util 'blessed';
use Storable     'dclone';

map with($_), our @ROLES = qw(
    Data::Object::Role::Defined
    Data::Object::Role::Collection
    Data::Object::Role::Detract
    Data::Object::Role::Keyed
    Data::Object::Role::Output
    Data::Object::Role::Ref
    Data::Object::Role::Values
);

# VERSION

sub aslice {
    goto &array_slice;
}

sub array_slice {
    my ($hash, @arguments) = @_;
    return [@{$hash}{@arguments}];
}

sub clear {
    goto &empty;
}

sub defined {
    my ($hash, $argument) = @_;
    return CORE::defined $hash->{$argument};
}

sub delete {
    my ($hash, $argument) = @_;
    return CORE::delete $hash->{$argument};
}

sub each {
    my ($hash, $code, @arguments) = @_;
    $code = codify $code if !ref $code;

    for my $key (CORE::keys %$hash) {
      $code->($key, $hash->{$key}, @arguments);
    }

    return $hash;
}

sub each_key {
    my ($hash, $code, @arguments) = @_;

    $code = codify $code if !ref $code;
    $code->($_, @arguments) for CORE::keys %$hash;

    return $hash;
}

sub each_n_values {
    my ($hash, $number, $code, @arguments) = @_;

    $code = codify $code if !ref $code;
    my @values = CORE::values %$hash;
    $code->(CORE::splice(@values, 0, $number), @arguments) while @values;

    return $hash;
}

sub each_value {
    my ($hash, $code, @arguments) = @_;

    $code = codify $code if !ref $code;
    $code->($_, @arguments) for CORE::values %$hash;

    return $hash;
}

sub empty {
    my ($hash) = @_;
    CORE::delete @$hash{CORE::keys %$hash};
    return $hash;
}

sub exists {
    my ($hash, $key) = @_;
    return CORE::exists $hash->{$key};
}

sub filter_exclude {
    my ($hash, @arguments) = @_;
    my %i = map { $_ => $_ } @arguments;

    return {
        CORE::map  { CORE::exists $hash->{$_} ? ($_ => $hash->{$_}) : () }
        CORE::grep { not CORE::exists $i{$_} } CORE::keys %$hash
    };
}

sub filter_include {
    my ($hash, @arguments) = @_;

    return {
        CORE::map { CORE::exists $hash->{$_} ? ($_ => $hash->{$_}) : () }
        @arguments
    };
}

sub get {
    my ($hash, $argument) = @_;
    return $hash->{$argument};
}

sub hash_slice {
    my ($hash, @arguments) = @_;
    return {CORE::map { $_ => $hash->{$_} } @arguments};
}

sub hslice {
    goto &hash_slice;
}

sub invert {
    my ($hash) = @_;

    my $temp = {};
    for (CORE::keys %$hash) {
        CORE::defined $hash->{$_} ?
            $temp->{CORE::delete $hash->{$_}} = $_ :
            CORE::delete $hash->{$_};
    }

    for (CORE::keys %$temp) {
        $hash->{$_} = CORE::delete $temp->{$_};
    }

    return $hash;
}

sub iterator {
    my ($hash) = @_;
    my @keys = CORE::keys %{$hash};

    my $i = 0;
    return sub {
        return undef if $i > $#keys;
        return $hash->{$keys[$i++]};
    }
}

sub keys {
    my ($hash) = @_;
    return [CORE::keys %$hash];
}

sub lookup {
    my ($hash, $path) = @_;

    return undef unless ($hash and $path) and (
        ('HASH' eq ref($hash)) or blessed($hash) and $hash->isa('HASH')
    );

    return $hash->{$path} if $hash->{$path};

    my $next;
    my $rest;

    ($next, $rest) = $path =~ /(.*)\.([^\.]+)$/;
    return lookup($hash->{$next}, $rest) if $next and $hash->{$next};

    ($next, $rest) = $path =~ /([^\.]+)\.(.*)$/;
    return lookup($hash->{$next}, $rest) if $next and $hash->{$next};

    return undef;
}

sub pairs {
    goto &pairs_array;
}

sub pairs_array {
    my ($hash) = @_;
    return [CORE::map { [ $_, $hash->{$_} ] } CORE::keys %$hash];
}

sub merge {
    my ($hash, @arguments) = @_;

    return dclone $hash unless @arguments;
    return dclone merge($hash, merge(@arguments)) if @arguments > 1;

    my ($right) = @arguments;

    my %merge = %$hash;
    for my $key (CORE::keys %$right) {
        my ($rv, $lv) = CORE::map { ref $$_{$key} eq 'HASH' } $right, $hash;
        if ($rv and $lv){ $merge{$key} = merge($hash->{$key}, $right->{$key}) }
        else { $merge{$key} = $right->{$key} }
    }

    return dclone \%merge;
}

sub reset {
    my ($hash) = @_;
    @$hash{CORE::keys %$hash} = ();
    return $hash;
}

sub reverse {
    my ($hash) = @_;

    my $temp = {};
    for (CORE::keys %$hash) {
        $temp->{$_} = $hash->{$_} if CORE::defined $hash->{$_};
    }

    return {CORE::reverse %$temp};
}

sub set {
    my ($hash, $key, $argument) = @_;
    return $hash->{$key} = $argument;
}

sub values {
    my ($hash) = @_;
    return [CORE::values %$hash];
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Hash;

=head1 DESCRIPTION

Data::Object::Role::Hash provides functions for operating on Perl 5 hash
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
