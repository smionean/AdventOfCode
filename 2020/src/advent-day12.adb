--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 12 / Day 12
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

package body Advent.Day12 is

   type Action_Type is (N, E, S, W, L, R, F);
   type Direction_Type is new Action_Type range N .. W;
   type  Move_Type is new Action_Type range L .. R;
   type Rotation_Type is mod 4;

   
   type Ferry_Type is
      record
	 Position_East_West : Integer := 0;
	 Position_North_South : Integer := 0;
      end record;
   
   function Change_Direction(Actual_Direction : in Direction_Type; Move : in Move_Type; Value : in Natural) return Direction_Type is
      Rotation : Natural := Value mod 89; -- 90 degrees 
      Position : Integer :=  Direction_Type'Pos(Actual_Direction) mod 4;     
   begin
      case Move is
      when L => 
	 Position := (Position - Rotation) mod 4;
      when R =>
	 Position := (Position + Rotation) mod 4;
      end case;
      
      return Direction_Type'Val(Position);
   end Change_Direction;
   
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Ferry : Ferry_Type;
      Action : Action_Type := E;
      Direction : Direction_Type := E;
      Value : Natural := 0;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
	    Action := Action_Type'Value(Line(Line'First..Line'First));
	    Value := Natural'Value(Line(Line'First+1..Line'Last));
	    case Action is
	    when N => Ferry.Position_North_South := Ferry.Position_North_South + Value;
	    when S => Ferry.Position_North_South := Ferry.Position_North_South - Value;
	    when E => Ferry.Position_East_West := Ferry.Position_East_West + Value;
	    when W => Ferry.Position_East_West := Ferry.Position_East_West - Value;
	    when L => 
	       Direction := Change_Direction(Direction, L, Value);
	    when R => 
	       Direction := Change_Direction(Direction, R, Value);
	    when F=> 
	       case Direction is
	       when N => Ferry.Position_North_South := Ferry.Position_North_South + Value;
	       when S => Ferry.Position_North_South := Ferry.Position_North_South - Value;
	       when E => Ferry.Position_East_West := Ferry.Position_East_West + Value;
	       when W => Ferry.Position_East_West := Ferry.Position_East_West - Value;
	       end case;
	    end case;
         end;
      end loop;
      Close(Input);

      Reponse := abs(Ferry.Position_East_West)+ abs(Ferry.Position_North_South);
      Put_Line("Reponse (part1) : " & Reponse'Img);
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
   end Execute;


end Advent.Day12;
