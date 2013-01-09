require 'formula'

class Libnet < Formula
  homepage 'https://github.com/sam-github/libnet'
  url 'http://sourceforge.net/projects/libnet-dev/files/libnet-1.1.6.tar.gz'
  sha1 'dffff71c325584fdcf99b80567b60f8ad985e34c'

  # MacPorts does an autoreconf to get raw sockets working
  depends_on :automake
  depends_on :autoconf
  depends_on :libtool

  # Patch 1: Fix raw sockets support
  # Patch 2: Fixes deprecated m4 macro preventing libnet from being compiled with newer versions of automake
  def patches
    { :p0 => [
       "https://trac.macports.org/export/95336/trunk/dports/net/libnet11/files/patch-configure.in.diff",
       "https://gist.github.com/raw/4479981/e6e37d367b8d82a251e39e5b1338527a22ce22b8/patch-deprecated-macro_configure.in.diff"
    ]}
  end

  def install
    # Necessary because autoreconf will fail on 'configure.in: AC_CONFIG_MACRO_DIR([m4])' if the dir doesn't exist
    # This workaround can be removed when we no longer need to run autoreconf for the raw sockets support patch
    mkdir_p 'm4'

    system "autoreconf --force --install"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    inreplace "src/libnet_link_bpf.c", "#include <net/bpf.h>", "" # Per MacPorts
    system "make install"
  end
end

