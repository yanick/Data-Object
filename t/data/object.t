use Test::More;

use_ok 'Data::Object';

subtest 'test module' => sub {
    can_ok 'Data::Object' => qw(
        load
        deduce
        type_array
        type_code
        type_float
        type_hash
        type_integer
        type_number
        type_scalar
        type_string
        type_undef
        type_universal
    );
};

ok 1 and done_testing;
