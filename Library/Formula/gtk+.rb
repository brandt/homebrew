require 'formula'

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.10.tar.xz'
  sha256 'ea56e31bb9d6e19ed2e8911f4c7ac493cb804431caa21cdcadae625d375a0e89'

  depends_on 'pkg-config' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'glib'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk'
  depends_on 'cairo'
  depends_on :x11
  depends_on 'gtk-doc' if ARGV.include? '--with-docs'

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end

  def options
  [
    ['--with-docs', 'Build documentation (requires gtk-doc).'],
  ]
  end

  def patches
    # Patch out the fragile gtk-doc build unless user explicitly wants docs:
    DATA
    
    # Patches used in the official GTK+ OSX installer project:
    # http://git.gnome.org/browse/gtk-osx/tree/modulesets-stable/gtk-osx.modules
    p = { :p1 => %W[
      http://git.gnome.org/browse/gtk-osx/plain/patches/0004-Bug-571582-GtkSelection-implementation-for-quartz.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0006-Bug-658722-Drag-and-Drop-sometimes-stops-working.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0008-Implement-GtkDragSourceOwner-pasteboardChangedOwner.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/gtk+-Bug-655065-Better-Fix.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0001-Bug-670373-gtk2-modules-printing-cups-gtkprintbackendcups.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0002-gtk2-Extract-reasons-and-reasons_desc-arrays-to-file-leve.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0003-gtk2-Create-enum-PrinterStateLevel.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0004-gtk2-Extract-printer-setup-variables-into-a-struct.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0005-gtk2-Extract-function-cups_printer_handle_attribute.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0006-gtk2-Extract-Function-cups_create_printer.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0007-gtk2-Move-some-variable-declarations-into-the-scopes-in-w.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0008-Bug-670373-gtk2-modules-printing-cups-gtkprintbackendcups.patch
      http://git.gnome.org/browse/gtk-osx/plain/patches/0009-Bug-670373-gtk2-modules-printing-cups-gtkprintbackendcups.patch
      ]}
      p[:p0] = [ DATA ] unless ARGV.include? '--with-docs'
    return p
  end

  def install
    # We have to rerun autotools due to patches:
    ENV['LIBTOOLIZE'] = 'glibtoolize'
    system "autoreconf", "--force", "--install"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-glibtest
      --disable-introspection
      --disable-visibility
      --disable-maintainer-mode
    ]
    
    system "./configure", *args
    system "make install"
  end

  def test
    system "#{bin}/gtk-demo"
  end
end


# Patches out docs due to the gtk-doc dependency. Gtk-doc requires the Python
# libxml2 lib, which is an optional install and thus can't be depended upon.
__END__
diff --git Makefile.am Makefile.am
index 8e3a2f1..fe3901b 100644
--- Makefile.am
+++ Makefile.am
@@ -2,7 +2,7 @@
 include $(top_srcdir)/Makefile.decl
 
 SRC_SUBDIRS = gdk gtk modules demos tests perf
-SUBDIRS = po po-properties $(SRC_SUBDIRS) docs m4macros build
+SUBDIRS = po po-properties $(SRC_SUBDIRS) m4macros build
 
 # require automake 1.4
 AUTOMAKE_OPTIONS = 1.7
diff --git configure.in configure.in
index 24f1d32..010394c 100644
--- configure.in
+++ configure.in
@@ -1583,39 +1583,6 @@ fi
 GOBJECT_INTROSPECTION_CHECK([0.9.3])
 
 ##################################################
-# Checks for gtk-doc and docbook-tools
-##################################################
-
-GTK_DOC_CHECK([1.11])
-
-AC_CHECK_PROG(DB2HTML, db2html, true, false)
-AM_CONDITIONAL(HAVE_DOCBOOK, $DB2HTML)
-
-AC_ARG_ENABLE(man,
-              [AC_HELP_STRING([--enable-man],
-                              [regenerate man pages from Docbook [default=no]])],enable_man=yes,
-              enable_man=no)
-
-if test "${enable_man}" != no; then
-  dnl
-  dnl Check for xsltproc
-  dnl
-  AC_PATH_PROG([XSLTPROC], [xsltproc])
-  if test -z "$XSLTPROC"; then
-    enable_man=no
-  fi
-
-  dnl check for DocBook DTD and stylesheets in the local catalog.
-  JH_CHECK_XML_CATALOG([-//OASIS//DTD DocBook XML V4.1.2//EN],
-     [DocBook XML DTD V4.1.2],,enable_man=no)
-  JH_CHECK_XML_CATALOG([http://docbook.sourceforge.net/release/xsl/current/manpages/docbook.xsl],
-     [DocBook XSL Stylesheets],,enable_man=no)
-fi
-
-AM_CONDITIONAL(ENABLE_MAN, test x$enable_man != xno)
-
-
-##################################################
 # Output commands
 ##################################################
 
@@ -1717,16 +1684,6 @@ demos/Makefile
 demos/gtk-demo/Makefile
 demos/gtk-demo/geninclude.pl
 tests/Makefile
-docs/Makefile
-docs/reference/Makefile
-docs/reference/gdk/Makefile
-docs/reference/gdk/version.xml
-docs/reference/gtk/Makefile
-docs/reference/gtk/version.xml
-docs/reference/libgail-util/Makefile
-docs/faq/Makefile
-docs/tools/Makefile
-docs/tutorial/Makefile
 build/Makefile
 build/win32/Makefile
 build/win32/vs9/Makefile

