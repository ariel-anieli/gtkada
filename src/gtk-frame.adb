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

with System;
with Gdk; use Gdk;

package body Gtk.Frame is

   -------------
   -- Gtk_New --
   -------------

   procedure Gtk_New (Widget : out Gtk_Frame;
                      Label  : in String := "")
   is
      function Internal (Label  : in String)
                         return      System.Address;
      pragma Import (C, Internal, "gtk_frame_new");
   begin
      Set_Object (Widget, Internal (Label & Ascii.NUL));
   end Gtk_New;

   ---------------
   -- Set_Label --
   ---------------

   procedure Set_Label
      (Frame : in Gtk_Frame;
       Label : in String)
   is
      procedure Internal
         (Frame : in System.Address;
          Label : in String);
      pragma Import (C, Internal, "gtk_frame_set_label");
   begin
      Internal (Get_Object (Frame),
                Label & Ascii.NUL);
   end Set_Label;

   ---------------------
   -- Set_Label_Align --
   ---------------------

   procedure Set_Label_Align
      (Frame  : in Gtk_Frame;
       Xalign : in Gfloat;
       Yalign : in Gfloat)
   is
      procedure Internal
         (Frame  : in System.Address;
          Xalign : in Gfloat;
          Yalign : in Gfloat);
      pragma Import (C, Internal, "gtk_frame_set_label_align");
   begin
      Internal (Get_Object (Frame),
                Xalign,
                Yalign);
   end Set_Label_Align;

   ---------------------
   -- Set_Shadow_Type --
   ---------------------

   procedure Set_Shadow_Type
      (Frame    : in Gtk_Frame;
       The_Type : in Gtk_Shadow_Type)
   is
      procedure Internal
         (Frame    : in System.Address;
          The_Type : in Gint);
      pragma Import (C, Internal, "gtk_frame_set_shadow_type");
   begin
      Internal (Get_Object (Frame),
                Gtk_Shadow_Type'Pos (The_Type));
   end Set_Shadow_Type;

end Gtk.Frame;
