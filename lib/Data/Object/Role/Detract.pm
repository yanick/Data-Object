# A Detract Data Type Role for Perl 5
package Data::Object::Role::Detract;

use 5.010;
use Moo::Role;

with 'Data::Object::Role::Defined';

# VERSION

requires 'data';
requires 'detract';

1;
