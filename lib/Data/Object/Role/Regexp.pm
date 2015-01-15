# ABSTRACT: A Regexp Object Role for Perl 5
package Data::Object::Role::Regexp;

use 5.010;
use Moo::Role;

use Data::Object::MatchResult;
use Data::Object::String;
use Carp 'croak';

# VERSION

sub match {
    my $self = shift;
    my $string = shift;

    my $matched = $string =~ $$self;
    return '' unless $matched;

    return Data::Object::MatchResult->new(string => $string,
                                          regexp => $self,
                                          _at_minus => [ @- ],
                                          _at_plus => [ @+ ],
                                          _captures_hashref => { %+ });
}

sub substitute {
    my($self, $string, $subst, $flags) = @_;

    if (defined $flags) {
        my $error = do {
            local $@;
            eval qq(\$string =~ s/\$\$self/\$subst/$flags);
            $@;
        };
        croak $error if $error;
    } else {
        $string =~ s/$$self/$subst/;
    }
    return Data::Object::String->new($string);
}

1;

=encoding utf8

=head1 SYNOPSIS

    use Data::Object::Role::Regexp;

=head1 DESCRIPTION

Data::Object::Role::Regexp provides functions for operating on Perl 5 regular
expressions.

=cut

=head1 SEE ALSO

=over 4

=item *

L<Object::Data>

=item *

L<Object::Data::Regexp>

=item *

L<Object::Data::String>

=back

=cut
