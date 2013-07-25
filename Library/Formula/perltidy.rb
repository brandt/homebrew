require 'formula'

class Perltidy < Formula
  homepage 'http://perltidy.sourceforge.net'
  url 'http://downloads.sourceforge.net/perltidy/Perl-Tidy-20121207.tar.gz'
  sha1 '82d82d7c47c3b50c3be7b24b282279684521cc4a'

  def install
    system "perl", "pm2pl"
    man1.install "docs/perltidy.1"
    bin.install "perltidy"
  end

  test do
    system "perltidy", "-v"
  end
end
