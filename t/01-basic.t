#!perl

####################
# LOAD CORE MODULES
####################
use strict;
use warnings FATAL => 'all';
use Encode qw();
use Test::More;

BEGIN { use_ok( "URI::Encode", qw(uri_encode uri_decode) ); }

# Define URI's
my $url
  = "http://mithun.aÿachit.com/my pages.html?name=m!thun&Yours=w%hat?#";
my $encoded
  = "http://mithun.a%C3%83%C2%BFachit.com/my%20pages.html?name=m!thun&Yours=w%25hat?#";
my $encoded_reserved
  = "http%3A%2F%2Fmithun.a%C3%83%C2%BFachit.com%2Fmy%20pages.html%3Fname%3Dm%21thun%26Yours%3Dw%25hat%3F%23";
my $double_test_in
  = 'This is a %20 test';
my $double_test_out
  = 'This%20is%20a%20%2520%20test';

# Test Init
my $uri = new_ok("URI::Encode");
can_ok( $uri, qw(encode decode) );

# Test OOP
is( $uri->encode($url), $encoded, 'OOP: Unreserved encoding' );
is( URI::Encode->new(
        encode_reserved => 1,
    )->encode($url),
    $encoded_reserved,
    'encode_reserved in non-HASH new() args'
);
is( URI::Encode->new(
        {
            encode_reserved => 1,
        },
    )->encode($url),
    $encoded_reserved,
    'encode_reserved in HASH new() args'
);
is(
    $uri->encode(
        $url, {
            encode_reserved => 1,
        }
    ),
    $encoded_reserved,
    'OOP: Reserved Encoding with HASH options'
);
is( $uri->encode( $url, 1 ),
    $encoded_reserved, 'OOP: Reserved Encoding with scalar option' );
is(
    $uri->encode(
        $encoded_reserved, {
            double_encode => 0,
        }
    ),
    $encoded_reserved,
    'OOP: Double encoding OFF'
);
is(
    URI::Encode->new(
        double_encode => 0,
    )->encode($encoded_reserved),
    $encoded_reserved,
    'OOP: Double encoding OFF (non-HASH new() arg)'
);
is(
    URI::Encode->new(
        {
            double_encode => 0,
        },
    )->encode($encoded_reserved),
    $encoded_reserved,
    'OOP: Double encoding OFF (HASH new() arg)'
);
is(
    $uri->encode(
        $double_test_in, {
            double_encode => 1,
        }
    ),
    $double_test_out,
    'OOP: Double encoding ON'
);
is(
    URI::Encode->new(
        double_encode => 1,
    )->encode($double_test_in),
    $double_test_out,
    'OOP: Double encoding ON (non-HASH new() arg)'
);
is(
    URI::Encode->new(
        {
            double_encode => 1,
        },
    )->encode($double_test_in),
    $double_test_out,
    'OOP: Double encoding ON (HASH new() arg)'
);
is( Encode::decode( 'utf-8-strict', $uri->decode($encoded) ),
    $url, 'OOP: Decoding' );

## Test Methods
can_ok( "URI::Encode", qw(uri_encode uri_decode) );
is( uri_encode($url), $encoded, 'Function: Unreserved encoding' );
is( uri_encode( $url, 1 ),
    $encoded_reserved, 'Function: Reserved encoding with scalar option' );
is(
    uri_encode(
        $url, {
            encode_reserved => 1,
        }
    ),
    $encoded_reserved,
    'Function: Reserved encoding with named option'
);
is(
    uri_encode(
        $encoded_reserved, {
            double_encode => 0,
        }
    ),
    $encoded_reserved,
    'Function: Double encoding OFF'
);
is( Encode::decode( 'utf-8-strict', uri_decode($encoded) ),
    $url, 'Function: Decoding' );
is( uri_encode('0'), '0', 'Encodes "0" input correctly');
is( scalar uri_encode(undef), undef, 'Encodes undef to undef (scalar context)');
is( scalar @{[ uri_encode(undef) ]}, 0, 'Encodes undef to empty list (list context)');
is( uri_decode('0'), '0', 'Decodes "0" input correctly');
is( scalar uri_decode(undef), undef, 'Decodes undef to undef (scalar context)');
is( scalar @{[ uri_decode(undef) ]}, 0, 'Decodes undef to empty list (list context)');

## Test Lowercase & Uppercase decode
is( $uri->decode('foo%2bbar'), 'foo+bar', 'Lower cased decoding' );
is( $uri->decode('foo%2Bbar'), 'foo+bar', 'Upper cased decoding' );

## Done
done_testing();
exit 0;
