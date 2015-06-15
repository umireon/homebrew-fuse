require "language/go"

class Gcsfuse < Formula
  desc "User-space file system for interacting with Google Cloud"
  homepage "https://github.com/googlecloudplatform/gcsfuse"
  url "https://github.com/GoogleCloudPlatform/gcsfuse/archive/v0.2.0.tar.gz"
  sha256 "8745d61b44bd41e779545f2642959173f3901d31f586167a9f2e7f7c98f2ac24"

  depends_on :osxfuse
  depends_on "go" => :build

  go_resource "github.com/jacobsa/bazilfuse" do
    url "https://github.com/jacobsa/bazilfuse.git",
      :revision => "0576778511943785a3d042694a2c34c6b8d664a7"
  end

  go_resource "github.com/jacobsa/fuse" do
    url "https://github.com/jacobsa/fuse.git",
      :revision => "1939992b465ab35fe2b64a177b3016d2ef37bc6b"
  end

  go_resource "github.com/jacobsa/gcloud" do
    url "https://github.com/jacobsa/gcloud.git",
      :revision => "54d39dbdab36b1c1495282bdbd0fae02fa4cd1fc"
  end

  go_resource "github.com/jacobsa/oglematchers" do
    url "https://github.com/jacobsa/oglematchers.git",
      :revision => "3ecefc49db07722beca986d9bb71ddd026b133f0"
  end

  go_resource "github.com/jacobsa/reqtrace" do
    url "https://github.com/jacobsa/reqtrace.git",
      :revision => "245c9e0234cb2ad542483a336324e982f1a22934"
  end

  go_resource "github.com/jacobsa/syncutil" do
    url "https://github.com/jacobsa/syncutil.git",
      :revision => "47ae5379a1cd4265867a8748ed01355df33e91a7"
  end

  go_resource "github.com/jacobsa/timeutil" do
    url "https://github.com/jacobsa/timeutil.git",
      :revision => "be3201437a80a536df57a5cc81d6eca0e3db132e"
  end

  go_resource "github.com/jacobsa/util" do
    url "https://github.com/jacobsa/util.git",
      :revision => "72fcc8628ce3fceba2ccb4a443015bee085cd7a4"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "e562cdb856bcf26549c3d024ec9c8a3d9493fe91"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
      :revision => "b5adcc2dcdf009d0391547edc6ecbaff889f5bb9"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys.git",
      :revision => "58e109635f5d754f4b3a8a0172db65a52fcab866"
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "0610a35668fd6881bec389e74208f0df92010e96"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "60dbe9142c48189502e0235845b4930505f30bc6"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    # Make the gcsfuse source code from the tarball appear in the appropriate
    # place in the $GOPATH workspace, then build the binaries with names that
    # don't conflict with directory names.
    mkdir_p "src/github.com/googlecloudplatform"
    ln_s buildpath, "src/github.com/googlecloudplatform/gcsfuse"
    system "go", "build", "-o", "gcsfuse.bin"
    system "go", "build", "-o", "gcsfuse_mount_helper.bin", "./gcsfuse_mount_helper"

    bin.install "gcsfuse.bin" => "gcsfuse"
    bin.install "gcsfuse_mount_helper.bin" => "gcsfuse_mount_helper"
  end

  test do
    system bin/"gcsfuse", "--help"
    system bin/"gcsfuse_mount_helper", "--help"
  end
end
