class S3fs < Formula
  desc "FUSE-based file system backed by Amazon S3"
  homepage "https://code.google.com/p/s3fs/"
  url "https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.79.tar.gz"
  sha256 "61c179f958ce236c6612bf6ffc7bdb6478393ac6e5ec0b04788000fc9f9dbf66"

  head "https://github.com/s3fs-fuse/s3fs-fuse.git"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gnutls"
  depends_on "nettle"
  depends_on "libgcrypt"

  depends_on :osxfuse

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

  test do
    system "#{bin}/s3fs", "--version"
  end
end
