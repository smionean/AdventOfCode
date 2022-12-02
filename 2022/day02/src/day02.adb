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
--|   * Project name : Advent of Code 2022 : 02
--|   * Name : Simon Be�n
--|   * Date : Fri 02 Dec 2022 08:24:29 AM EST
--|   
--|   * Filename : day02.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2022
--|                        Jour 02
--|
--|                 (en) : Advent Of Code Challenge 2022
--|                        Day 02
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

procedure Day02 is

   type Combinaison_1 is (B_X, C_Y, A_Z,  --lost
                          A_X, B_Y, C_Z,  --draw
                          C_X, A_Y, B_Z ); --win

   type Combinaison_2 is (B_X, C_X, A_X,  --lost
                          A_Y, B_Y, C_Y,  --draw
                          C_Z, A_Z, B_Z ); --win

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Play_1 : Combinaison_1;
      Play_2 : Combinaison_2;
      Score_1 : Natural := 0;
      Score_2 : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            Line(2) :=  '_';

            Play_1 := Combinaison_1'Value(Line);
            Play_2 := Combinaison_2'Value(Line);
            Score_1 := Score_1 + Combinaison_1'Pos(Play_1) + 1;
            Score_2 := Score_2 + Combinaison_2'Pos(Play_2) + 1;
         end;
      end loop;
      Close(Input);
            
      Put_Line("Results (part1) : " & Score_1'Img);
      Put_Line("Results (part2) : " & Score_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 02");
   Execute("data/data.txt");
end Day02;
