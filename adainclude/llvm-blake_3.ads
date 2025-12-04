pragma Ada_2012;

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

pragma Warnings (Off); with Interfaces.C; use Interfaces.C; pragma Warnings (On);
with stdint_h;
with Interfaces.C.Strings;
with System;
with stddef_h;

package LLVM.Blake_3 is

   BLAKE3_VERSION_STRING : aliased constant String := "1.8.2" & ASCII.NUL;  --  include/llvm-c/blake3.h:28
   LLVM_BLAKE3_KEY_LEN : constant := 32;  --  include/llvm-c/blake3.h:29
   LLVM_BLAKE3_OUT_LEN : constant := 32;  --  include/llvm-c/blake3.h:30
   LLVM_BLAKE3_BLOCK_LEN : constant := 64;  --  include/llvm-c/blake3.h:31
   LLVM_BLAKE3_CHUNK_LEN : constant := 1024;  --  include/llvm-c/blake3.h:32
   LLVM_BLAKE3_MAX_DEPTH : constant := 54;  --  include/llvm-c/blake3.h:33

  --===-- llvm-c/blake3.h - BLAKE3 C Interface ----------------------*- C -*-===*|*                                                                            *|
  --|
  --|* Released into the public domain with CC0 1.0                               *|
  --|* See 'llvm/lib/Support/BLAKE3/LICENSE' for info.                            *|
  --|* SPDX-License-Identifier: CC0-1.0                                           *|
  --|*                                                                            *|
  --|*===----------------------------------------------------------------------===*|
  --|*                                                                            *|
  --|* This header declares the C interface to LLVM's BLAKE3 implementation.      *|
  --|* Original BLAKE3 C API: https://github.com/BLAKE3-team/BLAKE3/tree/1.3.1/c  *|
  --|*                                                                            *|
  --|* Symbols are prefixed with 'llvm' to avoid a potential conflict with        *|
  --|* another BLAKE3 version within the same program.                            *|
  --|*                                                                            *|
  --\*===----------------------------------------------------------------------=== 

  -- This struct is a private implementation detail. It has to be here because
  -- it's part of llvm_blake3_hasher below.
   type anon_array1129 is array (0 .. 7) of aliased stdint_h.uint32_t;
   type anon_array1132 is array (0 .. 63) of aliased stdint_h.uint8_t;
   type Blake_3_Chunk_State_T is record
      cv : aliased anon_array1129;  -- include/llvm-c/blake3.h:38
      chunk_counter : aliased stdint_h.uint64_t;  -- include/llvm-c/blake3.h:39
      buf : aliased anon_array1132;  -- include/llvm-c/blake3.h:40
      buf_len : aliased stdint_h.uint8_t;  -- include/llvm-c/blake3.h:41
      blocks_compressed : aliased stdint_h.uint8_t;  -- include/llvm-c/blake3.h:42
      flags : aliased stdint_h.uint8_t;  -- include/llvm-c/blake3.h:43
   end record
   with Convention => C_Pass_By_Copy;  -- include/llvm-c/blake3.h:44

   type anon_array1137 is array (0 .. 1759) of aliased stdint_h.uint8_t;
   type Blake_3_Hasher_T is record
      key : aliased anon_array1129;  -- include/llvm-c/blake3.h:47
      chunk : aliased Blake_3_Chunk_State_T;  -- include/llvm-c/blake3.h:48
      cv_stack_len : aliased stdint_h.uint8_t;  -- include/llvm-c/blake3.h:49
      cv_stack : aliased anon_array1137;  -- include/llvm-c/blake3.h:55
   end record
   with Convention => C_Pass_By_Copy;  -- include/llvm-c/blake3.h:56

  -- The stack size is MAX_DEPTH + 1 because we do lazy merging. For example,
  -- with 7 chunks, we have 3 entries in the stack. Adding an 8th chunk
  -- requires a 4th entry, rather than merging everything down to 1, because we
  -- don't know whether more input is coming. This is different from how the
  -- reference implementation does things.
function Blake_3_Version
      return String;

   procedure Blake_3_Hasher_Init (Self : access Blake_3_Hasher_T)  -- include/llvm-c/blake3.h:59
   with Import => True, 
        Convention => C, 
        External_Name => "llvm_blake3_hasher_init";

   procedure Blake_3_Hasher_Init_Keyed (Self : access Blake_3_Hasher_T; Key : access stdint_h.uint8_t)  -- include/llvm-c/blake3.h:61
   with Import => True, 
        Convention => C, 
        External_Name => "llvm_blake3_hasher_init_keyed";

procedure Blake_3_Hasher_Init_Derive_Key
     (Self    : access Blake_3_Hasher_T;
      Context : String);

   procedure Blake_3_Hasher_Init_Derive_Key_Raw
     (Self : access Blake_3_Hasher_T;
      Context : System.Address;
      Context_Len : stddef_h.size_t)  -- include/llvm-c/blake3.h:65
   with Import => True, 
        Convention => C, 
        External_Name => "llvm_blake3_hasher_init_derive_key_raw";

   procedure Blake_3_Hasher_Update
     (Self : access Blake_3_Hasher_T;
      Input : System.Address;
      Input_Len : stddef_h.size_t)  -- include/llvm-c/blake3.h:68
   with Import => True, 
        Convention => C, 
        External_Name => "llvm_blake3_hasher_update";

   procedure Blake_3_Hasher_Finalize
     (Self : access constant Blake_3_Hasher_T;
      C_Out : access stdint_h.uint8_t;
      Out_Len : stddef_h.size_t)  -- include/llvm-c/blake3.h:70
   with Import => True, 
        Convention => C, 
        External_Name => "llvm_blake3_hasher_finalize";

   procedure Blake_3_Hasher_Finalize_Seek
     (Self : access constant Blake_3_Hasher_T;
      Seek : stdint_h.uint64_t;
      C_Out : access stdint_h.uint8_t;
      Out_Len : stddef_h.size_t)  -- include/llvm-c/blake3.h:72
   with Import => True, 
        Convention => C, 
        External_Name => "llvm_blake3_hasher_finalize_seek";

   procedure Blake_3_Hasher_Reset (Self : access Blake_3_Hasher_T)  -- include/llvm-c/blake3.h:75
   with Import => True, 
        Convention => C, 
        External_Name => "llvm_blake3_hasher_reset";

end LLVM.Blake_3;

pragma Style_Checks (On);
pragma Warnings (On, "-gnatwu");
