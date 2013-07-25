require 'formula'

# The manual isn't included in the 0.19 binary release zip, so we download it
# from VCS at the corresponding revision, r991.
class SublerCliManual < Formula
  url 'https://subler.googlecode.com/svn-history/r991/trunk/SublerCLI/SublerCLI.1'
  sha1 '3f1eb2d73ae8c87a875534d4449c52957e7fd087'
end

class SublerCli < Formula
  homepage 'http://code.google.com/p/subler/'
  url 'https://subler.googlecode.com/files/SublerCLI-0.19.zip'
  sha1 'ea35f9ae5bc2c7395bb94c0f1870af608e758c6c'

  option 'no-docs', 'Do not install documentation'

  def install
    bin.install 'SublerCLI'

    unless build.include? 'no-docs'
      SublerCliManual.new.brew { man1.install 'SublerCLI.1' }
    end
  end

  test do
    system "#{bin}/SublerCLI", '-version'
  end
end
