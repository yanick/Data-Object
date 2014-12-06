use Test::More;

use_ok 'Data::Object::Hash';
can_ok 'Data::Object::Hash', 'pairs_array';

use Scalar::Util 'refaddr';

subtest 'test the pairs_array method' => sub {
    my $hash = Data::Object::Hash->new({1..8});

    my @argument = ();
    my $pairs_array = $hash->pairs_array(@argument);

    isnt refaddr($hash), refaddr($pairs_array);
    is_deeply $_, [$_->[0], $_->[0] + 1] for @$pairs_array;

    isa_ok $hash, 'Data::Object::Hash';
    isa_ok $pairs_array, 'Data::Object::Array';
};

ok 1 and done_testing;
