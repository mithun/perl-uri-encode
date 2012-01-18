package URI::Encode;

#######################
# LOAD MODULES
#######################
use strict;
use warnings FATAL => 'all';
use 5.008001;
use Encode qw();
use Carp qw(croak carp);

#######################
# VERSION
#######################
our $VERSION = '0.06';

#######################
# EXPORT
#######################
use base qw(Exporter);
our (@EXPORT_OK);

@EXPORT_OK = qw(uri_encode uri_decode);

#######################
# SETTINGS
#######################

# Reserved characters
my $reserved_re =
    qr{([^a-zA-Z0-9\-\_\.\~\!\*\'\(\)\;\:\@\&\=\+\$\,\/\?\%\#\[\]])}x;

# Un-reserved characters
my $unreserved_re = qr{([^a-zA-Z0-9\Q-_.~\E])}x;

# Encoded character set
my $encoded_chars = qr{%([a-fA-F0-9]{2})}x;

#######################
# CONSTRUCTOR
#######################
sub new {
    my ( $class, @in ) = @_;

    # Check Input
    my $input = {

        #   this module, unlike URI::Escape,
        #   does not encode reserved characters
        encode_reserved => 0,
    };
    if   ( ref $in[0] eq 'HASH' ) { $input = $in[0]; }
    else                          { $input = {@in}; }

    # Encoding Map
    $input->{enc_map} =
        { ( map { chr($_) => sprintf( "%%%02X", $_ ) } ( 0 ... 255 ) ) };

    # Decoding Map
    $input->{dec_map} =
        { ( map { sprintf( "%02X", $_ ) => chr($_) } ( 0 ... 255 ) ) };

    # Return
    my $self = bless $input, $class;
    return $self;
} ## end sub new

#######################
# ENCODE
#######################
sub encode {
    my ( $self, $data, $reserved_flag ) = @_;

    # Check for data
    # Allow to be '0'
    return unless defined $data;

    # Encode reserved?
    my $enc_res = $reserved_flag || $self->{encode_reserved};

    # UTF-8 encode
    $data = Encode::encode( 'utf-8-strict', $data );

    # Percent Encode
    if ($enc_res) {
        $data =~ s{$unreserved_re}{$self->{enc_map}->{$1}}gx;
    }
    else {
        $data =~ s{$reserved_re}{$self->{enc_map}->{$1}}gx;
    }

    # Done
    return $data;
} ## end sub encode

#######################
# DECODE
#######################
sub decode {
    my ( $self, $data ) = @_;

    # Check for data
    # Allow to be '0'
    return unless defined $data;

    # Percent Decode
    $data =~ s{$encoded_chars}{$self->{dec_map}->{$1}}gx;

    return $data;
} ## end sub decode

#######################
# EXPORTED FUNCTIONS
#######################

# Encoder
sub uri_encode { return __PACKAGE__->new()->encode(@_); }

# Decoder
sub uri_decode { return __PACKAGE__->new()->decode(@_); }

#######################
1;

__END__

#######################
# POD SECTION
#######################
=pod

=head1 NAME

URI::Encode - Simple percent Encoding/Decoding

=head1 SYNOPSIS

    # OOP Interface
    use URI::Encode;
    my $uri = URI::Encode->new({encode_reserved =>0});
    my $encoded = $uri->encode($data);
    my $decoded = $uri->decode($encoded);

    # Functional
    use URI::Encode qw(uri_encode uri_decode);
    my $encoded = uri_encode($data);
    my $decoded = uri_decode($encoded);

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

Please report any bugs or feature requests to C<bug-uri-encode@rt.cpan.org>, or
through the web interface at
L<http://rt.cpan.org/Public/Dist/Display.html?Name=URI-Encode>

=head1 AUTHOR

Mithun Ayachit C<mithun@cpan.org>

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2012, Mithun Ayachit. All rights reserved.

This module is free software; you can redistribute it and/or modify it under
the same terms as Perl itself. See L<perlartistic>.

=cut
