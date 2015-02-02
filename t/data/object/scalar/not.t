use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Scalar';
can_ok 'Data::Object::Scalar', 'not';

use Scalar::Util 'refaddr';

subtest 'test the not method' => sub {
    my $scalar = Data::Object::Scalar->new(0);
    my $not = $scalar->not();

    isnt refaddr($scalar), refaddr($not);
    is $not, '';

    isa_ok $scalar, 'Data::Object::Scalar';
    isa_ok $not, 'Data::Object::String';
};

ok 1 and done_testing;
