# ABSTRACT: Type Constraint Library for Perl 5
package Data::Object::Library;

use 5.14.0;

use strict;
use warnings;

use Type::Library -base;
use Type::Utils   -all;

use Data::Object;

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

my $array_constraint_name = 'constraint_generator';
my $array_constraint_code = sub {
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
};

my $array_coercion_name = 'coercion_generator';
my $array_coercion_code = sub {
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
};

my $array_explanation_name = 'deep_explanation';
my $array_explanation_code = sub {
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
};

my @with_array_extras = (
    $array_constraint_name  => $array_constraint_code,
    $array_coercion_name    => $array_coercion_code,
    $array_explanation_name => $array_explanation_code,
);

DECLARE ["ArrayObj", "ArrayObject"] => (@with_array_extras,
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

my $hash_constraint_name = 'constraint_generator';
my $hash_constraint_code = sub {
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
};

my $hash_coercion_name = 'coercion_generator';
my $hash_coercion_code = sub {
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
};

my $hash_explanation_name = 'deep_explanation';
my $hash_explanation_code = sub {
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
};

my $hash_overrides_name = 'my_methods';
my $hash_overrides_opts = {
    hashref_allows_key => sub {
        my ($self, $key) = @_;
        $registry->get_type('Str')->check($key);
    },
    hashref_allows_value => sub {
        my ($self, $key, $value) = @_;

        return !!0 unless $self->my_hashref_allows_key($key);
        return !!1 if $self == $registry->get_type('HashRef');

        my $href = $self->find_parent(sub {
            $_->has_parent && $_->parent == $registry->get_type('HashRef')
        });

        my $param = $href->type_parameter;
        $registry->get_type('Str')->check($key) and $param->check($value);
    },
};

my @with_hash_extras = (
    $hash_constraint_name  => $hash_constraint_code,
    $hash_coercion_name    => $hash_coercion_code,
    $hash_explanation_name => $hash_explanation_code,
    $hash_overrides_name   => $hash_overrides_opts,
);

DECLARE ["HashObj", "HashObject"] => (@with_hash_extras,
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

=head1 DESCRIPTION

Data::Object::Library is a L<Type::Tiny> library that extends the
L<Types::Standard>, L<Types::Common::Numeric>, and L<Types::Common::String>
libraries and adds type constraints and coercions for L<Data::Object> objects.

=cut

=type Any

The Any type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type AnyObj

The AnyObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Universal> object.

=cut

=type AnyObject

The AnyObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Universal> object.

=cut

=type ArrayObj

The ArrayObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Array> object.

=cut

=type ArrayObject

The ArrayObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Array> object.

=cut

=type ArrayRef

The ArrayRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type Bool

The Bool type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type ClassName

The ClassName type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type CodeObj

The CodeObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Code> object.

=cut

=type CodeObject

The CodeObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Code> object.

=cut

=type CodeRef

The CodeRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type ConsumerOf

The ConsumerOf type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type Defined

The Defined type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type Dict

The Dict type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type Enum

The Enum type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type FileHandle

The FileHandle type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type FloatObj

The FloatObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Float> object.

=cut

=type FloatObject

The FloatObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Float> object.

=cut

=type GlobRef

The GlobRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type HasMethods

The HasMethods type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type HashObj

The HashObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Hash> object.

=cut

=type HashObject

The HashObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Hash> object.

=cut

=type HashRef

The HashRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type InstanceOf

The InstanceOf type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type Int

The Int type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type IntObj

The IntObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Integer> object.

=cut

=type IntObject

The IntObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Integer> object.

=cut

=type IntegerObj

The IntegerObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Integer> object.

=cut

=type IntegerObject

The IntegerObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Integer> object.

=cut

=type Item

The Item type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type LaxNum

The LaxNum type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type LowerCaseSimpleStr

The LowerCaseSimpleStr type constraint is provided by the
L<Types::Common::String> library. Please see that documentation for more
information.

=cut

=type LowerCaseStr

The LowerCaseStr type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information.

=cut

=type Map

The Map type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type Maybe

The Maybe type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type NegativeInt

The NegativeInt type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information.

=cut

=type NegativeNum

The NegativeNum type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information.

=cut

=type NegativeOrZeroInt

The NegativeOrZeroInt type constraint is provided by the
L<Types::Common::Numeric> library. Please see that documentation for more
information.

=cut

=type NegativeOrZeroNum

The NegativeOrZeroNum type constraint is provided by the
L<Types::Common::Numeric> library. Please see that documentation for more
information.

=cut

=type NonEmptySimpleStr

The NonEmptySimpleStr type constraint is provided by the
L<Types::Common::String> library. Please see that documentation for more
information.

=cut

=type NonEmptyStr

The NonEmptyStr type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type Num

The Num type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type NumObj

The NumObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Number> object.

=cut

=type NumObject

The NumObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Number> object.

=cut

=type NumberObj

The NumberObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Number> object.

=cut

=type NumberObject

The NumberObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Number> object.

=cut

=type NumericCode

The NumericCode type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information.

=cut

=type Object

The Object type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type OptList

The OptList type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type Optional

The Optional type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type Overload

The Overload type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type Password

The Password type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type PositiveInt

The PositiveInt type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information.

=cut

=type PositiveNum

The PositiveNum type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information.

=cut

=type PositiveOrZeroInt

The PositiveOrZeroInt type constraint is provided by the
L<Types::Common::Numeric> library. Please see that documentation for more
information.

=cut

=type PositiveOrZeroNum

The PositiveOrZeroNum type constraint is provided by the
L<Types::Common::Numeric> library. Please see that documentation for more
information.

=cut

=type Ref

The Ref type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type RegexpObj

The RegexpObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Regexp> object.

=cut

=type RegexpObject

The RegexpObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Regexp> object.

=cut

=type RegexpRef

The RegexpRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type RoleName

The RoleName type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type ScalarObj

The ScalarObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Scalar> object.

=cut

=type ScalarObject

The ScalarObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Scalar> object.

=cut

=type ScalarRef

The ScalarRef type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type SimpleStr

The SimpleStr type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information.

=cut

=type SingleDigit

The SingleDigit type constraint is provided by the L<Types::Common::Numeric>
library. Please see that documentation for more information.

=cut

=type Str

The Str type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type StrMatch

The StrMatch type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type StrObj

The StrObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::String> object.

=cut

=type StrObject

The StrObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::String> object.

=cut

=type StrictNum

The StrictNum type constraint is provided by the L<Types::Standard> library.
Please see that documentation for more information.

=cut

=type StringObj

The StringObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::String> object.

=cut

=type StringObject

The StringObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::String> object.

=cut

=type StrongPassword

The StrongPassword type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information.

=cut

=type Tied

The Tied type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type Tuple

The Tuple type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type Undef

The Undef type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

=type UndefObj

The UndefObj type constraint is provided by this library and accepts any object
that is, or is derived from, a L<Data::Object::Undef> object.

=cut

=type UndefObject

The UndefObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Undef> object.

=cut

=type UniversalObj

The UniversalObj type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Universal> object.

=cut

=type UniversalObject

The UniversalObject type constraint is provided by this library and accepts any
object that is, or is derived from, a L<Data::Object::Universal> object.

=cut

=type UpperCaseSimpleStr

The UpperCaseSimpleStr type constraint is provided by the
L<Types::Common::String> library. Please see that documentation for more
information.

=cut

=type UpperCaseStr

The UpperCaseStr type constraint is provided by the L<Types::Common::String>
library. Please see that documentation for more information.

=cut

=type Value

The Value type constraint is provided by the L<Types::Standard> library. Please
see that documentation for more information.

=cut

