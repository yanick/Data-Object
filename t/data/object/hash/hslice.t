use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Hash';
can_ok 'Data::Object::Hash', 'hslice';

use Scalar::Util 'refaddr';

subtest 'test the hslice method' => sub {
    my $hash = Data::Object::Hash->new({1..8});

    my @argument = (1,3);
    my $hslice = $hash->hslice(@argument);

    isnt refaddr($hash), refaddr($hslice);
    is_deeply $hslice, {1=>2,3=>4};

    isa_ok $hash, 'Data::Object::Hash';
    isa_ok $hslice, 'Data::Object::Hash';
};

ok 1 and done_testing;
