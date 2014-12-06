# A Reference Data Type Role for Perl 5
package Data::Object::Role::Type::Ref;

use 5.10.0;
use Moo::Role;

with 'Data::Object::Role::Type::Defined';

use Scalar::Util ();

# VERSION

sub refaddr {
    goto &Scalar::Util::refaddr;
}

sub reftype {
    goto &Scalar::Util::reftype;
}

1;
