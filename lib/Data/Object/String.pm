# ABSTRACT: A String Object for Perl 5
package Data::Object::String;

use 5.10.0;

use Moo 'with';
use Scalar::Util 'blessed';
use Types::Standard 'Str';
use Data::Object 'deduce';

with 'Data::Object::Role::String';

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

    $class = ref($class) || $class;
    $data  = Str->($data)
        unless blessed($data) && $data->isa($class);

    return bless \$data, $class;
}

around 'append' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'camelcase' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'chomp' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'chop' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'concat' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'contains' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'hex' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'index' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'lc' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'lcfirst' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'length' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'lines' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'lowercase' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'replace' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'reverse' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'rindex' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'snakecase' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'split' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'strip' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'titlecase' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'trim' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'uc' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'ucfirst' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'uppercase' => sub {
    my ($orig, $self, @args) = @_;
    $$self = $self->$orig(@args);
    return $self;
};

around 'words' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

sub value {
    my $self = shift;
    return "${$self}";
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::String;

    my $string = Data::Object::String->new('abcedfghi');

=head1 DESCRIPTION

Data::Object::String provides common methods for operating on Perl 5 string
data.

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

=back

=cut
