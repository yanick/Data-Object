use Test::More;

use_ok 'Data::Object::Scalar';
can_ok 'Data::Object::Scalar', 'and';

use Scalar::Util 'refaddr';

subtest 'test the and method' => sub {
    my $scalar = Data::Object::Scalar->new(0);
    my $and = $scalar->and(12345);

    isnt refaddr($scalar), refaddr($and);
    is $and, 12345;

    isa_ok $scalar, 'Data::Object::Scalar';
    isa_ok $and, 'Data::Object::Number';
};

ok 1 and done_testing;
