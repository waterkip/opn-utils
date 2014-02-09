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

This class exposes the methods from Test::More and Test::Exception so you don't have to worry about which package to use. Just use this one.

=cut
