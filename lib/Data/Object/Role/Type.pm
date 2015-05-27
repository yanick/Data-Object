# The Default Data Type Role
package Data::Object::Role::Type;

use 5.010;
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
