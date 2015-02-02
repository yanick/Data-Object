use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Float';
can_ok 'Data::Object::Float', 'gte';

use Scalar::Util 'refaddr';

subtest 'test the gte method' => sub {
    my $float = Data::Object::Float->new(1.00034);
    my $gte = $float->gte(0);

    isnt refaddr($float), refaddr($gte);
    is $gte, 1;

    $gte = $float->gte(1.00034);

    isnt refaddr($float), refaddr($gte);
    is $gte, 1;

    $gte = $float->gte(2);

    isnt refaddr($float), refaddr($gte);
    is $gte, 0;

    isa_ok $float, 'Data::Object::Float';
    isa_ok $gte, 'Data::Object::Number';
};

ok 1 and done_testing;
