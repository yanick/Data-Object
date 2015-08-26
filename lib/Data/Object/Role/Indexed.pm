# Indexed Data Type Role for Perl 5
package Data::Object::Role::Indexed;

use 5.014;
use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object::Role;

# VERSION

requires 'slice';

1;
