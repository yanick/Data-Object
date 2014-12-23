# A Generic Constructor Role for Perl 5
package Data::Object::Role::Constructor;

use 5.010;
use Moo::Role;

use Scalar::Util 'blessed';
use Types::Standard 'Any';

# VERSION

sub new {
    my $class = shift;
    my $data  = shift;

    $class = ref($class) || $class;
    unless (blessed($data) && $data->isa($class)) {
        $data = Any->($data);
    }

    if (blessed($data) && $data->isa('Regexp') && $^V <= v5.12.0) {
        $data = do {\(my $q = qr/$data/)};
    }

    return bless ref($data) ? $data : \$data, $class;
}

1;
