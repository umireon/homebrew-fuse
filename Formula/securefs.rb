class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/0.6.0.tar.gz"
  sha256 "698b8251640bd8b6ef04f94147a1c05aaa8495ebea4a03faa08ed91c967bd3cb"
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
