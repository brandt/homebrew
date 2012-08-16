require 'formula'

class Gti < Formula
  homepage 'https://github.com/rwos/gti'
  version '0.1'
  url 'https://github.com/rwos/gti/zipball/ef5c4d822ba4e0227981b274fd65619e5beaa754'
  sha1 '08dc051f51d674c950ff1db38227b2c531469604'

  def install
    system "make"
    bin.install 'gti'
  end

  def test
    system "gti --version"
  end
end
