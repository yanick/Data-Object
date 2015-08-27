# ABSTRACT: Hash Object Role for Perl 5
package Data::Object::Role::Hash;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object;
use Data::Object::Role;
use Scalar::Util;
use Storable;

map with($_), our @ROLES = qw(
    Data::Object::Role::Defined
    Data::Object::Role::Collection
    Data::Object::Role::Detract
    Data::Object::Role::Keyed
    Data::Object::Role::Output
    Data::Object::Role::Ref
    Data::Object::Role::Values
    Data::Object::Role::Type
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
    return CORE::defined($hash->{$argument});
}

sub delete {
    my ($hash, $argument) = @_;
    return CORE::delete($hash->{$argument});
}

sub each {
    my ($hash, $code, @arguments) = @_;
    $code = Data::Object::codify($code) if !ref $code;

    for my $key (CORE::keys %$hash) {
      $code->($key, $hash->{$key}, @arguments);
    }

    return $hash;
}

sub each_key {
    my ($hash, $code, @arguments) = @_;

    $code = Data::Object::codify($code) if !ref $code;
    $code->($_, @arguments) for CORE::keys %$hash;

    return $hash;
}

sub each_n_values {
    my ($hash, $number, $code, @arguments) = @_;

    $code = Data::Object::codify($code) if !ref $code;
    my @values = CORE::values %$hash;
    $code->(CORE::splice(@values, 0, $number), @arguments) while @values;

    return $hash;
}

sub each_value {
    my ($hash, $code, @arguments) = @_;

    $code = Data::Object::codify($code) if !ref $code;
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
    return CORE::exists($hash->{$key});
}

sub filter_exclude {
    my ($hash, @arguments) = @_;
    my %i = map { $_ => $_ } @arguments;

    return {
        CORE::map  { CORE::exists($hash->{$_}) ? ($_ => $hash->{$_}) : () }
        CORE::grep { not CORE::exists($i{$_}) } CORE::keys %$hash
    };
}

sub filter_include {
    my ($hash, @arguments) = @_;

    return {
        CORE::map { CORE::exists($hash->{$_}) ? ($_ => $hash->{$_}) : () }
        @arguments
    };
}

sub fold {
    my ($data, $path, $store, $cache) = @_;

    $store ||= {};
    $cache ||= {};

    my $ref = CORE::ref($data);
    my $obj = Scalar::Util::blessed($data);
    my $adr = Scalar::Util::refaddr($data);
    my $tmp = { %$cache };

    if ($adr && $tmp->{$adr}) {
        $store->{$path} = $data;
    } elsif ($ref eq 'HASH'  || ($obj and $obj->isa('Data::Object::Hash'))) {
        $tmp->{$adr} = 1;
        if (%$data) {
            for my $key (CORE::sort(CORE::keys %$data)) {
                my $place = $path ? CORE::join('.', $path, $key) : $key;
                my $value = $data->{$key};
                fold($value, $place, $store, $tmp);
            }
        } else {
            $store->{$path} = {};
        }
    } elsif ($ref eq 'ARRAY' || ($obj and $obj->isa('Data::Object::Array'))) {
        $tmp->{$adr} = 1;
        if (@$data) {
            for my $idx (0 .. $#$data) {
                my $place = $path ? CORE::join(':', $path, $idx) : $idx;
                my $value = $data->[$idx];
                fold($value, $place, $store, $tmp);
            }
        } else {
            $store->{$path} = [];
        }
    } else {
        $store->{$path} = $data;
    }

    return $store;
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
        CORE::defined($hash->{$_}) ?
            $temp->{CORE::delete($hash->{$_})} = $_ :
            CORE::delete($hash->{$_});
    }

    for (CORE::keys %$temp) {
        $hash->{$_} = CORE::delete($temp->{$_});
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
        ('HASH' eq ref($hash)) or Scalar::Util::blessed($hash)
            and $hash->isa('HASH')
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
    my ($left, @arguments) = @_;

    return Storable::dclone($left) if ! @arguments;
    return Storable::dclone merge($left, merge(@arguments)) if @arguments > 1;

    my ($right) = @arguments;
    my (%merge) = %$left;

    for my $key (CORE::keys %$right) {
        my $lprop = $$left{$key};
        my $rprop = $$right{$key};

        $merge{$key} = ((ref($rprop) eq 'HASH') and (ref($lprop) eq 'HASH'))
            ? merge($$left{$key}, $$right{$key}) : $$right{$key};
    }

    return Storable::dclone \%merge;
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
        $temp->{$_} = $hash->{$_} if CORE::defined($hash->{$_});
    }

    return {CORE::reverse %$temp};
}

sub set {
    my ($hash, $key, $argument) = @_;
    return $hash->{$key} = $argument;
}

sub unfold {
    my ($hash) = @_;

    my $store = {};
    for my $key (CORE::sort(CORE::keys(%$hash))) {
        my $node = $store;
        my @steps = CORE::split(/\./, $key);
        for (my $i=0; $i < @steps; $i++) {
            my $last = $i == $#steps;
            my $step = $steps[$i];
            if (my @parts = $step =~ /^(\w*):(0|[1-9]\d*)$/) {
                $node = $node->{$parts[0]}[$parts[1]] = $last
                    ? $hash->{$key}
                    : exists $node->{$parts[0]}[$parts[1]]
                    ?        $node->{$parts[0]}[$parts[1]]
                    : {};
            } else {
                $node = $node->{$step} = $last
                    ? $hash->{$key}
                    : exists $node->{$step}
                    ?        $node->{$step}
                    : {};
            }
        }
    }

    return $store;
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

=head1 ROLES

This role is composed of the following roles.

=over 4

=item *

L<Data::Object::Role::Collection>

=item *

L<Data::Object::Role::Defined>

=item *

L<Data::Object::Role::Detract>

=item *

L<Data::Object::Role::Keyed>

=item *

L<Data::Object::Role::Output>

=item *

L<Data::Object::Role::Ref>

=item *

L<Data::Object::Role::Values>

=back

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
