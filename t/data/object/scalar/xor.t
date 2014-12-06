use Test::More;

use_ok 'Data::Object::Scalar';
can_ok 'Data::Object::Scalar', 'xor';

use Scalar::Util 'refaddr';

subtest 'test the xor method' => sub {
    my $scalar = Data::Object::Scalar->new(12345);
    my $xor = $scalar->xor(12345);

    isnt refaddr($scalar), refaddr($xor);
    is $xor, 0;

    isa_ok $scalar, 'Data::Object::Scalar';
    isa_ok $xor, 'Data::Object::Number';
};

ok 1 and done_testing;
