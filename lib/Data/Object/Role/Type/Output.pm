# An Output Data Type Role for Perl 5
package Data::Object::Role::Type::Output;

use 5.10.0;
use Moo::Role;

with 'Data::Object::Role::Type::Defined';

# VERSION

requires 'print';
requires 'say';

1;
