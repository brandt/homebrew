require 'formula'

class Ccv < Formula
  homepage 'http://libccv.org'
  url 'https://github.com/liuliu/ccv/archive/r0.3-rc1.zip'
  version '0.3-rc1'
  sha1 '204ff206cd3adc78c22575a89ce521e7cd868900'

  depends_on 'jpeg'
  depends_on 'libpng'
  depends_on 'liblinear'
  depends_on 'fftw'
  depends_on 'gsl'

  def install

    ENV.append_to_cflags %W[
                 -msse2
                 -I"/System/Library/Frameworks/vecLib.framework/Headers"
                 -ffast-math
                 -D HAVE_SSE2
                 -D HAVE_LIBJPEG
                 -D HAVE_LIBPNG
                 -D HAVE_GSL
                 -D HAVE_FFTW3
                 -D HAVE_LIBLINEAR
                 -D HAVE_CBLAS
               ].join(' ')

    ENV.append 'LDFLAGS', %W[
                  -lm
                  -lz
                  -ljpeg
                  -lpng
                  -lgsl
                  -lfftw3
                  -lfftw3f
                  -llinear
                  -lblas
                ].join(' ')

    cd 'lib' do
#      system 'make', '-e', "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", 'all'
      touch [ '.LN', '.DEF', '.CC' ]
    end

    cd 'bin' do
#      inreplace "makefile" do |s|
#        s.gsub! /libccv\.a/, '../lib/libccv.a'
#      end
      ENV.prepend 'CFLAGS', '-I../lib'
      ENV.prepend 'LDFLAGS', '-L../lib -lccv'
      system 'make', '-e', "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "LDFLAGS=#{ENV.ldflags}", 'all'
    end
  end

  def test
    system "true"
  end
end
