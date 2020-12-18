--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 15 / Day 15
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Maps;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Strings.Maps.Constants;

package body Advent.Day15 is

   type Game_Record is array (1..2) of Positive;
   
   package Game_Vector is new Ada.Containers.Vectors(Index_Type   => Positive,              
						     Element_Type => Natural);
   package Game_Map is new Ada.Containers.Ordered_Maps(Key_Type     => Natural,
						      Element_Type => Game_Record);
   
   Comma_Sign  : constant Ada.Strings.Maps.Character_Set := Ada.Strings.Maps.To_Set (",");   
   
   procedure Insert (New_Position : in Positive; Position_Array : in out Game_Record) is
      B : Positive := Position_Array(2);
   begin
      Position_Array(1) := B;
      Position_Array(2) := New_Position;
   end Insert;
   
   procedure Insert (Number_Shout : in Natural; New_Position : in Positive; Position_Map : in out Game_Map.Map ) is
      Position_Array : Game_Record;
   begin
      if not Position_Map.Is_Empty and then Position_Map.Contains(Number_Shout) then
	 Position_Array := Position_Map.Element(Number_Shout);
	 Insert(New_Position, Position_Array);
	 Position_Map.Replace(Number_Shout, Position_Array);
      else
	 Position_Array := (others => New_Position);
	 Position_Map.Insert(Number_Shout,Position_Array);
      end if;
   end Insert;
   
   function Is_New_Number (Number_Shout : in Natural; Position_Map : in Game_Map.Map; Position : in out Positive) return Boolean is
   begin
      if Position_Map.Contains(Number_Shout) then
	 if Position_Map.Element(Number_Shout)(2) =  Position_Map.Element(Number_Shout)(1) then
	    return True;
	 else
	    Position := Position_Map.Element(Number_Shout)(1);
	    return False;
	 end if;
      else
	 return False;
      end if;
	 
   end Is_New_Number;
   
   function Consecutive_Number (Number_Shout : in Natural; Game : in Game_Vector.Vector) return Boolean is
      Turn : Positive := Game.Last_Index;
   begin
      if Number_Shout = Game.Element(Turn-1) and Number_Shout = Game.Element(Turn-2) then
	 return True;
      end if;
      return False;
   end Consecutive_Number;
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Game : Game_Vector.Vector;
      Position_Map : Game_Map.Map;
      Number_Shout : Natural := 0;
      Position : Positive;
      Reponse_1 : Natural := 0;
      B : Boolean;
   begin
      Open (File => Input,
	    Mode => In_File,
	    Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
	 declare
	    Line : String := Get_Line (Input);
	    First : Positive;
	    Last  : Natural := 0;
	 begin
	    while Last < Line'Last loop
	       Ada.Strings.Fixed.Find_Token (Source => Line,
				      Set    => Comma_Sign,
				      From   => Last + 1,
				      Test   => Ada.Strings.Outside,
				      First  => First,
				      Last   => Last);

	       exit when Last < First;
	       Number_Shout := Natural'Value(Line (First .. Last));
	       Game.Append(Number_Shout);
	       Insert(Number_Shout, Game.Last_Index,Position_Map);
	    end loop;  
	 end;
      end loop;
      Close(Input);

      -- Really Game begins
      while Game.Last_Index < 30000000 loop
	 Position := Game.Last_Index;
	 if Is_New_Number(Number_Shout,Position_Map,Position) then
	    Number_Shout := 0;
	 else
	    B:=Is_New_Number(Number_Shout,Position_Map,Position);
	    if Consecutive_Number(Number_Shout, Game) then
	       Number_Shout := 1;
	    else
	       Number_Shout := Game.Last_Index - Position;
	    end if;   
	 end if;
	 
	 Game.Append( Number_Shout );	 
	  Insert(Number_Shout, Game.Last_Index,Position_Map);
	-- Put(Game.Last_Index'Img&" ");
	 if Game.Last_Index = 2020 then
	    Reponse_1 := Number_Shout;
	 end if;
      end loop;
      Put_Line("Reponse (part1) : " & Reponse_1'Img);

      Put_Line("Reponse (part2) : " & Number_Shout'Img);
   end Execute;

end Advent.Day15;
