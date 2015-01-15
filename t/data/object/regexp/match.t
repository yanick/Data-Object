use Test::More;

use Data::Object::String;

use_ok 'Data::Object::Regexp';
can_ok 'Data::Object::Regexp', 'match';

subtest 'constructor' => sub {
    plan tests => 2;

    isa_ok(Data::Object::Regexp->new(qr(test)), 'Data::Object::Regexp', 'new from qr');
    isa_ok(Data::Object::Regexp->new(q(test)), 'Data::Object::Regexp', 'new from string');

};

subtest 'no capturing' => sub {
    plan tests => 7;
    my $re = Data::Object::Regexp->new(qr(test));

    my $result = $re->match('this is a test of matching');
    isa_ok($result, 'Data::Object::MatchResult');
    is($result->string, 'this is a test of matching', 'result string()');
    is($result->matched, 'test', 'result matched()');
    is($result->regexp, $re, 'result regexp()');
    is($result->prematch, 'this is a ', 'result prematch()');
    is($result->postmatch, ' of matching', 'result postmatch()');

    ok ! $re->match('this does not match'), 'match returns false for non-matching string';
};

subtest 'captures' => sub {
    plan tests => 17;

    my $re = Data::Object::Regexp->new(qr((\w+)\s+(\w+)));

    my $result = $re->match('two words');
    isa_ok $result, 'Data::Object::MatchResult';
    is_deeply([$result->capt], [qw(two words)], 'captured two matches');
    is_deeply({ $result->capt_hash }, {}, 'no named matches');

    is($result->[0], 'two words', 'as arrayref 0th idx');
    is($result->[1], 'two', 'as arrayref 1th idx');
    is($result->[2], 'words', 'as arrayref 2th idx');

    is($result->begin(0), 0, 'begin(0)');
    is($result->end(0), 9, 'end(0)');
    is_deeply([$result->offset(0)], [0, 9], 'offset(0)');
    is($result->begin(1), 0, 'begin(1)');
    is($result->end(1), 3, 'end(1)');
    is_deeply([$result->offset(1)], [0, 3], 'offset(1)');
    is($result->begin(2), 4, 'begin(2)');
    is($result->end(2), 9, 'end(2)');
    is_deeply([$result->offset(2)], [4, 9], 'offset(2)');

    $result = $re->match('here are more words to match');
    is_deeply([$result->capt], [qw(here are)], 'captured two matches with longer string');

    $result = $re->match('nope');
    ok(! $result, 'non-matching string returns false');
};

subtest 'named captures' => sub {
    plan tests => 5;

    my $re = Data::Object::Regexp->new(qr{(?<first>foo).*(?<second>bar)});

    my $result = $re->match('this string has foo and bar');
    is_deeply({ $result->capt_hash },
            { first => 'foo', second => 'bar' },
            'Matched both named captures');
    is_deeply([sort $result->capt_names], ['first', 'second'], 'capt_names()');
    is($result->capt_hash('first'), 'foo', 'capture named foo');
    is($result->capt_hash('second'), 'bar', 'capture named foo');
    is($result->capt_hash('bogus'), undef, 'capture named bogus');
};

subtest 'match against Data::Object::String' => sub {
    plan tests => 2;

    my $re = Data::Object::Regexp->new(qr(test));

    my $matching = Data::Object::String->new('this is a test');
    ok $re->match($matching), 'match against Data::Object::String instance';

    my $nonmatching = Data::Object::String->new('no matching here');
    ok ! $re->match($nonmatching), 'failed match against Data::Object::String instance';
};

ok 1 and done_testing;
