# List Data Type Role for Perl 5
package Data::Object::Role::List;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object::Role;

# VERSION

requires 'defined';
requires 'grep';
requires 'head';
requires 'join';
requires 'length';
requires 'map';
requires 'reverse';
requires 'sort';
requires 'tail';

1;
