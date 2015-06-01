class Tup < Formula
  desc "File-based build system"
  homepage "http://gittup.org/tup/"
  head "https://github.com/gittup/tup.git"

  depends_on "pkg-config" => :build
  depends_on :osxfuse

  # Backport Yosemite compilation fix
  stable do
    url "https://github.com/gittup/tup/archive/v0.7.3.tar.gz"
    sha256 "2bfc08c1201475803428dc2f665f90595d733be1a4189feaf4949b305fe13403"

    if MacOS.version >= :yosemite
      patch do
        url "https://github.com/gittup/tup/commit/9812548b4d38336.diff"
        sha256 "6c6e785332ac18b317cff52928a6bc94c364308c4c2ea8e7b44c339e465441ea"
      end
    end
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
