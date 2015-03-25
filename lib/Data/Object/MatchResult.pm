package Data::Object::MatchResult;

use 5.010;

use Moo;
use Types::Standard qw(ArrayRef HashRef Maybe Str Int);

use overload 'bool' => sub() { 1 },
             '@{}' => '_arrayref';

has string => ( is => 'ro',
                isa => sub {
                    return 1 if ref($_[0]) && $_[0]->isa('Data::Object::String');
                    Str->($_[0]);
                },
                required => 1 );
has regexp => ( is => 'ro',
                isa => sub {
                    die "Not a Data::Object::Regexp" unless ref($_[0]) && $_[0]->isa('Data::Object::Regexp');
                },
                required => 1 );
has _at_minus => ( is => 'ro', isa => ArrayRef[Maybe[Int]], required => 1 );
has _at_plus => ( is => 'ro', isa => ArrayRef[Maybe[Int]], required => 1 );
has _captures => ( is => 'ro', isa => ArrayRef[Maybe[Str]], builder => '_build_captures', lazy => 1 );
has _captures_hashref => ( is => 'ro', isa => HashRef[Maybe[Str]] );
has matched => ( is => 'ro', isa => Str, builder => '_build_matched', lazy => 1 );
has prematch => ( is => 'ro', isa => Str, builder => '_build_prematch', lazy => 1 );
has postmatch => ( is => 'ro', isa => Str, builder => '_build_postmatch', lazy => 1 );

sub _build_captures {
    my $self = shift;
    my $string = $self->string;

    my @captures;
    my($at_plus, $at_minus) = ($self->_at_plus, $self->_at_minus);
    for (my $i = 1; $i < @$at_plus; $i++) {
        push @captures, substr($string, $at_minus->[$i], $at_plus->[$i] - $at_minus->[$i]);
    }
    return \@captures;
}

sub _build_matched {
    my $self = shift;
    my $string = $self->string;

    my($at_plus, $at_minus) = ($self->_at_plus, $self->_at_minus);
    return substr($string, $at_minus->[0], $at_plus->[0] - $at_minus->[0]);
}

sub _build_prematch {
    my $self = shift;
    my $string = $self->string;

    return substr($string, 0, $self->_at_minus->[0]);
}

sub _build_postmatch {
    my $self = shift;
    my $string = $self->string;

    return substr($string, $self->_at_plus->[0]);
}

sub _arrayref {
    my $self = shift;
    my @array = ( $self->matched, $self->capt );
    return \@array;
}

sub capt {
    my $self = shift;

    my $captures = $self->_captures;
    return @$captures;
}

sub capt_hash {
    my $self = shift;
    my $captures = $self->_captures_hashref;

    if (@_) {
        my $name = shift;
        return $captures->{$name};

    } else {
        return %$captures;
    }
}

sub capt_names {
    my $matches = shift->_captures_hashref;
    return keys %$matches;
}

sub begin {
    my($self, $idx) = @_;
    Int->($idx);
    return $self->_at_minus->[$idx];
}

sub end {
    my($self, $idx) = @_;
    Int->($idx);
    return $self->_at_plus->[$idx];
}

sub offset {
    my($self, $idx) = @_;
    Int->($idx);
    return ( $self->begin($idx), $self->end($idx) );
}

1;

=encoding utf8

=head1 NAME

Data::Object::MatchResult - Results of match() from Data::Object::Regexp

=head1 SYNOPSIS

    use Data::Object::Regexp;

    my $re = Data::Object::Regexp->new(qr(something to (match) against));
    my $result = $re->match('A string with something to match against');

    my @captures = $result->capt();    # ('match')
    my $dollar_one = $result->capt(0); # 'match'

=head1 DESCRIPTION

The return value from calling match() on a L<Data::Object::Regexp> is an
instance Data::Object::MatchResult.  It preserves the values of the regular
expression special variables so they can be inspected outside the scope of
the match operation.

Data::Object::MatchResult objects are not intended to be instantiated
directly, but only as the result of C<$regexp->match()>.

=cut

=method string

    # given qr((test))

    $re->match('this is a test')->string;  # 'this is a test'

Returns the string matched against the regular expression

=cut

=method matched

    # given qr(test \d)

    $re->match('test 1 2 3')->matched; # 'test 1'

Returns the portion of the string that matched the regular expression

=cut

=method prematch

    # given qr(test)

    $re->match('this is a test')->prematch; # 'this is a '

Returns the portion of the string before the regular expression matched.

=cut

=method postmatch

    # given qr(test)

    $re->match('testing 1 2 3')->postmatch; # 'ing 1 2 3'

Return the portion of the string after the regular expression matched.

=cut

=method regexp

Returns the L<Data::Object::Regexp> instance used to perform the match.

=cut

=method capt

    # given qr((test))

    $re->match('this is a test')->capt;    # the list ('test')

Returns the list of captured strings.  The 0th index in this list corresponds
to C<$1>.

=cut

=method capt_hash

    # given qr((?<string>test))

    $re->match('this is a test')->capt_hash;  # the list (string => 'test')
    $re->match('this is a test')->capt_hash('string');  # the string 'test'

Given no arguments, returns a hash of captured strings.  Given one string
argument, returns the requested named, captured string.

=cut

=method begin

    # given qr((test) (\d))

    $re->match('this is a test 1 2 3')->begin(0); # 10
    $re->match('this is a test 1 2 3')->begin(1); # 10
    $re->match('this is a test 1 2 3')->begin(2); # 15

Returns the offset into the string where the n-th capture matched.  An
argument of C<0> returns the offset of the entire matching string.  Any other
positive integer returns the offset of the n-th capture.  Corresponds to C<$-[$n]>

=cut

=method end

    # given qr((test) (\d))

    $re->match('this is a test 1 2 3')->end(0); # 16
    $re->match('this is a test 1 2 3')->end(1); # 14
    $re->match('this is a test 1 2 3')->end(2); # 16

Returns the offset into the string where the n-th capture stopped matching.
An argument of C<0> returns the offset of the entire matching string.  Any
other positive integer returns the offset of the n-th capture.  Corresponds
to C<$+[$n]>

=cut

=method offset

    # given qr((test) (\d))

    $re->match('this is a test 1 2 3')->offset(0); # (10, 16)
    $re->match('this is a test 1 2 3')->offset(1); # (10, 14)
    $re->match('this is a test 1 2 3')->offset(2); # (15, 16)

Returns a 2-element list comtaining the start and end offset into the string
where the n-th capture matched.  An argument of C<0> returns the offsets for
the entire matching string.  Any other positive integer returns the offsets
for the n-th capture.  Corresponds to C<($-[$n], $+[$n])>

=cut

=head1 Overloading

This class implements overloading so the object can be used as an arrayref.

    # given qr((test) (\d))

    $re->match('this is a test 1 2 3')->[0]; # 'test 1'
    $re->match('this is a test 1 2 3')->[1]; # 'test'
    $re->match('this is a test 1 2 3')->[2]; # '1'

The 0th index return the same value as the C<matched()> method.  The 1st
index corresponds to C<$1>.

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object>

=item *

L<Data::Object::Regexp>

=item *

L<Data::Object::String>

=back

=cut
