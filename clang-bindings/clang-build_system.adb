pragma Style_Checks (Off);
pragma Warnings (Off, "*is already use-visible*");
pragma Warnings (Off, "*redundant with clause in body*");

with Interfaces.C;         use Interfaces.C;
pragma Unreferenced (Interfaces.C);
with Interfaces.C.Strings; use Interfaces.C.Strings;pragma Unreferenced (Interfaces.C.Strings);

package body Clang.Build_System is

   function Virtual_File_Overlay_Add_File_Mapping
     (Arg_1        : Virtual_File_Overlay_T;
      Virtual_Path : Interfaces.C.Strings.chars_ptr;
      Real_Path    : Interfaces.C.Strings.chars_ptr)
      return Clang.CX_Error_Code.Error_Code_T
   with Import => True,
        Convention => C,
        External_Name => "clang_VirtualFileOverlay_addFileMapping";
   function Virtual_File_Overlay_Add_File_Mapping
     (Arg_1        : Virtual_File_Overlay_T;
      Virtual_Path : String;
      Real_Path    : String)
      return Clang.CX_Error_Code.Error_Code_T
   is
      Return_Value        : Clang.CX_Error_Code.Error_Code_T;
      Virtual_Path_Array  : aliased char_array := To_C (Virtual_Path);
      Virtual_Path_String : constant chars_ptr := To_Chars_Ptr (Virtual_Path_Array'Unchecked_Access);
      Real_Path_Array     : aliased char_array := To_C (Real_Path);
      Real_Path_String    : constant chars_ptr := To_Chars_Ptr (Real_Path_Array'Unchecked_Access);
   begin
      Return_Value := Virtual_File_Overlay_Add_File_Mapping (Arg_1, Virtual_Path_String, Real_Path_String);
      return Return_Value;
   end Virtual_File_Overlay_Add_File_Mapping;

   function Module_Map_Descriptor_Set_Framework_Module_Name
     (Arg_1 : Module_Map_Descriptor_T;
      Name  : Interfaces.C.Strings.chars_ptr)
      return Clang.CX_Error_Code.Error_Code_T
   with Import => True,
        Convention => C,
        External_Name => "clang_ModuleMapDescriptor_setFrameworkModuleName";
   function Module_Map_Descriptor_Set_Framework_Module_Name
     (Arg_1 : Module_Map_Descriptor_T;
      Name  : String)
      return Clang.CX_Error_Code.Error_Code_T
   is
      Return_Value : Clang.CX_Error_Code.Error_Code_T;
      Name_Array   : aliased char_array := To_C (Name);
      Name_String  : constant chars_ptr := To_Chars_Ptr (Name_Array'Unchecked_Access);
   begin
      Return_Value := Module_Map_Descriptor_Set_Framework_Module_Name (Arg_1, Name_String);
      return Return_Value;
   end Module_Map_Descriptor_Set_Framework_Module_Name;

   function Module_Map_Descriptor_Set_Umbrella_Header
     (Arg_1 : Module_Map_Descriptor_T;
      Name  : Interfaces.C.Strings.chars_ptr)
      return Clang.CX_Error_Code.Error_Code_T
   with Import => True,
        Convention => C,
        External_Name => "clang_ModuleMapDescriptor_setUmbrellaHeader";
   function Module_Map_Descriptor_Set_Umbrella_Header
     (Arg_1 : Module_Map_Descriptor_T;
      Name  : String)
      return Clang.CX_Error_Code.Error_Code_T
   is
      Return_Value : Clang.CX_Error_Code.Error_Code_T;
      Name_Array   : aliased char_array := To_C (Name);
      Name_String  : constant chars_ptr := To_Chars_Ptr (Name_Array'Unchecked_Access);
   begin
      Return_Value := Module_Map_Descriptor_Set_Umbrella_Header (Arg_1, Name_String);
      return Return_Value;
   end Module_Map_Descriptor_Set_Umbrella_Header;

   procedure Module_Cache_Prune
     (Path           : Interfaces.C.Strings.chars_ptr;
      Prune_Interval : time_h.time_t;
      Prune_After    : time_h.time_t)
   with Import => True,
        Convention => C,
        External_Name => "clang_ModuleCache_prune";
   procedure Module_Cache_Prune
     (Path           : String;
      Prune_Interval : time_h.time_t;
      Prune_After    : time_h.time_t)
   is
      Path_Array  : aliased char_array := To_C (Path);
      Path_String : constant chars_ptr := To_Chars_Ptr (Path_Array'Unchecked_Access);
   begin
      Module_Cache_Prune (Path_String, Prune_Interval, Prune_After);
   end Module_Cache_Prune;

   procedure Module_Cache_Prune_With_Callback
     (Path           : Interfaces.C.Strings.chars_ptr;
      Prune_Interval : time_h.time_t;
      Prune_After    : time_h.time_t;
      Callback       : Module_Cache_Prune_Callback_T;
      User_Data      : System.Address)
   with Import => True,
        Convention => C,
        External_Name => "clang_ModuleCache_pruneWithCallback";
   procedure Module_Cache_Prune_With_Callback
     (Path           : String;
      Prune_Interval : time_h.time_t;
      Prune_After    : time_h.time_t;
      Callback       : Module_Cache_Prune_Callback_T;
      User_Data      : System.Address)
   is
      Path_Array  : aliased char_array := To_C (Path);
      Path_String : constant chars_ptr := To_Chars_Ptr (Path_Array'Unchecked_Access);
   begin
      Module_Cache_Prune_With_Callback (Path_String, Prune_Interval, Prune_After, Callback, User_Data);
   end Module_Cache_Prune_With_Callback;

end Clang.Build_System;
