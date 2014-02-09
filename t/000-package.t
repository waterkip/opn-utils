#! perl
#
use Test::Package;
use warnings;
use strict;

all_package_files_ok(skip => { 'pm' => 1});
