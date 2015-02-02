use Test::More;

use_ok 'Data::Object::Undef';

subtest 'test object overloading' => sub {
    my $string = Data::Object::Undef->new(undef);
    ok !$string;
    is "$string", '';
    is "$string", '';
    is((0+$string), 0);
    like $string, qr/^$/;
};

ok 1 and done_testing;
