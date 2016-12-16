class RofsFiltered < Formula
  desc "Filtered read-only filesystem for FUSE"
  homepage "https://github.com/gburca/rofs-filtered/"
  url "https://github.com/gburca/rofs-filtered/archive/rel-1.6.tar.gz"
  sha256 "9f46269be24ba6ff23575c0a1a9a6c5923aab749e104984513884c668bf4bf90"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on :osxfuse
  depends_on :macos => :yosemite

  def install
    ENV.prepend "CPPFLAGS", "-I#{HOMEBREW_PREFIX}/include/osxfuse/fuse"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-libfuse=#{HOMEBREW_PREFIX}"
    system "make", "install"
  end

  test do
    system bin/"rofs-filtered"
  end
end
