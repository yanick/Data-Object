use strict;
use warnings;
use Test::More;

use Data::Object;
use Scalar::Util;

can_ok 'Data::Object', 'alias';
subtest 'test the alias function' => sub {
    my $alias = Data::Object::alias('Scalar::Util');
    is $alias, 'Util';
    is Util(), 'Scalar::Util';
    is do { no strict 'refs'; &$alias }, 'Scalar::Util';
};

subtest 'test the alias function with explicit alias' => sub {
    my $alias = Data::Object::alias(SclUtl => 'Scalar::Util');
    is $alias, 'SclUtl';
    is SclUtl(), 'Scalar::Util';
    is do { no strict 'refs'; &$alias }, 'Scalar::Util';
};

subtest 'test the alias function with explicit namespaced alias' => sub {
    my $alias = Data::Object::alias('Stash::SclUtl' => 'Scalar::Util');
    is $alias, 'Stash::SclUtl';
    is Stash::SclUtl(), 'Scalar::Util';
    is do { no strict 'refs'; &$alias }, 'Scalar::Util';
};

ok 1 and done_testing;
