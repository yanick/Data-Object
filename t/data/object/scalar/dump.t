use Test::More;

use_ok 'Data::Object::Scalar';
can_ok 'Data::Object::Scalar', 'dump';

subtest 'test the dump method' => sub {
    my $scalar = Data::Object::Scalar->new(qr/\w+/);
    like $scalar->dump, qr/(\\w\+|\(\?\^u*\:\\w\+\))/;
};

ok 1 and done_testing;
