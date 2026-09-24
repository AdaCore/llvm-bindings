pragma Ada_2012;

pragma Style_Checks (Off);
pragma Warnings (Off, "-gnatwu");

pragma Warnings (Off); with Interfaces.C; use Interfaces.C; pragma Warnings (On);
with Interfaces.C.Extensions;
with Interfaces.C.Strings;
with Clang.CX_Error_Code;
with System;
with time_h;

package Clang.Build_System is

  --==-- clang-c/BuildSystem.h - Utilities for use by build systems -*- C -*-===*|*                                                                            *|
  --|
  --|* Part of the LLVM Project, under the Apache License v2.0 with LLVM          *|
  --|* Exceptions.                                                                *|
  --|* See https://llvm.org/LICENSE.txt for license information.                  *|
  --|* SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception                    *|
  --|*                                                                            *|
  --|*===----------------------------------------------------------------------===*|
  --|*                                                                            *|
  --|* This header provides various utilities for use by build systems.           *|
  --|*                                                                            *|
  --\*===----------------------------------------------------------------------=== 

  --*
  -- * \defgroup BUILD_SYSTEM Build system utilities
  -- * @{
  --  

  --*
  -- * Return the timestamp for use with Clang's
  -- * \c -fbuild-session-timestamp= option.
  --  

   function Get_Build_Session_Timestamp return Extensions.unsigned_long_long  -- include/clang-c/BuildSystem.h:34
   with Import => True, 
        Convention => C, 
        External_Name => "clang_getBuildSessionTimestamp";

  --*
  -- * Object encapsulating information about overlaying virtual
  -- * file/directories over the real file system.
  --  

   type Virtual_File_Overlay_Impl_T is null record;   -- incomplete struct

   type Virtual_File_Overlay_T is access all Virtual_File_Overlay_Impl_T;  -- include/clang-c/BuildSystem.h:40

  --*
  -- * Create a \c CXVirtualFileOverlay object.
  -- * Must be disposed with \c clang_VirtualFileOverlay_dispose().
  -- *
  -- * \param options is reserved, always pass 0.
  --  

   function Virtual_File_Overlay_Create (Options : unsigned) return Virtual_File_Overlay_T  -- include/clang-c/BuildSystem.h:49
   with Import => True, 
        Convention => C, 
        External_Name => "clang_VirtualFileOverlay_create";

  --*
  -- * Map an absolute virtual file path to an absolute real one.
  -- * The virtual path must be canonicalized (not contain "."/"..").
  -- * \returns 0 for success, non-zero to indicate an error.
  --  

function Virtual_File_Overlay_Add_File_Mapping
     (Arg_1        : Virtual_File_Overlay_T;
      Virtual_Path : String;
      Real_Path    : String)
      return Clang.CX_Error_Code.Error_Code_T;

  --*
  -- * Set the case sensitivity for the \c CXVirtualFileOverlay object.
  -- * The \c CXVirtualFileOverlay object is case-sensitive by default, this
  -- * option can be used to override the default.
  -- * \returns 0 for success, non-zero to indicate an error.
  --  

   function Virtual_File_Overlay_Set_Case_Sensitivity (Arg_1 : Virtual_File_Overlay_T; Case_Sensitive : int) return Clang.CX_Error_Code.Error_Code_T  -- include/clang-c/BuildSystem.h:68
   with Import => True, 
        Convention => C, 
        External_Name => "clang_VirtualFileOverlay_setCaseSensitivity";

  --*
  -- * Write out the \c CXVirtualFileOverlay object to a char buffer.
  -- *
  -- * \param options is reserved, always pass 0.
  -- * \param out_buffer_ptr pointer to receive the buffer pointer, which should be
  -- * disposed using \c clang_free().
  -- * \param out_buffer_size pointer to receive the buffer size.
  -- * \returns 0 for success, non-zero to indicate an error.
  --  

   function Virtual_File_Overlay_Write_To_Buffer
     (Arg_1 : Virtual_File_Overlay_T;
      Options : unsigned;
      Out_Buffer_Ptr : System.Address;
      Out_Buffer_Size : access unsigned) return Clang.CX_Error_Code.Error_Code_T  -- include/clang-c/BuildSystem.h:81
   with Import => True, 
        Convention => C, 
        External_Name => "clang_VirtualFileOverlay_writeToBuffer";

  --*
  -- * free memory allocated by libclang, such as the buffer returned by
  -- * \c CXVirtualFileOverlay() or \c clang_ModuleMapDescriptor_writeToBuffer().
  -- *
  -- * \param buffer memory pointer to free.
  --  

   procedure Free (Buffer : System.Address)  -- include/clang-c/BuildSystem.h:91
   with Import => True, 
        Convention => C, 
        External_Name => "clang_free";

  --*
  -- * Dispose a \c CXVirtualFileOverlay object.
  --  

   procedure Virtual_File_Overlay_Dispose (Arg_1 : Virtual_File_Overlay_T)  -- include/clang-c/BuildSystem.h:96
   with Import => True, 
        Convention => C, 
        External_Name => "clang_VirtualFileOverlay_dispose";

  --*
  -- * Object encapsulating information about a module.modulemap file.
  --  

   type Module_Map_Descriptor_Impl_T is null record;   -- incomplete struct

   type Module_Map_Descriptor_T is access all Module_Map_Descriptor_Impl_T;  -- include/clang-c/BuildSystem.h:101

  --*
  -- * Create a \c CXModuleMapDescriptor object.
  -- * Must be disposed with \c clang_ModuleMapDescriptor_dispose().
  -- *
  -- * \param options is reserved, always pass 0.
  --  

   function Module_Map_Descriptor_Create (Options : unsigned) return Module_Map_Descriptor_T  -- include/clang-c/BuildSystem.h:110
   with Import => True, 
        Convention => C, 
        External_Name => "clang_ModuleMapDescriptor_create";

  --*
  -- * Sets the framework module name that the module.modulemap describes.
  -- * \returns 0 for success, non-zero to indicate an error.
  --  

function Module_Map_Descriptor_Set_Framework_Module_Name
     (Arg_1 : Module_Map_Descriptor_T;
      Name  : String)
      return Clang.CX_Error_Code.Error_Code_T;

  --*
  -- * Sets the umbrella header name that the module.modulemap describes.
  -- * \returns 0 for success, non-zero to indicate an error.
  --  

function Module_Map_Descriptor_Set_Umbrella_Header
     (Arg_1 : Module_Map_Descriptor_T;
      Name  : String)
      return Clang.CX_Error_Code.Error_Code_T;

  --*
  -- * Write out the \c CXModuleMapDescriptor object to a char buffer.
  -- *
  -- * \param options is reserved, always pass 0.
  -- * \param out_buffer_ptr pointer to receive the buffer pointer, which should be
  -- * disposed using \c clang_free().
  -- * \param out_buffer_size pointer to receive the buffer size.
  -- * \returns 0 for success, non-zero to indicate an error.
  --  

   function Module_Map_Descriptor_Write_To_Buffer
     (Arg_1 : Module_Map_Descriptor_T;
      Options : unsigned;
      Out_Buffer_Ptr : System.Address;
      Out_Buffer_Size : access unsigned) return Clang.CX_Error_Code.Error_Code_T  -- include/clang-c/BuildSystem.h:138
   with Import => True, 
        Convention => C, 
        External_Name => "clang_ModuleMapDescriptor_writeToBuffer";

  --*
  -- * Dispose a \c CXModuleMapDescriptor object.
  --  

   procedure Module_Map_Descriptor_Dispose (Arg_1 : Module_Map_Descriptor_T)  -- include/clang-c/BuildSystem.h:145
   with Import => True, 
        Convention => C, 
        External_Name => "clang_ModuleMapDescriptor_dispose";

  --*
  -- * Prune module files in the module cache directory that haven't been accessed
  -- * in a long time.
  -- *
  -- * \param Path the path to the module cache directory.
  -- *
  -- * \param PruneInterval the minimum time in seconds between two prune
  -- * operations. If the timestamp file is newer than this, pruning is skipped.
  -- *
  -- * \param PruneAfter the time in seconds after which unused module files are
  -- * removed.
  -- *
  --  

procedure Module_Cache_Prune
     (Path           : String;
      Prune_Interval : time_h.time_t;
      Prune_After    : time_h.time_t);

  --*
  -- * Callback invoked by \c clang_ModuleCache_pruneWithCallback() once for each
  -- * file or directory removed from the module cache.
  -- *
  -- * \param Path the absolute path of the file or directory that was pruned.
  -- * The pointer is only valid for the duration of the callback.
  -- *
  -- * \param UserData the opaque pointer passed to
  -- * \c clang_ModuleCache_pruneWithCallback().
  --  

   type Module_Cache_Prune_Callback_T is access procedure (Arg_1 : Interfaces.C.Strings.chars_ptr; Arg_2 : System.Address)
   with Convention => C;  -- include/clang-c/BuildSystem.h:174

  --*
  -- * Variant of \c clang_ModuleCache_prune() that invokes \p Callback once for
  -- * each absolute path removed from the cache. This includes pruned \c .pcm
  -- * files, their companion \c .timestamp files, and any cache subdirectory that
  -- * becomes empty as a result of pruning.
  -- *
  -- * \param Path the path to the module cache directory.
  -- *
  -- * \param PruneInterval the minimum time in seconds between two prune
  -- * operations. If the timestamp file is newer than this, pruning is skipped.
  -- *
  -- * \param PruneAfter the time in seconds after which unused module files are
  -- * removed.
  -- *
  -- * \param Callback invoked for each pruned absolute path. May be NULL, in
  -- * which case this function behaves like \c clang_ModuleCache_prune().
  -- *
  -- * \param UserData opaque pointer passed through to \p Callback.
  --  

procedure Module_Cache_Prune_With_Callback
     (Path           : String;
      Prune_Interval : time_h.time_t;
      Prune_After    : time_h.time_t;
      Callback       : Module_Cache_Prune_Callback_T;
      User_Data      : System.Address);

  --*
  -- * @}
  --  

end Clang.Build_System;

pragma Style_Checks (On);
pragma Warnings (On, "-gnatwu");
