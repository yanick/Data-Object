# Default Data Type Role
package Data::Object::Role::Type;

use 5.014;
use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object::Role;

use Data::Object ();
use Scalar::Util ();

# VERSION

sub objtype {
    goto &Data::Object::deduce_type;
}

sub refaddr {
    goto &Scalar::Util::refaddr;
}

sub reftype {
    goto &Scalar::Util::reftype;
}

1;
