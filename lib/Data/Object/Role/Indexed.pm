# An Indexed Data Type Role for Perl 5
package Data::Object::Role::Indexed;

use 5.010;
use Moo::Role;

with 'Data::Object::Role::Collection';

# VERSION

requires 'slice';

1;
