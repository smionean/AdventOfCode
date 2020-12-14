--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
--------------------------------------------


with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Command_Line;      use Ada.Command_Line;
with Advent.Day1;
with Advent.Day2;
with Advent.Day3;
with Advent.Day4;
with Advent.Day5;
with Advent.Day6;
--with Advent.Day7;
with Advent.Day8;
with Advent.Day9;
with Advent.Day10;
--with Advent.Day11;
with Advent.Day12;

procedure Main is

   function Question_Reponse(Question : in String) return Unbounded_String is
      Input         : Unbounded_String;
      Console_Input : String (1 .. 128);
      Last          : Natural;
   begin
      Put(Question & " ");
      Get_Line (Console_Input, Last);
      Input := To_Unbounded_String (Console_Input (1 .. Last));
      --Put_Line(To_String (Input));
      return Input;
   end Question_Reponse;

   Input         : Unbounded_String;
begin

   loop
      Input := Question_Reponse("Donne le jour du defi (quit pour quitter):");

      exit when Input = "quit";

      if Input = "1" then
         Advent.Day1.Execute("data/advent01.txt");
      elsif Input = "2" then
         Advent.Day2.Execute("data/advent02.txt");
      elsif Input = "3" then
         Advent.Day3.Execute("data/advent03.txt");
      elsif Input = "4" then
         Advent.Day4.Execute("data/advent04.txt");
      elsif Input = "5" then
         Advent.Day5.Execute("data/advent05.txt");
      elsif Input = "6" then
         Advent.Day6.Execute("data/advent06.txt");
      elsif Input = "7" then
	 Put_Line("Sorry no solution for now.");
	 --Advent.Day7.Execute("data/advent07.txt");
      elsif Input = "8" then
	 Advent.Day8.Execute("data/advent08.txt");
      elsif Input = "9" then
	 Advent.Day9.Execute("data/advent09.txt");
      elsif Input = "10" then
	 Advent.Day10.Execute("data/advent10.txt");
      elsif Input = "11" then
	 Put_Line("Sorry no time to think.");
	 --Advent.Day11.Execute("data/advent11.txt");
      elsif Input = "12" then
         Advent.Day12.Execute("data/advent12.txt");
      end if;


   end loop;
end Main;
