pragma Style_Checks (Off);
pragma Warnings (Off, "*is already use-visible*");
pragma Warnings (Off, "*redundant with clause in body*");

with Interfaces.C;         use Interfaces.C;
pragma Unreferenced (Interfaces.C);
with Interfaces.C.Strings; use Interfaces.C.Strings;pragma Unreferenced (Interfaces.C.Strings);

package body LLVM.Orc_EE is

   function Orc_Create_RT_Dyld_Object_Linking_Layer_With_Section_Memory_Manager_Reserve_Alloc
     (ES            : LLVM.Orc.Orc_Execution_Session_T;
      Reserve_Alloc : LLVM.Types.Bool_T)
      return LLVM.Orc.Orc_Object_Layer_T
   with Import => True,
        Convention => C,
        External_Name => "LLVMOrcCreateRTDyldObjectLinkingLayerWithSectionMemoryManagerReserveAlloc";
   function Orc_Create_RT_Dyld_Object_Linking_Layer_With_Section_Memory_Manager_Reserve_Alloc
     (ES            : LLVM.Orc.Orc_Execution_Session_T;
      Reserve_Alloc : Boolean)
      return LLVM.Orc.Orc_Object_Layer_T
   is
      Return_Value       : LLVM.Orc.Orc_Object_Layer_T;
      Reserve_Alloc_Bool : constant LLVM.Types.Bool_T := Boolean'Pos (Reserve_Alloc);
   begin
      Return_Value := Orc_Create_RT_Dyld_Object_Linking_Layer_With_Section_Memory_Manager_Reserve_Alloc (ES, Reserve_Alloc_Bool);
      return Return_Value;
   end Orc_Create_RT_Dyld_Object_Linking_Layer_With_Section_Memory_Manager_Reserve_Alloc;

end LLVM.Orc_EE;
