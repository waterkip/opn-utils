package OPN::Exception;

use base 'Exporter';
our @EXPORT_OK = qw(
    throw
);

our %EXPORT_TAGS = (
    all => [@EXPORT_OK],
);

=head1 NAME

OPN::Exception - Opperschaap's Exception class

=head1 SYNOPSIS

use OPN::Exception qw(:all); 

# or 

use OPN::Exception qw(throw);

throw(message => "my error message");

# or

throw(
    class   => 'Some/Class',
    message => "my Error message",
    object  => $object
);

=head1 DESCRIPTION

=head1 METHODS

=head2 throw(%args);

=head3 Arguments

=head3 Returns

Exception

B<Options in order>

=over 4

=item type [optional]

Type: String
Default: We try to figure out the caller.

=item message [required]

Type: String

A human readable error message, containing more descriptive information about
this single error

=item object [optional]

Type: Any

=back

=cut

sub throw {
    my $args = {@_};

    if (!$args->{class}) {
        my $caller = (caller(1))[3];
        $caller =~ s#::#/#g;
        $args->{class} = $caller;
    }

    return OPN::Exception::Base->throw($args);
}

package OPN::Exception::Base;
use Moose;

use Data::Dumper;

extends 'Throwable::Error';

has 'class'  => (is => 'ro');
has 'object' => (is => 'ro');

sub trace_frames {
    my $self = shift;
    return map { $_->as_string } $self->stack_trace->frames;
}

sub as_string {
    my $self = shift;
    my $msg = sprintf("%s: %s", $self->class, $self->message);
    if ($self->object) {
        {
            local $Data::Dumper::Indent     = 0;
            local $Data::Dumper::Varname    = "";
            local $Data::Dumper::Terse      = 1;
            local $Data::Dumper::Quotekeys  = 0;
            local $Data::Dumper::Sparseseen = 1;
            $msg = sprintf("$msg %s", Dumper $self->object);
        }
    }
    return $msg;
}

1;
