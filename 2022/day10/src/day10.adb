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
--|   * Project name : Advent of Code 2022 : 10
--|   * Name : Simon Be�n
--|   * Date : Sat 10 Dec 2022 03:46:27 PM EST
--|   
--|   * Filename : day10.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2022
--|                        Jour 10
--|
--|                 (en) : Advent Of Code Challenge 2022
--|                        Day 10
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
with Ada.Containers.Vectors;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;

procedure Day10 is

   type Type_Instruction is (noop, addx);
   type Type_Screen_Cycle is mod 239;
   type Type_Screen is array (Type_Screen_Cycle) of Character;

   function Signal_Strength(Cycle : Natural; Register_Value : Integer) return Integer is
   begin
      if Cycle = 20 or Cycle = 60 or Cycle = 100 or Cycle = 140 or Cycle = 180 or Cycle = 220 then
         return (Cycle*Register_Value);
      end if;
      return 0;
   end Signal_Strength; 

   procedure Draw_Screen(Cycle : Natural; Register_Value : Integer; Screen : in out Type_Screen) is
   begin
     null;
   end Draw_Screen; 

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Instruction : Type_Instruction := noop;
      Add_X : integer := 1;
      Cycle : Natural := 0;
      Cycle_Add_X : Natural := 0;
      Register_Value : Integer := 1;
      Position : Natural := 0;
      Screen : Type_Screen := (others => '.');
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            Position := Index (Line, " ", 1);
            Cycle := Cycle + 1;
            Reponse := Reponse + Signal_Strength(Cycle,Register_Value);
            if Position > 0 then
               Instruction := addx;
               Add_X := Integer'Value(Line(Position..Line'Last));              
               Cycle := Cycle + 1; 
               Reponse := Reponse + Signal_Strength(Cycle,Register_Value);
            else
               Instruction := noop;
            end if;
            
 

            if Instruction = addx then
               Register_Value := Register_Value + Add_X;
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
   Put_Line("CHALLENGE DAY 10");
   Execute("data/data.txt");
end Day10;
