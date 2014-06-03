use OPN::Test;
use OPN::Tools;

my $msg = OPN::Tools::_generate_message("Meuk");
is($msg, "Meuk", "Correct message");

done_testing();
