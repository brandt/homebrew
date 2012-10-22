require 'formula'

class Pyenv < Formula
  homepage 'https://github.com/yyuu/pyenv'
  url 'https://github.com/yyuu/pyenv/tarball/v0.1.1'
  sha1 '44d752134015c2ea2a46565d65496420ca190056'

  head 'https://github.com/yyuu/pyenv.git'


  def install
    prefix.install Dir['*']
  end

  # Adds default path search for plugins
  def patches; DATA; end

  def test
    system "pyenv versions"
  end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion, add pyenv init to your profile:
      if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
    EOS
  end
end


__END__
diff --git a/libexec/pyenv b/libexec/pyenv
index b0470f2..3275815 100755
--- a/libexec/pyenv
+++ b/libexec/pyenv
@@ -43,13 +43,13 @@ export PYENV_DIR
 shopt -s nullglob
 
 bin_path="$(abs_dirname "$0")"
-for plugin_bin in "${PYENV_ROOT}/plugins/"*/bin; do
+for plugin_bin in {"${PYENV_ROOT}","${bin_path}/.."}/plugins/*/bin; do
   bin_path="${bin_path}:${plugin_bin}"
 done
 export PATH="${bin_path}:${PATH}"
 
 hook_path="${PYENV_HOOK_PATH}:${PYENV_ROOT}/pyenv.d:/usr/local/etc/pyenv.d:/etc/pyenv.d:/usr/lib/pyenv/hooks"
-for plugin_hook in "${PYENV_ROOT}/plugins/"*/etc/pyenv.d; do
+for plugin_hook in {"${PYENV_ROOT}","${bin_path}/.."}/plugins/*/etc/pyenv.d; do
   hook_path="${hook_path}:${plugin_hook}"
 done
 export PYENV_HOOK_PATH="$hook_path"
