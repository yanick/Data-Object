# ABSTRACT: Type Library for Perl 5
package Data::Object::Library;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Scalar::Util;

use Type::Library -base;
use Type::Utils   -all;

# VERSION

extends 'Types::Standard';
extends 'Types::Common::Numeric';
extends 'Types::Common::String';

my $registry = __PACKAGE__->meta;

sub DECLARE {

    my ($name, %opts) = @_;

    return map +(DECLARE($_, %opts)), @$name if ref $name;

    ($opts{name} = $name) =~ s/:://g;

    my @cans = ref($opts{can})  eq 'ARRAY' ? @{$opts{can}}  : $opts{can}  // ();
    my @isas = ref($opts{isa})  eq 'ARRAY' ? @{$opts{isa}}  : $opts{isa}  // ();
    my @does = ref($opts{does}) eq 'ARRAY' ? @{$opts{does}} : $opts{does} // ();

    my $code = $opts{constraint};
    my $text = $opts{inlined};

    $opts{constraint} = sub {
        my @args = @_;
        return if @isas and grep(not($args[0]->isa($_)),  @isas);
        return if @cans and grep(not($args[0]->can($_)),  @cans);
        return if @does and grep(not($args[0]->does($_)), @does);
        return if $code and not $code->(@args);
        return 1;
    };

    $opts{inlined} = sub {
        my $blessed = "Scalar::Util::blessed($_[1])";
        return join(' && ', map "($_)",
            join(' && ', map "($blessed and $_[1]->isa('$_'))",  @isas),
            join(' && ', map "($blessed and $_[1]->does('$_'))", @does),
            join(' && ', map "($blessed and $_[1]->can('$_'))",  @cans),
        $text ? $text : (),
        );
    };

    $opts{bless}   = "Type::Tiny";
    $opts{parent}  = "Object" unless $opts{parent};
    $opts{coerion} = 1;

    { no warnings "numeric"; $opts{_caller_level}++ }

    my $coerce = delete $opts{coerce};
    my $type   = declare(%opts);

    my $functions = {
        'Data::Object::Array'     => 'data_array',
        'Data::Object::Code'      => 'data_code',
        'Data::Object::Float'     => 'data_float',
        'Data::Object::Hash'      => 'data_hash',
        'Data::Object::Integer'   => 'data_integer',
        'Data::Object::Number'    => 'data_number',
        'Data::Object::Regexp'    => 'data_regexp',
        'Data::Object::Scalar'    => 'data_scalar',
        'Data::Object::String'    => 'data_string',
        'Data::Object::Undef'     => 'data_undef',
        'Data::Object::Universal' => 'data_universal',
    };

    my ($key) = grep { $functions->{$_} } @isas;

    for my $coercive ('ARRAY' eq ref $coerce ? @$coerce : $coerce) {
        my $object   = $registry->get_type($coercive);
        my $function = $$functions{$key};

        my $forward = Data::Object->can($function);
        coerce $opts{name}, from $coercive, via { $forward->($_) };

       $object->coercion->i_really_want_to_unfreeze;

        my $reverse = Data::Object->can('deduce_deep');
        coerce $coercive, from $opts{name}, via { $reverse->($_) };

        $object->coercion->freeze;
    }

    return $type;

}

my %array_constraint = (constraint_generator => sub {

    my $param = @_ ? Types::TypeTiny::to_TypeTiny(shift) :
        return $registry->get_type('ArrayObject');

    Types::TypeTiny::TypeTiny->check($param)
        or Types::Standard::_croak(
            "Parameter to ArrayObject[`a] expected ".
            "to be a type constraint; got $param"
        );

    return sub {
        my $arrayobj = shift;
        $param->check($_) || return for @$arrayobj;
        return !!1;
    }

});

my %array_coercion = (coercion_generator => sub {

    my ($parent, $child, $param) = @_;

    return $parent->coercion unless $param->has_coercion;

    my $coercable_item = $param->coercion->_source_type_union;
    my $c = "Type::Coercion"->new(type_constraint => $child);

    $c->add_type_coercions(
        $registry->get_type('ArrayRef') => sub {
            my $value = @_ ? $_[0] : $_;
            my $new   = [];

            for (my $i=0; $i < @$value; $i++) {
                my $item = $value->[$i];
                return $value unless $coercable_item->check($item);
                $new->[$i] = $param->coerce($item);
            }

            return $parent->coerce($new);
        },
    );

    return $c;

});

my %array_explanation = (deep_explanation => sub {

    my ($type, $value, $varname) = @_;
    my $param = $type->parameters->[0];

    for my $i (0 .. $#$value) {
        my $item = $value->[$i];
        next if $param->check($item);
        my $message  = '"%s" constrains each value in the array object with "%s"';
        my $position = sprintf('%s->[%d]', $varname, $i);
        my $criteria = $param->validate_explain($item, $position);
        return [sprintf($message, $type, $param), @{$criteria}]
    }

    return;

});

DECLARE ["ArrayObj", "ArrayObject"] => (
    %array_constraint,
    %array_coercion,
    %array_explanation,

    isa    => ["Data::Object::Array"],
    does   => ["Data::Object::Role::Array"],
    can    => ["data", "dump"],
    coerce => ["ArrayRef"],
);

DECLARE ["CodeObj", "CodeObject"] => (
    isa    => ["Data::Object::Code"],
    does   => ["Data::Object::Role::Code"],
    can    => ["data", "dump"],
    coerce => ["CodeRef"],
);

DECLARE ["FloatObj", "FloatObject"] => (
    isa    => ["Data::Object::Float"],
    does   => ["Data::Object::Role::Float"],
    can    => ["data", "dump"],
    coerce => ["Str", "Num", "LaxNum"],
);

my %hash_constraint = (constraint_generator => sub {

    my $param = @_ ? Types::TypeTiny::to_TypeTiny(shift) :
        return $registry->get_type('HashObject');

    Types::TypeTiny::TypeTiny->check($param)
        or Types::Standard::_croak(
            "Parameter to HashObject[`a] expected ".
            "to be a type constraint; got $param"
        );

    return sub {
        my $hashobj = shift;
        $param->check($_) || return for values %$hashobj;
        return !!1;
    }

});

my %hash_coercion = (coercion_generator => sub {

    my ($parent, $child, $param) = @_;

    return $parent->coercion unless $param->has_coercion;

    my $coercable_item = $param->coercion->_source_type_union;
    my $c = "Type::Coercion"->new(type_constraint => $child);

    $c->add_type_coercions(
        $registry->get_type('HashRef') => sub {
            my $value = @_ ? $_[0] : $_;
            my $new   = {};

            for my $key (sort keys %$value) {
                my $item = $value->{$key};
                return $value unless $coercable_item->check($item);
                $new->{$key} = $param->coerce($item);
            }

            return $parent->coerce($new);
        },
    );

    return $c;

});

my %hash_explanation = (deep_explanation => sub {

    my ($type, $value, $varname) = @_;
    my $param = $type->parameters->[0];

    for my $key (sort keys %$value) {
        my $item = $value->{$key};
        next if $param->check($item);
        my $message  = '"%s" constrains each value in the hash object with "%s"';
        my $position = sprintf('%s->{%s}', $varname, B::perlstring($key));
        my $criteria = $param->validate_explain($item, $position);
        return [sprintf($message, $type, $param), @{$criteria}]
    }

    return;

});

my %hash_overrides = (my_methods => {

    hashref_allows_key => sub {

        my ($self, $key) = @_;

        $registry->get_type('Str')->check($key);

    },

    hashref_allows_value => sub {

        my ($self, $key, $value) = @_;

        return !!0 unless $self->my_hashref_allows_key($key);
        return !!1 if $self == $registry->get_type('HashRef');

        my $href = $self->find_parent(sub { $_->has_parent
            && $registry->get_type('HashRef') == $_->parent
        });

        my $param = $href->type_parameter;

        $registry->get_type('Str')->check($key) and $param->check($value);

    },

});

DECLARE ["HashObj", "HashObject"] => (
    %hash_constraint,
    %hash_coercion,
    %hash_explanation,
    %hash_overrides,

    isa    => ["Data::Object::Hash"],
    does   => ["Data::Object::Role::Hash"],
    can    => ["data", "dump"],
    coerce => ["HashRef"],
);

DECLARE ["IntObj", "IntObject", "IntegerObj", "IntegerObject"] => (
    isa    => ["Data::Object::Integer"],
    does   => ["Data::Object::Role::Integer"],
    can    => ["data", "dump"],
    coerce => ["Str", "Num", "LaxNum", "StrictNum", "Int"],
);

DECLARE ["NumObj", "NumObject", "NumberObj", "NumberObject"] => (
    isa    => ["Data::Object::Number"],
    does   => ["Data::Object::Role::Number"],
    can    => ["data", "dump"],
    coerce => ["Str", "Num", "LaxNum", "StrictNum"],
);

DECLARE ["RegexpObj", "RegexpObject"] => (
    isa    => ["Data::Object::Regexp"],
    does   => ["Data::Object::Role::Regexp"],
    can    => ["data", "dump"],
    coerce => ["RegexpRef"],
);

DECLARE ["ScalarObj", "ScalarObject"] => (
    isa    => ["Data::Object::Scalar"],
    does   => ["Data::Object::Role::Scalar"],
    can    => ["data", "dump"],
    coerce => ["ScalarRef"],
);

DECLARE ["StrObj", "StrObject", "StringObj", "StringObject"] => (
    isa    => ["Data::Object::String"],
    does   => ["Data::Object::Role::String"],
    can    => ["data", "dump"],
    coerce => ["Str"],
);

DECLARE ["UndefObj", "UndefObject"] => (
    isa    => ["Data::Object::Undef"],
    does   => ["Data::Object::Role::Undef"],
    can    => ["data", "dump"],
    coerce => ["Undef"],
);

DECLARE ["AnyObj", "AnyObject", "UniversalObj", "UniversalObject"] => (
    isa    => ["Data::Object::Universal"],
    does   => ["Data::Object::Role::Universal"],
    can    => ["data", "dump"],
    coerce => ["Any"],
);

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Library;

=cut

=head1 DESCRIPTION

Data::Object::Library is a <Type::Tiny> type library that extends the
L<Types::Standard>, L<Types::Common::Numeric>, and L<Types::Common::String>
libraries and adds type constraints and coercions for L<Data::Object> objects.

=cut

=type Any

    has data => (isa => Any);

The Any type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Any function can be
used to throw an exception is the argument can not be validated. The is_Any
function can be used to return true or false if the argument can not be
validated.

=cut

=type AnyObj

    has data => (isa => AnyObj);

The AnyObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Universal> object. The
assert_AnyObj function can be used to throw an exception if the argument can
not be validated. The is_AnyObj function can be used to return true or false if
the argument can not be validated.

=cut

=type AnyObject

    has data => (isa => AnyObject);

The AnyObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Universal> object. The
assert_AnyObject function can be used to throw an exception if the argument can
not be validated. The is_AnyObject function can be used to return true or false
if the argument can not be validated.

=cut

=type ArrayObj

    has data => (isa => ArrayObj);

The ArrayObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Array> object. The
assert_ArrayObj function can be used to throw an exception if the argument can
not be validated. The is_ArrayObj function can be used to return true or false
if the argument can not be validated.

=cut

=type ArrayObject

    has data => (isa => ArrayObject);

The ArrayObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Array> object. The
assert_ArrayObject function can be used to throw an exception if the argument
can not be validated. The is_ArrayObject function can be used to return true or
false if the argument can not be validated.

=cut

=type ArrayRef

    has data => (isa => ArrayRef);

The ArrayRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_ArrayRef
function can be used to throw an exception if the argument can not be
validated. The is_ArrayRef function can be used to return true or false if the
argument can not be validated.

=cut

=type Bool

    has data => (isa => Bool);

The Bool type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Bool function can be
used to throw an exception if the argument can not be validated. The is_Bool
function can be used to return true or false if the argument can not be
validated.

=cut

=type ClassName

    has data => (isa => ClassName['MyClass']);

The ClassName type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_ClassName
function can be used to throw an exception if the argument can not be
validated. The is_ClassName function can be used to return true or false if the
argument can not be validated.

=cut

=type CodeObj

    has data => (isa => CodeObj);

The CodeObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Code> object. The assert_CodeObj
function can be used to throw an exception if the argument can not be
validated. The is_CodeObj function can be used to return true or false if the
argument can not be validated.

=cut

=type CodeObject

    has data => (isa => CodeObject);

The CodeObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Code> object. The
assert_CodeObject function can be used to throw an exception if the argument
can not be validated. The is_CodeObject function can be used to return true or
false if the argument can not be validated.

=cut

=type CodeRef

    has data => (isa => CodeRef);

The CodeRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_CodeRef function
can be used to throw an exception if the argument can not be validated. The
is_CodeRef function can be used to return true or false if the argument can not
be validated.

=cut

=type ConsumerOf

    has data => (isa => ConsumerOf['MyRole']);

The ConsumerOf type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_ConsumerOf
function can be used to throw an exception if the argument can not be
validated. The is_ConsumerOf function can be used to return true or false if
the argument can not be validated.

=cut

=type Defined

    has data => (isa => Defined);

The Defined type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_Defined function
can be used to throw an exception if the argument can not be validated. The
is_Defined function can be used to return true or false if the argument can not
be validated.

=cut

=type Dict

    has data => (isa => Dict);

The Dict type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Dict function can be
used to throw an exception if the argument can not be validated. The is_Dict
function can be used to return true or false if the argument can not be
validated.

=cut

=type Enum

    has data => (isa => Enum);

The Enum type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Enum function can be
used to throw an exception if the argument can not be validated. The is_Enum
function can be used to return true or false if the argument can not be
validated.

=cut

=type FileHandle

    has data => (isa => FileHandle);

The FileHandle type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_FileHandle
function can be used to throw an exception if the argument can not be
validated. The is_FileHandle function can be used to return true or false if
the argument can not be validated.

=cut

=type FloatObj

    has data => (isa => FloatObj);

The FloatObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Float> object. The
assert_FloatObj function can be used to throw an exception if the argument can
not be validated. The is_FloatObj function can be used to return true or false
if the argument can not be validated.

=cut

=type FloatObject

    has data => (isa => FloatObject);

The FloatObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Float> object. The
assert_FloatObject function can be used to throw an exception if the argument
can not be validated. The is_FloatObject function can be used to return true or
false if the argument can not be validated.

=cut

=type GlobRef

    has data => (isa => GlobRef);

The GlobRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_GlobRef function
can be used to throw an exception if the argument can not be validated. The
is_GlobRef function can be used to return true or false if the argument can not
be validated.

=cut

=type HasMethods

    has data => (isa => HasMethods);

The HasMethods type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_HasMethods
function can be used to throw an exception if the argument can not be
validated. The is_HasMethods function can be used to return true or false if
the argument can not be validated.

=cut

=type HashObj

    has data => (isa => HashObj);

The HashObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Hash> object. The assert_HashObj
function can be used to throw an exception if the argument can not be
validated. The is_HashObj function can be used to return true or false if the
argument can not be validated.

=cut

=type HashObject

    has data => (isa => HashObject);

The HashObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Hash> object. The
assert_HashObject function can be used to throw an exception if the argument
can not be validated. The is_HashObject function can be used to return true or
false if the argument can not be validated.

=cut

=type HashRef

    has data => (isa => HashRef);

The HashRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_HashRef function
can be used to throw an exception if the argument can not be validated. The
is_HashRef function can be used to return true or false if the argument can not
be validated.

=cut

=type InstanceOf

    has data => (isa => InstanceOf['MyClass']);

The InstanceOf type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_InstanceOf
function can be used to throw an exception if the argument can not be
validated. The is_InstanceOf function can be used to return true or false if
the argument can not be validated.

=cut

=type Int

    has data => (isa => Int);

The Int type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Int function can be
used to throw an exception if the argument can not be validated. The is_Int
function can be used to return true or false if the argument can not be
validated.

=cut

=type IntObj

    has data => (isa => IntObj);

The IntObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Integer> object. The
assert_IntObj function can be used to throw an exception if the argument can
not be validated. The is_IntObj function can be used to return true or false if
the argument can not be validated.

=cut

=type IntObject

    has data => (isa => IntObject);

The IntObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Integer> object. The
assert_IntObject function can be used to throw an exception if the argument can
not be validated. The is_IntObject function can be used to return true or false
if the argument can not be validated.

=cut

=type IntegerObj

    has data => (isa => IntegerObj);

The IntegerObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Integer> object. The
assert_IntegerObj function can be used to throw an exception if the argument
can not be validated. The is_IntegerObj function can be used to return true or
false if the argument can not be validated.

=cut

=type IntegerObject

    has data => (isa => IntegerObject);

The IntegerObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Integer> object. The
assert_IntegerObject function can be used to throw an exception if the argument
can not be validated. The is_IntegerObject function can be used to return true
or false if the argument can not be validated.

=cut

=type Item

    has data => (isa => Item);

The Item type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Item function can be
used to throw an exception if the argument can not be validated. The is_Item
function can be used to return true or false if the argument can not be
validated.

=cut

=type LaxNum

    has data => (isa => LaxNum);

The LaxNum type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_LaxNum function
can be used to throw an exception if the argument can not be validated. The
is_LaxNum function can be used to return true or false if the argument can not
be validated.

=cut

=type LowerCaseSimpleStr

    has data => (isa => LowerCaseSimpleStr);

The LowerCaseSimpleStr type constraint is provided by the
L<Types::Common::String> library. Please see that documentation for more The
assert_LowerCaseSimpleStr function can be used to throw an exception if the
argument can not be validated. The is_LowerCaseSimpleStr function can be used
to return true or false if the argument can not be validated.
information.

=cut

=type LowerCaseStr

    has data => (isa => LowerCaseStr);

The LowerCaseStr type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information. The assert_type
function can be used to throw an exception if the argument can not be
validated. The is_type function can be used to return true or false if the
argument can not be validated.

=cut

=type Map

    has data => (isa => Map[Int, HashRef]);

The Map type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Map function can be
used to throw an exception if the argument can not be validated. The is_Map
function can be used to return true or false if the argument can not be
validated.

=cut

=type Maybe

    has data => (isa => Maybe);

The Maybe type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Maybe function can be
used to throw an exception if the argument can not be validated. The is_Maybe
function can be used to return true or false if the argument can not be
validated.

=cut

=type NegativeInt

    has data => (isa => NegativeInt);

The NegativeInt type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information. The
assert_NegativeInt function can be used to throw an exception if the argument
can not be validated. The is_NegativeInt function can be used to return true or
false if the argument can not be validated.

=cut

=type NegativeNum

    has data => (isa => NegativeNum);

The NegativeNum type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information. The
assert_NegativeNum function can be used to throw an exception if the argument
can not be validated. The is_NegativeNum function can be used to return true or
false if the argument can not be validated.

=cut

=type NegativeOrZeroInt

    has data => (isa => NegativeOrZeroInt);

The NegativeOrZeroInt type constraint is provided by the
L<Types::Common::Numeric> library. Please see that documentation for more The
assert_NegativeOrZeroInt function can be used to throw an exception if the
argument can not be validated. The is_NegativeOrZeroInt function can be used to
return true or false if the argument can not be validated.
information.

=cut

=type NegativeOrZeroNum

    has data => (isa => NegativeOrZeroNum);

The NegativeOrZeroNum type constraint is provided by the
L<Types::Common::Numeric> library. Please see that documentation for more The
assert_type function can be used to throw an exception if the argument can not
be validated. The is_type function can be used to return true or false if the
argument can not be validated.
information.

=cut

=type NonEmptySimpleStr

    has data => (isa => NonEmptySimpleStr);

The NonEmptySimpleStr type constraint is provided by the
L<Types::Common::String> library. Please see that documentation for more The
assert_type function can be used to throw an exception if the argument can not
be validated. The is_type function can be used to return true or false if the
argument can not be validated.
information.

=cut

=type NonEmptyStr

    has data => (isa => NonEmptyStr);

The NonEmptyStr type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_type function
can be used to throw an exception if the argument can not be validated. The
is_type function can be used to return true or false if the argument can not be
validated.

=cut

=type Num

    has data => (isa => Num);

The Num type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Num function can be
used to throw an exception if the argument can not be validated. The is_Num
function can be used to return true or false if the argument can not be
validated.

=cut

=type NumObj

    has data => (isa => NumObj);

The NumObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Number> object. The
assert_NumObj function can be used to throw an exception if the argument can
not be validated. The is_NumObj function can be used to return true or false if
the argument can not be validated.

=cut

=type NumObject

    has data => (isa => NumObject);

The NumObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Number> object. The
assert_NumObject function can be used to throw an exception if the argument can
not be validated. The is_NumObject function can be used to return true or false
if the argument can not be validated.

=cut

=type NumberObj

    has data => (isa => NumberObj);

The NumberObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Number> object. The
assert_NumberObj function can be used to throw an exception if the argument can
not be validated. The is_NumberObj function can be used to return true or false
if the argument can not be validated.

=cut

=type NumberObject

    has data => (isa => NumberObject);

The NumberObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Number> object. The
assert_NumberObject function can be used to throw an exception if the argument
can not be validated. The is_NumberObject function can be used to return true
or false if the argument can not be validated.

=cut

=type NumericCode

    has data => (isa => NumericCode);

The NumericCode type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information. The
assert_NumericCode function can be used to throw an exception if the argument
can not be validated. The is_NumericCode function can be used to return true or
false if the argument can not be validated.

=cut

=type Object

    has data => (isa => Object);

The Object type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_Object function
can be used to throw an exception if the argument can not be validated. The
is_Object function can be used to return true or false if the argument can not
be validated.

=cut

=type OptList

    has data => (isa => OptList);

The OptList type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_OptList function
can be used to throw an exception if the argument can not be validated. The
is_OptList function can be used to return true or false if the argument can not
be validated.

=cut

=type Optional

    has data => (isa => Dict[id => Optional[Int]]);

The Optional type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_Optional
function can be used to throw an exception if the argument can not be
validated. The is_Optional function can be used to return true or false if the
argument can not be validated.

=cut

=type Overload

    has data => (isa => Overload);

The Overload type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_Overload
function can be used to throw an exception if the argument can not be
validated. The is_Overload function can be used to return true or false if the
argument can not be validated.

=cut

=type Password

    has data => (isa => Password);

The Password type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_Password
function can be used to throw an exception if the argument can not be
validated. The is_Password function can be used to return true or false if the
argument can not be validated.

=cut

=type PositiveInt

    has data => (isa => PositiveInt);

The PositiveInt type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information. The
assert_PositiveInt function can be used to throw an exception if the argument
can not be validated. The is_PositiveInt function can be used to return true or
false if the argument can not be validated.

=cut

=type PositiveNum

    has data => (isa => PositiveNum);

The PositiveNum type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information. The
assert_PositiveNum function can be used to throw an exception if the argument
can not be validated. The is_PositiveNum function can be used to return true or
false if the argument can not be validated.

=cut

=type PositiveOrZeroInt

    has data => (isa => PositiveOrZeroInt);

The PositiveOrZeroInt type constraint is provided by the
L<Types::Common::Numeric> library. Please see that documentation for more The
assert_PositiveOrZeroInt function can be used to throw an exception if the
argument can not be validated. The is_PositiveOrZeroInt function can be used to
return true or false if the argument can not be validated.
information.

=cut

=type PositiveOrZeroNum

    has data => (isa => PositiveOrZeroNum);

The PositiveOrZeroNum type constraint is provided by the
L<Types::Common::Numeric> library. Please see that documentation for more The
assert_type function can be used to throw an exception if the argument can not
be validated. The is_type function can be used to return true or false if the
argument can not be validated.
information.

=cut

=type Ref

    has data => (isa => Ref['SCALAR']);

The Ref type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_type function can be
used to throw an exception if the argument can not be validated. The is_type
function can be used to return true or false if the argument can not be
validated.

=cut

=type RegexpObj

    has data => (isa => RegexpObj);

The RegexpObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Regexp> object. The
assert_RegexpObj function can be used to throw an exception if the argument can
not be validated. The is_RegexpObj function can be used to return true or false
if the argument can not be validated.

=cut

=type RegexpObject

    has data => (isa => RegexpObject);

The RegexpObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Regexp> object. The
assert_RegexpObject function can be used to throw an exception if the argument
can not be validated. The is_RegexpObject function can be used to return true
or false if the argument can not be validated.

=cut

=type RegexpRef

    has data => (isa => RegexpRef);

The RegexpRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_RegexpRef
function can be used to throw an exception if the argument can not be
validated. The is_RegexpRef function can be used to return true or false if the
argument can not be validated.

=cut

=type RoleName

    has data => (isa => RoleName);

The RoleName type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_RoleName
function can be used to throw an exception if the argument can not be
validated. The is_RoleName function can be used to return true or false if the
argument can not be validated.

=cut

=type ScalarObj

    has data => (isa => ScalarObj);

The ScalarObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Scalar> object. The
assert_ScalarObj function can be used to throw an exception if the argument can
not be validated. The is_ScalarObj function can be used to return true or false
if the argument can not be validated.

=cut

=type ScalarObject

    has data => (isa => ScalarObject);

The ScalarObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Scalar> object. The
assert_ScalarObject function can be used to throw an exception if the argument
can not be validated. The is_ScalarObject function can be used to return true
or false if the argument can not be validated.

=cut

=type ScalarRef

    has data => (isa => ScalarRef);

The ScalarRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_ScalarRef
function can be used to throw an exception if the argument can not be
validated. The is_ScalarRef function can be used to return true or false if the
argument can not be validated.

=cut

=type SimpleStr

    has data => (isa => SimpleStr);

The SimpleStr type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information. The
assert_SimpleStr function can be used to throw an exception if the argument can
not be validated. The is_SimpleStr function can be used to return true or false
if the argument can not be validated.

=cut

=type SingleDigit

    has data => (isa => SingleDigit);

The SingleDigit type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information. The
assert_SingleDigit function can be used to throw an exception if the argument
can not be validated. The is_SingleDigit function can be used to return true or
false if the argument can not be validated.

=cut

=type Str

    has data => (isa => Str);

The Str type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Str function can be
used to throw an exception if the argument can not be validated. The is_Str
function can be used to return true or false if the argument can not be
validated.

=cut

=type StrMatch

    has data => (isa => StrMatch);

The StrMatch type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_StrMatch
function can be used to throw an exception if the argument can not be
validated. The is_StrMatch function can be used to return true or false if the
argument can not be validated.

=cut

=type StrObj

    has data => (isa => StrObj);

The StrObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::String> object. The
assert_StrObj function can be used to throw an exception if the argument can
not be validated. The is_StrObj function can be used to return true or false if
the argument can not be validated.

=cut

=type StrObject

    has data => (isa => StrObject);

The StrObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::String> object. The
assert_StrObject function can be used to throw an exception if the argument can
not be validated. The is_StrObject function can be used to return true or false
if the argument can not be validated.

=cut

=type StrictNum

    has data => (isa => StrictNum);

The StrictNum type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information. The assert_StrictNum
function can be used to throw an exception if the argument can not be
validated. The is_StrictNum function can be used to return true or false if the
argument can not be validated.

=cut

=type StringObj

    has data => (isa => StringObj);

The StringObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::String> object. The
assert_StringObj function can be used to throw an exception if the argument can
not be validated. The is_StringObj function can be used to return true or false
if the argument can not be validated.

=cut

=type StringObject

    has data => (isa => StringObject);

The StringObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::String> object. The
assert_StringObject function can be used to throw an exception if the argument
can not be validated. The is_StringObject function can be used to return true
or false if the argument can not be validated.

=cut

=type StrongPassword

    has data => (isa => StrongPassword);

The StrongPassword type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information. The
assert_StrongPassword function can be used to throw an exception if the
argument can not be validated. The is_StrongPassword function can be used to
return true or false if the argument can not be validated.

=cut

=type Tied

    has data => (isa => Tied['MyClass']);

The Tied type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Tied function can be
used to throw an exception if the argument can not be validated. The is_Tied
function can be used to return true or false if the argument can not be
validated.

=cut

=type Tuple

    has data => (isa => Tuple[Int, Str, Str]);

The Tuple type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Tuple function can be
used to throw an exception if the argument can not be validated. The is_Tuple
function can be used to return true or false if the argument can not be
validated.

=cut

=type Undef

    has data => (isa => Undef);

The Undef type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Undef function can be
used to throw an exception if the argument can not be validated. The is_Undef
function can be used to return true or false if the argument can not be
validated.

=cut

=type UndefObj

    has data => (isa => UndefObj);

The UndefObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Undef> object. The
assert_UndefObj function can be used to throw an exception if the argument can
not be validated. The is_UndefObj function can be used to return true or false
if the argument can not be validated.

=cut

=type UndefObject

    has data => (isa => UndefObject);

The UndefObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Undef> object. The
assert_UndefObject function can be used to throw an exception if the argument
can not be validated. The is_UndefObject function can be used to return true or
false if the argument can not be validated.

=cut

=type UniversalObj

    has data => (isa => UniversalObj);

The UniversalObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Universal> object. The
assert_UniversalObj function can be used to throw an exception if the argument
can not be validated. The is_UniversalObj function can be used to return true
or false if the argument can not be validated.

=cut

=type UniversalObject

    has data => (isa => UniversalObject);

The UniversalObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Universal> object. The
assert_UniversalObject function can be used to throw an exception if the
argument can not be validated. The is_UniversalObject function can be used to
return true or false if the argument can not be validated.

=cut

=type UpperCaseSimpleStr

    has data => (isa => UpperCaseSimpleStr);

The UpperCaseSimpleStr type constraint is provided by the
L<Types::Common::String> library. Please see that documentation for more The
assert_UpperCaseSimpleStr function can be used to throw an exception if the
argument can not be validated. The is_UpperCaseSimpleStr function can be used
to return true or false if the argument can not be validated.
information.

=cut

=type UpperCaseStr

    has data => (isa => UpperCaseStr);

The UpperCaseStr type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information. The assert_type
function can be used to throw an exception if the argument can not be
validated. The is_type function can be used to return true or false if the
argument can not be validated.

=cut

=type Value

    has data => (isa => Value);

The Value type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information. The assert_Value function can be
used to throw an exception if the argument can not be validated. The is_Value
function can be used to return true or false if the argument can not be
validated.

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

