--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 6 / Day 6
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

package body Advent.Day6 is

   type Question_Set is array (Character range 'a' .. 'z') of Boolean;
    type Question_Array is array (Character range 'a' .. 'z') of Natural;
   procedure Execute(fichier : in String) is
      Input : File_Type;
       Answer : Question_Set := (others => False);
      Answer_Sum : Question_Array := (others => 0);
      Line_Count : Natural := 0;
      Yes_Answer : Integer := 0;
      Everybody_Yes_Answer : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            if Line = "" then
               for b of Answer loop
                  if b then
                     Yes_Answer := Yes_Answer + 1;
                  end if;
               end loop;
								 
               for b of Answer_Sum loop
                  if b = Line_Count then
                     Everybody_Yes_Answer := Everybody_Yes_Answer + 1;
                  end if;
               end loop;								 
               
               --Reponse := Answer'Count
               Answer := (others => False);
               Answer_Sum := (others => 0);
               Line_Count := 0;
               
            else
               Line_Count := Line_Count + 1;
               for c of Line loop
                  if Is_Letter(c) then
                     Answer(c) := True;
                     Answer_Sum(c) := Answer_Sum(c) + 1;
                  end if;
               end loop;
               
            end if;
            
         end;
      end loop;
      --fin
      for b of Answer loop
         if b then
            Yes_Answer := Yes_Answer + 1;
         end if;
      end loop;
				
      for b of Answer_Sum loop
         if b = Line_Count then
            Everybody_Yes_Answer := Everybody_Yes_Answer + 1;
         end if;
      end loop;	
      Close(Input);

            
      Put_Line("Reponse (part1) : " & Yes_Answer'Img);
      Put_Line("Reponse (part2) : " & Everybody_Yes_Answer'Img);
   end Execute;


end Advent.Day6;
