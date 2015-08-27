# Detract Data Type Role for Perl 5
package Data::Object::Role::Detract;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object::Role;

with 'Data::Object::Role::Defined';

# VERSION

requires 'data';
requires 'detract';

1;
