# A Coercive Data Type Role for Perl 5
package Data::Object::Role::Type::Coercive;

use 5.10.0;
use Moo::Role;

use Data::Object 'deduce';

# VERSION

my $coercable = {
    'UNDEF' => {
        'UNDEF'  => sub { deduce undef },
        'CODE'   => sub { deduce undef },
        'NUMBER' => sub { deduce undef },
        'HASH'   => sub { deduce undef },
        'ARRAY'  => sub { deduce undef },
        'STRING' => sub { deduce undef },
    },
    'CODE' => {
        'UNDEF'  => sub { deduce undef },
        'CODE'   => sub { deduce undef },
        'ARRAY'  => sub { deduce undef },
        'NUMBER' => sub { deduce undef },
        'HASH'   => sub { deduce undef },
        'STRING' => sub { deduce undef },
    },
    'NUMBER' => {
        'UNDEF'  => sub { deduce undef },
        'CODE'   => sub { deduce undef },
        'NUMBER' => sub { deduce undef },
        'HASH'   => sub { deduce undef },
        'ARRAY'  => sub { deduce undef },
        'STRING' => sub { deduce undef },
    },
    'HASH' => {
        'UNDEF'  => sub { deduce undef },
        'CODE'   => sub { deduce undef },
        'NUMBER' => sub { deduce undef },
        'HASH'   => sub { deduce undef },
        'ARRAY'  => sub { deduce undef },
        'STRING' => sub { deduce undef },
    },
    'ARRAY' => {
        'UNDEF'  => sub { deduce undef },
        'CODE'   => sub { deduce undef },
        'NUMBER' => sub { deduce undef },
        'HASH'   => sub { deduce undef },
        'ARRAY'  => sub { deduce undef },
        'STRING' => sub { deduce undef },
    },
    'STRING' => {
        'UNDEF'  => sub { deduce undef },
        'CODE'   => sub { deduce undef },
        'NUMBER' => sub { deduce undef },
        'HASH'   => sub { deduce undef },
        'ARRAY'  => sub { deduce undef },
        'STRING' => sub { deduce undef },
    }
};

$coercable->{INTEGER} = $coercable->{NUMBER};
$coercable->{FLOAT}   = $coercable->{NUMBER};

sub to_array {
    my $coerce = 'ARRAY';
    my $object = deduce shift;
    return unless my $type = $object->type;
    return $coercable->{$type}{$coerce}->($object);
}

sub to_code {
    my $coerce = 'CODE';
    my $object = deduce shift;
    return unless my $type = $object->type;
    return $coercable->{$type}{$coerce}->($object);
}

sub to_hash {
    my $coerce = 'HASH';
    my $object = deduce shift;
    return unless my $type = $object->type;
    return $coercable->{$type}{$coerce}->($object);
}

sub to_number {
    my $coerce = 'NUMBER';
    my $object = deduce shift;
    return unless my $type = $object->type;
    return $coercable->{$type}{$coerce}->($object);
}

sub to_string {
    my $coerce = 'STRING';
    my $object = deduce shift;
    return unless my $type = $object->type;
    return $coercable->{$type}{$coerce}->($object);
}

sub to_undef {
    my $coerce = 'UNDEF';
    my $object = deduce shift;
    return unless my $type = $object->type;
    return $coercable->{$type}{$coerce}->($object);
}

{
    no warnings 'once';
    *to_a = \&to_array;
    *to_c = \&to_code;
    *to_h = \&to_hash;
    *to_n = \&to_number;
    *to_s = \&to_string;
    *to_u = \&to_undef;
}

1;
