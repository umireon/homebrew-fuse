class Stormfs < Formula
  desc "FUSE abstraction layer for cloud storage"
  homepage "https://github.com/benlemasurier/stormfs"
  url "https://github.com/benlemasurier/stormfs/archive/v0.03.tar.gz"
  sha256 "6e165d89011af6350852a313ac30252fa3db2c28cbb83cf49389998a75341be6"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "glib"
  depends_on "fuse4x"
  depends_on "curl" if MacOS.version <= :leopard

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
