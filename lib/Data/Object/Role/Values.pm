# Value Data Type Role for Perl 5
package Data::Object::Role::Values;

use 5.014;
use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object::Role;

# VERSION

requires 'list';
requires 'values';

1;
