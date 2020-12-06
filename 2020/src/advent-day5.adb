--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 5 / Day 5
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;

package body Advent.Day5 is
   
	type Airplane_Plan is array (range <> ) of natural;
	
	
	procedure First_Half(Data : in out Airplane_Plan );
	
	procedure Last_Half(Data : in out Airplane_Plan );
		
   procedure Execute(fichier : in String) is
      Input : File_Type;

      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => fichier);
      
      --Get data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);

         begin
            null;
         end;
      end loop;
      Close(Input);
      
      Put_Line("Reponse (part1) : " & Reponse'Img);
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
      
   end Execute;

end Advent.Day5;
