# Throwable Data Type Role for Perl 5
package Data::Object::Role::Throwable;

use 5.014;
use Type::Tiny;
use Type::Tiny::Signatures;

use Data::Object;
use Data::Object::Role;

# VERSION

sub throw {
    my $self = shift;

    my $message = (@_ % 2 == 1) ? shift : undef;
    my $class = Data::Object::load('Data::Object::Exception');
    unshift @_, $class => (object => $self, message => $message);

    goto $class->can('throw');
}

1;
