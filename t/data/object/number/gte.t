use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Number';
can_ok 'Data::Object::Number', 'gte';

use Scalar::Util 'refaddr';

subtest 'test the gte method' => sub {
    my $number = Data::Object::Number->new(1);
    my $gte = $number->gte(0);

    isnt refaddr($number), refaddr($gte);
    is $gte, 1;

    $gte = $number->gte(1);

    isnt refaddr($number), refaddr($gte);
    is $gte, 1;

    $gte = $number->gte(2);

    isnt refaddr($number), refaddr($gte);
    is $gte, 0;

    isa_ok $number, 'Data::Object::Number';
    isa_ok $gte, 'Data::Object::Number';
};

ok 1 and done_testing;
