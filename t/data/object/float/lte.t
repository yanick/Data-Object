use Test::More;

use_ok 'Data::Object::Float';
can_ok 'Data::Object::Float', 'lte';

use Scalar::Util 'refaddr';

subtest 'test the lte method' => sub {
    my $float = Data::Object::Float->new(1.50);
    my $lte = $float->lte(1.50);

    isnt refaddr($float), refaddr($lte);
    is $lte, 1;

    $lte = $float->lte(2.00);

    isnt refaddr($float), refaddr($lte);
    is $lte, 1;

    $lte = $float->lte(0);

    isnt refaddr($float), refaddr($lte);
    is $lte, 0;

    isa_ok $float, 'Data::Object::Float';
    isa_ok $lte, 'Data::Object::Number';
};

ok 1 and done_testing;
