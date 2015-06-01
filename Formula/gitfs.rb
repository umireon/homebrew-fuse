class Gitfs < Formula
  desc "Version controlled file system"
  homepage "http://www.presslabs.com/gitfs"
  url "https://github.com/PressLabs/gitfs/archive/0.2.5.tar.gz"
  sha256 "b546ae6cbe91fbf0142860b67eb85d467a9ca5dc11681ad656f20deb573f9670"

  head "https://github.com/PressLabs/gitfs.git"

  depends_on "libgit2" => "with-libssh2"
  depends_on :osxfuse
  depends_on :python if MacOS.version <= :snow_leopard

  resource "fusepy" do
    url "https://pypi.python.org/packages/source/f/fusepy/fusepy-2.0.2.tar.gz"
    sha256 "aa5929d5464caed81406481a330dc975d1a95b9a41d0a98f095c7e18fe501bfc"
  end

  # MUST update this every time libgit2 gets a major update.
  # Check if upstream have updated the requirements, and patch if necessary.
  resource "pygit2" do
    url "https://pypi.python.org/packages/source/p/pygit2/pygit2-0.22.0.tar.gz"
    sha256 "d67045c8f6d6e8c23fc2bb6ba51f084177c7b7617c42bc433c6fec5ac0bf42e4"
  end

  resource "atomiclong" do
    url "https://pypi.python.org/packages/source/a/atomiclong/atomiclong-0.1.1.tar.gz"
    sha256 "cb1378c4cd676d6f243641c50e277504abf45f70f1ea76e446efcdbb69624bbe"
  end

  resource "cffi" do
    url "https://pypi.python.org/packages/source/c/cffi/cffi-0.8.6.tar.gz"
    sha256 "2532d9e3af9e3c6d0f710fc98b0295b563c7f39cfd97dd2242bd36fbf4900610"
  end

  resource "pycparser" do
    url "https://pypi.python.org/packages/source/p/pycparser/pycparser-2.10.tar.gz"
    sha256 "957d98b661c0b64b580ab6f94b125e09b6714154ee51de40bca16d3f0076b86c"
  end

  def install
    # This exactly replicates how upstream handled the last pygit2 update
    # https://github.com/PressLabs/gitfs/commit/8a53f6ba5ce2a4497779077a9249e7b4b5fcc32b
    # https://github.com/PressLabs/gitfs/pull/178
    inreplace "requirements.txt", "pygit2==0.21.4", "pygit2==0.22.0"

    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[fusepy pygit2 atomiclong cffi pycparser].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<-EOS.undent
    gitfs clones repos in /var/lib/gitfs. You can either create it with
    sudo mkdir -m 1777 /var/lib/gitfs or use another folder with the
    repo_path argument.

    Also make sure OSXFUSE is properly installed by running brew info osxfuse.
    EOS
  end

  test do
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    Pathname("test.py").write <<-EOS.undent
     import gitfs
     import pygit2
     pygit2.init_repository('testing/.git', True)
    EOS

    system "python", "test.py"
    assert File.exist?("testing/.git/config")
    cd "testing" do
      system "git", "remote", "add", "homebrew", "https://github.com/Homebrew/homebrew.git"
      assert_match /homebrew/, shell_output("git remote")
    end
  end
end
