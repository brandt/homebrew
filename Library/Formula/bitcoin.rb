require 'formula'

class Bitcoin < Formula
  homepage 'https://github.com/bitcoin/bitcoin'
  url 'https://github.com/bitcoin/bitcoin/archive/v0.8.0.zip'
  head 'https://github.com/bitcoin/bitcoin.git'
  sha1 'ed90d0f3c624700ff5c2f608815de91903e197a9'

  depends_on 'boost'
  depends_on 'qt'
  depends_on 'miniupnpc'
  depends_on 'openssl'
  depends_on 'berkeley-db4'

  if build.include? 'with-qt'
    depends_on 'qt'
  end

  option 'with-qt', 'Include Bitcoin-QT GUI'

  def patches
    # Fixes some of the paths used by Homebrew.
    "contrib/homebrew/makefile.osx.patch" if build.head?
  end

  def install
    args = [
      "DEPSDIR=#{HOMEBREW_PREFIX}",
      "DB4DIR=#{HOMEBREW_PREFIX}",
      "OPENSSLDIR=#{HOMEBREW_PREFIX}/opt/openssl"
    ]
    chdir 'src'
    system 'qmake', 'USE_UPNP=1' if build.include? 'with-qt'
    system 'false'
    system 'make', '-f', 'makefile.osx', *args
  end

  test do
    system 'bitcoind', '--help'
  end
end
