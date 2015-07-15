# ABSTRACT: A Regexp Result Object for Perl 5
package Data::Object::Regexp::Result;

use 5.010;
use Data::Object::Class;

use Data::Object 'deduce_deep';

extends 'Data::Object::Array';

# VERSION

sub captures {
    my $self   = shift;
    my $string = $self->initial;

    my $last_match_start = $self->last_match_start;
    my $last_match_end   = $self->last_match_end;

    my @captures;

    for (my $i = 1; $i < @$last_match_end; $i++) {
        my $start = $last_match_start->[$i] || 0;
        my $end   = $last_match_end->[$i]   || 0;

        push @captures, substr "$string", $start, $end - $start;
    }

    return deduce_deep [@captures];
}

sub count {
    my $self = shift;
    return deduce_deep $self->[2];
}

sub initial {
    my $self = shift;
    return deduce_deep $self->[6];
}

sub last_match_end {
    my $self = shift;
    return deduce_deep $self->[4];
}

sub last_match_start {
    my $self = shift;
    return deduce_deep $self->[3];
}

sub named_captures {
    my $self = shift;
    return deduce_deep $self->[5];
}

sub matched {
    my $self   = shift;
    my $string = $self->initial;

    my $last_match_start = $self->last_match_start;
    my $last_match_end   = $self->last_match_end;

    my $start = $last_match_start->[0] || 0;
    my $end   = $last_match_end->[0]   || 0;

    return deduce_deep substr "$string", $start, $end - $start;
}

sub prematched {
    my $self   = shift;
    my $string = $self->initial;

    my $last_match_start = $self->last_match_start;
    my $last_match_end   = $self->last_match_end;

    my $start = $last_match_start->[0] || 0;
    my $end   = $last_match_end->[0]   || 0;

    return deduce_deep substr "$string", 0, $start;
}

sub postmatched {
    my $self   = shift;
    my $string = $self->initial;

    my $last_match_start = $self->last_match_start;
    my $last_match_end   = $self->last_match_end;

    my $start = $last_match_start->[0] || 0;
    my $end   = $last_match_end->[0]   || 0;

    return deduce_deep substr "$string", $end;
}

sub regexp {
    my $self = shift;
    return deduce_deep $self->[0];
}

sub string {
    my $self = shift;
    return deduce_deep $self->[1];
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Regexp::Result;

    my $result = Data::Object::Regexp::Result->new([
        $regexp,
        $altered_string,
        $count,
        $last_match_end,
        $last_match_start,
        $named_captures,
        $initial_string
    ]);

=head1 DESCRIPTION

Data::Object::Regexp::Result provides common methods for introspecting the
results of an operation involving a regular expressions. These methods work on
data whose shape conforms to the tuple defined in the synopsis.

=cut

=head1 COMPOSITION

This class inherits all functionality from the L<Data::Object::Array>
class and implements additional methods as documented herewith.

=cut

=method captures

    # given the expression qr/(.* test)/
    # given the string "example test matching"

    $result->captures; # ['example test']

The captures method returns the capture groups from the result object which
contains information about the results of the regular expression operation.

=cut

=method count

    # given the expression qr/.* test/
    # given the string "example test matching"

    $result->count; # 1

The count method returns the number of match occurrences from the result object
which contains information about the results of the regular expression
operation.

=cut

=method initial

    # given the expression qr/.* test/
    # given the string "example test matching"

    $result->replace($string, 'love', 'g');

    $result->string;  # 'love matching'
    $result->initial; # 'example test matching'

The initial method returns the unaltered string from the result object which
contains information about the results of the regular expression operation.

=cut

=method last_match_end

    # given the expression qr/(.* test)/
    # given the string "example test matching"

    $result->last_match_end;

The last_match_end method returns an array of offset positions into the string
where the capture(s) stopped matching from the result object which contains
information about the results of the regular expression operation.

=cut

=method last_match_start

    # given the expression qr/(.* test)/
    # given the string "example test matching"

    $result->last_match_start;

The last_match_start method returns an array of offset positions into the
string where the capture(s) matched from the result object which contains
information about the results of the regular expression operation.

=cut

=method named_captures

    # given the expression qr/(?<stuff>.* test)/
    # given the string "example test matching"

    $result->named_captures; # { stuff => "example test" }

The named_captures method returns a hash containing the requested named regular
expressions and captured string pairs from the result object which contains
information about the results of the regular expression operation.

=cut

=method matched

    # given the expression qr/.* test/
    # given the string "example test matching"

    $result->matched; # "example test"

The matched method returns the portion of the string that matched from the
result object which contains information about the results of the regular
expression operation.

=cut

=method prematched

    # given the expression qr/(test .*)/
    # given the string "example test matching"

    $result->prematched; # "example "

The prematched method returns the portion of the string before the regular
expression matched from the result object which contains information about the
results of the regular expression operation.

=cut

=method postmatched

    # given the expression qr/(.* test)/
    # given the string "example test matching"

    $result->postmatched; # " matching"

The postmatched method returns the portion of the string after the regular
expression matched from the result object which contains information about the
results of the regular expression operation.

=cut

=method regexp

    # given the expression qr/.* test/
    # given the string "example test matching"

    $result->regexp; # qr/.* test/

The regexp method returns the regular expression used to perform the match from
the result object which contains information about the results of the regular
expression operation.

=cut

=method string

    # given the expression qr/(.* test)/
    # given the string "example test matching"

    $result->string; # "example test matching"

The string method returns the string matched against the regular expression
from the result object which contains information about the results of the
regular expression operation.

=cut

=head1 SEE ALSO

=over 4

=item *

L<Data::Object::Role::Array>

=item *

L<Data::Object::Role::Code>

=item *

L<Data::Object::Role::Float>

=item *

L<Data::Object::Role::Hash>

=item *

L<Data::Object::Role::Integer>

=item *

L<Data::Object::Role::Number>

=item *

L<Data::Object::Role::Regexp>

=item *

L<Data::Object::Role::Scalar>

=item *

L<Data::Object::Role::String>

=item *

L<Data::Object::Role::Undef>

=item *

L<Data::Object::Role::Universal>

=item *

L<Data::Object::Autobox>

=item *

L<Data::Object::Library>

=item *

L<Data::Object::Signatures>

=back

=cut
