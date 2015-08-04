# A Generic Exception Object for Perl 5
package Data::Object::Exception;

use 5.010;

use overload (
    '""'     => 'to_string',
    '~~'     => 'to_string',
    fallback => 1,
);

use Data::Dumper ();
use Scalar::Util ();

use Data::Object::Class;

# VERSION

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

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Exception;

    my $exception = Data::Object::Exception->new;

    $exception->throw('Something went wrong.');

=head1 DESCRIPTION

Data::Object::Exception provides a functionality for creating, throwing,
catching, and introspecting generic exception objects.

=cut

=method catch

    $exception->catch;

The catch method returns true if the argument is the same type of object as the
invocant.

=cut

=method dump

    $exception->dump;

The dump method returns a stringified version of the exception object.

=cut

=method file

    $exception->file;

The file method returns the path to the file where the exception was thrown.

=cut

=method line

    $exception->line;

The line method returns the line number in the file where the exception was
thrown.

=cut

=method message

    $exception->message;

The message method returns the message associated with the exception.

=cut

=method object

    $exception->object;

The object method returns the object (or data) associated with the exception if
available.

=cut

=method package

    $exception->package;

The package method returns the package name where the exception was thrown.

=cut

=method subroutine

    $exception->subroutine;

The subroutine method returns the fully-qualified subroutine name where the
exception was thrown.

=cut

=method throw

    $exception->throw;

The throw method terminates the program using the core die keyword passing the
exception object as the only argument.

=cut

=method to_string

    $exception->to_string;

The to_string method returns an informatve description of the exception thrown.

=cut

