require 'formula'

class Naclsdk < Formula
  homepage 'https://developers.google.com/native-client/sdk/'
  head 'http://storage.googleapis.com/nativeclient-mirror/nacl/nacl_sdk/nacl_sdk.zip'

  def install
    inreplace 'naclsdk',
      'readonly SCRIPT_DIR_ABS="$(cd "${SCRIPT_DIR}" ; pwd -P)"',
      "readonly SCRIPT_DIR_ABS=\"#{libexec}\""
    libexec.install Dir['*']
    bin.install_symlink libexec+('naclsdk') => 'naclsdk'
  end

  def test
    system "naclsdk -v"
  end
end
