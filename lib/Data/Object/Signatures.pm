# ABSTRACT: Method and Function Signatures for Perl 5
package Data::Object::Signatures;

use 5.14.0;

use strict;
use warnings;

use Data::Object::Library;

use parent 'Type::Tiny::Signatures';

our @DEFAULTS = @Type::Tiny::Signatures::DEFAULTS = 'Data::Object::Library';

# VERSION

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Signatures;

=head1 DESCRIPTION

Data::Object::Signatures is a subclass of L<Type::Tiny::Signatures> and derives
its functionality to provide method and function signatures with support for
all the standard L<Type::Tiny> type constraints, as well as a few additional
type constraints provided by L<Data::Object::Library>.

=cut

