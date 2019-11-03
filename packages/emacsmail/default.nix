{ writeShellScriptBin }:

writeShellScriptBin "emacsmail" ''
 exec emacsclient --create-frame --eval "(browse-url-mail \"$@\")"
''
