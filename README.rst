NixOS 17: Compiling Python Even More Properly on NixOS
======================================================

- Companion to video at https://www.youtube.com/watch?v=yd8VvuNofvo

- See the other videos in this series by visiting the playlist at
  https://www.youtube.com/playlist?list=PLa01scHy0YEmg8trm421aYq4OtPD8u1SN

Video Script
------------

- In a prior video (entitled "How to Build Python Mostly Properly on NixOS" at
  https://www.youtube.com/watch?v=yLENUTfzuBg ), I took a baby step
  towards compiling software on NixOS properly using ``nix-shell``.  But,
  despite the title of the video, it was stil done mostly the wrong way.  The
  right way, instead of ``nix-shell``, is to use the Nix language, and its
  associated ecosystem, to create a *derivation*.

- Our baby step in a prior vid did the same thing, but the result is not great:
  Nix knows nothing about what we actually want.  Still worth watching the
  other vid, as it describes the environment.

- Our ``newchrism-py310.nix`` file::

    with rec {
      pkgs = import <nixpkgs> {};
    };

    pkgs.stdenv.mkDerivation {
      name = "chrism-py310";
      src = pkgs.fetchFromGitHub {
        owner = "python";
        repo = "cpython";
        rev = "v3.10.5"; # tag
        sha256 = pkgs.lib.fakeSha256;
      };
      buildInputs = [ pkgs.tzdata pkgs.zlib pkgs.zlib.dev pkgs.readline pkgs.readline.dev pkgs.bzip2 pkgs.bzip2.dev pkgs.ncurses pkgs.ncurses.dev pkgs.sqlite pkgs.sqlite.dev pkgs.openssl pkgs.openssl.dev pkgs.libuuid pkgs.libuuid.dev pkgs.gdbm pkgs.lzlib pkgs.tk pkgs.tk.dev pkgs.libffi pkgs.libffi.dev pkgs.expat pkgs.expat.dev pkgs.mailcap pkgs.xz pkgs.xz.dev ];
      ''
    ];
    }

- Job of a file related to packaging is to describe a *derivation*.

  https://edolstra.github.io/pubs/phd-thesis.pdf

  "For these reasons Nix expressions are not built directly; rather, they are
  translated to the more primitive language of ``store derivations``, which
  encode single component build actions."" See .drv files in nix store, which
  have absolute paths to input libraries, etc.

  In reality, the reason it's called a "derivation" is because it's *derived*
  from a Nix expression, which is important to Nix but maybe one of the least
  interesting things about it.  The thesis explains this.  If you don't know
  this, the name is curious.

  https://nixos.org/manual/nix/stable/expressions/derivations.html

  "The most important built-in function is ``derivation``, which is used to
  describe a single derivation (a build action)..."

- I haven't yet learned the Nix language.  E.g. still fuzzy on what this does::

   with rec {
     pkgs = import <nixpkgs> {};
   };

  I am not a language geek.  I learn as I go.  Proceed with partial knowledge.
  I look dumb, but its ok.  Head of Zeus / 10X developers.  Make a choice: it
  will be wrong.  It is the only way forward.

- A derivation is more fundamental than a "package."  Note that we are several
  levels above the bottom of Nix here with ``stdenv.makeDerivation``.
  (e.g. postPatch is a makeDerivation thing, not a derivation thing).
  
- The docs at https://nixos.wiki/wiki/Nixpkgs/Create_and_debug_packages really
  describe this higher level.

- There is lots of talk about a "builder" in nix docs that refer to the lowest
  level of Nix derivations.  But we aren't concerned about a ``builder`` here.
  That's because stdenv.makeDerivation uses a "generic" builder (actually
  /bin/sh, that executes
  ``/nix/store/720ikgx7yaapyb8hvi8lkicjqwzcx3xr-builder.sh`` (Note that a lot
  of Nix-on-UNIX is written in shell.)).

- Building a derivation happens in phases (unpackPhase configurePhase,
  installPhase, checkPhase).  postPatch is probably part of the patch phase, or
  maybe not.  This is all convention.

- See ``nix-build newchrism-py310.nix`` fail.

- ``pkgs.lib.fakeSha256``?  It's all hunt and peck.

- Add a postPatch to our mkDerivation call::

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


- ``pkgs.lib.concatStringsSep``: How did I find this?  It's all hunt and peck.

- See ``nix-build newchrism-py310.nix`` succeed.  Except it didn't do anything.
  We need to tell it really rebuild somehow.

- The stdout output of a derivation is its store path.

- We can try to delete the old derivation::

    sudo nix-store --delete /nix/store/2z8vdvxwkfz1ydqkvy7gn1z34iirxy96-chrism-py310

- But it won't allow it, because it's "live".

- How does Nix know that this derivation should be "kept"?  Well, it's
  "reachable from a garbage collector root".  This means that Nix keeps around
  a set of "roots" of derivations.  Once this root is removed, it knows it is
  safe to garbage collect all of the derivations for which the only root is
  the removed root.

- How do we find the root of our derivation?  Use the output of nix-build
  as an input to ``nix-store -q --roots``::

    sudo nix-store -q --roots /nix/store/2z8vdvxwkfz1ydqkvy7gn1z34iirxy96-chrism-py310

- Note "result".  This is the built output dir, a symlink to a directory in the
  store.

- How do we delete it even though it's "alive"::

    sudo nix-store --delete --ignore-liveness /nix/store/2z8vdvxwkfz1ydqkvy7gn1z34iirxy96-chrism-py310

- Wash, rinse, repeat for all *chrism-py* derivations::

    ls -al /nix/store |grep chrism-py 

- Rebuild.  Take a look at nix log of the derivation.

- Testing my derivation::

    import subprocess

    def run(cmd):
        proc = subprocess.Popen(
            cmd,
            shell=True,
            stdout = subprocess.PIPE,
            stderr = subprocess.PIPE,
            )
        return proc.communicate() # (stdout, stderr)

    store_path  = str(run('nix-build newchrism-py-3.10.nix')[0][:-1], 'utf-8')
    print(store_path)
    stdout, stderr = run(f'{store_path}/bin/python3 -c "import zlib; import readline; import lzma ; import sqlite3; import curses; import bz2; import ctypes; import ssl; import tkinter"')
    print((stdout, stderr))

- What is wrong with this derivation?  It isn't proven repeatable.  It's not
  particularly easy to rememnber its path.  Many build inputs aren't actually
  required.  We didn't run our command as the root user.  How do we signify
  that our configuration requires this derivative?  These are topics for the
  future.  But it's one more step along the path.
  
- Nixpkgs expression for rolling a Python derivation is much more complicated.
  e.g. https://github.com/NixOS/nixpkgs/blob/nixos-22.05/pkgs/development/interpreters/python/cpython/default.nix

