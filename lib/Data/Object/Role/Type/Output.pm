# An Output Data Type Role for Perl 5
package Data::Object::Role::Type::Output;

use 5.010;
use Moo::Role;

with 'Data::Object::Role::Type::Defined';

# VERSION

requires 'print';
requires 'say';

1;
