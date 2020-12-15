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
   
   
   --
   procedure Rotate(Move : in Move_Type; Value : in Natural; Waypoint : in out Ferry_Type)  is
      Rotation : Natural := Value mod 89; -- 90 degrees 
      Left : Natural := 0;
      Right : Natural := 0;
   begin
      case Move is
      when L => Left := Value;
      when R => Right := Value; 
      end case;
      
      Rotation := ((Left-Right) mod 360) mod 89;
      
      case Rotation is
      when 0 => null;
      when 1 => 
	 Waypoint := (Position_East_West => -Waypoint.Position_North_South, Position_North_South => Waypoint.Position_East_West);
      when 2 => 
	 Waypoint := (Position_East_West => -Waypoint.Position_East_West, Position_North_South => -Waypoint.Position_North_South);
      when 3 => 
	 Waypoint := (Position_East_West => Waypoint.Position_North_South, Position_North_South => -Waypoint.Position_East_West);
      when others => null;
      end case;
           
   end Rotate;
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Ferry : Ferry_Type;
      Ferry_2 : Ferry_Type;
      Waypoint : Ferry_Type := (Position_East_West => 10, Position_North_South => 1);
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
	    when N => 
	       Ferry.Position_North_South := Ferry.Position_North_South + Value;
	       Waypoint.Position_North_South := Waypoint.Position_North_South + Value;
	       
	    when S => 
	       Ferry.Position_North_South := Ferry.Position_North_South - Value;
	       Waypoint.Position_North_South := Waypoint.Position_North_South - Value;
	       
	    when E => 
	       Ferry.Position_East_West := Ferry.Position_East_West + Value;
	       Waypoint.Position_East_West := Waypoint.Position_East_West + Value;
	       
	    when W => 
	       Ferry.Position_East_West := Ferry.Position_East_West - Value;
	       Waypoint.Position_East_West := Waypoint.Position_East_West - Value;
	       
	    when L => 
	       Direction := Change_Direction(Direction, L, Value);
	       Rotate(L, Value, Waypoint);
	       
	    when R => 
	       Direction := Change_Direction(Direction, R, Value);
	       Rotate(R, Value, Waypoint);
	       
	    when F=>      
	       case Direction is
	       when N => 
		  Ferry.Position_North_South := Ferry.Position_North_South + Value;
	       when S => 
		  Ferry.Position_North_South := Ferry.Position_North_South - Value;
	       when E => 
		  Ferry.Position_East_West := Ferry.Position_East_West + Value;
	       when W => 
		  Ferry.Position_East_West := Ferry.Position_East_West - Value;
	       end case;
	       
	       Ferry_2.Position_North_South := Ferry_2.Position_North_South + (Value * Waypoint.Position_North_South);
	       Ferry_2.Position_East_West := Ferry_2.Position_East_West + (Value * Waypoint.Position_East_West);
	       
	    end case;
         end;
      end loop;
      Close(Input);

      Reponse := abs(Ferry.Position_East_West)+ abs(Ferry.Position_North_South);
      Reponse_2 := abs(Ferry_2.Position_East_West)+ abs(Ferry_2.Position_North_South); 
      Put_Line("Reponse (part1) : " & Reponse'Img);
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
   end Execute;


end Advent.Day12;
