class Bindfs < Formula
  desc "FUSE file system for mounting to another location"
  homepage "http://bindfs.org/"
  url "http://bindfs.org/downloads/bindfs-1.13.1.tar.gz"
  sha256 "fb25f0ca6b1c2ec446b418f4ecc0cce3ba07a3a539f48398e8bddf3474e95889"

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
