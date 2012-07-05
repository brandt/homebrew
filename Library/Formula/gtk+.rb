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
  # Patches out dodgy doc build unless user explicitly wants them (see patch)
  [['--with-docs', 'Build documentation (requires gtk-doc).']]
  end

  def patches
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
      # Patches out docs due to the gtk-doc dependency. Gtk-doc requires the Python
      # libxml2 lib, which is an optional install and thus can't be depended upon.
      p[:p0] = %W[
          https://gist.github.com/gists/3051415/download
        ] unless ARGV.include? '--with-docs'
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

