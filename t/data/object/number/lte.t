use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Number';
can_ok 'Data::Object::Number', 'lte';

use Scalar::Util 'refaddr';

subtest 'test the lte method' => sub {
    my $number = Data::Object::Number->new(1);
    my $lte = $number->lte(1);

    isnt refaddr($number), refaddr($lte);
    is $lte, 1;

    $lte = $number->lte(2);

    isnt refaddr($number), refaddr($lte);
    is $lte, 1;

    $lte = $number->lte(0);

    isnt refaddr($number), refaddr($lte);
    is $lte, 0;

    isa_ok $number, 'Data::Object::Number';
    isa_ok $lte, 'Data::Object::Number';
};

ok 1 and done_testing;
