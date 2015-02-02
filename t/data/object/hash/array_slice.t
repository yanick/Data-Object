use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Hash';
can_ok 'Data::Object::Hash', 'array_slice';

use Scalar::Util 'refaddr';

subtest 'test the array_slice method' => sub {
    my $hash = Data::Object::Hash->new({1..8});

    my @argument = (1,3);
    my $array_slice = $hash->array_slice(@argument);

    isnt refaddr($hash), refaddr($array_slice);
    is_deeply $array_slice, [2,4];

    isa_ok $hash, 'Data::Object::Hash';
    isa_ok $array_slice, 'Data::Object::Array';
};

ok 1 and done_testing;
