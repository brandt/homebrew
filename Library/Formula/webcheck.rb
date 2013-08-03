require 'formula'

class Webcheck < Formula
  homepage 'http://arthurdejong.org/webcheck'
  url 'http://arthurdejong.org/webcheck/webcheck-1.10.4.tar.gz'
  sha1 '03518626ca11cf898c2497423bfa9321f01e94c6'

  depends_on :python
  depends_on 'lynx' => :optional

  def install
    # Remove unneeded Debian directory
    rm_rf Dir['debian']

    prefix.install_metafiles
    man1.install "webcheck.1"

    ln_s "webcheck.py", "webcheck"
    libexec.install Dir['*']
    bin.write_exec_script libexec/'webcheck'
  end

  test do
    system "webcheck", "--version"
  end
end
