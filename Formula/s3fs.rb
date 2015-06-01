class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://code.google.com/p/s3fs/"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.78.tar.gz"
  sha256 "36c0b00a294d9676c462985c0c3f1362540e8ebc61c15bacb45e28a2f00297f5"

  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnutls"
  depends_on "nettle"
  depends_on "libgcrypt"

  # S3fs currently relies on fuse4x which uses unsigned kexts, barred by Yosemite.
  # Fuse4x and osxfuse are merging so monitor this over time and switch if/when possible.
  depends_on "fuse4x"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking", "--with-gnutls", "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Be aware that s3fs has some caveats concerning S3 "directories"
    that have been created by other tools. See the following issue for
    details:

      https://code.google.com/p/s3fs/issues/detail?id=73
    EOS
  end
end
