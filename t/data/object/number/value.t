use Test::More;

use_ok 'Data::Object::Number';
can_ok 'Data::Object::Number', 'value';

subtest 'test the value method' => sub {
    my $number = Data::Object::Number->new('+12345');
    is $number->value, 12345;

    $number = Data::Object::Number->new(-12345);
    is $number->value, -12345;
};

ok 1 and done_testing;
