--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 2 / Day 2
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;

package body Advent.Day2 is
   
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
            Min : Natural := 0;
            Max : Natural := 0;
            Char_Policy : String := " ";
            Position_Passwd : Natural := 0;
            Position_Policy_Begin : Natural := 0;
            Position_Policy_End : Natural := 0;
            Nb_Occurence : Natural := 0;
         begin
            Position_Policy_Begin := Index (Line, "-", 1);
            Position_Policy_End := Index (Line, " ", 1);
            Position_Passwd := Index (Line, ":", 1);
            Min := Natural'Value(Line(1..Position_Policy_Begin-1));
            Max := Natural'Value(Line(Position_Policy_Begin+1..Position_Policy_End-1));
            Char_Policy := Line(Position_Policy_End+1..Position_Passwd-1);
            for c in Position_Passwd+2..Line'Length loop
               if Line(c) = Char_Policy(1) then
                  Nb_Occurence := Nb_Occurence +1;
               end if;
            end loop;
            
            if Min <= Nb_Occurence and  Nb_Occurence <= Max then
               Reponse := Reponse + 1;
            end if;
            
            -- Part 2 : Min => first position ; Max => second position
            Min := Min + Position_Passwd+1;
            Max := Max + Position_Passwd+1;
            if Min <= Line'Length and Max <= Line'Length then
               if (Line(Min) = Char_Policy(1) and Line(Max) /= Char_Policy(1)) 
                 or else (Line(Min) /= Char_Policy(1) and Line(Max) = Char_Policy(1)) then
                  Reponse_2 := Reponse_2 + 1;
               end if;
            end if;
         end;
      end loop;
      Close(Input);
      
      Put_Line("Reponse (part1) : " & Reponse'Img);
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
      
   end Execute;

end Advent.Day2;
