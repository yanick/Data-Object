# A Generic Constructor Role for Perl 5
package Data::Object::Role::Constructor;

use 5.010;
use Data::Object::Role;

use Scalar::Util 'blessed';

# VERSION

sub new {
    my $class = shift;
    my $data  = shift;

    $data = $data->data if blessed($data)
        and $data->can('does') and $data->does('Data::Object::Role::Type');

    if (blessed($data) && $data->isa('Regexp') && $^V <= v5.12.0) {
        $data = do {\(my $q = qr/$data/)};
    }

    return bless ref($data) ? $data : \$data, $class;
}

1;
