require 'formula'

class Gtkx < Formula
  homepage 'http://gtk.org/'
  url 'http://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.10.tar.xz'
  sha256 'ea56e31bb9d6e19ed2e8911f4c7ac493cb804431caa21cdcadae625d375a0e89'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'gdk-pixbuf'
  depends_on 'pango'
  depends_on 'jasper' => :optional
  depends_on 'atk' => :optional

  fails_with :llvm do
    build 2326
    cause "Undefined symbols when linking"
  end
  
  def options
    [['--enable-cups', 'Enable CUPS support']]
  end

  def install
    args = [ "--disable-debug",
             "--disable-dependency-tracking",
             "--prefix=#{prefix}",
             "--disable-glibtest",
             "--disable-introspection",
             "--disable-visibility"]

    # 2012-04-05: Optionally enable CUPS support which is broken in Mac OS X 10.8
    args << '--disable-cups' unless ARGV.include? '--enable-cups'

    system "./configure", *args
    system "make install"
  end
  
  def test
    system "#{bin}/gtk-demo"
  end
  
  def caveats
    return <<-EOS.undent
    By default, this package is installed without CUPS support because it is broken
    in recent versions of Mac OS X.  
    
    For CUPS support, reinstall with:
     brew install --with-cups gtk+
    EOS
  end
end