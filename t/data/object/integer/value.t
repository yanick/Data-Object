use Test::More;

use_ok 'Data::Object::Number';
can_ok 'Data::Object::Number', 'value';

subtest 'test the value method' => sub {
    my $integer = Data::Object::Number->new(99999);
    is $integer->value, 99999;

    $integer = Data::Object::Number->new('99999');
    is "$integer", 99999;
};

ok 1 and done_testing;
