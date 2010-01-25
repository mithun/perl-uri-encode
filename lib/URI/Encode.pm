package URI::Encode;

use warnings;
use strict;
use Carp;
use Encode qw();

our $VERSION = 0.01;

## Exporter
use base qw(Exporter);
our @EXPORT_OK = qw(uri_encode uri_decode);

## OOP Intrerface

# Constructor
sub new {
    my $class = shift;
    my $self = bless {}, $class;
    return $self;
}

# Encode
sub encode {
    my ( $self, $url, $encode_reserved ) = @_;
    return unless $url;

    # Encode URL into UTF-8
    $url = Encode::encode( 'utf-8-strict', $url );

    # Create character map
    my %map = map { chr($_) => sprintf( "%%%02X", $_ ) } ( 0 ... 255 );

    # Create Regex
    my $reserved =
      qr{([^a-zA-Z0-9\-\_\.\~\!\*\'\(\)\;\:\@\&\=\+\$\,\/\?\%\#\[\]])}x;
    my $unreserved = qr{([^a-zA-Z0-9\Q-_.~\E])}x;

    # Percent Encode URL
    if ($encode_reserved) {
        $url =~ s/$unreserved/$map{$1}/gx;
    }
    else {
        $url =~ s/$reserved/$map{$1}/gx;
    }

    return $url;
}

# Decode
sub decode {
    my ( $shift, $url ) = @_;
    return unless $url;

    # Character map
    my %map = map { sprintf( "%02X", $_ ) => chr($_) } ( 0 ... 255 );

    # Decode percent encoding
    $url =~ s/%([a-fA-F0-9]{2})/$map{$1}/gx;
    return $url;
}

## Traditional Interface

# Encode
sub uri_encode {
    my ( $url, $flag ) = @_;
    my $uri = URI::Encode->new();
    return $uri->encode( $url, $flag );
}

# Decode
sub uri_decode {
    my ($url) = @_;
    my $uri = URI::Encode->new();
    return $uri->decode($url);
}

## Done
1;
__END__

=pod

=head1 NAME

URI::Encode - Simple URI Encoding/Decoding

=head1 VERSION

This document describes URI::Encode version 0.0.1

=head1 SYNOPSIS

	## OO Interface
	use URI::Encode;
	my $uri = URI::Encode->new();
	my $encoded = $uri->encode($url);
	my $decoded = $uri->decode($encoded);

	## Using exported functions
	use URI::Encode qw(uri_encode uri_decode);
	my $encoded = uri_encode($url);
	my $decoded = uri_decode($url);
  
=head1 DESCRIPTION

This modules provides simple URI encoding/decoding.

=head1 METHODS

=over

=item new()

=item encode($url)

=item encode($url, $including_reserved)

=item decode($url)

=back

=head1 EXPORTED FUNCTIONS

=over

=item uri_encode($url)

=item uri_encode($url, $including_reserved)

=item uri_decode($url)

=back

=head1 DEPENDENCIES

L<Encode>

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-uri-encode@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=head1 AUTHOR

Mithun Ayachit  C<< <mithun@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Mithun Ayachit C<< <mithun@cpan.org> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.

=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
