require 'formula'

class Gmvault < Formula
  homepage 'http://gmvault.org'
  url 'https://bitbucket.org/gaubert/gmvault-official-download/downloads/gmvault-v1.7-beta-macosx-intel.tar.gz'
  sha1 'dc2f81096b943080f0ca93ec3ca112c6b64858a2'

  def install
    mv "bin/README.txt", "README"
    bin.install 'bin/gmvault'
    prefix.install Dir["lib"]
  end

  test do
    system "gmvault", "-v"
  end

  def caveats; <<-EOS.undent
    Your Gmail settings might need to be adjusted for Gmvault to work properly:
      http://gmvault.org/gmail_setup.html
    EOS
  end
end
