# A Defined Data Type Role for Perl 5
package Data::Object::Role::Type::Defined;

use 5.010;
use Moo::Role;

with 'Data::Object::Role::Type::Item';

# VERSION

sub defined {
    return 1
}

1;
