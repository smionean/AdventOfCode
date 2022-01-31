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
-- Jour 02 / Day 02
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

procedure Day02 is

   type Commande_Type is ( forward, up, down );

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Forward_Move : Integer := 0;
      Depth : Integer := 0;
      Depth_2 : Integer := 0;
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
            Position : Natural := 0;
            Distance : Integer := 0;
            Commande : Commande_Type;
         begin
            Position := Index (Line, " ", 1);
            Commande := Commande_Type'Value(Line(1..Position-1));
            Distance := Integer'Value(Line(Position..Line'Length));
            case Commande is
               when forward => Forward_Move := Forward_Move + Distance; Depth_2 := Depth_2 + (Depth * Distance);
               when up => Depth := Depth - Distance; 
               when down => Depth := Depth + Distance; 
            end case;
         end;
      end loop;
      Close(Input);
      Reponse := Forward_Move * Depth;
      Reponse_2 := Forward_Move * Depth_2;
            
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 02");
   Execute("data/data.txt");
end Day02;
