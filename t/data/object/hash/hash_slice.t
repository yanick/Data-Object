use Test::More;

use_ok 'Data::Object::Hash';
can_ok 'Data::Object::Hash', 'hash_slice';

use Scalar::Util 'refaddr';

subtest 'test the hash_slice method' => sub {
    my $hash = Data::Object::Hash->new({1..8});

    my @argument = (1,3);
    my $hash_slice = $hash->hash_slice(@argument);

    isnt refaddr($hash), refaddr($hash_slice);
    is_deeply $hash_slice, {1=>2,3=>4};

    isa_ok $hash, 'Data::Object::Hash';
    isa_ok $hash_slice, 'Data::Object::Hash';
};

ok 1 and done_testing;
