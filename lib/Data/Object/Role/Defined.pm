# Defined Data Type Role for Perl 5
package Data::Object::Role::Defined;

use 5.014;
use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object::Role;

# VERSION

sub defined {
    return 1
}

1;
