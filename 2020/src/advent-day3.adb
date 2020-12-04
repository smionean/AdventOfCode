--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 3 / Day 3
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Calendar; use Ada.Calendar;
with Ada.Containers.Vectors;
with Parallel_Analyse;

package body Advent.Day3 is




   function Analyse_Path ( Map : in Parallel_Analyse.type_vector_data.Vector;  Horizontal_Move : in Natural;  Vertical_Move : in Natural ) return Natural is
      Trees_Encounter : Natural := 0;
      Horizontal_Position : Natural := 0;
      Vertical_Position : Natural := Map.First_Index;
   begin
      while Vertical_Position <= Map.Last_Index loop
         declare
            Altitude : Parallel_Analyse.Line_Map :=  Map.Element(Vertical_Position);
            Adjusted_Horizontal_Position : Natural := Horizontal_Position mod Altitude'Length + 1;
         begin
            if Altitude(Adjusted_Horizontal_Position) = '#' then
               Trees_Encounter := Trees_Encounter + 1;
            end if;
            --
            Horizontal_Position := Horizontal_Position + Horizontal_Move;
            Vertical_Position := Vertical_Position + Vertical_Move;
         end;
      end loop;
      return Trees_Encounter;
   end Analyse_Path;


   procedure Execute(fichier : in String) is
      Input : File_Type;
      Data : Parallel_Analyse.type_vector_data.Vector;
      Trees_Encounter_Path_1 : Natural := 0;
      Trees_Encounter_Path_2 : Natural := 0;
      Trees_Encounter_Path_3 : Natural := 0;
      Trees_Encounter_Path_4 : Natural := 0;
      Trees_Encounter_Path_5 : Natural := 0;
      Reponse : Long_Long_Integer := 0;
      Start : Time;
      Stop : Time;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : Parallel_Analyse.Line_Map := Get_Line (Input);
         begin
            Data.Append(Line);
         end;
      end loop;
      Close(Input);

      Start := Clock;
      Trees_Encounter_Path_1 := Analyse_Path(Data,1,1);
      Trees_Encounter_Path_2 := Analyse_Path(Data,3,1);
      Trees_Encounter_Path_3 := Analyse_Path(Data,5,1);
      Trees_Encounter_Path_4 := Analyse_Path(Data,7,1);
      Trees_Encounter_Path_5 := Analyse_Path(Data,1,2);
      Reponse := Long_Long_Integer(Trees_Encounter_Path_1)
        * Long_Long_Integer(Trees_Encounter_Path_2)
        * Long_Long_Integer(Trees_Encounter_Path_3)
        * Long_Long_Integer(Trees_Encounter_Path_4)
        * Long_Long_Integer(Trees_Encounter_Path_5);
      Stop := Clock;
      Put_Line("Reponse (part1) : " & Trees_Encounter_Path_2'Img);
      Put_Line("Reponse (part2) : " & Reponse'Img);
      Put_Line("Addition elapsed time is " &
                 Duration'Image (Stop - Start) &
                 " seconds.");

      Start := Clock;
      Reponse := Parallel_Analyse.Calculate_Possibility(Data);
      Stop := Clock;
      Put_Line("Reponse (task-version) : " & Reponse'Img);
            Put_Line("Addition elapsed time is " &
                 Duration'Image (Stop - Start) &
                 " seconds.");
   end Execute;

end Advent.Day3;
