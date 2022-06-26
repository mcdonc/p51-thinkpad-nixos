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
