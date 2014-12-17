use Test::More;

use_ok 'Data::Object::Hash';
can_ok 'Data::Object::Hash', 'list';

use Scalar::Util 'refaddr';

subtest 'test the list method - scalar context' => sub {
    my $hash = Data::Object::Hash->new({1..8});

    my @argument = ();
    my $values = $hash->list(@argument);

    isnt refaddr($hash), refaddr($values);
    is_deeply [sort @{$values}], [sort values %{$hash}];

    isa_ok $hash, 'Data::Object::Hash';
    isa_ok $values, 'Data::Object::Array';
};

subtest 'test the list method - list context' => sub {
    my $hash = Data::Object::Hash->new({1..8});

    my @argument = ();
    my @values = $hash->list(@argument);
    @values = sort @values;

    is_deeply [@values], [sort values %{$hash}];

    is $values[0], 2;
    isa_ok $values[0], 'Data::Object::Number';

    is $values[1], 4;
    isa_ok $values[1], 'Data::Object::Number';

    is $values[2], 6;
    isa_ok $values[2], 'Data::Object::Number';

    is $values[3], 8;
    isa_ok $values[3], 'Data::Object::Number';

    isa_ok $hash, 'Data::Object::Hash';
};

ok 1 and done_testing;
