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
--|   * Project name : Advent of Code 2022 : 01
--|   * Name : Simon Be�n
--|   * Date : Thu 01 Dec 2022 09:37:51 PM EST
--|   
--|   * Filename : day01.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2022
--|                        Jour 01
--|
--|                 (en) : Advent Of Code Challenge 2022
--|                        Day 01
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

procedure Day01 is

   procedure Process(Max_Calories, Max_Calories_2, Max_Calories_3 : in out Natural;
                     Elf_With_Max, Elf_With_Max_2, Elf_With_Max_3 : in out Positive;
                     Calories_Count : in out Natural;
                     Elf_Id : in out Positive) is
   
   begin
      if Calories_Count > Max_Calories then
         Max_Calories_3 := Max_Calories_2;
         Max_Calories_2 := Max_Calories;
         Max_Calories := Calories_Count;

         Elf_With_Max_3 := Elf_With_Max_2;
         Elf_With_Max_2 := Elf_With_Max;
         Elf_With_Max := Elf_Id;
      end if;

      if Calories_Count > Max_Calories_2  and Calories_Count < Max_Calories then
         Max_Calories_3 := Max_Calories_2;
         Max_Calories_2 := Calories_Count;

         Elf_With_Max_3 := Elf_With_Max_2;
         Elf_With_Max_2 := Elf_Id;
      end if;

      if Calories_Count > Max_Calories_3 and Calories_Count < Max_Calories and Calories_Count < Max_Calories_2 then
         Max_Calories_3 := Calories_Count;

         Elf_With_Max_3 := Elf_Id;
      end if;

      Calories_Count := 0;
      Elf_Id := Elf_Id + 1;
   end Process;

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Max_Calories : Natural := 0;
      Max_Calories_2 : Natural := 0;
      Max_Calories_3 : Natural := 0;
      Calories_Count : Natural := 0;
      Elf_With_Max : Positive := 1;
      Elf_With_Max_2 : Positive := 1;
      Elf_With_Max_3 : Positive := 1;
      Elf_Id : Positive := 1; 
      Reponse_2 : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            if Line /= "" then
               Calories_Count := Calories_Count + Natural'Value(Line);
            else
               Process(Max_Calories => Max_Calories,
                       Max_Calories_2 => Max_Calories_2,
                       Max_Calories_3 => Max_Calories_3,
                       Elf_With_Max => Elf_With_Max,
                       Elf_With_Max_2 => Elf_With_Max_2,
                       Elf_With_Max_3 => Elf_With_Max_3,
                       Elf_Id => Elf_Id,
                       Calories_Count => Calories_Count
                       );
               
            end if;
         end;
      end loop;
      Close(Input);

      Process(Max_Calories => Max_Calories,
            Max_Calories_2 => Max_Calories_2,
            Max_Calories_3 => Max_Calories_3,
            Elf_With_Max => Elf_With_Max,
            Elf_With_Max_2 => Elf_With_Max_2,
            Elf_With_Max_3 => Elf_With_Max_3,
            Elf_Id => Elf_Id,
            Calories_Count => Calories_Count
            );

      Reponse_2 := Max_Calories + Max_Calories_2 + Max_Calories_3;
      Put_Line("Results (part1) : " & Max_Calories'Img & " (elf : " & Elf_With_Max'Img & " )");
      New_Line;
      Put_Line("Results (part2) : " & Max_Calories'Img & " (elf : " & Elf_With_Max'Img & " )");
      Put_Line("                : " & Max_Calories_2'Img & " (elf : " & Elf_With_Max_2'Img & " )");
      Put_Line("                : " & Max_Calories_3'Img & " (elf : " & Elf_With_Max_3'Img & " )");
      Put_Line("Total           : " & Reponse_2'Img );
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 01");
   Execute("data/data.txt");
end Day01;
