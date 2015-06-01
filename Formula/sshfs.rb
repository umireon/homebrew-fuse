class Sshfs < Formula
  desc "File system client based on SSH File Transfer Protocol"
  homepage "https://osxfuse.github.io/"
  url "https://github.com/osxfuse/sshfs/archive/osxfuse-sshfs-2.5.0.tar.gz"
  sha256 "8ea4d3d5bc0f343998009d7eb138e3804490f6a22e890c6de4eadc6fd2414ae0"

  option "without-sshnodelay", "Don't compile NODELAY workaround for ssh"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :osxfuse
  depends_on "glib"

  # Fixes issue https://github.com/osxfuse/sshfs/pull/4
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-sshnodelay" if build.without? "sshnodelay"

    system "autoreconf", "--force", "--install"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/sshfs", "--version"
  end
end

__END__
--- a/sshfs.c
+++ b/sshfs.c
@@ -313,6 +313,8 @@
	"ConnectTimeout",
	"ControlMaster",
	"ControlPath",
+	"ForwardAgent",
+	"ForwardX11",
	"GlobalKnownHostsFile",
	"GSSAPIAuthentication",
	"GSSAPIDelegateCredentials",
