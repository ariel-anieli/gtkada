-----------------------------------------------------------------------
--               GtkAda - Ada95 binding for Gtk+/Gnome               --
--                                                                   --
--   Copyright (C) 1998-2000 E. Briot, J. Brobecker and A. Charlet   --
--                Copyright (C) 2000-2001 ACT-Europe                 --
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

--  This package is deprecated.
--  <c_version>1.3.4</c_version>

with Gtk.Adjustment;
with Gtk.Widget;

package Gtk.Progress is

   type Gtk_Progress_Record is new Gtk.Widget.Gtk_Widget_Record with private;
   type Gtk_Progress is access all Gtk_Progress_Record'Class;

   function Get_Type return Glib.GType;
   --  Return the internal value associated with a Gtk_Progress.

   function Get_Current_Percentage
     (Progress : access Gtk_Progress_Record) return Gdouble;

   function Get_Current_Text
     (Progress : access Gtk_Progress_Record) return String;

   function Get_Percentage_From_Value
     (Progress : access Gtk_Progress_Record;
      Value    : Gdouble) return Gdouble;

   function Get_Text_From_Value
     (Progress : access Gtk_Progress_Record;
      Value    : Gdouble) return String;

   function Get_Value (Progress : access Gtk_Progress_Record) return Gdouble;

   function Get_Adjustment
     (Widget : access Gtk_Progress_Record)
      return Gtk.Adjustment.Gtk_Adjustment;

   procedure Configure
     (Progress : access Gtk_Progress_Record;
      Value    : Gdouble;
      Min      : Gdouble;
      Max      : Gdouble);

   procedure Set_Activity_Mode
     (Progress      : access Gtk_Progress_Record;
      Activity_Mode : Boolean);

   function Get_Activity_Mode
     (Progress : access Gtk_Progress_Record) return Boolean;

   procedure Set_Adjustment
     (Progress   : access Gtk_Progress_Record;
      Adjustment : Gtk.Adjustment.Gtk_Adjustment);

   procedure Set_Format_String
     (Progress : access Gtk_Progress_Record;
      Format   : String);

   procedure Set_Percentage
     (Progress   : access Gtk_Progress_Record;
      Percentage : Gdouble);

   procedure Set_Show_Text
     (Progress  : access Gtk_Progress_Record;
      Show_Text : Boolean);

   procedure Set_Text_Alignment
     (Progress : access Gtk_Progress_Record;
      X_Align  : Gfloat;
      Y_Align  : Gfloat);

   procedure Set_Value
     (Progress : access Gtk_Progress_Record;
      Value    : Gdouble);

private
   type Gtk_Progress_Record is new Gtk.Widget.Gtk_Widget_Record
     with null record;

   pragma Import (C, Get_Type, "gtk_progress_get_type");
end Gtk.Progress;
