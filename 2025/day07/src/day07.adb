--+-------------------------------------------------------------------------+--
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2025 : 07
--|   * Name : Simon Beàn
--|   * Date : Mon Dec  8 21:02:21 EST 2025
--|
--|   * Filename : day07.adb
--|
--|   * Description (fr) : Défi Calnedrier de l'Avent 2025
--|                        Jour 07
--|
--|                 (en) : Advent Of Code Challenge 2025
--|                        Day 07
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
with Ada.Characters.Handling;  use Ada.Characters.Handling;
with Ada.Strings.Fixed;        use Ada.Strings.Fixed;

procedure Day07 is

   type Position_Splitter is record
      X : Natural := 0;
      Y : Natural := 0;
   end record;

   package Position_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Position_Splitter);

   package Tachyon_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Character);

   package Tachyon_Manifolds_Vectors is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Tachyon_Vector.Vector,
        "="          => Tachyon_Vector."=");

   procedure Print (Tachyon_Manifolds : Tachyon_Manifolds_Vectors.Vector) is
   begin
      for L in Tachyon_Manifolds.First_Index .. Tachyon_Manifolds.Last_Index
      loop
         for C in
           Tachyon_Manifolds.Element (L).First_Index
           .. Tachyon_Manifolds.Element (L).Last_Index
         loop
            put (Tachyon_Manifolds.Element (L).Element (C));
         end loop;
         New_Line;
      end loop;
   end Print;

   procedure Beam_Falling
     (Tachyon_Manifolds : in out Tachyon_Manifolds_Vectors.Vector;
      X                 : Positive;
      Y                 : Positive)
   is
      TM : Tachyon_Manifolds_Vectors.Vector := Tachyon_Manifolds;
      TV : Tachyon_Vector.Vector := Tachyon_Vector.Empty_Vector;
   begin
      for B in Y .. TM.Last_Index loop
         if TM.Element (B).Element (X) = '.' then
            TV := TM.Element (B);
            TV.Replace_Element (X, '|');
            TM.Replace_Element (B, TV);
         elsif TM.Element (B).Element (X) = '^' then
            exit;
         end if;
      end loop;
      Tachyon_Manifolds := TM;
   end Beam_Falling;

   function Beam_Splitting
     (Tachyon_Manifolds  : in out Tachyon_Manifolds_Vectors.Vector;
      Splitters_Position : Position_Vector.Vector) return Natural
   is
      TM : Tachyon_Manifolds_Vectors.Vector := Tachyon_Manifolds;
      TV : Tachyon_Vector.Vector := Tachyon_Vector.Empty_Vector;
      n  : Natural := 0;
   begin
      for S in Splitters_Position.First_Index .. Splitters_Position.Last_Index
      loop

         if TM.Element (Splitters_Position.Element (S).Y).Element
              (Splitters_Position.Element (S).X)
           = 'S'
         then
            Beam_Falling
              (TM,
               Splitters_Position.Element (S).X,
               Splitters_Position.Element (S).Y + 1);
         elsif TM.Element (Splitters_Position.Element (S).Y).Element
                 (Splitters_Position.Element (S).X)
           = '^'
           and TM.Element (Splitters_Position.Element (S).Y - 1).Element
                 (Splitters_Position.Element (S).X)
               = '|'
         then
            Beam_Falling
              (TM,
               Splitters_Position.Element (S).X - 1,
               Splitters_Position.Element (S).Y);
            Beam_Falling
              (TM,
               Splitters_Position.Element (S).X + 1,
               Splitters_Position.Element (S).Y);
            n := n + 1;
         end if;
         --  Print (TM);
      end loop;
      Print (TM);
      return n;
   end Beam_Splitting;

   function Quantum_Beam_Splitting
     (Tachyon_Manifolds  : in out Tachyon_Manifolds_Vectors.Vector;
      Splitters_Position : Position_Vector.Vector) return Natural
   is
      TM : Tachyon_Manifolds_Vectors.Vector := Tachyon_Manifolds;
      TV : Tachyon_Vector.Vector := Tachyon_Vector.Empty_Vector;
      n  : Natural := 0;
      X  : Positive := 1;
      Y  : Positive := 1;
   begin
      for S in Splitters_Position.First_Index .. Splitters_Position.Last_Index
      loop
         X := Splitters_Position.Element (S).X;
         Y := Splitters_Position.Element (S).Y;
         if TM.Element (Y).Element (X) = 'S' then
            Beam_Falling (TM, X, Y + 1);
         elsif TM.Element (Y).Element (X) = '^'
           and TM.Element (Y - 1).Element (X) = '|'
         then
            Beam_Falling (TM, X - 1, Y);
            Beam_Falling (TM, X + 1, Y);
            n := n + 1;
         end if;
         --  Print (TM);
      end loop;
      Print (TM);
      return n;
   end Quantum_Beam_Splitting;

   procedure Execute (fichier : in String) is
      Input              : File_Type;
      Reponse            : Integer := 0;
      Reponse_2          : Integer := 0;
      Tachyon_Manifolds  : Tachyon_Manifolds_Vectors.Vector :=
        Tachyon_Manifolds_Vectors.Empty_Vector;
      Splitters_Position : Position_Vector.Vector :=
        Position_Vector.Empty_Vector;
   begin
      Open (File => Input, Mode => In_File, Name => fichier);
      -- Get Data
      while not End_Of_File (Input) loop
         declare
            Line         : String := Get_Line (Input);
            A_Position   : Position_Splitter;
            Tachyon_Line : Tachyon_Vector.Vector :=
              Tachyon_Vector.Empty_Vector;
         begin
            for C in Line'First .. Line'Last loop
               Tachyon_Line.Append (Line (C));
               if Line (C) = 'S' then
                  A_Position.X := C;
                  A_Position.Y := 1;
                  Splitters_Position.Append (A_Position);
               elsif Line (C) = '^' then
                  A_Position.X := C;
                  A_Position.Y := Tachyon_Manifolds.Last_Index + 1;
                  Splitters_Position.Append (A_Position);
               end if;
            end loop;
            Tachyon_Manifolds.Append (Tachyon_Line);
         end;
      end loop;
      Reponse := Beam_Splitting (Tachyon_Manifolds, Splitters_Position);
      Close (Input);

      Put_Line ("Results (part1) : " & Reponse'Img);
      Put_Line ("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line ("TEST");
   Execute ("data/test.txt");

   New_Line;
   Put_Line ("CHALLENGE DAY 07");
--  Execute ("data/input.txt");
end Day07;
