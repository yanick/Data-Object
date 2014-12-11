# ABSTRACT: A Float Object for Perl 5
package Data::Object::Float;

use 5.10.0;

use Moo 'with';
use Scalar::Util 'blessed';
use Types::Standard 'Num';
use Data::Object 'deduce';

with 'Data::Object::Role::Float';
with 'Data::Object::Role::Type::Numeric';

use overload
    'bool'   => \&value,
    '""'     => \&value,
    '~~'     => \&value,
    fallback => 1,
;

# VERSION

sub new {
    my $class = shift;
    my $data  = shift;

    $data =~ s/^\+//; # not keen on this but ...

    $class = ref($class) || $class;
    $data  = Num->($data)
        unless blessed($data) && $data->isa($class);

    return bless \$data, $class;
}

around 'downto' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'eq' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'gt' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'gte' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'lt' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'lte' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'ne' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'to' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'upto' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

sub value {
    my $self = shift;
    return 0+${$self};
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Float;

    my $float = Data::Object::Float->new(9.9999);

=head1 DESCRIPTION

Data::Object::Float provides common methods for operating on Perl 5
floating-point data. Float methods work on data that meets the criteria for
being a floating-point number. A float holds and manipulates an arbitrary
sequence of bytes, typically representing numberic characters with decimals.
Users of floats should be aware of the methods that modify the float itself as
opposed to returning a new float. Unless stated, it may be safe to assume that
the following methods copy, modify and return new floats based on their
function.

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
