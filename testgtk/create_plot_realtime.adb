-----------------------------------------------------------------------
--          GtkAda - Ada95 binding for the Gimp Toolkit              --
--                                                                   --
--                     Copyright (C) 2001                            --
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

with Gdk.Color;             use Gdk.Color;
with Gdk.Rectangle;         use Gdk.Rectangle;
with Glib;                  use Glib;
with Gtk.Enums;             use Gtk.Enums;
with Gtk.Extra.Plot;        use Gtk.Extra.Plot;
with Gtk.Extra.Plot_Data;   use Gtk.Extra.Plot_Data;
with Gtk.Extra.Plot_Canvas; use Gtk.Extra.Plot_Canvas;
with Gtk.Frame;             use Gtk.Frame;
with Gtk.Main;              use Gtk.Main;
with Gtk.Scrolled_Window;   use Gtk.Scrolled_Window;
with Gtk.Widget;            use Gtk.Widget;
with Gtkada.Handlers;       use Gtkada.Handlers;
with Unchecked_Deallocation;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;

package body Create_Plot_Realtime is

   Timer : Timeout_Handler_Id;
   Random_Generator : Ada.Numerics.Float_Random.Generator;

   type Timeout_Data is record
      Canvas  : Gtk_Plot_Canvas;
      Plot    : Gtk_Plot;
      Dataset : Gtk_Plot_Data;
      X       : Gdouble_Array_Access;
      Y       : Gdouble_Array_Access;
   end record;
   type Timeout_Data_Access is access Timeout_Data;

   package Plot_Timeout is new Gtk.Main.Timeout (Timeout_Data_Access);
   use Plot_Timeout;

   procedure Free is new Unchecked_Deallocation
     (Gdouble_Array, Gdouble_Array_Access);

   ----------
   -- Help --
   ----------

   function Help return String is
   begin
      return "This demo shows how a plot can be updated periodically to"
        & " show new data.";
   end Help;

   -------------
   -- Destroy --
   -------------

   procedure Destroy (Widget : access Gtk_Widget_Record'Class) is
      pragma Warnings (Off, Widget);
   begin
      Timeout_Remove (Timer);
   end Destroy;

   ------------
   -- Update --
   ------------

   function Update (Data : Timeout_Data_Access) return Boolean is
      X, Y : Gdouble_Array_Access;
      Xmin, Xmax : Gdouble;
      Length : Natural := 1;
   begin
      if Data.X /= null then
         Length := Data.X'Length + 1;
      end if;

      X := new Gdouble_Array (1 .. Length);
      Y := new Gdouble_Array (1 .. Length);

      if Length /= 1 then
         X (1 .. Length - 1) := Data.X.all;
         Y (1 .. Length - 1) := Data.Y.all;
         X (Length) := X (Length - 1) + 1.0;
      else
         X (Length) := 1.0;
      end if;

      Y (Length) := Gdouble (Random (Random_Generator));

      Free (Data.X);
      Free (Data.Y);

      Data.X := X;
      Data.Y := Y;

      Set_Numpoints (Data.Dataset, Gint (Length));
      Set_X (Data.Dataset, X);
      Set_Y (Data.Dataset, Y);

      Get_Xrange (Data.Plot, Xmin, Xmax);
      if X (Length) > Xmax then
         Set_Xrange (Data.Plot, Xmin + 5.0, Xmax + 5.0);
         Paint (Data.Canvas);
         Refresh (Data.Canvas);

      else
         --  Draw only the last point added
         Draw_Points (Data.Dataset, 1);
         Refresh (Data.Plot, Full_Area);
         Refresh (Data.Canvas);
      end if;
      return True;
   end Update;

   ---------
   -- Run --
   ---------

   procedure Run (Frame : access Gtk.Frame.Gtk_Frame_Record'Class) is
      Scrollw1    : Gtk_Scrolled_Window;
      Child       : Gtk_Plot_Canvas_Child;
      Canvas      : Gtk_Plot_Canvas;
      Color       : Gdk_Color;
      Active_Plot : Gtk_Plot;
      Dataset     : Gtk_Plot_Data;
   begin
      Set_Label (Frame, "gtk_plot realtime");

      --  Put the Plot in a scrolled window, in case it is too big for
      --  the screen
      Gtk_New (Scrollw1);
      Set_Border_Width (Scrollw1, 0);
      Set_Policy (Scrollw1, Policy_Always, Policy_Always);
      Add (Frame, Scrollw1);

      --  Create the canvas in which the plot will be drawn
      Gtk_New (Canvas, Gint (Get_Allocation_Width (Frame) - 10),
               Gint (Get_Allocation_Height (Frame) - 10), 1.0);
      Plot_Canvas_Set_Flags (Canvas, Dnd_Flags);
      Add_With_Viewport (Scrollw1, Canvas);

      Widget_Callback.Connect
        (Canvas, "destroy", Widget_Callback.To_Marshaller (Destroy'Access));

      Color := Parse ("light blue");
      Alloc (Get_Default_Colormap, Color);
      Set_Background (Canvas, Color);
      Show (Canvas);

      --  Create the plot, the axis and legends
      Gtk_New (Active_Plot, 0.65, 0.45);
      Color := Parse ("light yellow");
      Alloc (Get_Default_Colormap, Color);
      Set_Background (Active_Plot, Color);

      Color := Parse ("white");
      Alloc (Get_Default_Colormap, Color);
      Legends_Set_Attributes
        (Active_Plot,
         Ps_Font    => "",
         Height     => 0,
         Foreground => Null_Color,
         Background => Color);
      Set_Legends_Border (Active_Plot, Border_Shadow, 3);
      Legends_Move (Active_Plot, 0.6, 0.1);
      Set_Range (Active_Plot, 0.0, 20.0, 0.0, 1.0);

      Axis_Set_Ticks (Active_Plot, Axis_X, 2.0, 1);
      Axis_Set_Ticks (Active_Plot, Axis_Y, 0.1, 1);
      Axis_Set_Visible (Active_Plot, Axis_Top, True);
      Axis_Set_Visible (Active_Plot, Axis_Right, True);
      Axis_Hide_Title (Active_Plot, Axis_Top);
      Axis_Hide_Title (Active_Plot, Axis_Right);
      Axis_Set_Title (Active_Plot, Axis_Left, "Intensity");
      Axis_Set_Title (Active_Plot, Axis_Bottom, "Time");
      Grids_Set_Visible (Active_Plot, True, True, True, True);

      Add_Plot (Canvas, Active_Plot, 0.15, 0.15);
      Show (Active_Plot);

      Child := Put_Text
        (Canvas,
         X             => 0.45,
         Y             => 0.05,
         Ps_Font       => "Times-BoldItalic",
         Height        => 20,
         Angle         => 0,
         Fg            => Null_Color,
         Bg            => Null_Color,
         Transparent   => True,
         Justification => Justify_Center,
         Text          => "Real Time Demo");

      --  Create the data

      Gtk_New (Dataset);
      Add_Data (Active_Plot, Dataset);
      Show (Dataset);

      Color := Parse ("red");
      Alloc (Get_Default_Colormap, Color);

      Set_Legend (Dataset, "Random Pulse");
      Set_Symbol (Dataset,
                  Symbol_Diamond,
                  Symbol_Opaque,
                  10, 2.0, Color, Color);
      Set_Line_Attributes (Dataset, Line_Solid, 1.0, Color);

      --  Paint everything
      Paint (Canvas);
      Refresh (Canvas);

      --  Register the periodic timer

      Timer := Plot_Timeout.Add
        (1000,
         Update'Access,
         new Timeout_Data' (Canvas  => Canvas,
                            Plot    => Active_Plot,
                            Dataset => Dataset,
                            X       => null,
                            Y       => null));
      Show_All (Frame);
   end Run;

end Create_Plot_Realtime;
