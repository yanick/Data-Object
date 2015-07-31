# A Generic Exception Object for Perl 5
package Data::Object::Exception;

use 5.010;

use Data::Dumper ();
use Scalar::Util ();

use Data::Object::Class;

# VERSION

use overload (
    '""'     => 'to_string',
    '~~'     => 'to_string',
    fallback => 1,
);

has file       => ( is => 'ro' );
has line       => ( is => 'ro' );
has message    => ( is => 'ro' );
has object     => ( is => 'ro' );
has package    => ( is => 'ro' );
has subroutine => ( is => 'ro' );

around BUILDARGS => sub {
    my $orig = shift;
    my $self = shift;

    unshift @_, (ref $_[0] ? 'object' : 'message') if @_ == 1;

    return $self->$orig(@_);
};

sub catch {
    my $invocant = shift;
    my $object   = shift;
    ! Scalar::Util::blessed($object)
    && UNIVERSAL::isa($object, $invocant);
}

sub dump {
    my $invocant = shift;
    local $Data::Dumper::Terse = 1;
    Data::Dumper::Dumper($invocant);
}

sub throw {
    my $invocant = shift;
    my $package  = ref $invocant || $invocant;
    unshift @_, (ref $_[0] ? 'object' : 'message') if @_ == 1;
    die $package->new(ref $invocant ? (%$invocant) : (), @_,
        file       => (caller(0))[1],
        line       => (caller(0))[2],
        package    => (caller(0))[0],
        subroutine => (caller(0))[3],
    );
}

sub to_string {
    my $self    = shift;
    my $class   = ref $self;
    my $file    = $self->file;
    my $line    = $self->line;
    my $default = $self->message;
    my $object  = $self->object;

    my $objref  = overload::StrVal $object if $object;
    my $message = $default || "An exception ($class) was thrown";
    my @with    = join " ", "with", $objref if $objref and not $default;

    return join(" ", $message, @with, "in $file at line $line") . "\n";
}

1;
