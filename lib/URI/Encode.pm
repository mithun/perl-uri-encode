package URI::Encode;

# Modules used
use 5.008001;
use warnings;
use strict;
use Encode qw();

our $VERSION = 0.04;

## Exporter
use base qw(Exporter);
our @EXPORT_OK = qw(uri_encode uri_decode);

## OOP Intrerface

# Constructor
sub new {
    my $class = shift;
    my $self = bless { encode_reserved => 0, }, $class;
    return $self;
}

# Encode
sub encode {
    my ( $self, $url, $encode_reserved ) = @_;

    # Allow $url to be '0'
    return unless defined $url;

    # Use setting from object initialization if not provided for this call
    if ( not defined $encode_reserved ) {
        $encode_reserved = $self->{encode_reserved};
    }

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
} ## end sub encode

# Decode
sub decode {
    my ( $shift, $url ) = @_;

    # Allow $url to be '0'
    return unless defined $url;

    # Character map
    my %map = map { sprintf( "%02X", $_ ) => chr($_) } ( 0 ... 255 );

    # Decode percent encoding
    $url =~ s/%([a-fA-F0-9]{2})/$map{$1}/gx;
    return $url;
} ## end sub decode

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

This document describes URI::Encode version 0.04

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

This modules provides simple URI (Percent) encoding/decoding

The main purpose of this module (at least for me) was to provide an easy method
to encode strings (mainly URLs) into a format which can be pasted into a plain
text emails, and that those links are 'click-able' by the person reading that
email. This can be accomplished by NOT encoding the reserved characters.

If you are looking for speed and want to encode reserved characters, use
L<URI::Escape::XS>

=head1 METHODS

=head2 new()

Creates a new object, no arguments are required

	my $encoder = URI::Encode->new(\%options);

The following options can be passed to the constructor

=over

=item encode_reserved

	my $encoder = URI::Encode->new({encode_reserved => 0});

If true, L</"Reserved Characters"> are also encoded. Defaults to false.

=back

=head2 encode($url, $including_reserved)

This method encodes the URL provided. The method does not encode any
L</"Reserved Characters"> unless C<$including_reserved> is true or set in the
constructor. The $url provided is first converted into UTF-8 before percent
encoding.

	$uri->encode("http://perl.com/foo bar");      # http://perl.com/foo%20bar
	$uri->encode("http://perl.com/foo bar", 1);   # http%3A%2F%2Fperl.com%2Ffoo%20bar

=head2 decode($url)

This method decodes a 'percent' encoded URL. If you had encoded the URL using
this module (or any other method), chances are that the URL was converted to
UTF-8 before 'percent' encoding. Be sure to check the format and convert back
if required.

	$uri->decode("http%3A%2F%2Fperl.com%2Ffoo%20bar"); # "http://perl.com/foo bar"

=head1 EXPORTED FUNCTIONS

The following functions are exported upon request. This provides a non-OOP
interface

=head2 uri_encode($url, $including_reserved)

See L</encode($url, $including_reserved)>

=head2 uri_decode($url)

See L</decode($url)>

=head1 CHARACTER CLASSES

=head2 Reserved Characters

The following characters are considered as reserved (L<RFC
3986|http://tools.ietf.org/html/rfc3986>). They will be encoded only if
requested.

	 ! * ' ( ) ; : @ & = + $ , / ? % # [ ]

=head2 Unreserved Characters

The following characters are considered as Unreserved. They will not be encoded

	a-z
	A-Z
	0-9
	- _ . ~

=head1 DEPENDENCIES

L<Encode>

=head1 ACKNOWLEDGEMENTS

Gisle Aas for L<URI::Escape>

David Nicol for L<Tie::UrlEncoder>

=head1 SEE ALSO

L<RFC 3986|http://tools.ietf.org/html/rfc3986>

L<URI::Escape>

L<URI::Escape::XS>

L<URI::Escape::JavaScript>

L<Tie::UrlEncoder>

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to C<bug-uri-encode@rt.cpan.org>, or
through the web interface at L<http://rt.cpan.org>.

=head1 AUTHOR

Mithun Ayachit  C<< <mithun@cpan.org> >>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2010, Mithun Ayachit C<< <mithun@cpan.org> >>. All rights
reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.

