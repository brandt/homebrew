require 'formula'

class Textmate < Formula
  head 'https://github.com/textmate/textmate.git', :branch => 'master'
  homepage 'https://github.com/textmate/textmate'
  url 'https://github.com/textmate/textmate.git', :revision => '7143f0034e1bec2346679d9997d8836d0baa0e3f'
  version '2.0-9268'

  depends_on 'ninja' => build
  depends_on 'proctools' if MACOS_VERSION < 10.8
  depends_on 'hg'
  depends_on 'ragel'
  depends_on 'boost'
  depends_on 'multimarkdown'

  def install
    ENV['builddir'] =  "#{Dir.pwd}/build"
    ENV['boostdir'] = "#{HOMEBREW_PREFIX}/include/boost"

    system "./configure"
    system "ninja io"
    system "ninja mate"
    system "ninja TextMate"

    bin.install "build/Applications/mate/mate"
    prefix.install "build/Applications/TextMate/TextMate.app"
  end

  def test
    system "mate -v"
  end

  def caveats; <<-EOS.undent
    TextMate.app installed to:
      #{prefix}

    To symlink into ~/Applications, you can do:
        brew linkapps
    EOS
  end
end
