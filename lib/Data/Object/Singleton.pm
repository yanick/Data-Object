# A Singleton Class for Perl 5
package Data::Object::Singleton;

use 5.010;
use parent 'Moo';

# VERSION

sub import {
    my $class  = shift;
    my $target = caller;
    my $state  = undef;

    eval "package $target; use Moo; 1;";

    my $new   = $target->can('new');
    my $renew = $target->can('renew');

    no strict 'refs';

    *{"${target}::new"}   = sub { $state = $new->(@_) if !$state; $state };
    *{"${target}::renew"} = sub { $state = $new->(@_) };

    return;
}

1;
