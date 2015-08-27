# Comparison Data Type Role for Perl 5
package Data::Object::Role::Comparison;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object::Role;

# VERSION

requires 'eq';
requires 'eqtv';
requires 'gt';
requires 'gte';
requires 'lt';
requires 'lte';
requires 'ne';

1;
