with rec {
  pkgs = import <nixpkgs> {};
};

pkgs.stdenv.mkDerivation {
  name = "chrism-py310";
  src = pkgs.fetchFromGitHub {
    owner = "python";
    repo = "cpython";
    rev = "v3.10.5"; # tag
    sha256 = "sha256-QmiAfYJzg/dUn3JH7FlUXDCMFFAUlV/KfH+Q4yUQYbA=";
  };
    postPatch = pkgs.lib.concatStringsSep "\n" [
      ''
      cat << EOF > Modules/Setup.local
      zlib zlibmodule.c -lz
      readline readline.c -lreadline
      _lzma _lzmamodule.c -llzma
      _sqlite3 _sqlite/cache.c _sqlite/connection.c _sqlite/cursor.c _sqlite/microprotocols.c _sqlite/module.c _sqlite/prepare_protocol.c _sqlite/row.c _sqlite/statement.c _sqlite/util.c -lsqlite3 -IModules/_sqlite
      _curses _cursesmodule.c -lncurses
      _bz2 _bz2module.c -lbz2
      _ctypes _ctypes/callbacks.c _ctypes/cfield.c _ctypes/_ctypes_test.c _ctypes/malloc_closure.c _ctypes/callproc.c _ctypes/_ctypes.c _ctypes/stgdict.c -I_ctypes/ctypes_dlfcn.h -I_ctypes/ctypes.h -I_ctypes/_ctypes_test.h  -lffi
      _hashlib _hashopenssl.c -lssl -lcrypto
      _ssl _ssl.c -lssl -lcrypto
      _tkinter _tkinter.c tkappinit.c -DWITH_APPINIT -ltcl8.6 -ltk8.6 -lX11 -lxcb # -lXau
      EOF
      ''];
  buildInputs = [ pkgs.tzdata pkgs.zlib pkgs.zlib.dev pkgs.readline pkgs.readline.dev pkgs.bzip2 pkgs.bzip2.dev pkgs.ncurses pkgs.ncurses.dev pkgs.sqlite pkgs.sqlite.dev pkgs.openssl pkgs.openssl.dev pkgs.libuuid pkgs.libuuid.dev pkgs.gdbm pkgs.lzlib pkgs.tk pkgs.tk.dev pkgs.libffi pkgs.libffi.dev pkgs.expat pkgs.expat.dev pkgs.mailcap pkgs.xz pkgs.xz.dev ];
}
