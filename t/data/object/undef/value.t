use Test::More;

use_ok 'Data::Object::Undef';
can_ok 'Data::Object::Undef', 'value';

subtest 'test the value method' => sub {
    my $string = Data::Object::Undef->new(undef);
    is $string->value, undef;
};

ok 1 and done_testing;
