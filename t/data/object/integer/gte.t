use Test::More;

use_ok 'Data::Object::Number';
can_ok 'Data::Object::Number', 'gte';

use Scalar::Util 'refaddr';

subtest 'test the gte method' => sub {
    my $integer = Data::Object::Number->new(1);
    my $gte = $integer->gte(0);

    isnt refaddr($integer), refaddr($gte);
    is $gte, 1;

    $gte = $integer->gte(1);

    isnt refaddr($integer), refaddr($gte);
    is $gte, 1;

    $gte = $integer->gte(2);

    isnt refaddr($integer), refaddr($gte);
    is $gte, 0;

    isa_ok $integer, 'Data::Object::Number';
    isa_ok $gte, 'Data::Object::Number';
};

ok 1 and done_testing;
