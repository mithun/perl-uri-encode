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

# Test Init
my $uri = new_ok("URI::Encode");
can_ok( $uri, qw(encode decode) );

# Test OOP
is( $uri->encode($url), $encoded, 'OOP: Unreserved encoding' );
is( $uri->encode( $url, { encode_reserved => 1, } ),
    $encoded_reserved, 'OOP: Reserved Encoding with HASH options' );
is( $uri->encode( $url, 1 ),
    $encoded_reserved, 'OOP: Reserved Encoding with scalar option' );
is( $uri->encode( $encoded_reserved, { double_encode => 0, } ),
    $encoded_reserved, 'OOP: Double encoding' );
is( Encode::decode( 'utf-8-strict', $uri->decode($encoded) ),
    $url, 'OOP: Decoding' );

## Test Methods
can_ok( "URI::Encode", qw(uri_encode uri_decode) );
is( uri_encode($url), $encoded, 'Function: Unreserved encoding' );
is( uri_encode( $url, 1 ),
    $encoded_reserved, 'Function: Reserved encoding with scalar option' );
is( uri_encode( $url, { encode_reserved => 1, } ),
    $encoded_reserved, 'Function: Reserved encoding with scalar option' );
is( uri_encode( $encoded_reserved, { double_encoding => 0, } ),
    $encoded_reserved, 'Function: Double encoding' );
is( Encode::decode( 'utf-8-strict', uri_decode($encoded) ),
    $url, 'Function: Decoding' );

## Done
done_testing();
exit 0;
