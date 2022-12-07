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
--|   * Project name : Advent of Code 2022 : 06
--|   * Name : Simon Be�n
--|   * Date : Tue 06 Dec 2022 08:56:32 PM EST
--|   
--|   * Filename : day06.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2022
--|                        Jour 06
--|
--|                 (en) : Advent Of Code Challenge 2022
--|                        Day 06
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
with Ada.Containers.Ordered_Sets;

procedure Day06 is

   package set_validator is new Ada.Containers.Ordered_Sets(character);
   use set_validator;

   function is_valid(code : in string) return boolean is
      a_set : set_validator.set := set_validator.empty_set;
      valid : boolean := true;
   begin
      for c of code loop
         if not a_set.contains(c) then
            a_set.insert(c);
         else
            valid := false;
         end if;
      end loop;
      --  Put_Line(code&" "&valid'img);
      return valid;
   end is_valid;

   procedure Execute(fichier : in String) is
      Input : File_Type;
      i : positive := 1;
      code : string(1..4) := (others => ' ');
      code_2 : string(1..14) := (others => ' ');
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
            i := line'first;
            loop -- part 1
               code(1..4) := line(i..i+3);
               i := i + 1;
               exit when I > Line'Length-4 or is_valid(code);
            end loop;
            reponse := i + 2;

            i := line'first;
            loop -- part 2
               code_2(1..14) := line(i..i+13);
               i := i + 1;
               exit when I > Line'Length-14 or is_valid(code_2);
            end loop;
            reponse_2 := i + 12;

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
   Put_Line("CHALLENGE DAY 06");
   Execute("data/data.txt");
end Day06;
