--------------------------------------------
-- Défi Calnedrier de l'Avent 2021
--   Advent Of Code Challenge 2021
--
-- #AdaAdventOfCode21
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 09 / Day 09
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Maps ; use Ada.Strings.Maps;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;

procedure Day09 is

   type Height_Point_Info is record
      North : Natural;
      East : Natural;
      South : Natural;
      West : Natural;
      Risk_Level : Natural;
      Highest_Point : Natural;
      Lowest_Point : Natural;
   end record;
     
   type Coord is record
      X : Natural;
      Y : Natural;
   end record;
   
   type Point_Of_Interest is record
      Position : Coord;
      Info : Height_Point_Info;
   end record;
   
   
   package Hydrothermal_Positions_Vector is new Ada.Containers.Vectors(Index_Type   => Positive,              
								  Element_Type => Point_Of_Interest);
      
   package Floor_Vector is new Ada.Containers.Vectors(Index_Type   => Natural,              
						      Element_Type => Unbounded_String);
   

   --use Floor_Vector;
  
   procedure Print_Point(Point : Point_Of_Interest) is
      
   begin
      Put_Line("---------------------------");
      Put_Line("X ; "&Point.Position.X'Img);
      Put_Line("Y ; "&Point.Position.Y'Img);
      Put_Line("  North : "&Point.Info.North'Img);
      Put_Line("  East  : "&Point.Info.East'Img);
      Put_Line("  South : "&Point.Info.South'Img);
      Put_Line("  West  : "&Point.Info.West'Img);
      Put_Line("Max  : "&Point.Info.Highest_Point'Img);
      Put_Line("Min  : "&Point.Info.Lowest_Point'Img);
      Put_Line("Risk_Level : "&Point.Info.Risk_Level'Img);
      New_Line;
      
   end Print_Point;
   
   function Give_Max(A:Natural;B:Natural;C:Natural;D:Natural) return Natural is   
   begin
      return Natural'Max(A,Natural'Max(B,Natural'Max(C,D)));
   end Give_Max;
   
   function Give_Min(A:Natural;B:Natural;C:Natural;D:Natural) return Natural is
   begin
      return Natural'Min(A,Natural'Min(B,Natural'Min(C,D)));
   end Give_Min;
   
   function Calculate_Risk(Height_Map : in Floor_Vector.Vector; 
			   Hydrothermal_Positions : in out Hydrothermal_Positions_Vector.Vector) return Natural  is
      Risk_Sum : Natural := 0;
   begin
      for Y in Height_Map.First_Index+1..Height_Map.Last_Index-1 loop
	-- Put_Line(To_String(Height_Map.Element(Y)));
	 declare
	    Floor_North : String := To_String(Height_Map.Element(Y-1));
	    Floor : String := To_String(Height_Map.Element(Y));
	    Floor_South : String := To_String(Height_Map.Element(Y+1));
	    Height : Natural := 0;
	    Height_West : Natural := 0;
	    Height_East : Natural := 0;
	    Height_North : Natural := 0;
	    Height_South : Natural := 0;
	    Point : Point_Of_Interest;
	 begin
	    for X in Floor'First+1..Floor'Last-1 loop
	       --Put(Floor(X));
	       Height := Natural'Value(Floor(X..X));
	       Height_North := Natural'Value(Floor_North(X..X));
	       Height_East := Natural'Value(Floor(X+1..X+1));
	       Height_South := Natural'Value(Floor_South(X..X));
	       Height_West := Natural'Value(Floor(X-1..X-1));
	       if Height < Height_North and Height < Height_East and Height < Height_South and Height < Height_West then
		  --Put_Line("X:"&X'Img&" Y:"&Y'Img&"")
		  Point.Position.X := X;
		  Point.Position.Y := Y;
		  Point.Info.North := Height_North;
		  Point.Info.East := Height_East;
		  Point.Info.South := Height_South;
		  Point.Info.West := Height_West;
		  Point.Info.Highest_Point := Give_Max(Height_North,Height_East,Height_South,Height_West);
		  Point.Info.Lowest_Point := Give_Min(Height_North,Height_East,Height_South,Height_West);
		  Point.Info.Risk_Level := Height + 1;
		  --Put_line("POINT: "&Height'Img);
		  --Print_Point(Point);
		  Hydrothermal_Positions.Append(Point);
	       end if;
	    end loop;
	 end;
      end loop;
      
      for P of Hydrothermal_Positions loop
	    Risk_Sum := Risk_Sum + P.Info.Risk_Level;
      end loop;
      return Risk_Sum;
   end Calculate_Risk;
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Height_Map : Floor_Vector.Vector;
      Hydrothermal_Positions : Hydrothermal_Positions_Vector.Vector;
      Floor_Length : Natural := 0;
      Reponse : Natural := 0;
      Reponse_2 : Natural := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : Unbounded_String := To_Unbounded_String(Get_Line (Input));
         begin
	    Height_Map.Append("9"&Line&"9");
	    if Floor_Length = 0 then
	       Floor_Length := To_String(Line)'Length+2;
	    end if;
         end;
      end loop;
      Close(Input);

      Height_Map.Prepend(Floor_Length*"9");
      Height_Map.Append(Floor_Length*"9");
      
      
      Reponse := Calculate_Risk(Height_Map, Hydrothermal_Positions);
      
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 09");
   Execute("data/data.txt");
end Day09;
