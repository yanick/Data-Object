use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Scalar';
can_ok 'Data::Object::Scalar', 'or';

use Scalar::Util 'refaddr';

subtest 'test the or method' => sub {
    my $scalar = Data::Object::Scalar->new(12345);
    my $or = $scalar->or(undef);

    is refaddr($scalar), refaddr($or);
    is $$or, 12345;

    isa_ok $scalar, 'Data::Object::Scalar';
    isa_ok $or, 'Data::Object::Scalar';
};

ok 1 and done_testing;
