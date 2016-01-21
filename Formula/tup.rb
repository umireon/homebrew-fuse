class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  head "https://github.com/gittup/tup.git"

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  stable do
    url "https://github.com/gittup/tup/archive/v0.7.4.tar.gz"
    sha256 "e23f10b618925c85bc376ff0613dc4daf3990ecf2fc811ece54e87c7d64c9010"
  end

  def install
    ENV["TUP_LABEL"] = version
    system "./build.sh"
    bin.install "build/tup"
    man1.install "tup.1"
  end

  test do
    system "#{bin}/tup", "-v"
  end
end
