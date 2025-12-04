--+-------------------------------------------------------------------------+--
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2022 : 03
--|   * Name : Simon Beàn
--|   * Date : Wed Dec  3 16:13:55 EST 2025
--|
--|   * Filename : day03.adb
--|
--|   * Description (fr) : Défi Calnedrier de l'Avent 2025
--|                        Jour 03
--|
--|                 (en) : Advent Of Code Challenge 2025
--|                        Day 03
--|
--|   #AdaAdventOfCode25
--|
--+-------------------------------------------------------------------------+--
--|   * Changelog *
--|
--|
--+-------------------------------------------------------------------------+--

with Ada.Text_IO;              use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

procedure Day03 is

   procedure Execute (fichier : in String) is
      Input     : File_Type;
      Reponse   : Integer := 0;
      Reponse_2 : Integer := 0;
   begin
      Open (File => Input, Mode => In_File, Name => fichier);
      -- Get Data
      while not End_Of_File (Input) loop
         declare
            Line : String := Get_Line (Input);
         begin
            null;
         end;
      end loop;
      Close (Input);

      Put_Line ("Results (part1) : " & Reponse'Img);
      Put_Line ("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line ("TEST");
   Execute ("data/test.txt");

   New_Line;
   Put_Line ("CHALLENGE DAY 03");
   Execute ("data/data.txt");
end Day03;
