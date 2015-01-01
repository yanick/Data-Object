# A Value Data Type Role for Perl 5
package Data::Object::Role::Values;

use 5.010;
use Moo::Role;

with 'Data::Object::Role::Defined';

# VERSION

requires 'list';
requires 'values';

1;