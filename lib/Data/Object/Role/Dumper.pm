# ABSTRACT: Dumper Object Role for Perl 5
package Data::Object::Role::Dumper;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Role;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

# VERSION

method dump () {

    require Data::Dumper;

    local $Data::Dumper::Indent    = 0;
    local $Data::Dumper::Purity    = 0;
    local $Data::Dumper::Quotekeys = 0;

    local $Data::Dumper::Deepcopy  = 1;
    local $Data::Dumper::Deparse   = 1;
    local $Data::Dumper::Sortkeys  = 1;
    local $Data::Dumper::Terse     = 1;
    local $Data::Dumper::Useqq     = 1;

    my $result = Data::Object::detract_deep($self);
       $result = Data::Dumper::Dumper($result);
       $result =~ s/^"|"$//g;

    return $result;

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Dumper;

=cut

=head1 DESCRIPTION

Data::Object::Role::Dumper provides routines for operating on Perl 5 data
objects which meet the criteria for being dumpable.

=cut

=method dump

    # given $dumper

    $dumper->dump;

The dump method returns returns a string representation of the object.
This method returns a string value.

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object::Array>

=item *

L<Data::Object::Class>

=item *

L<Data::Object::Class::Syntax>

=item *

L<Data::Object::Code>

=item *

L<Data::Object::Float>

=item *

L<Data::Object::Hash>

=item *

L<Data::Object::Integer>

=item *

L<Data::Object::Number>

=item *

L<Data::Object::Role>

=item *

L<Data::Object::Role::Syntax>

=item *

L<Data::Object::Regexp>

=item *

L<Data::Object::Scalar>

=item *

L<Data::Object::String>

=item *

L<Data::Object::Undef>

=item *

L<Data::Object::Universal>

=item *

L<Data::Object::Autobox>

=item *

L<Data::Object::Library>

=item *

L<Data::Object::Prototype>

=item *

L<Data::Object::Signatures>

=back

=cut

