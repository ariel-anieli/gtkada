-----------------------------------------------------------------------
--              GtkAda - Ada95 binding for Gtk+/Gnome                --
--                                                                   --
--                     Copyright (C) 2001                            --
--                         ACT-Europe                                --
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

--  <description>
--  A Gtk_Text_Iter represents a location in the text. It becomes invalid if
--  the characters/pixmaps/widgets (indexable objects) in the text buffer
--  are changed.
--  </description>
--  <c_version>1.3.6</c_version>

with Glib; use Glib;
with Glib.Values;
with Gdk.Pixbuf;
with Gtk.Text_Child;
with Gtk.Text_Tag;
with System;

package Gtk.Text_Iter is

   type Gtk_Text_Iter is limited private;

   procedure Copy
     (Source : Gtk_Text_Iter;
      Dest   : out Gtk_Text_Iter);
   --  Create a copy of Source.

   -----------------------------------------
   -- Convert to different kinds of index --
   -----------------------------------------

   function Get_Offset (Iter : Gtk_Text_Iter) return Gint;
   --  Return the character offset of an iterator.
   --  Each character in a Gtk_Text_Buffer has an offset, starting with 0 for
   --  the first character in the buffer.
   --  Use Gtk.Text_Buffer.Get_Iter_At_Offset to convert an offset back into an
   --  iterator.

   function Get_Line (Iter : Gtk_Text_Iter) return Gint;
   --  Return the line number containing the iterator.
   --  Lines in a Gtk_Text_Buffer are numbered beginning with 0 for the first
   --  line in the buffer.

   function Get_Line_Offset (Iter : Gtk_Text_Iter) return Gint;
   --  Return the character offset of the iterator, counting from the start of
   --  a newline-terminated line.
   --  The first character on the line has offset 0.

   function Get_Line_Index (Iter : Gtk_Text_Iter) return Gint;
   --  Return the byte index of the iterator, counting from the start of a
   --  newline-terminated line.
   --  Remember that Gtk_Text_Buffer encodes text in UTF-8, and that characters
   --  can require a variable number of bytes to represent.

   function Get_Visible_Line_Offset (Iter : Gtk_Text_Iter) return Gint;

   function Get_Visible_Line_Index (Iter : Gtk_Text_Iter) return Gint;

   ---------------------------
   -- Dereference operators --
   ---------------------------

   function Get_Char (Iter : Gtk_Text_Iter) return Gunichar;
   --  Return the character immediately following Iter. If Iter is at the
   --  end of the buffer, then return ASCII.NUL.

   function Get_Char (Iter : Gtk_Text_Iter) return Character;
   --  Return the character immediately following Iter. If Iter is at the
   --  end of the buffer, then return ASCII.NUL.
   --  Note that this function assumes that the text is encoded in ASCII
   --  format. If this is not the case, use the Get_Char function that
   --  returns a Gunichar instead.

   function Get_Slice
     (Start   : Gtk_Text_Iter;
      The_End : Gtk_Text_Iter) return String;
   --  Return the text in the given range.
   --  A "slice" is an array of characters encoded in UTF-8 format, including
   --  the Unicode "unknown" character 16#FFFC# for iterable non-character
   --  elements in the buffer, such as images. Because images are encoded in
   --  the slice, byte and character offsets in the returned array will
   --  correspond to byte offsets in the text buffer. Note that 16#FFFC# can
   --  occur in normal text as well, so it is not a reliable indicator that a
   --  pixbuf or widget is in the buffer.

   function Get_Text
     (Start   : Gtk_Text_Iter;
      The_End : Gtk_Text_Iter) return String;
   --  Return text in the given range.
   --  If the range contains non-text elements such as images, the character
   --  and byte offsets in the returned string will not correspond to character
   --  and byte offsets in the buffer. If you want offsets to correspond, see
   --  Get_Slice.

   function Get_Visible_Slice
     (Start   : Gtk_Text_Iter;
      The_End : Gtk_Text_Iter) return String;
   --  Like Get_Slice, but invisible text is not included.
   --  Invisible text is usually invisible because a Gtk_Text_Tag with the
   --  "invisible" attribute turned on has been applied to it.

   function Get_Visible_Text
     (Start   : Gtk_Text_Iter;
      The_End : Gtk_Text_Iter) return String;
   --  Like Get_Text, but invisible text is not included.
   --  Invisible text is usually invisible because a Gtk_Text_Tag with the
   --  "invisible" attribute turned on has been applied to it.

   function Get_Pixbuf (Iter : Gtk_Text_Iter) return Gdk.Pixbuf.Gdk_Pixbuf;
   --  If the location pointed to by Iter contains a pixbuf, the pixbuf
   --  is returned (with no new reference count added). Otherwise, null is
   --  returned.

   --  function Get_Marks
   --    (Iter : access Gtk_Text_Iter)
   --     return Gtk.Text_Mark.Text_Mark_List.GSList;
   --  Return a list of all Gtk_Text_Mark at this location.
   --  Because marks are not iterable (they don't take up any "space" in the
   --  buffer, they are just marks in between iterable locations), multiple
   --  marks can exist in the same place. The returned list is not in any
   --  meaningful order.
   --  ???

   function Get_Child_Anchor
     (Iter : Gtk_Text_Iter)
      return Gtk.Text_Child.Gtk_Text_Child_Anchor;
   --  If the location pointed to by Iter contains a child anchor, the anchor
   --  is returned (with no new reference count added). Otherwise, null is
   --  returned.

   --  function Get_Toggled_Tags
   --    (Iter       : access Gtk_Text_Iter;
   --     Toggled_On : Boolean) return Gtk.Text_Tag.Text_Tag_List.GSList;
   --  Return a list of Gtk_Text_Tag that are toggled on or off at this point.
   --  If Toggled_On is True, the list contains tags that are toggled on. If a
   --  tag is toggled on at Iter, then some non-empty range of characters
   --  following Iter has that tag applied to it. If a tag is toggled off, then
   --  some non-empty range following Iter does not have the tag applied to it.
   --  ???

   function Begins_Tag
     (Iter : Gtk_Text_Iter;
      Tag  : Gtk.Text_Tag.Gtk_Text_Tag := null) return Boolean;
   --  Return True if Tag is toggled on at exactly this point.
   --  If Tag is null, return True if any tag is toggled on at this point.
   --  Return True if Iter is the start of the tagged range;
   --  Has_Tag tells you whether an iterator is within a tagged range.

   function Ends_Tag
     (Iter : Gtk_Text_Iter;
      Tag  : Gtk.Text_Tag.Gtk_Text_Tag := null) return Boolean;
   --  Return True if Tag is toggled off at exactly this point.
   --  If Tag is null, return True if any tag is toggled off at this point.
   --  Note that the Ends_Tag return True if Iter is the end of the tagged
   --  range; Has_Tag tells you whether an iterator is within a tagged range.

   function Toggles_Tag
     (Iter : Gtk_Text_Iter;
      Tag  : Gtk.Text_Tag.Gtk_Text_Tag := null) return Boolean;
   --  Whether a range with Tag applied to it begins or ends at Iter.
   --  Equivalent to "Begins_Tag (Iter, Tag) or else Ends_Tag (Iter, Tag)".

   function Has_Tag
     (Iter : Gtk_Text_Iter;
      Tag  : Gtk.Text_Tag.Gtk_Text_Tag := null) return Boolean;
   --  Return True if Iter is within a range tagged with Tag.

   --  function Get_Tags
   --    (Iter : Gtk_Text_Iter) return Gtk.Text_Tag.Text_Tag_List.GSList;
   --  ??? Need a GSLists of Tags to bind this function
   --  Return a list of tags that apply to Iter, in ascending order of priority
   --  (highest-priority tags are last). The Gtk_Text_Tag in the list don't
   --  have a reference added, but you have to free the list itself.

   function Editable
     (Iter            : Gtk_Text_Iter;
      Default_Setting : Boolean := True) return Boolean;
   --  Return whether Iter is within an editable region of text.
   --  Non-editable text is "locked" and can't be changed by the user via
   --  Gtk_Text_View. This function is simply a convenience wrapper around
   --  Get_Attributes. If no tags applied to this text affect editability,
   --  Default_Setting will be returned.

   function Starts_Word (Iter : Gtk_Text_Iter) return Boolean;
   --  Determine whether Iter begins a natural-language word.
   --  Word breaks are determined by Pango and should be correct for nearly any
   --  language (if not, the correct fix would be to the Pango word break
   --  algorithms.

   function Ends_Word (Iter : Gtk_Text_Iter) return Boolean;
   --  Determine whether Iter ends a natural-language word.
   --  Word breaks are determined by Pango and should be correct for nearly any
   --  language (if not, the correct fix would be to the Pango word break
   --  algorithms).

   function Inside_Word (Iter : Gtk_Text_Iter) return Boolean;
   --  Determine whether Iter is inside a natural-language word (as opposed to
   --  say inside some whitespace). Word breaks are determined by Pango and
   --  should be correct for nearly any language (if not, the correct fix would
   --  be to the Pango word break algorithms).

   function Starts_Sentence (Iter : Gtk_Text_Iter) return Boolean;
   --  Determine whether Iter begins a sentence.
   --  Sentence boundaries are determined by Pango and should be correct for
   --  nearly any language (if not, the correct fix would be to the Pango text
   --  boundary algorithms).

   function Ends_Sentence (Iter : Gtk_Text_Iter) return Boolean;
   --  Determine whether Iter ends a sentence.
   --  Sentence boundaries are determined by Pango and should be correct for
   --  nearly any language (if not, the correct fix would be to the Pango text
   --  boundary algorithms).

   function Inside_Sentence (Iter : Gtk_Text_Iter) return Boolean;
   --  Determine whether Iter is inside a sentence (as opposed to in between
   --  two sentences, e.g. after a period and before the first letter of the
   --  next sentence). Sentence boundaries are determined by Pango and should
   --  be correct for nearly any language (if not, the correct fix would be to
   --  the Pango text boundary algorithms).

   function Starts_Line (Iter : Gtk_Text_Iter) return Boolean;
   --  Return True if Iter begins a paragraph.
   --  i.e. if Get_Line_Offset would return 0.
   --  However this function is potentially more efficient than
   --  Get_Line_Offset because it doesn't have to compute the offset, it just
   --  has to see whether it's 0.

   function Ends_Line (Iter : Gtk_Text_Iter) return Boolean;
   --  Return True if Iter points to the start of the paragraph delimiter
   --  characters for a line (delimiters will be either a newline, a carriage
   --  return, a carriage return followed by a newline, or a Unicode paragraph
   --  separator character). Note that an iterator pointing to the ASCII.LF of
   --  a ASCII.CR & ASCII.LF pair will not be counted as the end of a line, the
   --  line ends before the ASCII.CR.

   function Is_Cursor_Position (Iter : Gtk_Text_Iter) return Boolean;
   --  Return True if the cursor can be placed at Iter.
   --  See Forward_Cursor_Position for details on what a cursor position is.

   function Get_Chars_In_Line (Iter : Gtk_Text_Iter) return Gint;
   --  Return the number of characters in the line containing Iter, including
   --  the paragraph delimiters.

   function Get_Bytes_In_Line (Iter : Gtk_Text_Iter) return Gint;
   --  Return the number of bytes in the line containing Iter, including the
   --  paragraph delimiters.

   --  function Get_Attributes
   --    (Iter   : Gtk_Text_Iter;
   --     Values : access Gtk.Text_Attributes.Gtk_Text_Attributes_Record'Class)
   --     return Boolean;
   --  ??? Gtk_Text_Attributes is defined in gtktexttag.h
   --  Compute the effect of any tags applied to this spot in the text.
   --  The Values parameter should be initialized to the default settings you
   --  wish to use if no tags are in effect. Get_Attributes will modify Values,
   --  applying the effects of any tags present at Iter. If any tags affected
   --  values, the function returns True.

   function Get_Language (Iter : Gtk_Text_Iter) return String;
   --  A convenience wrapper around Get_Attributes,
   --  which returns the language in effect at Iter. If no tags affecting
   --  language apply to Iter, the return value is identical to that of
   --  Gtk.Get_Default_Language.

   function Is_End (Iter : Gtk_Text_Iter) return Boolean;
   --  Return True if Iter is the end iterator.
   --  i.e. one past the last dereferenceable iterator in the buffer.
   --  This is the most efficient way to check whether an iterator is the end
   --  iterator.

   function Is_Start (Iter : Gtk_Text_Iter) return Boolean;
   --  Return True if Iter is the first iterator in the buffer, that is
   --  if Iter has a character offset of 0.

   ------------------------------
   -- Moving around the buffer --
   ------------------------------

   procedure Forward_Char
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move Iter forward by one character offset.
   --  Note that images embedded in the buffer occupy 1 character slot, so
   --  Forward_Char may actually move onto an image instead of a character, if
   --  you have images in your buffer. If Iter is the end iterator or one
   --  character before it, Iter will now point at the end iterator, and
   --  Forward_Char returns False for convenience when writing loops.

   procedure Backward_Char
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move backward by one character offset.
   --  Return True if movement was possible; if Iter was the first in the
   --  buffer (character offset 0), return False for convenience when writing
   --  loops.

   procedure Forward_Chars
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Move Count characters if possible.
   --  If Count would move past the start or end of the buffer, move to the
   --  start or end of the buffer). Result indicates whether the new position
   --  of Iter is different from its original position, and dereferenceable
   --  (the last iterator in the buffer is not dereferenceable). If Count
   --  is 0, this procedure does nothing and returns False.

   procedure Backward_Chars
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Move Count characters backward, if possible.
   --  If Count would move past the start or end of the buffer, moves to the
   --  start or end of the buffer). Result indicates whether the iterator moved
   --  onto a dereferenceable position; if the iterator didn't move, or moved
   --  onto the end iterator, then False is returned. If Count is 0, the
   --  function does nothing and returns False.

   procedure Forward_Line
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move Iter to the start of the next line.
   --  Return True if there was a next line to move to, and False if iter was
   --  simply moved to the end of the buffer and is now not dereferenceable, or
   --  if Iter was already at the end of the buffer.

   procedure Backward_Line
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move Iter to the start of the previous line.
   --  Return True if Iter could be moved; i.e. if Iter was at character offset
   --  0, this function returns False. Therefore if Iter was already on line 0,
   --  but not at the start of the line, Iter is snapped to the start of the
   --  line and the function returns True. (Note that this implies that in a
   --  loop calling this function, the line number may not change on every
   --  iteration, if your first iteration is on line 0.)

   procedure Forward_Lines
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Call Forward_Line, up to Count times.

   procedure Backward_Lines
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Call Backward_Line, up to Count times.

   procedure Forward_Word_End
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move forward to the next word end.
   --  If Iter is currently on a word end, move forward to the next one after
   --  that. Word breaks are determined by Pango and should be correct for
   --  nearly any language (if not, the correct fix would be to the Pango word
   --  break algorithms).

   procedure Backward_Word_Start
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move backward to the next word start.
   --  If Iter is currently on a word start, move backward to the next one
   --  after that.

   procedure Forward_Word_Ends
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Call Forward_Word_End up to Count times.

   procedure Backward_Word_Starts
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Call Backward_Word_Start up to Count times.

   procedure Forward_Sentence_End
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move forward to the next sentence end.
   --  If Iter is at the end of a sentence, move to the next end of sentence.

   procedure Backward_Sentence_Start
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move backward to the next sentence start.
   --  If Iter is already at the start of a sentence, move backward to the next
   --  one.

   procedure Forward_Sentence_Ends
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Call Forward_Sentence_End up to Count times.

   procedure Backward_Sentence_Starts
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Call Backward_Sentence_Starts up to Count times.

   procedure Forward_Cursor_Position
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move Iter forward by a single cursor position.
   --  Cursor positions are (unsurprisingly) positions where the cursor can
   --  appear. Perhaps surprisingly, there may not be a cursor position between
   --  all characters. The most common example for European languages would be
   --  a carriage return/newline sequence. For some Unicode characters, the
   --  equivalent of say the letter "a" with an accent mark will be represented
   --  as two characters, first the letter then a "combining mark" that causes
   --  the accent to be rendered; so the cursor can't go between those two
   --  characters.

   procedure Backward_Cursor_Position
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Like Forward_Cursor_Position, but moves backward.

   procedure Forward_Cursor_Positions
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Call Forward_Cursor_Position up to Count times.

   procedure Backward_Cursor_Positions
     (Iter   : in out Gtk_Text_Iter;
      Count  : Gint := 1;
      Result : out Boolean);
   --  Call Backward_Cursor_Position up to Count times.

   procedure Set_Offset
     (Iter        : in out Gtk_Text_Iter;
      Char_Offset : Gint);
   --  Set Iter to point to Char_Offset.
   --  Char_Offset counts from the start of the entire text buffer, starting
   --  with 0.

   procedure Set_Line
     (Iter        : in out Gtk_Text_Iter;
      Line_Number : Gint);
   --  Move iterator Iter to the start of the line Line_Number.

   procedure Set_Line_Offset
     (Iter         : in out Gtk_Text_Iter;
      Char_On_Line : Gint);
   --  Move Iter within a line, to a new character (not byte) offset.
   --  The given character offset must be less than or equal to the number of
   --  characters in the line; if equal, Iter moves to the start of the next
   --  line. See Set_Line_Index if you have a byte index rather than a
   --  character offset.

   procedure Set_Line_Index
     (Iter         : in out Gtk_Text_Iter;
      Byte_On_Line : Gint);
   --  Same as Set_Line_Offset, but work with a byte index.
   --  The given byte index must be at the start of a character, it can't be in
   --  the middle of a UTF-8 encoded character.

   procedure Forward_To_End
     (Iter : in out Gtk_Text_Iter);
   --  Move Iter forward to the "end iterator", which points one past the last
   --  valid character in the buffer. Get_Char called on the end iterator
   --  returns 0, which is convenient for writing loops.

   procedure Forward_To_Line_End
     (Iter   : in out Gtk_Text_Iter;
      Result : out Boolean);
   --  Move the iterator to point to the paragraph delimiter characters,
   --  which will be either a newline, a carriage return, a carriage
   --  return/newline in sequence, or the Unicode paragraph separator
   --  character. If the iterator is already at the paragraph delimiter
   --  characters, move to the paragraph delimiter characters for the next
   --  line.

   procedure Forward_To_Tag_Toggle
     (Iter   : in out Gtk_Text_Iter;
      Tag    : Gtk.Text_Tag.Gtk_Text_Tag := null;
      Result : out Boolean);
   --  Move forward to the next toggle (on or off) of the Gtk_Text_Tag Tag, or
   --  to the next toggle of any tag if Tag is null. If no matching tag toggles
   --  are found, return False, otherwise True. Do not return toggles located
   --  at Iter, only toggles after Iter. Set Iter to the location of the
   --  toggle, or to the end of the buffer if no toggle is found.

   procedure Backward_To_Tag_Toggle
     (Iter   : in out Gtk_Text_Iter;
      Tag    : Gtk.Text_Tag.Gtk_Text_Tag := null;
      Result : out Boolean);
   --  Move backward to the next toggle (on or off) of the Gtk_Text_Tag Tag,
   --  or to the next toggle of any tag if Tag is null. If no matching tag
   --  toggles are found, return False, otherwise True. Do not return toggles
   --  located at Iter, only toggles before Iter. Set Iter to the location of
   --  the toggle, or the start of the buffer if no toggle is found.

   --  function Forward_Find_Char
   --    (Iter      : access Gtk_Text_Iter;
   --     Pred      : Gtk_Text_Char_Predicate;
   --     User_Data : gpointer;
   --     Limit     : access Gtk_Text_Iter)
   --     return Boolean;
   --  ??? Need to be put in a generic package...
   --  ??? And also needs a binding to gunichar

   --  function Backward_Find_Char
   --    (Iter      : access Gtk_Text_Iter;
   --     Pred      : Gtk_Text_Char_Predicate;
   --     User_Data : gpointer;
   --     Limit     : access Gtk_Text_Iter)
   --     return Boolean;
   --  ??? Need to be put in a generic package.
   --  ??? And also needs a binding to gunichar.

   procedure Forward_Search
     (Iter         : Gtk_Text_Iter;
      Str          : String;
      Visible_Only : Boolean := False;
      Slice        : Boolean;
      Match_Start  : out Gtk_Text_Iter;
      Match_End    : out Gtk_Text_Iter;
      Limit        : Gtk_Text_Iter;
      Result       : out Boolean);
   --  Search forward for Str.
   --  Any match is returned as the range Match_Start, Match_End. If you
   --  specify Visible_Only or Slice, the match may have invisible text,
   --  pixbufs, or child widgets interspersed in Str.
   --  Iter: start of search
   --  Str: a search string
   --  Visible_Only: if True, search only visible text
   --  Slice: if True, Str contains 16#FFFC# when we want to match widgets,
   --  pixbufs
   --  Match_Start: return location for start of match, or null
   --  Match_End: return location for end of match, or null
   --  Limit: bound for the search, or null for the end of the buffer
   --  Result: whether a match was found.

   procedure Backward_Search
     (Iter         : Gtk_Text_Iter;
      Str          : String;
      Visible_Only : Boolean := False;
      Slice        : Boolean;
      Match_Start  : out Gtk_Text_Iter;
      Match_End    : out Gtk_Text_Iter;
      Limit        : Gtk_Text_Iter;
      Result       : out Boolean);
   --  Same as Forward_Search, but move backward.

   -----------------
   -- Comparisons --
   -----------------

   function Equal (Lhs : Gtk_Text_Iter; Rhs : Gtk_Text_Iter) return Boolean;
   --  Test whether two iterators are equal, using the fastest possible
   --  mechanism. This function is very fast; you can expect it to perform
   --  better than e.g. getting the character offset for each iterator and
   --  comparing the offsets yourself. Also, it's a bit faster than Compare.

   function Compare (Lhs : Gtk_Text_Iter; Rhs : Gtk_Text_Iter) return Gint;
   --  A quick sort-style function that return negative if Lhs is less than
   --  Rhs, positive if Lhs is greater than Rhs, and 0 if they're equal.
   --  Ordering is in character offset order, i.e. the first character in the
   --  buffer is less than the second character in the buffer.

   function In_Range
     (Iter    : Gtk_Text_Iter;
      Start   : Gtk_Text_Iter;
      The_End : Gtk_Text_Iter) return Boolean;
   --  Start and End must be in order, unlike most text buffer functions, for
   --  efficiency reasons. Return True if Iter falls in the range [Start, End)

   procedure Order
     (First  : in out Gtk_Text_Iter;
      Second : in out Gtk_Text_Iter);
   --  Swap the value of First and Second if Second comes before First in the
   --  buffer. That is, ensures that First and Second are in sequence. Most
   --  text buffer functions that take a range call this automatically on your
   --  behalf, so there's no real reason to call it yourself in those cases.
   --  There are some exceptions, such as In_Range, that expect a pre-sorted
   --  range.

   -------------------------------
   -- Converting to/from GValue --
   -------------------------------

   procedure Set_Text_Iter
     (Val  : in out Glib.Values.GValue;
      Iter : Gtk_Text_Iter);
   --  Set the value of the given GValue to Iter.
   --  Note that Iter is stored by reference, which means no copy of Iter
   --  is made. Iter should remain allocated as long as Val is being used.

   procedure Get_Text_Iter
     (Val  : Glib.Values.GValue;
      Iter : out Gtk_Text_Iter);
   --  Extract the iterator from the given GValue.
   --  Note that the iterator returned is a copy of the iterator referenced
   --  by the give GValue. Modifying the iterator returned does not modify
   --  the iterator referenced by the GValue.

   function Get_Text_Iter (Val : Glib.Values.GValue) return Gtk_Text_Iter;
   --  This is the function equivalent of procedure Get_Text_Iter above. It is
   --  sometimes more convenient that then procedure, but its use is limited by
   --  the fact that the result returned can not be stored in a variable, since
   --  Gtk_Text_Iter is limited.

private
   function C_Gtk_Text_Iter_Size return Natural;
   pragma Import (C, C_Gtk_Text_Iter_Size, "ada_c_gtk_text_iter_size");

   type Gtk_Text_Iter is limited record
      Dummy1  : System.Address;
      Dummy2  : System.Address;
      Dummy3  : Gint;
      Dummy4  : Gint;
      Dummy5  : Gint;
      Dummy6  : Gint;
      Dummy7  : Gint;
      Dummy8  : Gint;
      Dummy9  : System.Address;
      Dummy10 : System.Address;
      Dummy11 : Gint;
      Dummy12 : Gint;
      Dummy13 : Gint;
      Dummy14 : Gint;
   end record;
   pragma Convention (C, Gtk_Text_Iter);
   --  Note that part of the implementation of this package assumes that this
   --  type is a limited record. If for some reason this can no longer remain
   --  the case, then it needs to be modified. (See note (2) at the beginning
   --  of the body of this package).
   --  Similarly, part of the implementation of the following packages depend
   --  on this assumption:
   --    - Gtk.Text_View

   pragma Import (C, Get_Offset, "gtk_text_iter_get_offset");
   pragma Import (C, Get_Line, "gtk_text_iter_get_line");
   pragma Import (C, Get_Line_Offset, "gtk_text_iter_get_line_offset");
   pragma Import (C, Get_Line_Index, "gtk_text_iter_get_line_index");
   pragma Import
     (C, Get_Visible_Line_Offset, "gtk_text_iter_set_visible_line_offset");
   pragma Import
     (C, Get_Visible_Line_Index, "gtk_text_iter_set_visible_line_index");
   pragma Import (C, Get_Chars_In_Line, "gtk_text_iter_get_chars_in_line");
   pragma Import (C, Get_Bytes_In_Line, "gtk_text_iter_get_bytes_in_line");
   pragma Import (C, Forward_To_End, "gtk_text_iter_forward_to_end");
   pragma Import (C, Compare, "gtk_text_iter_compare");
   pragma Import (C, Order, "gtk_text_iter_order");
   pragma Import (C, Get_Pixbuf, "gtk_text_iter_get_pixbuf");
   pragma Import (C, Set_Text_Iter, "g_value_set_pointer");

end Gtk.Text_Iter;
