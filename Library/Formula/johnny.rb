require 'formula'

class Johnny < Formula
  homepage 'http://openwall.info/wiki/john/johnny'
  url 'http://openwall.info/wiki/_media/john/johnny1.1.3.tar.gz'
  head 'https://github.com/AlekseyCherepanov/johnny.git'
  sha1 '5c46a5f0611e1b6b60509f866b1d93bbc3a670ac'

  depends_on 'qt'
  depends_on 'john'
  depends_on :x11

  def install
    system "qmake"
    system "make"
    prefix.install 'johnny.app'
  end

  def caveats; <<-EOS.undent
    johnny.app installed to:
      #{prefix}

    To link the application to a normal Mac OS X location:
        brew linkapps
    or:
        ln -s #{prefix}/johnny.app /Applications
    EOS
  end
end
