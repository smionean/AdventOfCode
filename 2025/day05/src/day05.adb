--+-------------------------------------------------------------------------+--
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2025 : 05
--|   * Name : Simon Beàn
--|   * Date : Fri Dec  5 21:55:56 EST 2025
--|
--|   * Filename : day05.adb
--|
--|   * Description (fr) : Défi Calnedrier de l'Avent 2025
--|                        Jour 05
--|
--|                 (en) : Advent Of Code Challenge 2025
--|                        Day 05
--|
--|   #AdaAdventOfCode25
--|
--+-------------------------------------------------------------------------+--
--|   * Changelog *
--|
--|
--+-------------------------------------------------------------------------+--

with Ada.Text_IO;                           use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;              use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;                     use Ada.Strings.Fixed;
with Ada.Numerics.Big_Numbers.Big_Integers;
use Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Containers.Vectors;

procedure Day05 is

   type Fresh_Range_Type is record
      Inf_Bound : Big_Integer := 0;
      Sup_Bound : Big_Integer := 0;
   end record;

   package Freshness_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Fresh_Range_Type);

   function "<" (Left, Right : Fresh_Range_Type) return Boolean is
   begin
      return Left.Inf_Bound < Right.Inf_Bound;
   end "<";

   package Freshness_Sorter is new Freshness_Vector.Generic_Sorting;

   package Ingredients_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Big_Integer);

   function Get_Fresh_Ingredient_Count
     (Fresh_Ranges : Freshness_Vector.Vector) return Big_Integer
   is
      I         : Big_Integer := 0;
      Inf_Bound : Big_Integer := 0;
      Sup_Bound : Big_Integer := 0;
      Go_Next   : Boolean := True;
   begin
      Inf_Bound := Fresh_Ranges.First_Element.Inf_Bound;
      Sup_Bound := Fresh_Ranges.First_Element.Sup_Bound;
      I := Sup_Bound - Inf_Bound + 1;
      for R in Fresh_Ranges.First_Index + 1 .. Fresh_Ranges.Last_Index loop
         Go_Next := True;
         if Fresh_Ranges.Element (R).Inf_Bound < Inf_Bound
           and Fresh_Ranges.Element (R).Sup_Bound < Inf_Bound
         then
            I :=
              I
              + (Fresh_Ranges.Element (R).Sup_Bound
                 - Fresh_Ranges.Element (R).Inf_Bound);
         elsif Fresh_Ranges.Element (R).Inf_Bound < Inf_Bound
           and In_Range
                 (Fresh_Ranges.Element (R).Sup_Bound, Inf_Bound, Sup_Bound)
         then
            I := I + (Fresh_Ranges.Element (R).Inf_Bound - Inf_Bound);
         elsif In_Range
                 (Fresh_Ranges.Element (R).Inf_Bound, Inf_Bound, Sup_Bound)
           and Fresh_Ranges.Element (R).Sup_Bound > Sup_Bound
         then
            I := I + (Fresh_Ranges.Element (R).Sup_Bound - Sup_Bound);
         elsif not In_Range
                     (Fresh_Ranges.Element (R).Inf_Bound, Inf_Bound, Sup_Bound)
           and not In_Range
                     (Fresh_Ranges.Element (R).Sup_Bound, Inf_Bound, Sup_Bound)
         then
            I :=
              I
              + (Fresh_Ranges.Element (R).Sup_Bound
                 - Fresh_Ranges.Element (R).Inf_Bound)
              + 1;
         elsif In_Range
                 (Fresh_Ranges.Element (R).Inf_Bound, Inf_Bound, Sup_Bound)
           and In_Range
                 (Fresh_Ranges.Element (R).Sup_Bound, Inf_Bound, Sup_Bound)
         then
            Go_Next := false;
         end if;
         if Go_Next then
            Inf_Bound := Fresh_Ranges.Element (R).Inf_Bound;
            Sup_Bound := Fresh_Ranges.Element (R).Sup_Bound;
         end if;
      end loop;
      return I;
   end Get_Fresh_Ingredient_Count;

   function Find_Fresh_Ingredients
     (Fresh_Ranges : Freshness_Vector.Vector;
      Ingredients  : Ingredients_Vector.Vector) return Natural
   is
      Is_Fresh : Boolean := False;
      Count    : Natural := 0;
   begin
      for I in Ingredients.First_Index .. Ingredients.Last_Index loop
         Is_Fresh := False;
         for R in Fresh_Ranges.First_Index .. Fresh_Ranges.Last_Index loop
            if not Is_Fresh
              and Ingredients.Element (I) <= Fresh_Ranges.Element (R).Sup_Bound
              and Ingredients.Element (I) >= Fresh_Ranges.Element (R).Inf_Bound
            then
               Is_Fresh := True;
               Count := Count + 1;
            end if;
         end loop;
      end loop;
      return Count;
   end Find_Fresh_Ingredients;

   procedure Execute (fichier : in String) is
      Input           : File_Type;
      Reponse         : Integer := 0;
      Reponse_2       : Big_Integer := 0;
      Range_Completed : Boolean := False;
      Fresh_Ranges    : Freshness_Vector.Vector :=
        Freshness_Vector.Empty_Vector;
      Ingredients     : Ingredients_Vector.Vector :=
        Ingredients_Vector.Empty_Vector;

   begin
      Open (File => Input, Mode => In_File, Name => fichier);
      -- Get Data
      while not End_Of_File (Input) loop
         declare
            Line               : String := Get_Line (Input);
            Position_Separator : Natural := 0;
            A_Range            : Fresh_Range_Type;
         begin
            if Line'Length > 0 and not Range_Completed then
               Position_Separator := Index (Line, "-", 1);
               A_Range.Inf_Bound :=
                 From_String (Line (1 .. Position_Separator - 1));
               A_Range.Sup_Bound :=
                 From_String (Line (Position_Separator + 1 .. Line'Length));
               Fresh_Ranges.Append (A_Range);
            else
               Range_Completed := True;
            end if;

            if Line'Length > 0 and Range_Completed then
               Ingredients.Append (From_String (Line));
            end if;

         end;
      end loop;

      Reponse := Find_Fresh_Ingredients (Fresh_Ranges, Ingredients);
      Freshness_Sorter.Sort (Fresh_Ranges);
      Reponse_2 := Get_Fresh_Ingredient_Count (Fresh_Ranges);
      Close (Input);

      Put_Line ("Results (part1) : " & Reponse'Img);
      Put_Line ("Results (part2) : " & To_String (Reponse_2));
   end Execute;

begin
   Put_Line ("TEST");
   Execute ("data/test.txt");

   New_Line;
   Put_Line ("CHALLENGE DAY 05");
   Execute ("data/input.txt");
end Day05;
