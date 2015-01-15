use Test::More;

use_ok 'Data::Object::Regexp';
can_ok 'Data::Object::Regexp', 'substitute';

subtest 'substitute' => sub {
$DB::single=1;
    my $re = Data::Object::Regexp->new(qr(test));

    is $re->substitute('this is a test', 'drill'),
        'this is a drill',
        'successful substitute';

    is $re->substitute('test one test two test three', 'match'),
        'match one test two test three',
        'multiple substitutions replaces only first match';

    is $re->substitute('this does not match'),
        'this does not match',
        'substitute against non-matching string';

    my $re_multi = Data::Object::Regexp->new(qr/test/);
    is $re_multi->substitute('test one test two test three', 'match', 'g'),
        'match one match two match three',
        'multiple substitutions';
};

ok 1 and done_testing;
