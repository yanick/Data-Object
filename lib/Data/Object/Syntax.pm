# ABSTRACT: Object Syntax DSL for Perl 5
package Data::Object::Syntax;

use strict;
use warnings;

use 5.014;

use Data::Object;
use Scalar::Util;
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

    unless ($target->can('BUILD')) {
        no strict 'refs';
        no warnings 'redefine';

        *{"${target}::BUILD"} = sub { shift };
    }

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
    @_ = ($name, ref($type) ? isa($type) : (), @props, @req) and goto &alt;

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
    @_ = ($name, ref($type) ? isa($type) : (), @props, @req) and goto &alt;

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

    use Data::Object::Syntax;

=cut

=head1 DESCRIPTION

Data::Object::Class::Syntax exports a collection of functions that provide a
DSL (syntactic sugar) for declaring and describing Data::Object::Class classes.
This package is used as a template for L<Data::Object::Class::Syntax> and
L<Data::Object::Role::Syntax>. It is highly recommended that you also use the
L<namespace::autoclean> library to automatically cleanup the functions exported
by this library and avoid method name collisions.

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

