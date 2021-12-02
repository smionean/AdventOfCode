--------------------------------------------
-- D�fi Calnedrier de l'Avent 2021
--   Advent Of Code Challenge 2021
--
-- #AdaAdventOfCode21
--
-- https://adventofcode.com
--
-- Simon Be�n : https://github.com/smionean
--
-- Jour 02 / Day 02
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

procedure Day02 is

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Forward : Integer := 0;
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
         begin
            Position := Index (Line, " ", 1);
            declare 
               Commande : String := Line(1..Position-1);
            begin
               Distance := Integer'Value(Line(Position..Line'Length));
               case Commande(1) is
                  when 'f' => Forward := Forward + Distance; Depth_2 := Depth_2 + (Depth * Distance);
                  when 'u' => Depth := Depth - Distance; 
                  when 'd' => Depth := Depth + Distance; 
                  when others => Put_Line("Commande inconnue : "&Commande);
               end case;
            end;
         end;
      end loop;
      Close(Input);
      Reponse := Forward * Depth;
      Reponse_2 := Forward * Depth_2;
            
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
