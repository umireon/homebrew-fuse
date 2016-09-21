class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/0.5.4.tar.gz"
  sha256 "ba69d000e135e600f4535adb7ec953fcd1b28faae7a7abe909a1b5f54eb4d2c1"
  head "https://github.com/netheril96/securefs.git"

  depends_on "cmake" => :build
  depends_on :osxfuse

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/securefs", "version" # The sandbox prevents a more thorough test
  end
end
