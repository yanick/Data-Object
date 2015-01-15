# ABSTRACT: A Regexp Object for Perl 5
package Data::Object::Regexp;

use 5.010;

use Moo 'with';
use Scalar::Util 'blessed';
use Types::Standard 'RegexpRef';

use Data::Object 'detract';

with 'Data::Object::Role::Regexp';
with 'Data::Object::Role::Defined';
with 'Data::Object::Role::Detract';
with 'Data::Object::Role::Output';
with 'Data::Object::Role::Ref';

# VERSION

sub new {
    my $class = shift;
    my $data  = shift;

    $class = ref($class) || $class;

    unless (ref $data) {
        return $class->new(qr($data));
    }

    unless (blessed($data) && $data->isa($class)) {
        $data = RegexpRef->($data);
    }

    return bless \$data, $class;
}

sub data {
    goto &detract;
}

1;

=encoding utf8

=head1 NAME

Data::Object::Regexp - An object representing a Perl5 regular expression

=head1 SYNOPSIS

    use Data::Object::Regexp;

    my $re = Data::Object::Regexp->new(qr(something to match against));

=head1 DESCRIPTION

Data::Object::Regexp provides common methods for operating on Perl 5 regular
expressions. Regexp methods work on data that meets the criteria for being a regular
expression.

=head1 CONSTRUCTOR

The constructor accepts a single argument which can either be a string
representing a regular expression or a precompiled regex created from C<qr()>.

=cut

=method match

    # given qr((test))

    $re->match('this is a test'); # a Data::Object::MatchResult instance
    $re->match('this does not match'); # undef

The match method performs a regular expression match against the given string.
If the match is successful, it returns an instance of
L<Data::Object::MatchResult>.  On an unsuccessful match, it returns a false
value.

=cut

=method substitute

    # given qr(test)

    $re->substitute('this is a test', 'drill'); # 'this is a test'
    $re->substitute('test 1 test 2 test 3', 'drill', 'g'); # 'drill 1 drill 2 drill 3'

Perform a regular expression substitution on the given string or
L<Data::Object::String>.  The first argument is the string to match against.
The second argument is the replacement string.

The optional third argument are flags to append to the s///x operator, such
as 'g' or 'e'.

Returns a L<Data::Object::String> instance with the result of the substution.

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object>

=item *

L<Data::Object::MatchResult>

=item *

L<Data::Object::String>

=back
