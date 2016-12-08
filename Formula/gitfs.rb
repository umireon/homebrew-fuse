class Gitfs < Formula
  include Language::Python::Virtualenv

  desc "Version controlled file system"
  homepage "http://www.presslabs.com/gitfs"
  url "https://github.com/PressLabs/gitfs/archive/0.4.5.tar.gz"
  sha256 "c22d48e32b0733815369812404d2002db50fefc983412da23c14d838226a6582"
  head "https://github.com/PressLabs/gitfs.git"

  depends_on "libgit2"
  depends_on :osxfuse
  depends_on :python if MacOS.version <= :snow_leopard

  resource "atomiclong" do
    url "https://files.pythonhosted.org/packages/86/8c/70aea8215c6ab990f2d91e7ec171787a41b7fbc83df32a067ba5d7f3324f/atomiclong-0.1.1.tar.gz"
    sha256 "cb1378c4cd676d6f243641c50e277504abf45f70f1ea76e446efcdbb69624bbe"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/83/3c/00b553fd05ae32f27b3637f705c413c4ce71290aa9b4c4764df694e906d9/cffi-1.7.0.tar.gz"
    sha256 "6ed5dd6afd8361f34819c68aaebf9e8fc12b5a5893f91f50c9e50c8886bb60df"
  end

  resource "fusepy" do
    url "https://files.pythonhosted.org/packages/source/f/fusepy/fusepy-2.0.2.tar.gz"
    sha256 "aa5929d5464caed81406481a330dc975d1a95b9a41d0a98f095c7e18fe501bfc"
  end

  # MUST update this every time libgit2 gets a major update.
  # Check if upstream have updated the requirements, and patch if necessary.
  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/97/b3/18a9f79c5e0e87d877d56566dae1fa5b8fa68a605b41e38f807951fe8620/pygit2-0.24.0.tar.gz"
    sha256 "ba76d97e90713584c8cb9d33c81cf9156aa69d6914cd3cdbddb740a069298105"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats; <<-EOS.undent
    gitfs clones repos in /var/lib/gitfs. You can either create it with
    sudo mkdir -m 1777 /var/lib/gitfs or use another folder with the
    repo_path argument.

    Also make sure OSXFUSE is properly installed by running brew info osxfuse.
    EOS
  end

  test do
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"

    (testpath/"test.py").write <<-EOS.undent
      import gitfs
      import pygit2
      pygit2.init_repository('testing/.git', True)
    EOS

    system "python", "test.py"
    assert File.exist?("testing/.git/config")
    cd "testing" do
      system "git", "remote", "add", "homebrew", "https://github.com/Homebrew/homebrew.git"
      assert_match "homebrew", shell_output("git remote")
    end
  end
end
