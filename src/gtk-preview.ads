-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
-- Copyright (C) 1998 Emmanuel Briot and Joel Brobecker              --
--                                                                   --
-- This library is free software; you can redistribute it and/or     --
-- modify it under the terms of the GNU Library General Public       --
-- License as published by the Free Software Foundation; either      --
-- version 2 of the License, or (at your option) any later version.  --
--                                                                   --
-- This library is distributed in the hope that it will be useful,   --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of    --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU --
-- Library General Public License for more details.                  --
--                                                                   --
-- You should have received a copy of the GNU Library General Public --
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

with Gdk.Color;
with Gdk.GC;
with Gdk.Visual;
with Gdk.Window;
with Gtk.Enums; use Gtk.Enums;
with Gtk.Widget;

package Gtk.Preview is

   type Gtk_Preview is new Gtk.Widget.Gtk_Widget with private;
   type Gtk_Preview_Info is new Gtk.Widget.Gtk_Widget with private;

   procedure Draw_Row
      (Preview : in Gtk_Preview'Class;
       Data    : in Guchar_Array;
       X       : in Gint;
       Y       : in Gint;
       W       : in Gint);
   --  The size required for Data depends of the color depth of the
   --  preview. No verification is done by Ada, everything is left to
   --  gtk. You might get some segmentation fault !
   --  for a color preview, Data'Length = W * 3  (for R, G ,B)
   --  for a grey preview, Data'Length = W;

   function Get_Cmap return Gdk.Color.Gdk_Colormap'Class;
   function Get_Info return Gtk_Preview_Info;
   function Get_Visual return Gdk.Visual.Gdk_Visual'Class;
   procedure Gtk_New (Widget   : out Gtk_Preview;
                      The_Type : in Gtk_Preview_Type);
   procedure Put
      (Preview : in Gtk_Preview'Class;
       Window  : in Gdk.Window.Gdk_Window'Class;
       Gc      : in Gdk.GC.Gdk_GC'Class;
       Srcx    : in Gint;
       Srcy    : in Gint;
       Destx   : in Gint;
       Desty   : in Gint;
       Width   : in Gint;
       Height  : in Gint);
   procedure Put_Row
      (Preview : in Gtk_Preview'Class;
       Src     : in Guchar_Array;
       Dest    : in Guchar_Array;
       X       : in Gint;
       Y       : in Gint;
       W       : in Gint);
   --  For a color preview, Src'Length = W * 3
   --  For a grey preview, Src'Length = W
   --  The size of depth depends of the depth of the screen

   procedure Reset;
   procedure Set_Color_Cube
      (Nred_Shades   : in Guint;
       Ngreen_Shades : in Guint;
       Nblue_Shades  : in Guint;
       Ngray_Shades  : in Guint);
   procedure Set_Expand
      (Preview : in Gtk_Preview'Class;
       Expand  : in Gint);
   procedure Set_Gamma (Gamma : in Gdouble);
   procedure Set_Install_Cmap (Install_Cmap : in Gint);
   procedure Set_Reserved (Nreserved : in Gint);
   procedure Size
      (Preview : in Gtk_Preview'Class;
       Width   : in Gint;
       Height  : in Gint);
   procedure Uninit;

private
   type Gtk_Preview is new Gtk.Widget.Gtk_Widget with null record;
   type Gtk_Preview_Info is new Gtk.Widget.Gtk_Widget with null record;

   --  mapping: Draw_Row gtkpreview.h gtk_preview_draw_row
   --  mapping: Get_Cmap gtkpreview.h gtk_preview_get_cmap
   --  mapping: Get_Info gtkpreview.h gtk_preview_get_info
   --  mapping: NOT_IMPLEMENTED gtkpreview.h gtk_preview_get_type
   --  mapping: Get_Visual gtkpreview.h gtk_preview_get_visual
   --  mapping: Gtk_New gtkpreview.h gtk_preview_new
   --  mapping: Put gtkpreview.h gtk_preview_put
   --  mapping: Put_Row gtkpreview.h gtk_preview_put_row
   --  mapping: Reset gtkpreview.h gtk_preview_reset
   --  mapping: Set_Color_Cube gtkpreview.h gtk_preview_set_color_cube
   --  mapping: Set_Expand gtkpreview.h gtk_preview_set_expand
   --  mapping: Set_Gamma gtkpreview.h gtk_preview_set_gamma
   --  mapping: Set_Install_Cmap gtkpreview.h gtk_preview_set_install_cmap
   --  mapping: Set_Reserved gtkpreview.h gtk_preview_set_reserved
   --  mapping: Size gtkpreview.h gtk_preview_size
   --  mapping: Uninit gtkpreview.h gtk_preview_uninit
end Gtk.Preview;
