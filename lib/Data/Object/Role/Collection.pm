# A Collection Data Type Role for Perl 5
package Data::Object::Role::Collection;

use 5.010;
use Data::Object::Role;

# VERSION

requires 'defined';
requires 'each';
requires 'each_key';
requires 'each_n_values';
requires 'each_value';
requires 'exists';
requires 'iterator';
requires 'list';
requires 'keys';
requires 'get';
requires 'set';
requires 'values';

1;
