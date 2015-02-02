use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Number';
can_ok 'Data::Object::Number', 'lte';

use Scalar::Util 'refaddr';

subtest 'test the lte method' => sub {
    my $integer = Data::Object::Number->new(1);
    my $lte = $integer->lte(1);

    isnt refaddr($integer), refaddr($lte);
    is $lte, 1;

    $lte = $integer->lte(2);

    isnt refaddr($integer), refaddr($lte);
    is $lte, 1;

    $lte = $integer->lte(0);

    isnt refaddr($integer), refaddr($lte);
    is $lte, 0;

    isa_ok $integer, 'Data::Object::Number';
    isa_ok $lte, 'Data::Object::Number';
};

ok 1 and done_testing;
