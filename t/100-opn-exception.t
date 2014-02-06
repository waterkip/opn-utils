#!/usr/bin/env perl

use OPN::Test;

{
    note("OPN::Exception");

    use OPN::Exception qw(:all);

    throws_ok(
        sub {
            throw(message => "Some error");
        },
        qr#Test/Exception/throws_ok: Some error#,
        "Caller is correct"
    );

    throws_ok(
        sub {
            throw(
                class   => "My/Class",
                message => "Some error");
        },
        qr#My/Class: Some error#,
        "Caller is correct"
    );

    my $object = bless({x=>'x'}, "Some object");
    ok($object, "We have an object");
    throws_ok(
        sub {
            throw(
                message => "Some error",
                object  => $object,
            );
        },
        qr#bless\( {x => 'x'}, 'Some object' \)#,
        "Found the object as well",
    );
}

done_testing();
