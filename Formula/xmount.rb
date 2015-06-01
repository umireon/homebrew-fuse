class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.pinguin.lu/index.php"
  url "http://files.pinguin.lu/xmount-0.5.0.tar.gz"
  sha256 "ae051d1901a74b34dce737275d0d385b20c21557d1458818dae8d04d5b25a47e"

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libewf"
  depends_on :osxfuse

  patch :DATA

  def install
    system "aclocal", "-I #{HOMEBREW_PREFIX}/share/aclocal"
    system "autoconf"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"xmount", "--version"
  end
end

__END__
diff  a/configure.ac b/configure.ac
--- a/configure.ac
+++ b/configure.ac
@@ -2,9 +2,9 @@

 AC_PREREQ(2.61)
 AC_INIT([xmount], [0.5.0], [bugs@pinguin.lu])
-AM_INIT_AUTOMAKE(@PACKAGE_NAME@, @PACKAGE_VERSION@)
 AC_CONFIG_SRCDIR([xmount.c])
 AC_CONFIG_HEADER([config.h])
+AM_INIT_AUTOMAKE

 # Checks for programs.
 AC_PROG_CC
