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

with System;

package body Gdk.Color is

   -----------
   -- Equal --
   -----------

   function Equal (Colora, Colorb : Gdk_Color) return Boolean is
   begin
      return Colora.Red = Colorb.Red
        and then Colora.Blue = Colorb.Blue
        and then Colora.Green = Colorb.Green;
   end Equal;

   -----------
   -- Alloc --
   -----------

   procedure Alloc
     (Colormap   : Gdk_Colormap;
      Contiguous : Boolean;
      Planes     : Gulong_Array;
      Pixels     : Gulong_Array;
      Succeeded  : out Boolean)
   is
      function Internal
        (Colormap   : Gdk_Colormap;
         Contiguous : Gint;
         Planes     : Gulong_Array;
         Nplanes    : Gint;
         Pixels     : Gulong_Array;
         Npixels    : Gint) return Gint;
      pragma Import (C, Internal, "gdk_colors_alloc");

   begin
      Succeeded :=
        Boolean'Val
          (Internal
            (Colormap, To_Gint (Contiguous), Planes, Planes'Length,
             Pixels, Pixels'Length));
   end Alloc;

   -----------
   -- Alloc --
   -----------

   procedure Alloc
     (Colormap  : Gdk_Colormap;
      Color     : in out Gdk_Color)
   is
      function Internal
        (Colormap : Gdk_Colormap;
         Color    : System.Address) return Gint;
      pragma Import (C, Internal, "gdk_color_alloc");

      Col : aliased Gdk_Color := Color;
      --  Need to use a local variable to avoid problems with 'Address if
      --  the parameter is passed in a register for instance.

   begin
      if not Boolean'Val (Internal (Colormap, Col'Address)) then
         raise Wrong_Color;
      end if;

      Color := Col;
   end Alloc;

   -----------------
   -- Alloc_Color --
   -----------------

   procedure Alloc_Color
     (Colormap   : Gdk_Colormap;
      Color      : in out Gdk_Color;
      Writeable  : Boolean := False;
      Best_Match : Boolean := True;
      Success    : out Boolean)
   is
      function Internal
        (Colormap   : Gdk_Colormap;
         Color      : System.Address;
         Writeable  : Gboolean;
         Best_Match : Gboolean) return Gboolean;
      pragma Import (C, Internal, "gdk_colormap_alloc_color");

      Col : aliased Gdk_Color := Color;
      --  Need to use a local variable to avoid problems with 'Address if
      --  the parameter is passed in a register for instance.

   begin
      Success :=
        Boolean'Val
          (Internal
            (Colormap, Col'Address,
             To_Gboolean (Writeable), To_Gboolean (Best_Match)));
      Color := Col;
   end Alloc_Color;

   ------------------
   -- Alloc_Colors --
   ------------------

   procedure Alloc_Colors
     (Colormap   : Gdk_Colormap;
      Colors     : in out Gdk_Color_Array;
      Writeable  : Boolean := False;
      Best_Match : Boolean := True;
      Success    : out Boolean_Array;
      Result     : out Gint)
   is
      function Internal
        (Colormap   : Gdk_Colormap;
         Colors     : System.Address;
         N_Colors   : Gint;
         Writeable  : Gboolean;
         Best_Match : Gboolean;
         Success    : System.Address) return Gint;
      pragma Import (C, Internal, "gdk_colormap_alloc_colors");

      Tmp : Gboolean_Array (Colors'Range);

   begin
      Result :=
        Internal
          (Colormap,
           Colors'Address,
           Colors'Length,
           To_Gboolean (Writeable),
           To_Gboolean (Best_Match),
           Tmp (Tmp'First)'Address);
      Success := To_Boolean_Array (Tmp);
   end Alloc_Colors;

   -----------
   -- Black --
   -----------

   function Black (Colormap : Gdk_Colormap) return Gdk_Color is
      function Internal
        (Colormap : Gdk_Colormap; Color : System.Address) return Gint;
      pragma Import (C, Internal, "gdk_color_black");

      Color : aliased Gdk_Color;

   begin
      if not To_Boolean (Internal (Colormap, Color'Address)) then
         raise Wrong_Color;
      end if;

      return Color;
   end Black;

   ----------
   -- Blue --
   ----------

   function Blue (Color : Gdk_Color) return Guint16 is
   begin
      return Color.Blue;
   end Blue;

   ------------
   -- Change --
   ------------

   procedure Change (Colormap : Gdk_Colormap; Ncolors : Gint) is
      procedure Internal (Colormap : Gdk_Colormap; Ncolors : Gint);
      pragma Import (C, Internal, "gdk_colormap_change");

   begin
      Internal (Colormap, Ncolors);
   end Change;

   procedure Change
     (Colormap  : Gdk_Colormap;
      Color     : in out Gdk_Color;
      Succeeded : out Boolean)
   is
      function Internal
        (Colormap : Gdk_Colormap; Color : System.Address) return Gint;
      pragma Import (C, Internal, "gdk_color_change");

      Col : aliased Gdk_Color := Color;
      --  Need to use a local variable to avoid problems with 'Address if
      --  the parameter is passed in a register for instance.

   begin
      Succeeded := To_Boolean (Internal (Colormap, Col'Address));
      Color := Col;
   end Change;

   ----------
   -- Copy --
   ----------

   procedure Copy (Source : Gdk_Color; Destination : out Gdk_Color) is
      function Internal (Source : System.Address) return System.Address;
      pragma Import (C, Internal, "gdk_color_copy");

      Result : aliased Gdk_Color;
      for Result'Address use Internal (Source'Address);

   begin
      Destination := Result;
   end Copy;

   ----------
   -- Free --
   ----------

   procedure Free (Color : Gdk_Color) is
      procedure Internal (Color : Gdk_Color);
      pragma Import (C, Internal, "gdk_color_free");

   begin
      Internal (Color);
   end Free;

   procedure Free
     (Colormap : Gdk_Colormap;
      Pixels   : Gulong_Array;
      Planes   : Gulong)
   is
      procedure Internal
        (Colormap : Gdk_Colormap;
         Pixels   : Gulong_Array;
         NPixels  : Gint;
         Planes   : Gulong);
      pragma Import (C, Internal, "gdk_colors_free");

   begin
      Internal (Colormap, Pixels, Pixels'Length, Planes);
   end Free;

   -----------------
   -- Free_Colors --
   -----------------

   procedure Free_Colors
     (Colormap : Gdk_Colormap;
      Colors   : Gdk_Color_Array)
   is
      procedure Internal
        (Colormap : Gdk_Colormap;
         Colors   : Gdk_Color_Array;
         Ncolors  : Gint);
      pragma Import (C, Internal, "gdk_colormap_free_colors");

   begin
      Internal (Colormap, Colors, Colors'Length);
   end Free_Colors;

   -------------
   -- Gdk_New --
   -------------

   procedure Gdk_New
     (Colormap     : out Gdk_Colormap;
      Visual       : Gdk.Visual.Gdk_Visual;
      Private_Cmap : Boolean)
   is
      function Internal
        (Visual       : Gdk.Visual.Gdk_Visual;
         Private_Cmap : Gint) return Gdk_Colormap;
      pragma Import (C, Internal, "gdk_colormap_new");

   begin
      Colormap := Internal (Visual, Boolean'Pos (Private_Cmap));
   end Gdk_New;

   ----------------
   -- Get_Visual --
   ----------------

   procedure Get_Visual
     (Colormap : Gdk_Colormap;
      Visual   : out Gdk.Visual.Gdk_Visual)
   is
      function Internal (Colormap : Gdk_Colormap) return Gdk.Visual.Gdk_Visual;
      pragma Import (C, Internal, "gdk_colormap_get_visual");

   begin
      Visual := Internal (Colormap);
   end Get_Visual;

   -----------
   -- Green --
   -----------

   function Green (Color : Gdk_Color) return Guint16 is
   begin
      return Color.Green;
   end Green;

   -----------
   -- Parse --
   -----------

   function Parse (Spec : String) return Gdk_Color is
      function Internal (Spec : String; Color : System.Address) return Gint;
      pragma Import (C, Internal, "gdk_color_parse");

      Color : aliased Gdk_Color;

   begin
      if not To_Boolean (Internal (Spec & ASCII.NUL, Color'Address)) then
         raise Wrong_Color;
      end if;

      return Color;
   end Parse;

   -----------
   -- Pixel --
   -----------

   function Pixel (Color : Gdk_Color) return Guint32 is
   begin
      return Color.Pixel;
   end Pixel;

   ---------
   -- Red --
   ---------

   function Red (Color : Gdk_Color) return Guint16 is
   begin
      return Color.Red;
   end Red;

   ---------------
   -- Set_Pixel --
   ---------------

   procedure Set_Pixel (Color : in out Gdk_Color; Pixel : Guint32) is
   begin
      Color.Pixel := Pixel;
   end Set_Pixel;

   -------------
   -- Set_Rgb --
   -------------

   procedure Set_Rgb (Color : out Gdk_Color; Red, Green, Blue : Guint16) is
   begin
      Color.Red := Red;
      Color.Green := Green;
      Color.Blue := Blue;
   end Set_Rgb;

   -----------
   -- Store --
   -----------

   procedure Store
     (Colormap : Gdk_Colormap;
      Colors   : Gdk_Color_Array)
   is
      procedure Internal
        (Colormap : Gdk_Colormap;
         Colors   : System.Address;
         Ncolors  : Gint);
      pragma Import (C, Internal, "gdk_colors_store");

   begin
      Internal (Colormap, Colors'Address, Colors'Length);
   end Store;

   -----------
   -- White --
   -----------

   function White (Colormap : Gdk_Colormap) return Gdk_Color is
      function Internal
        (Colormap : Gdk_Colormap; Color : System.Address) return Gint;
      pragma Import (C, Internal, "gdk_color_white");

      Color : aliased Gdk_Color;

   begin
      if not To_Boolean (Internal (Colormap, Color'Address)) then
         raise Wrong_Color;
      end if;

      return Color;
   end White;

   ------------------
   -- Set_Property --
   ------------------

   procedure Set_Property
     (Object : access Glib.Object.GObject_Record'Class;
      Name   : Property_Gdk_Color;
      Value  : Gdk_Color) is
   begin
      Color_Properties.Set_Property
        (Object, Color_Properties.Property (Name), Value);
   end Set_Property;

   ------------------
   -- Get_Property --
   ------------------

   function Get_Property
     (Object : access Glib.Object.GObject_Record'Class;
      Name   : Property_Gdk_Color) return Gdk_Color is
   begin
      return Color_Properties.Get_Property
        (Object, Color_Properties.Property (Name));
   end Get_Property;

end Gdk.Color;
