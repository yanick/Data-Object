# A Reference Data Type Role for Perl 5
package Data::Object::Role::Ref;

use 5.010;
use Moo::Role;

with 'Data::Object::Role::Defined';

use Scalar::Util ();

# VERSION

sub refaddr {
    goto &Scalar::Util::refaddr;
}

sub reftype {
    goto &Scalar::Util::reftype;
}

1;
