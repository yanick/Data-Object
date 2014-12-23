# An Output Data Type Role for Perl 5
package Data::Object::Role::Output;

use 5.010;
use Moo::Role;
use Data::Dumper ();

use Data::Object 'detract_deep';

with 'Data::Object::Role::Defined';

# VERSION

requires 'print';
requires 'say';

sub dump {
    local $Data::Dumper::Indent    = 0;
    local $Data::Dumper::Purity    = 0;
    local $Data::Dumper::Quotekeys = 0;

    local $Data::Dumper::Deepcopy  = 1;
    local $Data::Dumper::Deparse   = 1;
    local $Data::Dumper::Sortkeys  = 1;
    local $Data::Dumper::Terse     = 1;
    local $Data::Dumper::Useqq     = 1;

    my $result = Data::Dumper::Dumper(
        detract_deep shift
    );

    $result =~ s/^"|"$//g;
    return $result;
}

sub print {
    return CORE::print(shift->dump);
}

sub say {
    return CORE::print(shift->dump, "\n");
}

1;
