# ABSTRACT: Data Type Objects for Perl 5
package Data::Object;

use 5.10.0;

use strict;
use warnings;

use Carp;
use Exporter 'import';

use Types::Standard ();
use Scalar::Util qw(
    blessed
    looks_like_number
);

our @EXPORT_OK = qw(
    deduce
    deduce_deep
    deduce_type
    load
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

push @EXPORT_OK, qw(
    asa_aref
    asa_arrayref
    asa_bool
    asa_boolean
    asa_class
    asa_classname
    asa_coderef
    asa_cref
    asa_def
    asa_defined
    asa_fh
    asa_filehandle
    asa_glob
    asa_globref
    asa_hashref
    asa_href
    asa_int
    asa_integer
    asa_nil
    asa_null
    asa_num
    asa_number
    asa_obj
    asa_object
    asa_ref
    asa_reference
    asa_regexpref
    asa_rref
    asa_scalarref
    asa_sref
    asa_str
    asa_string
    asa_undef
    asa_undefined
    asa_val
    asa_value
    isa_aref
    isa_arrayref
    isa_bool
    isa_boolean
    isa_class
    isa_classname
    isa_coderef
    isa_cref
    isa_def
    isa_defined
    isa_fh
    isa_filehandle
    isa_glob
    isa_globref
    isa_hashref
    isa_href
    isa_int
    isa_integer
    isa_nil
    isa_null
    isa_num
    isa_number
    isa_obj
    isa_object
    isa_ref
    isa_reference
    isa_regexpref
    isa_rref
    isa_scalarref
    isa_sref
    isa_str
    isa_string
    isa_undef
    isa_undefined
    isa_val
    isa_value
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
    # ... using spaces for clarity
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
                return type_float   $scalar if $scalar =~ /\./;
                return type_number  $scalar if $scalar =~ /^\d+$/;
                return type_integer $scalar;
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

sub deduce_deep {
    my @objects = @_;

    for my $object (@objects) {
        my $type = deduce_type($object);

        if ($type and $type eq 'HASH') {
            for my $i (keys %$object) {
                my $val = $object->{$i};
                $object->{$i} = ref($val) ? deduce_deep($val) : deduce($val);
            }
        }

        if ($type and $type eq 'ARRAY') {
            for (my $i = 0; $i < @$object; $i++) {
                my $val = $object->[$i];
                $object->[$i] = ref($val) ? deduce_deep($val) : deduce($val);
            }
        }
    }

    return wantarray ? (@objects) : $objects[0];
}

sub deduce_type ($) {
    my $object = deduce shift;

    return 'ARRAY'     if $object->isa('Data::Object::Array');
    return 'HASH'      if $object->isa('Data::Object::Hash');
    return 'CODE'      if $object->isa('Data::Object::Code');

    return 'FLOAT'     if $object->isa('Data::Object::Float');
    return 'NUMBER'    if $object->isa('Data::Object::Number');
    return 'INTEGER'   if $object->isa('Data::Object::Integer');

    return 'STRING'    if $object->isa('Data::Object::String');
    return 'SCALAR'    if $object->isa('Data::Object::Scalar');

    return 'UNDEF'     if $object->isa('Data::Object::Undef');
    return 'UNIVERSAL' if $object->isa('Data::Object::Universal');

    return undef;
}

{
    no warnings 'once';
    *asa_aref       = \&Types::Standard::assert_ArrayRef;
    *asa_arrayref   = \&Types::Standard::assert_ArrayRef;
    *asa_bool       = \&Types::Standard::assert_Bool;
    *asa_boolean    = \&Types::Standard::assert_Bool;
    *asa_class      = \&Types::Standard::assert_ClassName;
    *asa_classname  = \&Types::Standard::assert_ClassName;
    *asa_coderef    = \&Types::Standard::assert_CodeRef;
    *asa_cref       = \&Types::Standard::assert_CodeRef;
    *asa_def        = \&Types::Standard::assert_Defined;
    *asa_defined    = \&Types::Standard::assert_Defined;
    *asa_fh         = \&Types::Standard::assert_FileHandle;
    *asa_filehandle = \&Types::Standard::assert_FileHandle;
    *asa_glob       = \&Types::Standard::assert_GlobRef;
    *asa_globref    = \&Types::Standard::assert_GlobRef;
    *asa_hashref    = \&Types::Standard::assert_HashRef;
    *asa_href       = \&Types::Standard::assert_HashRef;
    *asa_int        = \&Types::Standard::assert_Int;
    *asa_integer    = \&Types::Standard::assert_Int;
    *asa_nil        = \&Types::Standard::assert_Undef;
    *asa_null       = \&Types::Standard::assert_Undef;
    *asa_num        = \&Types::Standard::assert_Num;
    *asa_number     = \&Types::Standard::assert_Num;
    *asa_obj        = \&Types::Standard::assert_Object;
    *asa_object     = \&Types::Standard::assert_Object;
    *asa_ref        = \&Types::Standard::assert_Ref;
    *asa_reference  = \&Types::Standard::assert_Ref;
    *asa_regexpref  = \&Types::Standard::assert_RegexpRef;
    *asa_rref       = \&Types::Standard::assert_RegexpRef;
    *asa_scalarref  = \&Types::Standard::assert_ScalarRef;
    *asa_sref       = \&Types::Standard::assert_ScalarRef;
    *asa_str        = \&Types::Standard::assert_Str;
    *asa_string     = \&Types::Standard::assert_Str;
    *asa_undef      = \&Types::Standard::assert_Undef;
    *asa_undefined  = \&Types::Standard::assert_Undef;
    *asa_val        = \&Types::Standard::assert_Value;
    *asa_value      = \&Types::Standard::assert_Value;
    *isa_aref       = \&Types::Standard::is_ArrayRef;
    *isa_arrayref   = \&Types::Standard::is_ArrayRef;
    *isa_bool       = \&Types::Standard::is_Bool;
    *isa_boolean    = \&Types::Standard::is_Bool;
    *isa_class      = \&Types::Standard::is_ClassName;
    *isa_classname  = \&Types::Standard::is_ClassName;
    *isa_coderef    = \&Types::Standard::is_CodeRef;
    *isa_cref       = \&Types::Standard::is_CodeRef;
    *isa_def        = \&Types::Standard::is_Defined;
    *isa_defined    = \&Types::Standard::is_Defined;
    *isa_fh         = \&Types::Standard::is_FileHandle;
    *isa_filehandle = \&Types::Standard::is_FileHandle;
    *isa_glob       = \&Types::Standard::is_GlobRef;
    *isa_globref    = \&Types::Standard::is_GlobRef;
    *isa_hashref    = \&Types::Standard::is_HashRef;
    *isa_href       = \&Types::Standard::is_HashRef;
    *isa_int        = \&Types::Standard::is_Int;
    *isa_integer    = \&Types::Standard::is_Int;
    *isa_nil        = \&Types::Standard::is_Undef;
    *isa_null       = \&Types::Standard::is_Undef;
    *isa_num        = \&Types::Standard::is_Num;
    *isa_number     = \&Types::Standard::is_Num;
    *isa_obj        = \&Types::Standard::is_Object;
    *isa_object     = \&Types::Standard::is_Object;
    *isa_ref        = \&Types::Standard::is_Ref;
    *isa_reference  = \&Types::Standard::is_Ref;
    *isa_regexpref  = \&Types::Standard::is_RegexpRef;
    *isa_rref       = \&Types::Standard::is_RegexpRef;
    *isa_scalarref  = \&Types::Standard::is_ScalarRef;
    *isa_sref       = \&Types::Standard::is_ScalarRef;
    *isa_str        = \&Types::Standard::is_Str;
    *isa_string     = \&Types::Standard::is_Str;
    *isa_undef      = \&Types::Standard::is_Undef;
    *isa_undefined  = \&Types::Standard::is_Undef;
    *isa_val        = \&Types::Standard::is_Value;
    *isa_value      = \&Types::Standard::is_Value;
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object 'deduce';

    my $object = deduce [1..9];

    $object->count; # 9

=head1 DESCRIPTION

Data::Object provides functions for promoting Perl 5 native data types to
objects which provide common methods for operating on the data. B<Note: This is
an early release available for testing and feedback and as such is subject to
change.>

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

=function deduce_deep

    # given {1,2,3,{4,5,6,[-1]}}

    $deep = deduce_deep {1,2,3,{4,5,6,[-1]}}; # produces ...

    # Data::Object::Hash {
    #     1 => Data::Object::Number ( 2 ),
    #     3 => Data::Object::Hash {
    #          4 => Data::Object::Number ( 5 ),
    #          6 => Data::Object::Array [ Data::Object::Integer ( -1 ) ],
    #     },
    # }

The deduce_deep function returns a data type object. If the data provided is
complex, this function traverses the data converting all nested data to objects.
Note, blessed objects are not traversed.

=cut

=function deduce_type

    # given qr/\w+/;

    $type = deduce_type qr/\w+/; # SCALAR

The deduce_type function returns a data type description for the type of data
provided, represented as a string in capital letters.

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

=head1 ASSERTIONS

The type assertions functions exported can be used on to help ensure data
integrity and prevent invalid usage patterns. The following is a list of
standard type assertion functions whose routines map to those corresponding in
the L<Types::Standard> library.

=cut

=head2 asa_aref

    my $thing = undef;
    asa_aref $thing;

The aref function asserts that the argument is an array reference. If the
argument is not an array reference, the program will die.

=cut

=head2 asa_arrayref

    my $thing = undef;
    asa_arrayref $thing;

The arrayref function asserts that the argument is an array reference. If the
argument is not an array reference, the program will die.

=cut

=head2 asa_bool

    my $thing = undef;
    asa_bool $thing;

The bool function asserts that the argument is a boolean value. If the argument
is not a boolean value, the program will die.

=cut

=head2 asa_boolean

    my $thing = undef;
    asa_boolean $thing;

The boolean function asserts that the argument is a boolean value. If the
argument is not a boolean value, the program will die.

=cut

=head2 asa_class

    my $thing = undef;
    asa_class $thing;

The class function asserts that the argument is a class name. If the argument is
not a class name, the program will die.

=cut

=head2 asa_classname

    my $thing = undef;
    asa_classname $thing;

The classname function asserts that the argument is a class name. If the
argument is not a class name, the program will die.

=cut

=head2 asa_coderef

    my $thing = undef;
    asa_coderef $thing;

The coderef function asserts that the argument is a code reference. If the
argument is not a code reference, the program will die.

=cut

=head2 asa_cref

    my $thing = undef;
    asa_cref $thing;

The cref function asserts that the argument is a code reference. If the argument
is not a code reference, the program will die.

=cut

=head2 asa_def

    my $thing = undef;
    asa_def $thing;

The def function asserts that the argument is a defined value. If the argument
is not a defined value, the program will die.

=cut

=head2 asa_defined

    my $thing = undef;
    asa_defined $thing;

The defined function asserts that the argument is a defined value. If the
argument is not a defined value, the program will die.

=cut

=head2 asa_fh

    my $thing = undef;
    asa_fh $thing;

The fh function asserts that the argument is a file handle. If the argument is
not a file handle, the program will die.

=cut

=head2 asa_filehandle

    my $thing = undef;
    asa_filehandle $thing;

The filehandle function asserts that the argument is a file handle. If the
argument is not a file handle, the program will die.

=cut

=head2 asa_glob

    my $thing = undef;
    asa_glob $thing;

The glob function asserts that the argument is a glob reference. If the argument
is not a glob reference, the program will die.

=cut

=head2 asa_globref

    my $thing = undef;
    asa_globref $thing;

The globref function asserts that the argument is a glob reference. If the
argument is not a glob reference, the program will die.

=cut

=head2 asa_hashref

    my $thing = undef;
    asa_hashref $thing;

The hashref function asserts that the argument is a hash reference. If the
argument is not a hash reference, the program will die.

=cut

=head2 asa_href

    my $thing = undef;
    asa_href $thing;

The href function asserts that the argument is a hash reference. If the argument
is not a hash reference, the program will die.

=cut

=head2 asa_int

    my $thing = undef;
    asa_int $thing;

The int function asserts that the argument is an integer. If the argument is not
an integer, the program will die.

=cut

=head2 asa_integer

    my $thing = undef;
    asa_integer $thing;

The integer function asserts that the argument is an integer. If the argument is
not an integer, the program will die.

=cut

=head2 asa_num

    my $thing = undef;
    asa_num $thing;

The num function asserts that the argument is a number. If the argument is not a
number, the program will die.

=cut

=head2 asa_number

    my $thing = undef;
    asa_number $thing;

The number function asserts that the argument is a number. If the argument is
not a number, the program will die.

=cut

=head2 asa_obj

    my $thing = undef;
    asa_obj $thing;

The obj function asserts that the argument is an object. If the argument is not
an object, the program will die.

=cut

=head2 asa_object

    my $thing = undef;
    asa_object $thing;

The object function asserts that the argument is an object. If the argument is
not an object, the program will die.

=cut

=head2 asa_ref

    my $thing = undef;
    asa_ref $thing;

The ref function asserts that the argument is a reference. If the argument is
not a reference, the program will die.

=cut

=head2 asa_reference

    my $thing = undef;
    asa_reference $thing;

The reference function asserts that the argument is a reference. If the argument
is not a reference, the program will die.

=cut

=head2 asa_regexpref

    my $thing = undef;
    asa_regexpref $thing;

The regexpref function asserts that the argument is a regular expression
reference. If the argument is not a regular expression reference, the program
will die.

=cut

=head2 asa_rref

    my $thing = undef;
    asa_rref $thing;

The rref function asserts that the argument is a regular expression reference.
If the argument is not a regular expression reference, the program will die.

=cut

=head2 asa_scalarref

    my $thing = undef;
    asa_scalarref $thing;

The scalarref function asserts that the argument is a scalar reference. If the
argument is not a scalar reference, the program will die.

=cut

=head2 asa_sref

    my $thing = undef;
    asa_sref $thing;

The sref function asserts that the argument is a scalar reference. If the
argument is not a scalar reference, the program will die.

=cut

=head2 asa_str

    my $thing = undef;
    asa_str $thing;

The str function asserts that the argument is a string. If the argument is not a
string, the program will die.

=cut

=head2 asa_string

    my $thing = undef;
    asa_string $thing;

The string function asserts that the argument is a string. If the argument is
not a string, the program will die.

=cut

=head2 asa_nil

    my $thing = undef;
    asa_nil $thing;

The nil function asserts that the argument is an undefined value. If the
argument is not an undefined value, the program will die.

=cut

=head2 asa_null

    my $thing = undef;
    asa_null $thing;

The null function asserts that the argument is an undefined value. If the
argument is not an undefined value, the program will die.

=cut

=head2 asa_undef

    my $thing = undef;
    asa_undef $thing;

The undef function asserts that the argument is an undefined value. If the
argument is not an undefined value, the program will die.

=cut

=head2 asa_undefined

    my $thing = undef;
    asa_undefined $thing;

The undefined function asserts that the argument is an undefined value. If the
argument is not an undefined value, the program will die.

=cut

=head2 asa_val

    my $thing = undef;
    asa_val $thing;

The val function asserts that the argument is a value. If the argument is not a
value, the program will die.

=cut

=head2 asa_value

    my $thing = undef;
    asa_value $thing;

The value method asserts that the argument is a value. If the argument is not a
value, the program will die.

=cut

=head1 VALIDATIONS

The type validation functions can be used to help control the flow of
operations. The following is a list of standard type checking functions whose
routines map to those corresponding in the L<Types::Standard> library.

=cut

=head2 isa_aref

    my $thing = undef;
    isa_aref $thing;

The aref function checks that the argument is an array reference. If the
argument is not an array reference, the function will return false.

=cut

=head2 isa_arrayref

    my $thing = undef;
    isa_arrayref $thing;

The arrayref function checks that the argument is an array reference. If the
argument is not an array reference, the function will return false.

=cut

=head2 isa_bool

    my $thing = undef;
    isa_bool $thing;

The bool function checks that the argument is a boolean value. If the argument
is not a boolean value, the function will return false.

=cut

=head2 isa_boolean

    my $thing = undef;
    isa_boolean $thing;

The boolean function checks that the argument is a boolean value. If the
argument is not a boolean value, the function will return false.

=cut

=head2 isa_class

    my $thing = undef;
    isa_class $thing;

The class function checks that the argument is a class name. If the argument is
not a class name, the function will return false.

=cut

=head2 isa_classname

    my $thing = undef;
    isa_classname $thing;

The classname function checks that the argument is a class name. If the argument
is not a class name, the function will return false.

=cut

=head2 isa_coderef

    my $thing = undef;
    isa_coderef $thing;

The coderef function checks that the argument is a code reference. If the
argument is not a code reference, the function will return false.

=cut

=head2 isa_cref

    my $thing = undef;
    isa_cref $thing;

The cref function checks that the argument is a code reference. If the argument
is not a code reference, the function will return false.

=cut

=head2 isa_def

    my $thing = undef;
    isa_def $thing;

The def function checks that the argument is a defined value. If the argument is
not a defined value, the function will return false.

=cut

=head2 isa_defined

    my $thing = undef;
    isa_defined $thing;

The defined function checks that the argument is a defined value. If the
argument is not a defined value, the function will return false.

=cut

=head2 isa_fh

    my $thing = undef;
    isa_fh $thing;

The fh function checks that the argument is a file handle. If the argument is
not a file handle, the function will return false.

=cut

=head2 isa_filehandle

    my $thing = undef;
    isa_filehandle $thing;

The filehandle function checks that the argument is a file handle. If the
argument is not a file handle, the function will return false.

=cut

=head2 isa_glob

    my $thing = undef;
    isa_glob $thing;

The glob function checks that the argument is a glob reference. If the argument
is not a glob reference, the function will return false.

=cut

=head2 isa_globref

    my $thing = undef;
    isa_globref $thing;

The globref function checks that the argument is a glob reference. If the
argument is not a glob reference, the function will return false.

=cut

=head2 isa_hashref

    my $thing = undef;
    isa_hashref $thing;

The hashref function checks that the argument is a hash reference. If the
argument is not a hash reference, the function will return false.

=cut

=head2 isa_href

    my $thing = undef;
    isa_href $thing;

The href function checks that the argument is a hash reference. If the argument
is not a hash reference, the function will return false.

=cut

=head2 isa_int

    my $thing = undef;
    isa_int $thing;

The int function checks that the argument is an integer. If the argument is not
an integer, the function will return false.

=cut

=head2 isa_integer

    my $thing = undef;
    isa_integer $thing;

The integer function checks that the argument is an integer. If the argument is
not an integer, the function will return false.

=cut

=head2 isa_num

    my $thing = undef;
    isa_num $thing;

The num function checks that the argument is a number. If the argument is not a
number, the function will return false.

=cut

=head2 isa_number

    my $thing = undef;
    isa_number $thing;

The number function checks that the argument is a number. If the argument is not
a number, the function will return false.

=cut

=head2 isa_obj

    my $thing = undef;
    isa_obj $thing;

The obj function checks that the argument is an object. If the argument is not
an object, the function will return false.

=cut

=head2 isa_object

    my $thing = undef;
    isa_object $thing;

The object function checks that the argument is an object. If the argument is
not an object, the function will return false.

=cut

=head2 isa_ref

    my $thing = undef;
    isa_ref $thing;

The ref function checks that the argument is a reference. If the argument is not
a reference, the function will return false.

=cut

=head2 isa_reference

    my $thing = undef;
    isa_reference $thing;

The reference function checks that the argument is a reference. If the argument
is not a reference, the function will return false.

=cut

=head2 isa_regexpref

    my $thing = undef;
    isa_regexpref $thing;

The regexpref function checks that the argument is a regular expression
reference. If the argument is not a regular expression reference, the function
will return false.

=cut

=head2 isa_rref

    my $thing = undef;
    isa_rref $thing;

The rref function checks that the argument is a regular expression reference. If
the argument is not a regular expression reference, the function will return
false.

=cut

=head2 isa_scalarref

    my $thing = undef;
    isa_scalarref $thing;

The scalarref function checks that the argument is a scalar reference. If the
argument is not a scalar reference, the function will return false.

=cut

=head2 isa_sref

    my $thing = undef;
    isa_sref $thing;

The sref function checks that the argument is a scalar reference. If the
argument is not a scalar reference, the function will return false.

=cut

=head2 isa_str

    my $thing = undef;
    isa_str $thing;

The str function checks that the argument is a string. If the argument is not a
string, the function will return false.

=cut

=head2 isa_string

    my $thing = undef;
    isa_string $thing;

The string function checks that the argument is a string. If the argument is not
a string, the function will return false.

=cut

=head2 isa_nil

    my $thing = undef;
    isa_nil $thing;

The nil function checks that the argument is an undefined value. If the argument
is not an undefined value, the function will return false.

=cut

=head2 isa_null

    my $thing = undef;
    isa_null $thing;

The null function checks that the argument is an undefined value. If the
argument is not an undefined value, the function will return false.

=cut

=head2 isa_undef

    my $thing = undef;
    isa_undef $thing;

The undef function checks that the argument is an undefined value. If the
argument is not an undefined value, the function will return false.

=cut

=head2 isa_undefined

    my $thing = undef;
    isa_undefined $thing;

The undefined function checks that the argument is an undefined value. If the
argument is not an undefined value, the function will return false.

=cut

=head2 isa_val

    my $thing = undef;
    isa_val $thing;

The val function checks that the argument is a value. If the argument is not a
value, the function will return false.

=cut

=head2 isa_value

    my $thing = undef;
    isa_value $thing;

The value function checks that the argument is a value. If the argument is not a
value, the function will return false.

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
