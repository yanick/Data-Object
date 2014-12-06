use Test::More;

use_ok 'Data::Object::Number';
can_ok 'Data::Object::Number', 'log';

use Scalar::Util 'refaddr';

subtest 'test the log method' => sub {
    my $number = Data::Object::Number->new(12345);
    my $log = $number->log();

    isnt refaddr($number), refaddr($log);
    is $log, 9.42100640177928;

    isa_ok $number, 'Data::Object::Number';
    isa_ok $log, 'Data::Object::Float';
};

ok 1 and done_testing;
