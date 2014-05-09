#! perl

require Test::More;
require Test::Exception;

use OPN::Test;

my @expect = (@Test::More::EXPORT, @Test::Exception::EXPORT);
my @is = @OPN::Test::EXPORT;

Test::More::is_deeply(\@is, \@expect, '@EXPORT is set correctly [Test::More]');
OPN::Test::is_deeply(\@is, \@expect, '@EXPORT is set correctly [OPN::Test]');

done_testing();
