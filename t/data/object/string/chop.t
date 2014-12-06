use Test::More;

use_ok 'Data::Object::String';
can_ok 'Data::Object::String', 'chop';

use Scalar::Util 'refaddr';

subtest 'test the chop method' => sub {
    my $string = Data::Object::String->new("name, age, dob, email.");
    my $chopped = $string->chop;

    is refaddr($string), refaddr($chopped);
    is "$chopped", 'name, age, dob, email';

    isa_ok $string, 'Data::Object::String';
    isa_ok $chopped, 'Data::Object::String';
};

ok 1 and done_testing;
