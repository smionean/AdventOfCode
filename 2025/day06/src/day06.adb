--+-------------------------------------------------------------------------+--
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2025 : 06
--|   * Name : Simon Beàn
--|   * Date : Sat Dec  6 11:52:20 EST 2025
--|
--|   * Filename : day06.adb
--|
--|   * Description (fr) : Défi Calnedrier de l'Avent 2025
--|                        Jour 06
--|
--|                 (en) : Advent Of Code Challenge 2025
--|                        Day 06
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
with Ada.Strings.Fixed;        use Ada.Strings.Fixed;
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Characters.Handling;  use Ada.Characters.Handling;
with Ada.Containers.Vectors;
with Ada.Strings.Maps;         use Ada.Strings.Maps;

with Ada.Strings; use Ada.Strings;
--
--  with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Day06 is

   Whitespace : constant Ada.Strings.Maps.Character_Set :=
     Ada.Strings.Maps.To_Set (' ');

   package Sheet_Vector is new
     Ada.Containers.Vectors (Index_Type => Natural, Element_Type => Natural);

   package Worksheet_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Sheet_Vector.Vector,
        "="          => Sheet_Vector."=");

   package Operator_Vector is new
     Ada.Containers.Vectors (Index_Type => Natural, Element_Type => Character);

   function Add
     (Left : Long_Long_Integer; Right : Natural) return Long_Long_Integer is
   begin
      return Left + Long_Long_Integer (Right);
   end Add;

   function Multiply
     (Left : Long_Long_Integer; Right : Natural) return Long_Long_Integer is
   begin
      return Left * Long_Long_Integer (Right);
   end Multiply;

   function Evaaluate_Equation
     (Worksheet : Worksheet_Vector.Vector; Operands : Operator_Vector.Vector)
      return Natural
   is
      Ans : Natural := 0;
   begin
      for I in Worksheet.First_Index .. Worksheet.Last_Index loop
         null;
         --if Operands.Element (I) = "+" then
         --Ans := Add(Ans,Worksheet.)
      end loop;
      return Ans;
   end Evaaluate_Equation;

   function Evaluate_Equation
     (Worksheet : Worksheet_Vector.Vector; Operands : Operator_Vector.Vector)
      return Long_Long_Integer
   is
      Sheet : Sheet_Vector.Vector := Sheet_Vector.Empty_Vector;
      Ans   : Long_Long_Integer := 0;
      Inter : Long_Long_Integer := 1;
   begin
      for Index in Operands.First_Index .. Operands.Last_Index loop
         if Operands.Element (Index) = '+' then
            Inter := 0;
         elsif Operands.Element (Index) = '*' then
            Inter := 1;
         end if;
         for W in Worksheet.First_Index .. Worksheet.Last_Index - 1 loop
            if Operands.Element (Index) = '+' then
               Inter := Add (Inter, Worksheet.Element (W).Element (Index));
            elsif Operands.Element (Index) = '*' then
               Inter :=
                 Multiply (Inter, Worksheet.Element (W).Element (Index));
            end if;

         end loop;
         Ans := Ans + Inter;
      end loop;
      return Ans;
   end Evaluate_Equation;

   procedure Parse_Worksheet
     (Ligne            : in String;
      Vecteur_Sequence : in out Sheet_Vector.Vector;
      Operands         : in out Operator_Vector.Vector)
   is
      F      : Positive;
      L      : Natural;
      I      : Natural := 1;
      Valeur : Natural := 0;
   begin
      while I in Ligne'Range loop
         Find_Token
           (Source => Ligne,
            Set    => Whitespace,
            From   => I,
            Test   => Outside,
            First  => F,
            Last   => L);

         exit when L = 0;

         if Is_Digit (Ligne (F)) then
            Put_line (Ligne (F .. L));
            Valeur := Natural'Value (Ligne (F .. L));
            Vecteur_Sequence.Append (Valeur);
         elsif Ligne (F) = '+' or Ligne (F) = '*' then
            Put_line (Ligne (F .. F));
            Operands.Append (Ligne (F));
         end if;
         I := L + 1;
      end loop;
   end Parse_Worksheet;


   procedure Execute (fichier : in String) is
      Input     : File_Type;
      Reponse   : Long_Long_Integer := 0;
      Reponse_2 : Integer := 0;
      Worksheet : Worksheet_Vector.Vector := Worksheet_Vector.Empty_Vector;
      Operands  : Operator_Vector.Vector := Operator_Vector.Empty_Vector;
   begin
      Open (File => Input, Mode => In_File, Name => fichier);
      -- Get Data
      while not End_Of_File (Input) loop
         declare
            Line  : String := Get_Line (Input);
            Sheet : Sheet_Vector.Vector := Sheet_Vector.Empty_Vector;
         begin
            if Line'Length > 0 then
               Parse_Worksheet (Line, Sheet, Operands);
               Worksheet.Append (Sheet);
            end if;
         end;
      end loop;
      Close (Input);

      Reponse := Evaluate_Equation (Worksheet, Operands);

      Put_Line ("Results (part1) : " & Reponse'Img);
      Put_Line
        ("Results (part2) : the young cephalopod went to sleep"); -- & Reponse_2'Img);
   end Execute;

begin
   Put_Line ("TEST");
   Execute ("data/test.txt");

   New_Line;
   Put_Line ("CHALLENGE DAY 06");
--  Execute ("data/input.txt");
end Day06;
