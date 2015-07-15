# A Singleton Class for Perl 5
package Data::Object::Singleton;

use 5.010;
use Data::Object::Class ();

# VERSION

sub import {
    my $target = caller;
    my $class  = shift;
    my @export = @_;

    Data::Object::Class->import($target, @export);

    my $hold;

    if (my $orig = $class->can('new')) {
        no strict 'refs'; *{"${target}::new"} = sub { $hold //= $orig->(@_) };
    }

    if (my $orig = $class->can('new') and !$class->can('renew')) {
        no strict 'refs'; *{"${target}::renew"} = sub { $hold = $orig->(@_) };
    }

    return;
}

1;
