require 'formula'

class Bfgminer < Formula
  homepage 'https://github.com/luke-jr/bfgminer'
  url 'http://luke.dashjr.org/programs/bitcoin/files/bfgminer/2.99.1/bfgminer-2.99.1.zip'
  sha1 '8e1e96ef3fd374fc88870ee9a501d0b39dda8cc7'
  head 'https://github.com/luke-jr/bfgminer.git', :branch => 'bfgminer'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on 'curl'
  depends_on 'jansson'
  depends_on 'libusb' => :optional

  def install
    system "./autogen.sh", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end

  test do
    system "bfgminer --help"
  end
end
