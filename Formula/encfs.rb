class Encfs < Formula
  desc "Encrypted pass-through FUSE file system"
  homepage "https://vgough.github.io/encfs/"
  url "https://github.com/vgough/encfs/archive/v1.9.tar.gz"
  sha256 "30d2db1555ec359082046748d278018b8a246dc49c0442291c5671da0486f4bf"
  head "https://github.com/vgough/encfs.git"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "gettext"
  depends_on "openssl"
  depends_on :osxfuse

  needs :cxx11

  def install
    ENV.cxx11

    # Undefined symbol "_libintl_gettext"
    # Reported 11 Sep 2016 https://github.com/vgough/encfs/issues/207
    ENV.append "LDFLAGS", "-lintl"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    # Functional test violates sandboxing, so punt.
    # Issue #50602; upstream issue vgough/encfs#151
    assert_match version.to_s, shell_output("#{bin}/encfs 2>&1", 1)
  end
end
