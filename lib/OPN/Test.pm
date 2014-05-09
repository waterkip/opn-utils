#!/usr/bin/env perl

package OPN::Test;

use Test::More;
use Test::Exception;
use Test::NoWarnings ();
use Test::Builder::Module;

use base 'Test::Builder::Module';
my $tb = __PACKAGE__->builder;

our @EXPORT = (
    @Test::More::EXPORT,
    @Test::Exception::EXPORT
);

sub import {
    warnings->import();
    strict->import();
    Test::NoWarnings->import();
    goto &Test::Builder::Module::import;
}

sub done_testing {
    Test::NoWarnings::had_no_warnings();
    $Test::NoWarnings::do_end_test = 0;
    $tb->done_testing(@_);
}

1;

__END__

=head1 NAME

OPN::Test - Opperschaap's Test class

=head1 SYNOPSIS

    use OPN::Test;

    my $ok = foo();
    ok($ok, "Foo says it is ok");
    throws_ok(
        sub {
            die "fubar";
        },
        qr/fubar/,
        "O no!"
    );

    done_testing;

=head1 EXPORTS

We export everything L<Test::Exception> and L<Test::More> exports

=over

=item * ok

=item * throws_ok

=item * is_deeply

=item * done_testing

=back

