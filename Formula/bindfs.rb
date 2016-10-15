class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "http://bindfs.org/"
  url "http://bindfs.org/downloads/bindfs-1.13.4.tar.gz"
  sha256 "a0e7336e5b7c9a4aaca7ba15487675dbe5c8dac692ee7341e7fcb41dd410d014"

  head do
    url "https://github.com/mpartel/bindfs.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  test do
    system "#{bin}/bindfs", "-V"
  end
end
