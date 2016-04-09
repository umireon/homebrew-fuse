class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.8.1.tar.gz"
  sha256 "ed6b69d8aba06382ad01116bbce2e4ad49f8de85cdf4e2fab7ee4ac82af537e9"
  revision 2

  head do
    url "https://github.com/vgough/encfs.git"
    depends_on "cmake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "boost"
  depends_on "rlog"
  depends_on "openssl"
  depends_on "xz"
  depends_on :osxfuse

  needs :cxx11 if MacOS.version < :mavericks

  def install
    ENV.cxx11 if MacOS.version < :mavericks
    if build.head?
      mkdir "build" do
        system "cmake", "..", *std_cmake_args
        system "make", "install"
      end
    else
      system "make", "-f", "Makefile.dist"
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-boost=#{HOMEBREW_PREFIX}"
      system "make", "install"
    end
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
