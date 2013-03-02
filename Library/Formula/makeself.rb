require 'formula'

class MakeselfDownloadStrategy < CurlDownloadStrategy
  def stage
    @tarball_path.chmod 0755
    system @tarball_path
    chdir
  end
end

class Makeself < Formula
  homepage 'http://megastep.org/makeself/'
  url 'http://www.megastep.org/makeself/makeself-2.1.5.run', :using => MakeselfDownloadStrategy
  sha1 '803ca42ea64e51af72a4ee50b4d8f7a6107c926d'
  head 'https://github.com/megastep/makeself.git'

  def install
    man1.install "makeself.1"
    bin.install "makeself-header.sh", "makeself.sh"
  end

  test do
    system "makeself", "--version"
  end
end
