# ABSTRACT: A Code Object for Perl 5
package Data::Object::Code;

use 5.10.0;

use Moo 'with';
use Scalar::Util 'blessed';
use Types::Standard 'CodeRef';
use Data::Object 'deduce';

with 'Data::Object::Role::Code';

# VERSION

sub new {
    my $class = shift;
    my $data  = shift;

    $class = ref($class) || $class;
    $data  = CodeRef->($data)
        unless blessed($data) && $data->isa($class);

    return bless $data, $class;
}

around 'call' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'compose' => sub {
    my ($orig, $self, @args) = @_;
    my $next = deduce shift @args;
    my $result = $self->$orig($next, @args);
    return deduce $result;
};

around 'conjoin' => sub {
    my ($orig, $self, @args) = @_;
    my $next = deduce shift @args;
    my $result = $self->$orig($next, @args);
    return deduce $result;
};

around 'curry' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'disjoin' => sub {
    my ($orig, $self, @args) = @_;
    my $next = deduce shift @args;
    my $result = $self->$orig($next, @args);
    return deduce $result;
};

around 'next' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

around 'rcurry' => sub {
    my ($orig, $self, @args) = @_;
    my $result = $self->$orig(@args);
    return deduce $result;
};

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Code;

    my $code = Data::Object::Code->new(sub { shift + 1 });

=head1 DESCRIPTION

Data::Object::Code provides common methods for operating on Perl 5 code
references.

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
