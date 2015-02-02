use strict;
use warnings;
use Test::More;

use_ok 'Data::Object::Scalar';
can_ok 'Data::Object::Scalar', 'data';

subtest 'test the data method' => sub {
    my $scalar = Data::Object::Scalar->new(qr/\w+/);
    is $scalar->detract, qr/\w+/;
};

ok 1 and done_testing;
