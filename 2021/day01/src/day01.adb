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
-- Jour 01 / Day 01
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

procedure Day01 is

   package type_vector_data is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                          Element_Type => Natural);
   
   function Mesure(Data : in type_vector_data.Vector) return Natural is
      Reponse : Integer := 0;
      Prec : Natural := 0;
   begin
      Prec := Data.Element(Data.First_Index);
      for I in Data.First_Index+1..Data.Last_Index loop
         if Data.Element(I) > Prec then
            Reponse := Reponse + 1;
         end if;
         Prec := Data.Element(I);
      end loop;
      return Reponse;
   end Mesure;
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Prec : Natural := 0;
      Somme : Natural := 0;
      Data : type_vector_data.Vector;
      Data2 : type_vector_data.Vector;
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

      Reponse := Mesure(Data); 

      Prec := Data.Element(Data.First_Index);
      for I in Data.First_Index+1..Data.Last_Index loop         
         -- pour le second defi
         if I+1 <= Data.Last_Index then
            somme := Prec + Data.Element(I) + Data.Element(I+1);
         end if;
         Data2.Append(somme);

         Prec := Data.Element(I);
      end loop;
            
      Reponse_2:= Mesure(Data2); 

      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   New_Line;
   Put_Line("CHALLENGE DAY 01");
   Execute("data/data.txt");
end Day01;
