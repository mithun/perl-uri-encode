#!perl

####################
# LOAD CORE MODULES
####################
use strict;
use warnings FATAL => 'all';
use Encode qw();
use Test::More tests => 10;

BEGIN { use_ok( "URI::Encode", qw(uri_encode uri_decode) ); }

# Define URI's
my $url =
    "http://mithun.aÿachit.com/my pages.html?name=m!thun&Yours=w%hat?#";
my $encoded =
    "http://mithun.a%C3%83%C2%BFachit.com/my%20pages.html?name=m!thun&Yours=w%hat?#";
my $encoded_reserved =
    "http%3A%2F%2Fmithun.a%C3%83%C2%BFachit.com%2Fmy%20pages.html%3Fname%3Dm%21thun%26Yours%3Dw%25hat%3F%23";

# Test OOP
my $uri = new_ok("URI::Encode");
can_ok( $uri, qw(encode decode) );
ok( $uri->encode($url) eq $encoded );
ok( $uri->encode( $url, { encode_reserved => 1, } ) eq $encoded_reserved );
ok( Encode::decode( 'utf-8-strict', $uri->decode($encoded) ) eq $url );

## Test Methods
can_ok( "URI::Encode", qw(uri_encode uri_decode) );
ok( uri_encode($url) eq $encoded );
ok( uri_encode( $url, 1 ) eq $encoded_reserved );
ok( Encode::decode( 'utf-8-strict', uri_decode($encoded) ) eq $url );
