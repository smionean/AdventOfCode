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
with Advent.Day13;
with Advent.Day14;
with Advent.Day15;

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

   function Change_Folder (Request : Boolean := False) Return String is
   begin
      if Request then
	 return "../";
      else
	 return "";
      end if;
   end Change_Folder;

   Input         : Unbounded_String;
   Do_I_Change_Folder : Boolean := False;
begin

   loop
      Input := Question_Reponse("Donne le jour du defi (quit pour quitter):");

      exit when Input = "quit";

      if Input = "0" then
	 Do_I_Change_Folder := True;
      end if;

      if Input = "1" then
         Advent.Day1.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent01.txt");
      elsif Input = "2" then
         Advent.Day2.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent02.txt");
      elsif Input = "3" then
         Advent.Day3.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent03.txt");
      elsif Input = "4" then
         Advent.Day4.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent04.txt");
      elsif Input = "5" then
         Advent.Day5.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent05.txt");
      elsif Input = "6" then
         Advent.Day6.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent06.txt");
      elsif Input = "7" then
	 Put_Line("Sorry no solution for now.");
	 --Advent.Day7.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent07.txt");
      elsif Input = "8" then
	 Advent.Day8.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent08.txt");
      elsif Input = "9" then
	 Advent.Day9.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent09.txt");
      elsif Input = "10" then
	 Advent.Day10.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent10.txt");
      elsif Input = "11" then
	 Put_Line("Sorry no time to think.");
	 --Advent.Day11.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent11.txt");
      elsif Input = "12" then
	 Advent.Day12.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent12.txt");
      elsif Input = "13" then
	 Advent.Day13.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent13.txt");
      elsif Input = "14" then
	 Advent.Day14.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent14.txt");
      elsif Input = "15" then
         Advent.Day15.Execute(Change_Folder(Do_I_Change_Folder)&"data/advent15.txt");
      end if;


   end loop;
end Main;
