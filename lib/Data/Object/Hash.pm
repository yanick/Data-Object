# ABSTRACT: Hash Object for Perl 5
package Data::Object::Hash;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object;
use Scalar::Util;

use Data::Object::Class 'with';

with 'Data::Object::Role::Hash';

# VERSION

method data () {

    @_ = $self and goto &detract;

}

method detract () {

    return Data::Object::detract_deep($self);

}

method list () {

    @_ = $self and goto &values;

}

method new (ClassName $class: ("HashRef | InstanceOf['Data::Object::Hash']") $data) {

    my $role = 'Data::Object::Role::Type';

    $data = $data->data if Scalar::Util::blessed($data)
        and $data->can('does')
        and $data->does($role);

    Data::Object::throw('Type Instantiation Error: Not a HashRef')
        unless 'HASH' eq ref $data;

    return bless $data, $class;

}

around 'array_slice' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'aslice' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'clear' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'defined' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'delete' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'each' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'each_key' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'each_n_values' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'each_value' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'empty' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'exists' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'filter_exclude' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'filter_include' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'fold' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'get' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'hash_slice' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'hslice' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'invert' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'iterator' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'keys' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'lookup' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'merge' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'new' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args > 1 && !(@args % 2) ? {@args} : shift @args);
    return $result;
};

around 'pairs' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'pairs_array' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'reset' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'reverse' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'set' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'unfold' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar Data::Object::deduce_deep($result);
};

around 'values' => sub {
    my ($orig, $self, @args) = @_;
    my $result = Data::Object::deduce_deep($self->$orig(@args));
    return wantarray ? (@$result) : $result;
};

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Hash;

    my $hash = Data::Object::Hash->new({1..4});

=head1 DESCRIPTION

Data::Object::Hash provides common methods for operating on Perl 5 hash
references. Hash methods work on hash references. Users of these methods should
be aware of the methods that modify the array reference itself as opposed to
returning a new array reference. Unless stated, it may be safe to assume that
the following methods copy, modify and return new hash references based on their
function.

=head1 COMPOSITION

This class inherits all functionality from the L<Data::Object::Role::Hash>
role and implements proxy methods as documented herewith.

=head1 CODIFICATION

Certain methods provided by the this module support codification, a process
which converts a string argument into a code reference which can be used to
supply a callback to the method called. A codified string can access its
arguments by using variable names which correspond to letters in the alphabet
which represent the position in the argument list. For example:

    $array->example('$a + $b * $c', 100);

    # if the example method does not supply any arguments automatically then
    # the variable $a would be assigned the user-supplied value of 100,
    # however, if the example method supplies two arguments automatically then
    # those arugments would be assigned to the variables $a and $b whereas $c
    # would be assigned the user-supplied value of 100

Any place a codified string is accepted, a coderef or L<Data::Object::Code>
object is also valid. Arguments are passed through the usual C<@_> list.

=cut

=method array_slice

    # given {1..8}

    $hash->array_slice(1,3); # [2,4]

The array_slice method returns an array reference containing the values in the
hash corresponding to the keys specified in the arguments in the order
specified. This method returns a L<Data::Object::Array> object.

=cut

=method aslice

    # given {1..8}

    $hash->aslice(1,3); # [2,4]

The aslice method is an alias to the array_slice method. This method returns a
L<Data::Object::Array> object. This method is an alias to the array_slice
method.

=cut

=method clear

    # given {1..8}

    $hash->clear; # {}

The clear method is an alias to the empty method. This method returns a
L<Data::Object::Hash> object. This method is an alias to the empty method.

=cut

=method defined

    # given {1..8,9,undef}

    $hash->defined(1); # 1; true
    $hash->defined(0); # 0; false
    $hash->defined(9); # 0; false

The defined method returns true if the value matching the key specified in the
argument if defined, otherwise returns false. This method returns a
L<Data::Object::Number> object.

=cut

=method delete

    # given {1..8}

    $hash->delete(1); # 2

The delete method returns the value matching the key specified in the argument
and returns the value. This method returns a data type object to be determined
after execution.

=cut

=method each

    # given {1..8}

    $hash->each(sub{
        my $key   = shift; # 1
        my $value = shift; # 2
    });

The each method iterates over each element in the hash, executing the code
reference supplied in the argument, passing the routine the key and value at the
current position in the loop. This method supports codification, i.e, takes an
argument which can be a codifiable string, a code reference, or a code data type
object. This method returns a L<Data::Object::Hash> object.

=cut

=method each_key

    # given {1..8}

    $hash->each_key(sub{
        my $key = shift; # 1
    });

The each_key method iterates over each element in the hash, executing the code
reference supplied in the argument, passing the routine the key at the current
position in the loop. This method supports codification, i.e, takes an argument
which can be a codifiable string, a code reference, or a code data type object.
This method returns a L<Data::Object::Hash> object.

=cut

=method each_n_values

    # given {1..8}

    $hash->each_n_values(4, sub {
        my $value_1 = shift; # 2
        my $value_2 = shift; # 4
        my $value_3 = shift; # 6
        my $value_4 = shift; # 8
        ...
    });

The each_n_values method iterates over each element in the hash, executing the
code reference supplied in the argument, passing the routine the next n values
until all values have been seen. This method supports codification, i.e, takes
an argument which can be a codifiable string, a code reference, or a code data
type object. This method returns a L<Data::Object::Hash> object.

=cut

=method each_value

    # given {1..8}

    $hash->each_value(sub {
        my $value = shift; # 2
    });

The each_value method iterates over each element in the hash, executing the code
reference supplied in the argument, passing the routine the value at the current
position in the loop. This method supports codification, i.e, takes an argument
which can be a codifiable string, a code reference, or a code data type object.
This method returns a L<Data::Object::Hash> object.

=cut

=method empty

    # given {1..8}

    $hash->empty; # {}

The empty method drops all elements from the hash. This method returns a
L<Data::Object::Hash> object. Note: This method modifies the hash.

=cut

=method exists

    # given {1..8,9,undef}

    $hash->exists(1); # 1; true
    $hash->exists(0); # 0; false

The exists method returns true if the value matching the key specified in the
argument exists, otherwise returns false. This method returns a
L<Data::Object::Number> object.

=cut

=method filter_exclude

    # given {1..8}

    $hash->filter_exclude(1,3); # {5=>6,7=>8}

The filter_exclude method returns a hash reference consisting of all key/value
pairs in the hash except for the pairs whose keys are specified in the
arguments. This method returns a L<Data::Object::Hash> object.

=cut

=method filter_include

    # given {1..8}

    $hash->filter_include(1,3); # {1=>2,3=>4}

The filter_include method returns a hash reference consisting of only key/value
pairs whose keys are specified in the arguments. This method returns a
L<Data::Object::Hash> object.

=cut

=method fold

    # given {3,[4,5,6],7,{8,8,9,9}}

    $hash->fold; # {'3:0'=>4,'3:1'=>5,'3:2'=>6,'7.8'=>8,'7.9'=>9}

The fold method returns a single-level hash reference consisting of key/value
pairs whose keys are paths (using dot-notation where the segments correspond to
nested hash keys and array indices) mapped to the nested values. This method
returns a L<Data::Object::Hash> object.

=cut

=method get

    # given {1..8}

    $hash->get(5); # 6

The get method returns the value of the element in the hash whose key
corresponds to the key specified in the argument. This method returns a data
type object to be determined after execution.

=cut

=method hash_slice

    # given {1..8}

    $hash->hash_slice(1,3); # {1=>2,3=>4}

The hash_slice method returns a hash reference containing the key/value pairs
in the hash corresponding to the keys specified in the arguments. This method
returns a L<Data::Object::Hash> object.

=cut

=method hslice

    # given {1..8}

    $hash->hslice(1,3); # {1=>2,3=>4}

The hslice method is an alias to the array_slice method. This method returns a
L<Data::Object::Hash> object. This method is an alias to the hash_slice method.

=cut

=method invert

    # given {1..8,9,undef,10,''}

    $hash->invert; # {''=>10,2=>1,4=>3,6=>5,8=>7}

The invert method returns the hash after inverting the keys and values
respectively. Note, keys with undefined values will be dropped, also, this
method modifies the hash. This method returns a L<Data::Object::Hash> object.
Note: This method modifies the hash.

=cut

=method iterator

    # given {1..8}

    my $iterator = $hash->iterator;
    while (my $value = $iterator->next) {
        say $value; # 2
    }

The iterator method returns a code reference which can be used to iterate over
the hash. Each time the iterator is executed it will return the values of the
next element in the hash until all elements have been seen, at which point
the iterator will return an undefined value. This method returns a
L<Data::Object::Code> object.

=cut

=method keys

    # given {1..8}

    $hash->keys; # [1,3,5,7]

The keys method returns an array reference consisting of all the keys in the
hash. This method returns a L<Data::Object::Array> object.

=cut

=method lookup

    # given {1..3,{4,{5,6,7,{8,9,10,11}}}}

    $hash->lookup('3.4.7'); # {8=>9,10=>11}
    $hash->lookup('3.4'); # {5=>6,7=>{8=>9,10=>11}}
    $hash->lookup(1); # 2

The lookup method returns the value of the element in the hash whose key
corresponds to the key specified in the argument. The key can be a string which
references (using dot-notation) nested keys within the hash. This method will
return undefined if the value is undef or the location expressed in the argument
can not be resolved. Please note, keys containing dots (periods) are not
handled. This method returns a data type object to be determined after
execution.

=cut

=method merge

    # given {1..8}

    $hash->merge({7,7,9,9}); # {1=>2,3=>4,5=>6,7=>7,9=>9}

The merge method returns a hash reference where the elements in the hash and
the elements in the argument(s) are merged. This operation performs a deep
merge and clones the datasets to ensure no side-effects. The merge behavior
merges hash references only, all other data types are assigned with precendence
given to the value being merged. This method returns a L<Data::Object::Hash>
object.

=cut

=method new

    # given 1..4

    my $hash = Data::Object::Hash->new(1..4);
    my $hash = Data::Object::Hash->new({1..4});

The new method expects a list or hash reference and returns a new class
instance.

=cut

=method pairs

    # given {1..8}

    $hash->pairs; # [[1,2],[3,4],[5,6],[7,8]]

The pairs method is an alias to the pairs_array method. This method returns a
L<Data::Object::Array> object. This method is an alias to the pairs_array
method.

=cut

=method pairs_array

    # given {1..8}

    $hash->pairs_array; # [[1,2],[3,4],[5,6],[7,8]]

The pairs_array method returns an array reference consisting of array references
where each sub-array reference has two elements corresponding to the key and
value of each element in the hash. This method returns a L<Data::Object::Array>
object.

=cut

=method reset

    # given {1..8}

    $hash->reset; # {1=>undef,3=>undef,5=>undef,7=>undef}

The reset method returns nullifies the value of each element in the hash. This
method returns a L<Data::Object::Hash> object. Note: This method modifies the
hash.

=cut

=method reverse

    # given {1..8,9,undef}

    $hash->reverse; # {8=>7,6=>5,4=>3,2=>1}

The reverse method returns a hash reference consisting of the hash's keys and
values inverted. Note, keys with undefined values will be dropped. This method
returns a L<Data::Object::Hash> object.

=cut

=method set

    # given {1..8}

    $hash->set(1,10); # 10
    $hash->set(1,12); # 12
    $hash->set(1,0); # 0

The set method returns the value of the element in the hash corresponding to
the key specified by the argument after updating it to the value of the second
argument. This method returns a data type object to be determined after
execution.

=cut

=method unfold

    # given {'3:0'=>4,'3:1'=>5,'3:2'=>6,'7.8'=>8,'7.9'=>9}

    $hash->unfold; # {3=>[4,5,6],7,{8,8,9,9}}

The unfold method processes previously folded hash references and returns an
unfolded hash reference where the keys, which are paths (using dot-notation
where the segments correspond to nested hash keys and array indices), are used
to created nested hash and/or array references. This method returns a
L<Data::Object::Hash> object.

=cut

=method values

    # given {1..8}

    $hash->values; # [2,4,6,8]

The values method returns an array reference consisting of the values of the
elements in the hash. This method returns a L<Data::Object::Array> object.

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
