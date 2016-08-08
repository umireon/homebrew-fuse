class Securefs < Formula
  desc "Filesystem with transparent authenticated encryption"
  homepage "https://github.com/netheril96/securefs"
  url "https://github.com/netheril96/securefs/archive/0.5.2.tar.gz"
  sha256 "6feacc286d0b26279366806818d730114966f2106cc4cdb3bde5aef650650fe3"
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
