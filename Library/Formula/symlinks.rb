require 'formula'

class Symlinks < Formula
  homepage 'http://packages.debian.org/wheezy/symlinks'
  url 'http://ftp.de.debian.org/debian/pool/main/s/symlinks/symlinks_1.4.orig.tar.gz'
  sha1 '10038cf12e510fd5b7266811622e05361e2b6e40'

  def patches; DATA; end

  def install

    inreplace 'Makefile' do |s|
      s.change_make_var! "CC", ENV.cc
    end

    system "make"
    bin.install('symlinks')
    man8.install('symlinks.8')
  end

  def test
    system "#{bin}/symlinks", "-t", "-v", "#{HOMEBREW_PREFIX}/bin"
  end
end

# Patches so that malloc.h isn't included when OSX (won't compile otherwise)
__END__
--- a/symlinks.c
+++ b/symlinks.c
@@ -4,7 +4,9 @@
 #endif
 #include <stdio.h>
 #include <stdlib.h>
+#if !defined(__APPLE__)
 #include <malloc.h>
+#endif
 #include <string.h>
 #include <fcntl.h>
 #include <sys/param.h>
