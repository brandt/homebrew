require 'formula'

# Documentation: https://github.com/mxcl/homebrew/wiki/Formula-Cookbook
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Gti < Formula
  homepage 'https://github.com/rwos/gti'
  version '0.1'
  url 'git://github.com/rwos/gti.git'

  def install
    system "make"
    bin.install 'gti'
  end

  def test
    system "gti --version"
  end
end
