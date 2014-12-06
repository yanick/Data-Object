use Test::More;

use_ok 'Data::Object::Float';
can_ok 'Data::Object::Float', 'value';

subtest 'test the value method' => sub {
    my $float = Data::Object::Float->new(3.99);
    is $float->value, 3.99;

    $float = Data::Object::Float->new('9.99');
    is $float->value, '9.99';
};

ok 1 and done_testing;
