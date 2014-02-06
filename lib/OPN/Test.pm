#!/usr/bin/env perl

package OPN::Test;

use Test::More;
use Test::Exception;

use base 'Exporter';
our @EXPORT = (
    @Test::More::EXPORT,
    @Test::Exception::EXPORT,
);


=head1 NAME

OPN::Test - Opperschaap's Test class

=head1 SYNOPSIS

use OPN::Test;

ok
throws_ok
is_deeply
done_testing

=cut
