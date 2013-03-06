require 'formula'

class Bfgminer < Formula
  homepage 'https://github.com/luke-jr/bfgminer'
  head 'https://github.com/luke-jr/bfgminer.git'

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
