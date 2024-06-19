{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # visual stuff
    brotli # a generic-purpose lossless compression algorithm and tool
    ffmpeg-full # ffmpeg with all codecs
    imagemagick # software suite to create, edit, compose, or convert bitmap images
    flac # library and tools for encoding and decoding the FLAC lossless audio file format
    libheif # ISO/IEC 23008-12:2017 HEIF image file format decoder and encoder
    libwebp # tools and library for the WebP image format
    optipng # PNG optimizer
  ];
}
