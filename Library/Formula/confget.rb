require 'formula'

class Confget < Formula
  homepage 'http://devel.ringlet.net/textproc/confget/'
  url 'http://devel.ringlet.net/textproc/confget/confget-1.04.tar.gz'
  sha1 'ad25d484612c78c56962ab17d47f836930772920'

  depends_on 'pcre'

  def install
    ENV.j1  # Failes when run in parallel.

    args = ["LOCALBASE=#{prefix}", "BINOWN=#{ENV['USER']}", "BINGRP=staff"]

    # The Makefile does adds a "1" to $MANDIR,
    # so we install the man page separately.
    system "make", "all", *args
    system "make", "install-bin", *args
    man1.install ['confget.1.gz']
  end

  def test
    system "confget −V"
  end
end
