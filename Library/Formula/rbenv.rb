require 'formula'

class Rbenv < Formula
  homepage 'https://github.com/sstephenson/rbenv'
  url 'https://github.com/sstephenson/rbenv/tarball/v0.3.0'
  sha1 'b9f78b1a10d4e225d0377cac33c1a964ee6df00b'

  head 'https://github.com/sstephenson/rbenv.git'

  # TODO: When we bump the version here we can remove making the plugin
  # directory in depending formulae.
  def install
    prefix.install Dir['*']

    var_lib = "#{HOMEBREW_PREFIX}/var/lib/rbenv/"
    ['plugins', 'versions'].each do |dir|
      var_dir = "#{var_lib}/#{dir}"
      mkdir_p var_dir
      ln_sf var_dir, "#{prefix}/#{dir}"
    end
  end

  # Adds default path search for plugins
  def patches; DATA; end

  def caveats; <<-EOS.undent
    To enable shims and autocompletion add to your profile:
      if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

    To use Homebrew's directories rather than ~/.rbenv add to your profile:
      export RBENV_ROOT=#{opt_prefix}
    EOS
  end
end


__END__
diff --git a/libexec/rbenv b/libexec/rbenv
index b0470f2..3275815 100755
--- a/libexec/rbenv
+++ b/libexec/rbenv
@@ -43,13 +43,13 @@ export RBENV_DIR
 shopt -s nullglob
 
 bin_path="$(abs_dirname "$0")"
-for plugin_bin in "${RBENV_ROOT}/plugins/"*/bin; do
+for plugin_bin in {"${RBENV_ROOT}","${bin_path}/.."}/plugins/*/bin; do
   bin_path="${bin_path}:${plugin_bin}"
 done
 export PATH="${bin_path}:${PATH}"
 
 hook_path="${RBENV_HOOK_PATH}:${RBENV_ROOT}/rbenv.d:/usr/local/etc/rbenv.d:/etc/rbenv.d:/usr/lib/rbenv/hooks"
-for plugin_hook in "${RBENV_ROOT}/plugins/"*/etc/rbenv.d; do
+for plugin_hook in {"${RBENV_ROOT}","${bin_path}/.."}/plugins/*/etc/rbenv.d; do
   hook_path="${hook_path}:${plugin_hook}"
 done
 export RBENV_HOOK_PATH="$hook_path"
