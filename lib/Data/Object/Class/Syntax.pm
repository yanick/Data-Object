# DSL for Declaring Data::Object Classes for Perl 5
package Data::Object::Class::Syntax;

use 5.010;
use strict;
use warnings;
use parent 'Exporter';

# VERSION

our @EXPORT = qw(
    builder
    clearer
    coerce
    default
    handles
    init_arg
    is
    isa
    lazy
    optional
    predicate
    reader
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
        *{"${target}::has"} = sub {
            $DB::single=1;
            my ($name, @props) = @_;
            return $orig->($name, @props) if @props % 2 != 0;

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

            return $orig->($name, %props);
        };
    }

    return $class->export_to_level(1, @_);
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

sub default ($) {
    return default => $_[0];
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

sub optional (@) {
    return required => 0, @_;
}

sub predicate (;$) {
    return predicate => $_[0] // 1;
}

sub reader (;$) {
    return reader => $_[0] // 1;
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
