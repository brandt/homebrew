require 'formula'

class Mdocml < Formula
  homepage 'http://mdocml.bsd.lv'
  url 'http://mdocml.bsd.lv/snapshots/mdocml-1.12.1.tar.gz'
  sha1 '83685cbfeea59eb21f2e9e335ea4dc61775a8159'

  def install
    # We unset STATIC because Mac OS X does not support it.
    # See: http://developer.apple.com/library/mac/#qa/qa1118
    system "make", "PREFIX=#{prefix}", "STATIC=", "install"
  end

  def test
    system "mandoc", "-V"
  end
end
