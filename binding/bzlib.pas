//
// bzlib.h header binding for the Free Pascal Compiler aka FPC
//
// Binaries and demos available at http://www.djmaster.com/
//

(*-------------------------------------------------------------*)
(*--- Public header file for the library.                   ---*)
(*---                                               bzlib.h ---*)
(*-------------------------------------------------------------*)

(* ------------------------------------------------------------------
   This file is part of bzip2/libbzip2, a program and library for
   lossless, block-sorting data compression.

   bzip2/libbzip2 version 1.0.6 of 6 September 2010
   Copyright (C) 1996-2010 Julian Seward <jseward@bzip.org>

   Please read the WARNING, DISCLAIMER and PATENTS sections in the 
   README file.

   This program is released under the terms of the license contained
   in the file LICENSE.
   ------------------------------------------------------------------ *)

unit bzlib;

{$mode objfpc}{$H+}

interface

uses
  ctypes;

const
  LIB_BZLIB = 'libbz2-1.dll';

const
  BZ_RUN = 0;
  BZ_FLUSH = 1;
  BZ_FINISH = 2;

  BZ_OK = 0;
  BZ_RUN_OK = 1;
  BZ_FLUSH_OK = 2;
  BZ_FINISH_OK = 3;
  BZ_STREAM_END = 4;
  BZ_SEQUENCE_ERROR = (-1);
  BZ_PARAM_ERROR = (-2);
  BZ_MEM_ERROR = (-3);
  BZ_DATA_ERROR = (-4);
  BZ_DATA_ERROR_MAGIC = (-5);
  BZ_IO_ERROR = (-6);
  BZ_UNEXPECTED_EOF = (-7);
  BZ_OUTBUFF_FULL = (-8);
  BZ_CONFIG_ERROR = (-9);

type
  Tbzalloc = function (data: pointer; items: cint; size: cint): pointer; cdecl;
  Tbzfree = procedure (data: pointer; block: pointer); cdecl;
  pbz_stream = ^bz_stream;
  bz_stream = record 
    next_in: pchar;
    avail_in: cuint;
    total_in_lo32: cuint;
    total_in_hi32: cuint;
  
    next_out: pchar;
    avail_out: cuint;
    total_out_lo32: cuint;
    total_out_hi32: cuint;
  
    state: pointer;
  
    bzalloc: Tbzalloc;
    bzfree: Tbzfree;
    opaque: pointer;
  end;


// #ifndef BZ_IMPORT
// #define BZ_EXPORT
// #endif
// 
// #ifndef BZ_NO_STDIO
// (* Need a definitition for FILE *)
// #include <stdio.h>
// #endif
// 
// #if defined(_WIN32) && !defined(__CYGWIN__)
// #   include <windows.h>
// #   ifdef small
//       (* windows.h define small to char *)
// #      undef small
// #   endif
// #   ifndef __GNUC__
//        (* Use these rules only for non-gcc native win32 *)
// #      ifdef BZ_EXPORT
// #      define BZ_API(func) WINAPI func
// #      define BZ_EXTERN extern
// #      else
//        (* import windows dll dynamically *)
// #      define BZ_API(func) (WINAPI * func)
// #      define BZ_EXTERN
// #      endif
// #   else
//        (* For gcc on native win32, use import library trampoline       *)
//        (* functions on DLL import.  This avoids requiring clients to   *)
//        (* use special compilation flags depending on whether eventual  *)
//        (* link will be against static libbz2 or against DLL, at the    *)
//        (* expense of a small loss of efficiency. *)
// 
//        (* Because libbz2 does not export any DATA items, GNU ld's      *)
//        (* "auto-import" is not a factor; the MinGW-built DLL can be    *)
//        (* used by other compilers, provided an import library suitable *)
//        (* for that compiler is (manually) constructed using the .def   *)
//        (* file and the appropriate tool. *)
// #      define BZ_API(func) func
// #      define BZ_EXTERN extern
// #   endif
// #else
//     (* non-win32 platforms, and cygwin *)
// #   define BZ_API(func) func
// #   define BZ_EXTERN extern
// #endif


(*-- Core (low-level) library functions --*)

function BZ2_bzCompressInit(strm: pbz_stream; blockSize100k: cint; verbosity: cint; workFactor: cint): cint; cdecl; external LIB_BZLIB;

function BZ2_bzCompress(strm: pbz_stream; action: cint): cint; cdecl; external LIB_BZLIB;

function BZ2_bzCompressEnd(strm: pbz_stream): cint; cdecl; external LIB_BZLIB;

function BZ2_bzDecompressInit(strm: pbz_stream; verbosity: cint; small: cint): cint; cdecl; external LIB_BZLIB;

function BZ2_bzDecompress(strm: pbz_stream): cint; cdecl; external LIB_BZLIB;

function BZ2_bzDecompressEnd(strm: pbz_stream): cint; cdecl; external LIB_BZLIB;


(*-- High(er) level library functions --*)

// #ifndef BZ_NO_STDIO
const
  BZ_MAX_UNUSED = 5000;

type
  PBZFILE = ^BZFILE;
  BZFILE = record
  end;

function BZ2_bzReadOpen(bzerror: pcint; f: pointer; verbosity: cint; small: cint; unused: pointer; nUnused: cint): PBZFILE; cdecl; external LIB_BZLIB;

procedure BZ2_bzReadClose(bzerror: pcint; b: PBZFILE); cdecl; external LIB_BZLIB;

procedure BZ2_bzReadGetUnused(bzerror: pcint; b: PBZFILE; unused: pointer; nUnused: pcint); cdecl; external LIB_BZLIB;

function BZ2_bzRead(bzerror: pcint; b: PBZFILE; buf: pointer; len: cint): cint; cdecl; external LIB_BZLIB;

function BZ2_bzWriteOpen(bzerror: pcint; f: pointer; blockSize100k: cint; verbosity: cint; workFactor: cint): PBZFILE; cdecl; external LIB_BZLIB;

procedure BZ2_bzWrite(bzerror: pcint; b: PBZFILE; buf: pointer; len: cint); cdecl; external LIB_BZLIB;

procedure BZ2_bzWriteClose(bzerror: pcint; b: PBZFILE; abandon: cint; nbytes_in: pcuint; nbytes_out: pcuint); cdecl; external LIB_BZLIB;

procedure BZ2_bzWriteClose64(bzerror: pcint; b: PBZFILE; abandon: cint; nbytes_in_lo32: pcuint; nbytes_in_hi32: pcuint; nbytes_out_lo32: pcuint; nbytes_out_hi32: pcuint); cdecl; external LIB_BZLIB;
// #endif


(*-- Utility functions --*)

function BZ2_bzBuffToBuffCompress(dest: pchar; destLen: pcuint; source: pchar; sourceLen: cuint; blockSize100k: cint; verbosity: cint; workFactor: cint): cint; cdecl; external LIB_BZLIB;

function BZ2_bzBuffToBuffDecompress(dest: pchar; destLen: pcuint; source: pchar; sourceLen: cuint; small: cint; verbosity: cint): cint; cdecl; external LIB_BZLIB;


(*--
   Code contributed by Yoshioka Tsuneo (tsuneo@rr.iij4u.or.jp)
   to support better zlib compatibility.
   This code is not _officially_ part of libbzip2 (yet);
   I haven't tested it, documented it, or considered the
   threading-safeness of it.
   If this code breaks, please contact both Yoshioka and me.
--*)

function BZ2_bzlibVersion(): pchar; cdecl; external LIB_BZLIB;

// #ifndef BZ_NO_STDIO
function BZ2_bzopen(const path: pchar; const mode: pchar): PBZFILE; cdecl; external LIB_BZLIB;

function BZ2_bzdopen(fd: cint; const mode: pchar): PBZFILE; cdecl; external LIB_BZLIB;
        
function BZ2_bzread(b: PBZFILE; buf: pointer; len: cint): cint; cdecl; external LIB_BZLIB;

function BZ2_bzwrite(b: PBZFILE; buf: pointer; len: cint): cint; cdecl; external LIB_BZLIB;

function BZ2_bzflush(b: PBZFILE): cint; cdecl; external LIB_BZLIB;

procedure BZ2_bzclose(b: PBZFILE); cdecl; external LIB_BZLIB;

function BZ2_bzerror(b: PBZFILE; errnum: pcint): pchar; cdecl; external LIB_BZLIB;
// #endif


(*-------------------------------------------------------------*)
(*--- end                                           bzlib.h ---*)
(*-------------------------------------------------------------*)


implementation


end.

