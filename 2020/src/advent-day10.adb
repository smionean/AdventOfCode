--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 10 / Day 10
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

package body Advent.Day10 is

   package Adapter_Vector is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                         Element_Type => Natural);
   package Adapter_Sorter is new Adapter_Vector.Generic_Sorting;

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Adapters : Adapter_Vector.Vector;
      Adapter : Natural := Natural'Last;
      Adapter_Position : Natural := 0;
      Total_1Jolt : Natural := 0;
      Total_2Jolt : Natural := 0;
      Total_3Jolt : Natural := 0;
      C : Adapter_Vector.Cursor;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      	    Adapters.Append(0);
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
	    Adapters.Append(Natural'Value(Line));
         end;
      end loop;
      Close(Input);
      
      Adapter_Sorter.Sort(Adapters);

      
      for A in Adapters.First_Index .. Adapters.Last_Index-1 loop
	 if Adapters.Element(A+1) - Adapters.Element(A) = 1 then
	    Total_1Jolt := Total_1Jolt + 1;
	 elsif Adapters.Element(A+1) - Adapters.Element(A) = 3 then
	    Total_3Jolt := Total_3Jolt + 1;
	 elsif Adapters.Element(A+1) - Adapters.Element(A) = 2 then
	    Total_2Jolt := Total_2Jolt + 1;
	 else
	    Put_Line("Hmmmm");
	 end if;
      end loop;
      Total_3Jolt := Total_3Jolt + 1; -- final plug
      
      Put_Line ("Jolt1 "& Total_1Jolt'Img &" Jolt2 "&Total_2Jolt'Img&" Jolt3 "&Total_3Jolt'Img);
      Reponse := Total_1Jolt * Total_3Jolt;
   

      Put_Line("Reponse (part1) : " & Reponse'Img);
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
   end Execute;


end Advent.Day10;
