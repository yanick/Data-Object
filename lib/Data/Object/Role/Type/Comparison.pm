# A Comparison Data Type Role for Perl 5
package Data::Object::Role::Type::Comparison;

use 5.10.0;
use Moo::Role;

with 'Data::Object::Role::Type::Item';

# VERSION

requires 'eq';
requires 'eqtv';
requires 'gt';
requires 'gte';
requires 'lt';
requires 'lte';
requires 'ne';

1;
