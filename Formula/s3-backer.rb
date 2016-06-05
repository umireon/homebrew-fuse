class S3Backer < Formula
  desc "FUSE-based single file backing store via Amazon S3"
  homepage "https://github.com/archiecobbs/s3backer"
  url "https://s3backer.googlecode.com/files/s3backer-1.3.7.tar.gz"
  sha256 "7a6f028d16301b0fd32679eebe34ff2d614f343979ee7a0fab0110b85934aaca"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on :osxfuse

  def install
    inreplace "configure", "-lfuse", "-losxfuse"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/s3backer", "--version"
  end
end
