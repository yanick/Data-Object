# A Singleton Class for Perl 5
package Data::Object::Singleton;

use 5.010;
use parent 'Moo';

# VERSION

sub import {
    my $state = undef;
    my $class = caller;

    eval "package $class; use Moo; 1;";

    my $new   = $class->can('new');
    my $renew = $class->can('renew');

    no strict 'refs';
    *{"${class}::new"}   = sub { $state = $new->(@_) if !$state; $state };
    *{"${class}::renew"} = sub { $state = $new->(@_) };

    return ;
}

1;
