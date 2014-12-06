use Test::More;

use_ok 'Data::Object::String';
can_ok 'Data::Object::String', 'value';

subtest 'test the value method' => sub {
    my $string = Data::Object::String->new('');
    is $string->value, '';

    $string = Data::Object::String->new('longgggg');
    is $string->value, 'longgggg';
};

ok 1 and done_testing;
