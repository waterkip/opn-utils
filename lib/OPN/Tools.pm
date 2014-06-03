package OPN::Tools;
use warnings;
use strict;
use autodie;
use v5.10;

use feature ();
use Data::Dump qw(dumpf);
use Devel::StackTrace;
use Exporter ();
use OPN::Exception;

our @EXPORT = (
    @OPN::Exception::EXPORT,

    qw(
        burp
        barf
    ),
);

sub import {
    warnings->import();
    strict->import();
    feature->import(':5.10');
    autodie->import(':all');

    OPN::Exception->import();

    goto &Exporter::import;
}

sub burp {
    my $msg = _generate_message(@_);

    return _log($msg);
}

sub barf {
    my $msg = _generate_message(@_);
    my $stack = Devel::StackTrace->new();

    return _log($msg, $stack->as_string());
}

sub _log {
    return join($/, @_)
        if (defined wantarray);

    warn(scalar(localtime), " ", join($/, @_), $/);
}

sub _generate_message {
    my $msg;

    if (@_ == 1 && ref($_[0])) {
        $msg = dumpf($_[0], \&_dump_filter);
    }
    else {
        # sprintf()'s prototype expects a scalar as the first argument, so we
        # have to split it out manually first.
        $msg = sprintf(shift, @_ || ());
    }

    return $msg;
}

sub _dump_filter {
    my ($ctx, $object_ref) = @_;

    if ($ctx->is_blessed && $object_ref->isa('DBIx::Class::Schema')) {
        my $storage = $object_ref->storage;
        return {
            dump => sprintf(
                "<%s database handle connected to %s>",
                $ctx->class,
                $storage
                    ? $storage->connect_info->[0]{dsn}
                    : 'nothing'
            ),
        };
    }

    return;
}

1;

__END__

=head1 NAME

OPN::Tools - Basic utility functions and imports for Opperschaap code

=head1 SYNOPSIS

    package OPN::Foo::Bar;
    use OPN::Tools;

    # We now have: warnings, strict, feature(:5.14), autodie
    # and everything else

=head2 _dump_filter

Filter for L<Data::Dumper::dumpf> that collapses known huge data structures
down to manageable size.

The following classes are made a bit easier on the eyes:

=over

=item * L<DBIx::Class::Schema>

=back

=head1 EXPORTED FUNCTIONS

=head2 burp

Print a warning.

This is smart about its arguments: if there is only one argument, and it's a
reference, L<Data::Dump::dump> is called on it. In other cases, it's passed to
sprintf().

This function is exported by default.

=head2 barf

Print a warning, like L<burp>, but include a stack trace.

This function is exported by default.

=head2 set_logger

Set the logger object that C<barf> and C<burp> use. This object should provide
a "debug" method.

By default, or when the logger is set to C<undef>, the built-in C<warn>
function will be used.

=head3 SYNOPSIS

    my $logger;

    sub set_logger {
        $logger = shift;
        return;
    }

=head1 INTERNAL FUNCTIONS

=head2 _log

Internal function that doest the actual logging. If called in void context,
the built-in C<warn> is used if no logger is set, and C<< $logger->debug() >>
if it is.

In other contexts (scalar, list), the value to be logged is returned instead.

=head2 _generate_message

Generate the "real" error message. If one argument is passed, and it's a
reference, L<Data::Dumper::dump()> will be called on it.

In all other cases, the argument(s) will be passed to C<sprintf>.

=head1 CONTRIBUTION

This code is taken from L<Zaaksysteem.nl|http://www.zaaksysteem.nl>, you can have a look at this code and more at 
L<their Bitbucket repository|https://bitbucket.org/mintlab/zaaksysteem>

=head1 COPYRIGHT and LICENSE

Copyright (c) 2009-2014, Mintlab B.V. and all the persons listed in the L<Zaaksysteem::CONTRIBUTORS> file.
Zaaksysteem uses the EUPL license, for more information please have a look at the L<Zaaksysteem::LICENSE> file.
