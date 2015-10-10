# ABSTRACT: Object Orientation for Perl 5
package Data::Object;

use strict;
use warnings;

use 5.014;

use Carp;
use Scalar::Util;
use Sub::Quote;

use Exporter qw(import);

# VERSION

my @CORE = grep !/^(data|type)_/, our @EXPORT_OK = qw(
    codify
    const
    data_array
    data_code
    data_float
    data_hash
    data_integer
    data_number
    data_regexp
    data_scalar
    data_string
    data_undef
    data_universal
    deduce
    deduce_deep
    deduce_type
    detract
    detract_deep
    immutable
    load
    prototype
    reify
    throw
    type_array
    type_code
    type_float
    type_hash
    type_integer
    type_number
    type_regexp
    type_scalar
    type_string
    type_undef
    type_universal
);

our %EXPORT_TAGS = (
    all  => [@EXPORT_OK],
    core => [@CORE],
    data => [grep m/^data_/, @EXPORT_OK],
    type => [grep m/^type_/, @EXPORT_OK],
);

sub new {

    shift and goto &deduce_deep;

}

sub const ($$) {

    my $name = shift;
    my $data = shift;

    my $class = caller(0);
       $class = caller(1) if __PACKAGE__ eq $class;

    my $fqsn  = $name =~ /(::|')/ ? $name : "${class}::${name}";

    no strict 'refs';
    no warnings 'redefine';

    *{ $fqsn } = sub () { (ref $data eq "CODE") ? goto &$data : $data };

    return $data;

}

sub codify ($;$) {

    my $code = shift;
    my $refs = shift;

    $code = reify($code);

    if ($code->type eq 'UNDEF') {

        # as you were !!!
        $code = q{ @_ };

    }

    elsif ($code->type eq 'CODE') {

        my $func = $code;

        # perform inception !!!
        $refs->{'$exec'} = \$func;
        $code = q{ goto &{$exec} };

    }

    # (facepalm) purely for backwards compatibility
    my $vars = sprintf 'my ($%s) = @_;', join ',$', 'a'..'z';
    my $body = sprintf '%s do { %s; }', $vars, "$code" // '@_';

    my $func = Sub::Quote::quote_sub($body, ref($refs) ? $refs : {});

    return $func;

}

sub immutable ($) {

    my $class = load('Data::Object::Immutable');

    unshift @_, $class and goto $class->can('new');

}

sub load ($) {

    my $class = shift;

    my $failed = ! $class || $class !~ /^\w(?:[\w:']*\w)?$/;
    my $loaded;

    my $error = do {
        local $@;
        $loaded = $class->can('new') || eval "require $class; 1";
        $@
    };

    croak "Error attempting to load $class: $error"
        if $error or $failed or not $loaded;

    return $class;

}

sub prototype (@) {

    my $class = load('Data::Object::Prototype');

    unshift @_, $class and goto $class->can('new');

}

sub reify ($) {

    goto &deduce_deep;

}
sub throw (@) {

    my $class = load('Data::Object::Exception');

    unshift @_, $class and goto $class->can('throw');

}

sub data_array ($) {

    my $class = load('Data::Object::Array');

    unshift @_, $class and goto $class->can('new');

}

sub data_code ($) {

    my $class = load('Data::Object::Code');

    unshift @_, $class and goto $class->can('new');

}

sub data_float ($) {

    my $class = load('Data::Object::Float');

    unshift @_, $class and goto $class->can('new');

}

sub data_hash ($) {

    my $class = load('Data::Object::Hash');

    unshift @_, $class and goto $class->can('new');

}

sub data_integer ($) {

    my $class = load('Data::Object::Integer');

    unshift @_, $class and goto $class->can('new');

}

sub data_number ($) {

    my $class = load('Data::Object::Number');

    unshift @_, $class and goto $class->can('new');

}

sub data_regexp ($) {

    my $class = load('Data::Object::Regexp');

    unshift @_, $class and goto $class->can('new');

}

sub data_scalar ($) {

    my $class = load('Data::Object::Scalar');

    unshift @_, $class and goto $class->can('new');

}

sub data_string ($) {

    my $class = load('Data::Object::String');

    unshift @_, $class and goto $class->can('new');

}

sub data_undef (;$) {

    my $class = load('Data::Object::Undef');

    unshift @_, $class and goto $class->can('new');

}

sub data_universal ($) {

    my $class = load('Data::Object::Universal');

    unshift @_, $class and goto $class->can('new');

}

sub deduce ($) {

    my $data = shift;

    # return undefined
    if (not defined $data) {
        return data_undef $data;
    }

    # handle blessed
    elsif (Scalar::Util::blessed($data)) {
        return data_regexp $data if $data->isa('Regexp');
        return $data;
    }

    # handle defined
    else {

        # handle references
        if (ref $data) {
            return data_array $data if 'ARRAY' eq ref $data;
            return data_hash  $data if 'HASH'  eq ref $data;
            return data_code  $data if 'CODE'  eq ref $data;
        }

        # handle non-references
        else {
            if (Scalar::Util::looks_like_number($data)) {
                return data_float   $data if $data =~ /\./;
                return data_number  $data if $data =~ /^\d+$/;
                return data_integer $data;
            }
            else {
                return data_string $data;
            }
        }

        # handle unhandled
        return data_scalar $data;

    }

    # fallback
    return data_undef $data;

}

sub deduce_deep {

    my @data = @_;

    for my $data (@data) {
        my $type;

        $data = deduce($data);
        $type   = deduce_type($data);

        if ($type and $type eq 'HASH') {
            for my $i (keys %$data) {
                my $val = $data->{$i};
                $data->{$i} = ref($val) ? deduce_deep($val) : deduce($val);
            }
        }

        if ($type and $type eq 'ARRAY') {
            for (my $i = 0; $i < @$data; $i++) {
                my $val = $data->[$i];
                $data->[$i] = ref($val) ? deduce_deep($val) : deduce($val);
            }
        }
    }

    return wantarray ? (@data) : $data[0];

}

sub deduce_type ($) {

    my $data = shift;

    $data = deduce $data;

    return 'ARRAY'     if $data->isa('Data::Object::Array');
    return 'HASH'      if $data->isa('Data::Object::Hash');
    return 'CODE'      if $data->isa('Data::Object::Code');

    return 'FLOAT'     if $data->isa('Data::Object::Float');
    return 'NUMBER'    if $data->isa('Data::Object::Number');
    return 'INTEGER'   if $data->isa('Data::Object::Integer');

    return 'STRING'    if $data->isa('Data::Object::String');
    return 'SCALAR'    if $data->isa('Data::Object::Scalar');
    return 'REGEXP'    if $data->isa('Data::Object::Regexp');

    return 'UNDEF'     if $data->isa('Data::Object::Undef');
    return 'UNIVERSAL' if $data->isa('Data::Object::Universal');

    return undef;

}

sub detract ($) {

    my $data = shift;

    $data = deduce $data;

    my $type = deduce_type $data;

    INSPECT:
    return $data unless $type;

    return [@$data] if $type eq 'ARRAY';
    return {%$data} if $type eq 'HASH';
    return $$data   if $type eq 'REGEXP';
    return $$data   if $type eq 'FLOAT';
    return $$data   if $type eq 'NUMBER';
    return $$data   if $type eq 'INTEGER';
    return $$data   if $type eq 'STRING';
    return undef    if $type eq 'UNDEF';

    if ($type eq 'SCALAR' or $type eq 'UNIVERSAL') {

        $type = Scalar::Util::reftype($data) // '';

        return [@$data] if $type eq 'ARRAY';
        return {%$data} if $type eq 'HASH';
        return $$data   if $type eq 'FLOAT';
        return $$data   if $type eq 'INTEGER';
        return $$data   if $type eq 'NUMBER';
        return $$data   if $type eq 'REGEXP';
        return $$data   if $type eq 'SCALAR';
        return $$data   if $type eq 'STRING';
        return undef    if $type eq 'UNDEF';

        if ($type eq 'REF') {
            $type = deduce_type($data = $$data)
                and goto INSPECT;
        }

    }

    if ($type eq 'CODE') {
        return sub { goto &{$data} };
    }

    return undef;

}

sub detract_deep {

    my @data = @_;

    for my $data (@data) {
        $data = detract($data);

        if ($data and 'HASH' eq ref $data) {
            for my $i (keys %$data) {
                my $val = $data->{$i};
                $data->{$i} = ref($val) ? detract_deep($val) : detract($val);
            }
        }

        if ($data and 'ARRAY' eq ref $data) {
            for (my $i = 0; $i < @$data; $i++) {
                my $val = $data->[$i];
                $data->[$i] = ref($val) ? detract_deep($val) : detract($val);
            }
        }
    }

    return wantarray ? (@data) : $data[0];

}

{

    # aliases
    no warnings 'once';

    *type_array     = *data_array;
    *type_code      = *data_code;
    *type_float     = *data_float;
    *type_hash      = *data_hash;
    *type_integer   = *data_integer;
    *type_number    = *data_number;
    *type_regexp    = *data_regexp;
    *type_scalar    = *data_scalar;
    *type_string    = *data_string;
    *type_undef     = *data_undef;
    *type_universal = *data_universal;

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object;

    # returns a code object
    my $object = Data::Object->new(sub{ join ' ', @_ });

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

=head1 DESCRIPTION

Data::Object is a framework for writing structured and highly object-oriented
Perl 5 software programs. Additionally, this distribution provides classes
which wrap Perl 5 native data types and provides methods for operating on the
data.

=cut

=export all

    use Data::Object qw(:all);

The all export tag will export all exportable functions.

=cut

=export core

    use Data::Object qw(:core);

The core export tag will export the exportable functions C<const>, C<deduce>,
C<deduce_deep>, C<detract>, C<detract_deep>, C<immutable>, C<load>, C<prototype>,
C<reify>, and C<throw> exclusively.

=cut

=export data

    use Data::Object qw(:data);

The data export tag will export all exportable functions whose names are
prefixed with the word "data".

=cut

=export type

    use Data::Object qw(:type);

The type export tag will export all exportable functions whose names are
prefixed with the word "type".

=cut

=function const

    # given 1.098765;

    const VERSION => 1.098765;

The const function creates a constant function using the name and expression
supplied to it. A constant function is a function that does not accept any
arguments and whose result(s) are deterministic.

=cut

=function data_array

    # given [2..5];

    $object = data_array [2..5];
    $object->isa('Data::Object::Array');

The data_array function returns a L<Data::Object::Array> instance which wraps
the provided data type and can be used to perform operations on the data. The
C<type_array> function is an alias to this function.

=cut

=function data_code

    # given sub { 1 };

    $object = data_code sub { 1 };
    $object->isa('Data::Object::Code');

The data_code function returns a L<Data::Object::Code> instance which wraps the
provided data type and can be used to perform operations on the data. The
C<type_code> function is an alias to this function.

=cut

=function data_float

    # given 5.25;

    $object = data_float 5.25;
    $object->isa('Data::Object::Float');

The data_float function returns a L<Data::Object::Float> instance which wraps
the provided data type and can be used to perform operations on the data. The
C<type_float> function is an alias to this function.

=cut

=function data_hash

    # given {1..4};

    $object = data_hash {1..4};
    $object->isa('Data::Object::Hash');

The data_hash function returns a L<Data::Object::Hash> instance which wraps the
provided data type and can be used to perform operations on the data. The
C<type_hash> function is an alias to this function.

=cut

=function data_integer

    # given -100;

    $object = data_integer -100;
    $object->isa('Data::Object::Integer');

The data_integer function returns a L<Data::Object::Object> instance which wraps
the provided data type and can be used to perform operations on the data. The
C<type_integer> function is an alias to this function.

=cut

=function data_number

    # given 100;

    $object = data_number 100;
    $object->isa('Data::Object::Number');

The data_number function returns a L<Data::Object::Number> instance which wraps
the provided data type and can be used to perform operations on the data. The
C<type_number> function is an alias to this function.

=cut

=function data_regexp

    # given qr/test/;

    $object = data_regexp qr/test/;
    $object->isa('Data::Object::Regexp');

The data_regexp function returns a L<Data::Object::Regexp> instance which wraps
the provided data type and can be used to perform operations on the data. The
C<type_regexp> function is an alias to this function.

=cut

=function data_scalar

    # given \*main;

    $object = data_scalar \*main;
    $object->isa('Data::Object::Scalar');

The data_scalar function returns a L<Data::Object::Scalar> instance which wraps
the provided data type and can be used to perform operations on the data. The
C<type_scalar> function is an alias to this function.

=cut

=function data_string

    # given 'abcdefghi';

    $object = data_string 'abcdefghi';
    $object->isa('Data::Object::String');

The data_string function returns a L<Data::Object::String> instance which wraps
the provided data type and can be used to perform operations on the data. The
C<type_string> function is an alias to this function.

=cut

=function data_undef

    # given undef;

    $object = data_undef undef;
    $object->isa('Data::Object::Undef');

The data_undef function returns a L<Data::Object::Undef> instance which wraps
the provided data type and can be used to perform operations on the data. The
C<type_undef> function is an alias to this function.

=cut

=function data_universal

    # given 0;

    $object = data_universal 0;
    $object->isa('Data::Object::Universal');

The data_universal function returns a L<Data::Object::Universal> instance which
wraps the provided data type and can be used to perform operations on the data.
The C<type_universal> function is an alias to this function.

=cut

=function deduce

    # given qr/\w+/;

    $object = deduce qr/\w+/;
    $object->isa('Data::Object::Regexp');

The deduce function returns a data type object instance based upon the deduced
type of data provided.

=cut

=function deduce_deep

    # given {1,2,3,{4,5,6,[-1]}}

    $deep = deduce_deep {1,2,3,{4,5,6,[-1]}};

    # Data::Object::Hash {
    #     1 => Data::Object::Number ( 2 ),
    #     3 => Data::Object::Hash {
    #          4 => Data::Object::Number ( 5 ),
    #          6 => Data::Object::Array [ Data::Object::Integer ( -1 ) ],
    #     },
    # }

The deduce_deep function returns a data type object. If the data provided is
complex, this function traverses the data converting all nested data to objects.
Note: Blessed objects are not traversed.

=cut

=function deduce_type

    # given qr/\w+/;

    $type = deduce_type qr/\w+/; # REGEXP

The deduce_type function returns a data type description for the type of data
provided, represented as a string in capital letters.

=cut

=function detract

    # given bless({1..4}, 'Data::Object::Hash');

    $object = detract $object; # {1..4}

The detract function returns a value of native type, based upon the underlying
reference of the data type object provided.

=cut

=function detract_deep

    # given {1,2,3,{4,5,6,[-1, 99, bless({}), sub { 123 }]}};

    my $object = deduce_deep $object;
    my $revert = detract_deep $object; # produces ...

    # {
    #     '1' => 2,
    #     '3' => {
    #         '4' => 5,
    #         '6' => [ -1, 99, bless({}, 'main'), sub { ... } ]
    #       }
    # }

The detract_deep function returns a value of native type. If the data provided
is complex, this function traverses the data converting all nested data type
objects into native values using the objects underlying reference. Note:
Blessed objects are not traversed.

=cut

=function immutable

    # given [1,2,3];

    $object = immutable data_array [1,2,3];
    $object->isa('Data::Object::Array); # via Data::Object::Immutable

The immutable function makes the data type object provided immutable. This
function loads L<Data::Object::Immutable> and returns the object provided as an
argument.

=cut

=function load

    # given 'List::Util';

    $package = load 'List::Util'; # List::Util if loaded

The load function attempts to dynamically load a module and either dies or
returns the package name of the loaded module.

=cut

=function prototype

    # given ('$name' => [is => 'ro']);

    my $proto  = data_prototype '$name' => [is => 'ro'];
    my $class  = $proto->create; # via Data::Object::Prototype
    my $object = $class->new(name => '...');

The prototype function returns a prototype object which can be used to
generate classes, objects, and derivatives. This function loads
L<Data::Object::Prototype> and returns an object based on the arguments
provided.

=cut

=function reify

    # given [1..9];

    $array = reify [1..9]; # Data::Object::Array

The reify function will determine the type of the value provided and return it
as a data type object. This method is an alias to the C<deduce_deep> function.

=cut

=function throw

    # given $message;

    throw $message; # An exception (...) was thrown in -e at line 1

The throw function will dynamically load and throw an exception object. This
function takes all arguments accepted by the L<Data::Object::Exception> class.

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
