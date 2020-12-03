--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 1 / Day 1
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

package body Advent.Day1 is


  package type_vector_data is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                         Element_Type => Natural);
   
   function Sum_Is_2020 (A : in Natural; B : in Natural) return Boolean is
   begin
      return A + B = 2020;
   end Sum_Is_2020;

   function Sum_Is_2020 (A : in Natural; B : in Natural; C : in Natural ) return Boolean is
   begin
      return A + B + C = 2020;
   end Sum_Is_2020;

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Data : type_vector_data.Vector;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            Data.Append(Natural'Value(Line));
         end;
      end loop;
      Close(Input);
      
      for I in 1..Data.Last_Index loop
         for J in 1..Data.Last_Index loop
            if Reponse = 0 and I /= J and Sum_Is_2020(Data.Element(I), Data.Element(J)) then
               Put_Line("A : " & Data.Element(I)'Img & " B : "& Data.Element(J)'Img);
               Reponse := Data.Element(I) * Data.Element(J);
            end if;
            for K in 1..Data.Last_Index loop
               if Reponse_2 = 0 and I /= J and Sum_Is_2020(Data.Element(I), Data.Element(J), Data.Element(K)) then
                  Put_Line("A : " & Data.Element(I)'Img & " B : "& Data.Element(J)'Img& " C : "& Data.Element(K)'Img);
                  Reponse_2 := Data.Element(I) * Data.Element(J) * Data.Element(K) ;
            end if; 
            end loop;
         end loop;   
      end loop;
            
      Put_Line("Reponse (part1) : " & Reponse'Img);
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
   end Execute;


end Advent.Day1;
