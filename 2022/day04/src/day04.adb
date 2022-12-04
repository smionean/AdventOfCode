--+-------------------------------------------------------------------------+-- 
--|                                                                         |--
--|                                                                         |--
--|                                  TTT                                    |--
--|                                  TTT                                    |--
--|                                  TTT                                    |--
--|                           TTT           TTT                             |--
--|                           TTT           TTT                             |--
--|                           TTTTTTTTTTTTTTTTT                             |--
--|                           TTTTTTTTTTTTTTTTT                             |--
--|                           TTT           TTT                             |--
--|                           TTT           TTT                             |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2022 : 04
--|   * Name : Simon Be�n
--|   * Date : Sun 04 Dec 2022 02:57:29 PM EST
--|   
--|   * Filename : day04.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2022
--|                        Jour 04
--|
--|                 (en) : Advent Of Code Challenge 2022
--|                        Day 04
--|
--|   #AdaAdventOfCode22
--|
--+-------------------------------------------------------------------------+--
--|   * Changelog * 
--|
--|
--+-------------------------------------------------------------------------+--

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;


procedure Day04 is

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Position_Inetrval_Seperator_1 : Natural := 0;
      Position_Separator : Natural := 0;
      Position_Inetrval_Seperator_2 : Natural := 0;
      Min_Elf_1 : Natural := 0;
      Max_Elf_1 : Natural := 0;
      Min_Elf_2 : Natural := 0;
      Max_Elf_2 : Natural := 0;    
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            Position_Inetrval_Seperator_1 := Index (Line, "-", 1);
            Position_Separator := Index (Line, ",", 1);
            Position_Inetrval_Seperator_2 := Index (Line, "-", Position_Separator);
            
            Min_Elf_1 := Natural'Value(Line(1..Position_Inetrval_Seperator_1-1));
            Max_Elf_1 := Natural'Value(Line(Position_Inetrval_Seperator_1+1..Position_Separator-1));
            Min_Elf_2 := Natural'Value(Line(Position_Separator+1..Position_Inetrval_Seperator_2-1));
            Max_Elf_2 := Natural'Value(Line(Position_Inetrval_Seperator_2+1..Line'Last));

            -- Part 1
            if (Min_Elf_1 >= Min_Elf_2 and Max_Elf_1 <= Max_Elf_2) or (Min_Elf_2 >= Min_Elf_1 and Max_Elf_2 <= Max_Elf_1 ) then
               Reponse := Reponse + 1;
            end if;

            -- Part 2
            if (Max_Elf_1 >= Min_Elf_2 and Min_Elf_1 <= Max_Elf_2) or (Max_Elf_2 >= Min_Elf_1 and Min_Elf_2 <= Max_Elf_1 )  then
               Reponse_2 := Reponse_2 + 1;
            end if;

         end;
      end loop;
      Close(Input);
      
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 04");
   Execute("data/data.txt");
end Day04;
