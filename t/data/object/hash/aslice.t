use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Hash';
can_ok 'Data::Object::Hash', 'aslice';

use Scalar::Util 'refaddr';

subtest 'test the aslice method' => sub {
    my $hash = Data::Object::Hash->new({1..8});

    my @argument = (1,3);
    my $aslice = $hash->aslice(@argument);

    isnt refaddr($hash), refaddr($aslice);
    is_deeply $aslice, [2,4];

    isa_ok $hash, 'Data::Object::Hash';
    isa_ok $aslice, 'Data::Object::Array';
};

ok 1 and done_testing;
