# An Indexed Data Type Role for Perl 5
package Data::Object::Role::Type::Indexed;

use 5.10.0;
use Moo::Role;

with 'Data::Object::Role::Type::Collection';

# VERSION

requires 'slice';

1;
