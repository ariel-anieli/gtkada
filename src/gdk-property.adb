-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 1998-1999                       --
--        Emmanuel Briot, Joel Brobecker and Arnaud Charlet          --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU General Public               --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- General Public License for more details.                          --
--                                                                   --
-- You should have received a copy of the GNU General Public         --
-- License along with this library; if not, write to the             --
-- Free Software Foundation, Inc., 59 Temple Place - Suite 330,      --
-- Boston, MA 02111-1307, USA.                                       --
--                                                                   --
-- As a special exception, if other files instantiate generics from  --
-- this unit, or you link this unit with other files to produce an   --
-- executable, this  unit  does not  by itself cause  the resulting  --
-- executable to be covered by the GNU General Public License. This  --
-- exception does not however invalidate any other reasons why the   --
-- executable file  might be covered by the  GNU Public License.     --
-----------------------------------------------------------------------

with Interfaces.C.Pointers;
with Interfaces.C.Strings;
with System;

package body Gdk.Property is

   --------------------------------------------------------------------
   --  Local declarations                                            --
   --------------------------------------------------------------------

   type Local_Guchar_Array is array (Natural range <>) of aliased Guchar;

   package Guchars_Ptr is new Interfaces.C.Pointers
     (Index => Natural,
      Element => Guchar,
      Element_Array => Local_Guchar_Array,
      Default_Terminator => 0);

   procedure C_Free (P : in Guchars_Ptr.Pointer);
   pragma Import (C, C_Free, "free");

   function To_Guchar_Array (Value : in Local_Guchar_Array)
                             return Guchar_Array;
   pragma Inline (To_Guchar_Array);


   --------------------------------------------------------------------
   --  The implementation part                                       --
   --------------------------------------------------------------------

   -----------------
   -- Atom_Intern --
   -----------------

   function Atom_Intern (Atom_Name      : in String;
                         Only_If_Exists : in Boolean)
                         return              Gdk.Types.Gdk_Atom
   is
      function Internal (Atom_Name      : in String;
                         Only_If_Exists : in Gint)
                         return              Gdk.Types.Gdk_Atom;
      pragma Import (C, Internal, "gdk_atom_intern");
   begin
      return Internal (Atom_Name & Ascii.NUL, To_Gint (Only_If_Exists));
   end Atom_Intern;

   ---------------
   -- Atom_Name --
   ---------------

   function Atom_Name (Atom   : in Gdk.Types.Gdk_Atom) return String
   is
      function Internal (Atom   : in Gdk.Types.Gdk_Atom)
                         return      Interfaces.C.Strings.chars_ptr;
      pragma Import (C, Internal, "gdk_atom_name");
   begin
      return Interfaces.C.Strings.Value (Internal (Atom));
   end Atom_Name;

   ------------
   -- Change --
   ------------

   procedure Change (Window    : in Gdk.Window.Gdk_Window;
                     Property  : in Gdk.Types.Gdk_Atom;
                     The_Type  : in Gdk.Types.Gdk_Atom;
                     Format    : in Gint;
                     Mode      : in Gdk.Types.Gdk_Prop_Mode;
                     Data      : in Guchar_Array) is
      procedure Internal (Window    : in System.Address;
                          Property  : in Gdk.Types.Gdk_Atom;
                          The_Type  : in Gdk.Types.Gdk_Atom;
                          Format    : in Gint;
                          Mode      : in Gdk.Types.Gdk_Prop_Mode;
                          Data      : in Guchar_Array;
                          Nelements : in Gint);
      pragma Import (C, Internal, "gdk_property_change");
   begin
      Internal (Get_Object (Window),
                Property,
                The_Type,
                Format,
                Mode,
                Data,
                Data'Length);
   end Change;


   ------------
   -- Delete --
   ------------

   procedure Delete (Window   : in Gdk.Window.Gdk_Window;
                     Property : in Gdk.Types.Gdk_Atom) is
      procedure Internal (Window   : in System.Address;
                          Property : in Gdk.Types.Gdk_Atom);
      pragma Import (C, Internal, "gdk_property_delete");
   begin
      Internal (Get_Object (Window), Property);
   end Delete;


   ---------
   -- Get --
   ---------

   procedure Get (Window               : in     Gdk.Window.Gdk_Window;
                  Property             : in     Gdk.Types.Gdk_Atom;
                  The_Type             : in     Gdk.Types.Gdk_Atom;
                  Offset               : in     Gulong;
                  Length               : in     Gulong;
                  Pdelete              : in     Boolean;
                  Actual_Property_Type :    out Gdk.Types.Gdk_Atom;
                  Actual_Format        :    out Gint;
                  Data                 :    out Guchar_Array_Access;
                  Success              :    out Boolean) is
      procedure Internal (Window               : in     System.Address;
                          Property             : in     Gdk.Types.Gdk_Atom;
                          The_Type             : in     Gdk.Types.Gdk_Atom;
                          Offset               : in     Gulong;
                          Length               : in     Gulong;
                          Pdelete              : in     Gint;
                          Actual_Property_Type :    out Gdk.Types.Gdk_Atom;
                          Actual_Format        :    out Gint;
                          Actual_Length        :    out Gint;
                          Data                 :    out Guchars_Ptr.Pointer;
                          Success              :    out Gint);
      pragma Import (C, Internal, "ada_gdk_property_get");
      Actual_Length : Gint;
      Tmp_Success : Gint;
      Tmp_Result : Guchars_Ptr.Pointer;
   begin

      Internal (Get_Object (Window),
                Property,
                The_Type,
                Offset,
                Length,
                To_Gint (Pdelete),
                Actual_Property_Type,
                Actual_Format,
                Actual_Length,
                Tmp_Result,
                Tmp_Success);

      Success := To_Boolean (Tmp_Success);
      Data := new Guchar_Array'
        (To_Guchar_Array
         (Guchars_Ptr.Value
          (Ref => Tmp_Result,
           Length => Interfaces.C.ptrdiff_t (Actual_Length))));

      C_Free (Tmp_Result);
   end Get;


   -----------------------
   --  To_Guchar_Array  --
   -----------------------

   function To_Guchar_Array (Value : in Local_Guchar_Array)
                             return Guchar_Array is
      Result : Guchar_Array (Value'Range);
   begin
      for Index in Value'Range loop
         Result (Index) := Value (Index);
      end loop;
      return Result;
   end To_Guchar_Array;

end Gdk.Property;
