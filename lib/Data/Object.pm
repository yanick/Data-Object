# ABSTRACT: Data Type Objects for Perl 5
package Data::Object;

use 5.10.0;

use strict;
use warnings;

use Carp;
use Exporter 'import';

use Scalar::Util qw(
    blessed
    looks_like_number
);

our @EXPORT_OK = qw(
    deduce
    type_array
    type_code
    type_float
    type_hash
    type_integer
    type_number
    type_scalar
    type_string
    type_undef
    type_universal
);

# VERSION

sub load ($) {
    my $class = shift;
    my $failed = ! $class || $class !~ /^\w(?:[\w:']*\w)?$/;
    my $loaded = $class->can('new') || eval "require $class; 1";

    croak join ": ", "Error attempting to load $class", $@
        if $@ or $failed or not $loaded;

    return $class;
}

sub type_array ($) {
    unshift @_, my $class = load 'Data::Object::Array';
    goto $class->can('new');
}

sub type_code ($) {
    unshift @_, my $class = load 'Data::Object::Code';
    goto $class->can('new');
}

sub type_float ($) {
    unshift @_, my $class = load 'Data::Object::Float';
    goto $class->can('new');
}

sub type_hash ($) {
    unshift @_, my $class = load 'Data::Object::Hash';
    goto $class->can('new');
}

sub type_integer ($) {
    unshift @_, my $class = load 'Data::Object::Integer';
    goto $class->can('new');
}

sub type_number ($) {
    unshift @_, my $class = load 'Data::Object::Number';
    goto $class->can('new');
}

sub type_scalar ($) {
    unshift @_, my $class = load 'Data::Object::Scalar';
    goto $class->can('new');
}

sub type_string ($) {
    unshift @_, my $class = load 'Data::Object::String';
    goto $class->can('new');
}

sub type_undef ($) {
    unshift @_, my $class = load 'Data::Object::Undef';
    goto $class->can('new');
}

sub type_universal ($) {
    unshift @_, my $class = load 'Data::Object::Universal';
    goto $class->can('new');
}

sub deduce ($) {
    my $scalar = shift;

    # return undef
    if (not defined $scalar) {
        return type_undef $scalar;
    }

    # handle blessed objects
    elsif (blessed $scalar) {
        return type_scalar $scalar if $scalar->isa('Regexp');
        return $scalar;
    }

    # handle data types
    else {
        # handle references
        if (ref $scalar) {
            return type_array $scalar if 'ARRAY' eq ref $scalar;
            return type_hash  $scalar if 'HASH'  eq ref $scalar;
            return type_code  $scalar if 'CODE'  eq ref $scalar;
        }

        # handle non-references
        else {
            if (looks_like_number $scalar) {
                return type_float   $scalar  if $scalar =~ /\./;
                return type_integer $scalar if $scalar =~ /^\d+$/;
                return type_number  $scalar;
            }
            else {
                return type_string $scalar;
            }
        }

        # handle unhandled
        return type_scalar $scalar;
    }

    # fallback
    return type_undef $scalar;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object 'deduce';

    my $object = deduce [1..9];

    $object->count; # 9

=head1 DESCRIPTION

Data::Object provides functions for promoting Perl 5 native data types to
objects which provide common methods for operating on the data.

=cut

=function load

    # given 'List::Util';

    $package = load 'List::Util'; # List::Util if loaded

The load function attempts to dynamically load a module and either dies or
returns the package name of the loaded module.

=cut

=function deduce

    # given qr/\w+/;

    $object = deduce qr/\w+/;
    $object->isa('Data::Object::Scalar');

The deduce function returns a data type object instance based upon the deduced
type of data provided.

=cut

=function type_array

    # given [2..5];

    $object = type_array [2..5];
    $object->isa('Data::Object::Array');

The type_array function returns a L<Data::Object::Array> instance which wraps
the provided data type and can be used to perform operations on the data.

=cut

=function type_code

    # given sub { 1 };

    $object = type_code sub { 1 };
    $object->isa('Data::Object::Code');

The type_code function returns a L<Data::Object::Code> instance which wraps the
provided data type and can be used to perform operations on the data.

=cut

=function type_float

    # given 5.25;

    $object = type_float 5.25;
    $object->isa('Data::Object::Float');

The type_float function returns a L<Data::Object::Float> instance which wraps
the provided data type and can be used to perform operations on the data.

=cut

=function type_hash

    # given {1..4};

    $object = type_hash {1..4};
    $object->isa('Data::Object::Hash');

The type_hash function returns a L<Data::Object::Hash> instance which wraps the
provided data type and can be used to perform operations on the data.

=cut

=function type_integer

    # given 100;

    $object = type_integer 100;
    $object->isa('Data::Object::Integer');

The type_integer function returns a L<Data::Object::Object> instance which wraps
the provided data type and can be used to perform operations on the data.

=cut

=function type_number

    # given "-900";

    $object = type_number "-900";

The type_number function returns a L<Data::Object::Number> instance which wraps
the provided data type and can be used to perform operations on the data.

=cut

=function type_scalar

    # given qr/\w+/;

    $object = type_scalar qr/\w+/;
    $object->isa('Data::Object::Scalar');

The type_scalar function returns a L<Data::Object::Scalar> instance which wraps
the provided data type and can be used to perform operations on the data.

=cut

=function type_string

    # given 'abcdefghi';

    $object = type_string 'abcdefghi';
    $object->isa('Data::Object::String');

The type_string function returns a L<Data::Object::String> instance which wraps
the provided data type and can be used to perform operations on the data.

=cut

=function type_undef

    # given undef;

    $object = type_undef undef;
    $object->isa('Data::Object::Undef');

The type_undef function returns a L<Data::Object::Undef> instance which wraps
the provided data type and can be used to perform operations on the data.

=cut

=function type_universal

    # given 0;

    $object = type_universal 0;
    $object->isa('Data::Object::Universal');

The type_universal function returns a L<Data::Object::Universal> instance which
wraps the provided data type and can be used to perform operations on the data.

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object::Array>

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

L<Data::Object::Scalar>

=item *

L<Data::Object::String>

=item *

L<Data::Object::Undef>

=item *

L<Data::Object::Universal>

=back

=cut
