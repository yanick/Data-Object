# Keyed Data Type Role for Perl 5
package Data::Object::Role::Keyed;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object::Role;

# VERSION

requires 'invert';

1;
