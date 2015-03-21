# ABSTRACT: An Integer Object for Perl 5
package Data::Object::Integer;

use 5.010;

use Carp         'confess';
use Data::Object 'deduce_deep', 'detract_deep';
use Moo          'with';
use Scalar::Util 'blessed', 'looks_like_number';

map with($_), our @ROLES = qw(
    Data::Object::Role::Integer
    Data::Object::Role::Defined
    Data::Object::Role::Detract
    Data::Object::Role::Numeric
    Data::Object::Role::Output
);

use overload
    'bool'   => \&data,
    '""'     => \&data,
    '~~'     => \&data,
    fallback => 1,
;

# VERSION

sub new {
    my $class = shift;
    my $data  = shift;

    $data =~ s/^\+//; # not keen on this but ...

    $class = ref($class) || $class;
    unless (blessed($data) && $data->isa($class)) {
        confess 'Type Instantiation Error: Not an Integer'
            unless defined($data) && !ref($data)
            && looks_like_number($data);
    }

    return bless \$data, $class;
}

sub data {
    goto &detract;
}

sub detract {
    return detract_deep shift;
}

around 'downto' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'eq' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'gt' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'gte' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'lt' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'lte' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'ne' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'to' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

around 'upto' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return scalar deduce_deep $result;
};

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Integer;

    my $integer = Data::Object::Integer->new(9);

=head1 DESCRIPTION

Data::Object::Integer provides common methods for operating on Perl 5 integer
data. Integer methods work on data that meets the criteria for being an integer.
An integer holds and manipulates an arbitrary sequence of bytes, typically
representing numeric characters. Users of integers should be aware of the
methods that modify the integer itself as opposed to returning a new integer.
Unless stated, it may be safe to assume that the following methods copy, modify
and return new integers based on their function.

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object::Array>

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

L<Data::Object::Scalar>

=item *

L<Data::Object::String>

=item *

L<Data::Object::Undef>

=item *

L<Data::Object::Universal>

=item *

L<Data::Object::Autobox>

=back

=cut
