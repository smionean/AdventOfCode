--+-------------------------------------------------------------------------+-- 
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2022 : 01
--|   * Name : Simon Be�n
--|   * Date : Mon Dec  2 21:42:21 EST 2024
--|   
--|   * Filename : day01.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2023
--|                        Jour 01
--|
--|                 (en) : Advent Of Code Challenge 2023
--|                        Day 01
--|
--|   #AdaAdventOfCode23
--|
--+-------------------------------------------------------------------------+--
--|   * Changelog * 
--|
--|
--+-------------------------------------------------------------------------+--

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Containers.Vectors;

procedure Day01 is

   package Location_Id_Vector is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                         Element_Type => Natural);
   package Location_Id_Sorter is new Location_Id_Vector.Generic_Sorting;


   function Find_Occurence(V : in Location_Id_Vector.Vector; Element: Natural) return Natural is
      Count : Natural := 0;
   begin
      for E in V.First_Index .. V.Last_Index loop
         if V.Element(E) = Element then
            Count := Count + 1;
         end if;
      end loop;
      return Count;
   end Find_Occurence;

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Natural := 0;
      Reponse_2 : Natural := 0;
      Location_Id_Left : Location_Id_Vector.Vector;
      Location_Id_Right : Location_Id_Vector.Vector;
      Position_Separator : Natural := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
            Left : Natural := 0;
            Right : Natural := 0;
         begin
            Position_Separator := Index (Line, " ", 1);

            Left := Natural'Value(Line(1..Position_Separator-1));
            Right :=  Natural'Value(Line(Position_Separator+1..Line'Last));

            Location_Id_Left.Append(Left);
            Location_Id_Right.Append(Right);
         end;
      end loop;
      Close(Input);

      Location_Id_Sorter.Sort(Location_Id_Left);
      Location_Id_Sorter.Sort(Location_Id_Right);
      
      for A in Location_Id_Left.First_Index .. Location_Id_Left.Last_Index loop
         Reponse := Reponse + abs(Location_Id_Left.Element(A)-Location_Id_Right.Element(A));
         Reponse_2 := Reponse_2 + (Location_Id_Left.Element(A) * Find_Occurence(Location_Id_Right, Location_Id_Left.Element(A)));
      end loop;

      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;



begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 01");
   Execute("data/data.txt");
end Day01;
