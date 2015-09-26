# ABSTRACT: Type Object Role for Perl 5
package Data::Object::Role::Type;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Data::Object::Role;
use Data::Object::Library;
use Data::Object::Signatures;
use Scalar::Util;

# VERSION

my %METHODS;
my %ROLES;

method methods () {

    no strict 'refs';

    my $package = ref($self) || $self;

    if (exists $METHODS{$package}) {

        return [ sort @{$METHODS{$package}} ];

    }

    require Function::Parameters::Info;

    for my $method (keys %{ "${package}::" }) {

        my $config = Function::Parameters::info("${package}::${method}");

        push @{$METHODS{$package}}, $method if $config;

    }

    return [ sort @{$METHODS{$package}} ];

}

method roles () {

    no strict 'refs';

    my $package = ref($self) || $self;

    if (exists $ROLES{$package}) {

        return [ sort @{$ROLES{$package}} ];

    }

    my @list = ();

    for my $role (@{ "${package}::ROLES" }) {

        push @list, $role;

    }

    if ($package !~ /::Role/) {

        (my $role = $package) =~ s/Data::Object/Data::Object::Role/;

        my $roles = roles($role);

        push @list, @$roles if @$roles;

    }

    for my $role (@list) {

        my $roles = roles($role);

        push @list, @$roles if @$roles;

    }

    my %seen;

    @list = grep { not $seen{$_}++ } @list;

    return $ROLES{$package} = [sort @list];

}

method type () {

    return Data::Object::deduce_type($self);

}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Type;

=cut

=head1 DESCRIPTION

Data::Object::Role::Type provides routines for operating on Perl 5 data
objects which meet the criteria for being considered type objects.

=cut

=method methods

    # given $type

    $type->methods;

The methods method returns the list of methods attached to object. This method
returns an array value.

=cut

=method roles

    # given $type

    $type->roles;

The roles method returns the list of roles attached to object. This method
returns an array value.

=cut

=method type

    # given $type

    $type->type; # TYPE

The type method returns a string representing the internal data type object name.
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

