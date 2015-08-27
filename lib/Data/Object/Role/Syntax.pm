# ABSTRACT: Role Declaration DSL for Perl 5
package Data::Object::Role::Syntax;

use strict;
use warnings;

use 5.014;

use Type::Tiny;
use Type::Tiny::Signatures;

use Sub::Quote;

use parent 'Exporter';

# VERSION

our @EXPORT = qw(
    alt
    builder
    clearer
    coerce
    def
    default
    defaulter
    handles
    init_arg
    is
    isa
    lazy
    opt
    optional
    predicate
    reader
    req
    required
    ro
    rw
    trigger
    weak_ref
    writer
);

sub import {
    my $class  = $_[0];
    my $target = caller;

    if (my $orig = $target->can('has')) {

        no strict 'refs';
        no warnings 'redefine';

        my $has = *{"${target}::has"} = sub {
            my ($name, @props) = @_;

            return $orig->($name, @props)
                if @props % 2 != 0;

            my $alt = $name =~ s/^\+//;

            my %codes = (
                builder   => 'build',
                clearer   => 'clear',
                predicate => 'has',
                reader    => 'get',
                trigger   => 'trigger',
                writer    => 'set',
            );

            my %props = @props;
            for my $code (sort keys %codes) {
                if ($props{$code} and $props{$code} eq "1") {
                    my $id = $codes{$code};
                    $props{$code} = "_${id}_${name}";
                    $props{$code} =~ s/_${id}__/_${id}_/;
                }
            }

            if (my $method = delete $props{defaulter}) {
                if ($method eq "1") {
                    $method = "_default_${name}";
                    $method =~ s/_default__/_default_/;
                }
                my $routine = q{ $target->$method(@_) };
                $props{default} = Sub::Quote::quote_sub($routine, {
                    '$target' => \$target,
                    '$method' => \$method,
                });
            }

            return $orig->($alt ? "+$name" : $name, %props);
        };

    }

    return $class->export_to_level(1, @_);
}

sub alt ($@) {
    my ($name, @props) = @_;
    if (my $has = caller->can('has')) {
        my @name = ref $name ? @$name : $name;
        @_ = ((map "+$_", @name), @props) and goto $has;
    }
}

sub builder (;$) {
    return builder => $_[0] // 1;
}

sub clearer (;$) {
    return clearer => $_[0] // 1;
}

sub coerce () {
    return coerce => 1;
}

sub def ($$@) {
    my ($name, $code, @props) = @_;
    @_ = ($name, 'default', $code, @props) and goto &alt;
}

sub default ($) {
    return default => $_[0];
}

sub defaulter (;$) {
    return defaulter => $_[0] // 1;
}

sub handles ($) {
    return handles => $_[0];
}

sub init_arg ($) {
    return init_arg => $_[0];
}

sub is (@) {
    return (@_);
}

sub isa ($) {
    return isa => $_[0];
}

sub lazy () {
    return lazy => 1;
}

sub opt ($;$@) {
    my ($name, $type, @props) = @_;
    my @req = (required => 0);
    @_ = ($name, ref($type) ? isa($type) : (), @props, @req)
        and goto &alt;
}

sub optional (@) {
    return required => 0, @_;
}

sub predicate (;$) {
    return predicate => $_[0] // 1;
}

sub reader (;$) {
    return reader => $_[0] // 1;
}

sub req ($;$@) {
    my ($name, $type, @props) = @_;
    my @req = (required => 1);
    @_ = ($name, ref($type) ? isa($type) : (), @props, @req)
        and goto &alt;
}

sub required (@) {
    return required => 1, @_;
}

sub ro () {
    return is => 'ro';
}

sub rw () {
    return is => 'rw';
}

sub trigger (;$) {
    return trigger => $_[0] // 1;
}

sub weak_ref () {
    return weak_ref => 1;
}

sub writer (;$) {
    return writer => $_[0] // 1;
}

1;

=encoding utf8

=head1 SYNOPSIS

    package Persona;

    use namespace::autoclean;

    use Data::Object::Role;
    use Data::Object::Role::Syntax;
    use Data::Object::Library ':types';

   # ATTRIBUTES

    has firstname  => ro;
    has lastname   => ro;
    has address1   => rw;
    has address2   => rw;
    has city       => rw;
    has state      => rw;
    has zip        => rw;
    has telephone  => rw;
    has occupation => rw;

    # CONSTRAINTS

    req firstname  => Str;
    req lastname   => Str;
    req address1   => Str;
    opt address2   => Str;
    req city       => Str;
    req state      => StrMatch[qr/^[A-Z]{2}$/];
    req zip        => Int;
    opt telephone  => StrMatch[qr/^\d{10,30}$/];
    opt occupation => Str;

    # DEFAULTS

    def occupation => 'Unassigned';
    def city       => 'San Franscisco';
    def state      => 'CA';

    1;

=head1 DESCRIPTION

Data::Object::Role::Syntax exports a collection of functions that provide a DSL
(syntactic sugar) for declaring and describing Data::Object::Role roles. It is
highly recommended that you also use the L<namespace::autoclean> library to
automatically cleanup the functions exported by this library and avoid method
name collisions.

=cut

=function alt

    alt attr => (is => 'ro');

    # equivalent to

    has '+attr' => (..., is => 'ro');

The alt function alters the preexisting attribute definition for the attribute
specified.

=cut

=function builder

    builder;
    builder '_build_attr';

    # equivalent to

    has attr => ..., builder => '_build_attr';

The builder function returns a list suitable for configuring the builder
portion of the attribute declaration.

=cut

=function clearer

    clearer;
    clearer '_clear_attr';

    # equivalent to

    has attr => ..., clearer => '_clean_attr';

The clearer function returns a list suitable for configuring the clearer
portion of the attribute declaration.

=cut

=function coerce

    coerce;

    # equivalent to

    has attr => ..., coerce => 1;

The coerce function return a list suitable for configuring the coerce portion
of the attribute declaration.

=cut

=function def

    def attr => sub { 1 };

    # equivalent to

    has '+attr' => (..., default => sub { 1 });

The def function alters the preexisting attribute definition setting and/or
overriding the default value property.

=cut

=function default

    default sub { ... };

    # equivalent to

    has attr => ..., default => sub { ... };

The default function returns a list suitable for configuring the default
portion of the attribute declaration.

=cut

=function defaulter

    defaulter;
    defaulter '_default_attr';

    # equivalent to

    has attr => ..., default => sub { $class->_default_attr(...) };

The defaulter function returns a list suitable for configuring the default
portion of the attribute declaration. The argument must be the name of an
existing routine available to the class.

=cut

=function handles

    handles { ... };

    # equivalent to

    has attr => ..., handles => { ... };

The handles function returns a list suitable for configuring the handles
portion of the attribute declaration.

=cut

=function init_arg

    init_arg;
    init_arg 'altattr';

    # equivalent to

    has attr => ..., init_arg => 'altattr';

The init_arg function returns a list suitable for configuring the init_arg
portion of the attribute declaration.

=cut

=function is

    is;

The is function returns a list from a list, and acts merely as a pass-through, 
for the purpose of being a visual/descriptive aid.

=cut

=function isa

    isa sub { ... };

    # equivalent to

    has attr => ..., isa => sub { ... };

The isa function returns a list suitable for configuring the isa portion of the
attribute declaration.

=cut

=function lazy

    lazy;

    # equivalent to

    has attr => ..., lazy => 1;

The lazy function returns a list suitable for configuring the lazy portion of
the attribute declaration.

=cut

=function opt

    opt attr => sub { ... };

    # equivalent to

    has '+attr' => ..., required => 0, isa => sub { ... };

The opt function alters the preexisting attribute definition for the attribute
specified using a list suitable for configuring the required and isa portions
of the attribute declaration.

=cut

=function optional

    optional;

    # equivalent to

    has attr => ..., required => 0;

The optional function returns a list suitable for configuring the required
portion of the attribute declaration.

=cut

=function predicate

    predicate;
    predicate '_has_attr';

    # equivalent to

    has attr => ..., predicate => '_has_attr';

The predicate function returns a list suitable for configuring the predicate
portion of the attribute declaration.

=cut

=function reader

    reader;
    reader '_get_attr';

    # equivalent to

    has attr => ..., reader => '_get_attr';

The reader function returns a list suitable for configuring the reader portion
of the attribute declaration.

=cut

=function req

    req attr => sub { ... };

    # equivalent to

    has '+attr' => ..., required => 1, isa => sub { ... };

The req function alters the preexisting attribute definition for the attribute
specified using a list suitable for configuring the required and isa portions
of the attribute declaration.

=cut

=function required

    required;

    # equivalent to

    has attr => ..., required => 1;

The required function returns a list suitable for configuring the required
portion of the attribute declaration.

=cut

=function ro

    ro;

    # equivalent to

    has attr => ..., is => 'ro';

The ro function returns a list suitable for configuring the is portion of the
attribute declaration.

=cut

=function rw

    rw;

    # equivalent to

    has attr => ..., is => 'rw';

The rw function returns a list suitable for configuring the rw portion of the
attribute declaration.

=cut

=function trigger

    trigger;
    trigger '_trigger_attr';

    # equivalent to

    has attr => ..., trigger => '_trigger_attr';

The trigger function returns a list suitable for configuring the trigger
portion of the attribute declaration.

=cut

=function weak_ref

    weak_ref;

    # equivalent to

    has attr => ..., weak_ref => 1;

The weak_ref function returns a list suitable for configuring the weak_ref
portion of the attribute declaration.

=cut

=function writer

    writer;
    writer '_set_attr';

    # equivalent to

    has attr => ..., writer => '_set_attr';

The writer function returns a list suitable for configuring the writer portion
of the attribute declaration.

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

L<Data::Object::Signatures>

=back

=cut
