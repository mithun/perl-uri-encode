#!/usr/bin/perl

####################
# LOAD CORE MODULES
####################
use strict;
use warnings FATAL => 'all';

# Autoflush ON
local $| = 1;

####################
# LOAD MODULES
####################
use URI::Encode;
use URI::Escape qw();
use URI::Escape::XS qw();
use Benchmark qw(cmpthese);

####################
# SETTINGS
####################

my $num_of_iters = '1000000';
my $url          = 'http://www.google.com/search?q=Ingy dÃffÃ,Â¶t Net';

# Objects
my $obj_uri_encode = URI::Encode->new();

# Reserved characters
my $reserved_re = "^a-zA-Z0-9\-\_\.\~\!\*\'\(\)\;\:\@\&\=\+\$\,\/\?\%\#\[\]";

print "Encoding URL: $url\n";
print "Using URI::Escape ($URI::Escape::VERSION)\t-> "
  . URI::Escape::uri_escape_utf8( $url, $reserved_re ) . "\n";
print "Using URI::Escape::XS ($URI::Escape::XS::VERSION)\t-> "
  . URI::Escape::XS::uri_escape( $url, $reserved_re ) . "\n";
print "Using URI::Encode ($URI::Encode::VERSION)\t-> "
  . $obj_uri_encode->encode($url) . "\n";

####################
# RUN BENCH
####################
print "\n\nBenchmarking $num_of_iters iterations on Perl $] ($^O)\n\n";

cmpthese(
    $num_of_iters, {
        'URI::Escape' => sub {
            URI::Escape::uri_escape_utf8( $url, $reserved_re );
        },
        'URI::Escape::XS' => sub {
            URI::Escape::XS::uri_escape( $url, $reserved_re );
        },
        'URI::Encode' => sub { $obj_uri_encode->encode($url) },
    }
);

print "\n";

####################
# DONE
####################
exit 0;

__END__

=pod

Sample script output

    Encoding URL: http://www.google.com/search?q=Ingy dÃffÃ,Â¶t Net
    Using URI::Escape (3.31)    -> http://www.google.com/search?q=Ingy dÃffÃ,fÃf,Ã,Â¶t Net
    Using URI::Escape::XS (0.08)-> http://www.google.com/search?q=Ingy dÃffÃ,Â¶t Net
    Using URI::Encode (0.06)    -> http://www.google.com/search?q=Ingy%20d%C3%83%C2%B6t%20Net


    Benchmarking 1000000 iterations on Perl 5.012003 (darwin)

                        Rate     URI::Encode     URI::Escape URI::Escape::XS
    URI::Encode      61237/s              --            -87%            -91%
    URI::Escape     473934/s            674%              --            -29%
    URI::Escape::XS 671141/s            996%             42%              --

=cut
