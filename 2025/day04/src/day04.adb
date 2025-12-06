--+-------------------------------------------------------------------------+--
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2025 : 04
--|   * Name : Simon Beàn
--|   * Date : Thu Dec  4 23:20:11 EST 2025
--|
--|   * Filename : day04.adb
--|
--|   * Description (fr) : Défi Calnedrier de l'Avent 2025
--|                        Jour 04
--|
--|                 (en) : Advent Of Code Challenge 2025
--|                        Day 04
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
with Ada.Strings.Unbounded;    use Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

procedure Day04 is

   type Position_Type is record
      X : Natural := 0;
      Y : Natural := 0;
   end record;

   package Shelf_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Natural,
        Element_Type => Unbounded_String);

   package Paper_Roll_Positions_Vector is new
     Ada.Containers.Vectors
       (Index_Type   => Positive,
        Element_Type => Position_Type);

   function Is_Paper_Roll (Compartment : String) return Boolean is
   begin
      return Compartment = "@";
   end Is_Paper_Roll;

   function Add_Paper_Roll (Compartment : String) return Natural is
   begin
      return Result : Natural := 0 do
         if Is_Paper_Roll (Compartment) then
            Result := 1;
         end if;
      end return;
   end Add_Paper_Roll;

   function Calculate_Number_Of_Paper_Roll
     (Shelving  : in Shelf_Vector.Vector;
      Positions : in out Paper_Roll_Positions_Vector.Vector) return Natural
   is
      Accessible_Paper_Roll : Natural := 0;
   begin
      for Y in Shelving.First_Index + 1 .. Shelving.Last_Index - 1 loop
         declare
            Compartments_High : String := To_String (Shelving.Element (Y - 1));
            Compartments      : String := To_String (Shelving.Element (Y));
            Compartments_Low  : String := To_String (Shelving.Element (Y + 1));
            Paper_Roll        : Natural := 0;
            Position          : Position_Type;
         begin
            for X in Compartments'First + 1 .. Compartments'Last - 1 loop
               if Compartments (X .. X) = "@" then
                  Paper_Roll := 1;
                  Paper_Roll :=
                    Paper_Roll + Add_Paper_Roll (Compartments_High (X .. X));
                  Paper_Roll :=
                    Paper_Roll
                    + Add_Paper_Roll (Compartments (X + 1 .. X + 1));
                  Paper_Roll :=
                    Paper_Roll + Add_Paper_Roll (Compartments_Low (X .. X));
                  Paper_Roll :=
                    Paper_Roll
                    + Add_Paper_Roll (Compartments (X - 1 .. X - 1));

                  Paper_Roll :=
                    Paper_Roll
                    + Add_Paper_Roll (Compartments_High (X - 1 .. X - 1));
                  Paper_Roll :=
                    Paper_Roll
                    + Add_Paper_Roll (Compartments_High (X + 1 .. X + 1));
                  Paper_Roll :=
                    Paper_Roll
                    + Add_Paper_Roll (Compartments_Low (X - 1 .. X - 1));
                  Paper_Roll :=
                    Paper_Roll
                    + Add_Paper_Roll (Compartments_Low (X + 1 .. X + 1));

                  if Paper_Roll <= 4 then
                     Position.X := X;
                     Position.Y := Y;
                     Positions.Append (Position);
                     Accessible_Paper_Roll := Accessible_Paper_Roll + 1;
                  end if;

               end if;

            end loop;
         end;
      end loop;
      return Accessible_Paper_Roll;
   end;

   procedure Remove_Paper_Rolls
     (Shelving  : in out Shelf_Vector.Vector;
      Positions : in out Paper_Roll_Positions_Vector.Vector) is

   begin
      for P in Positions.First_Index .. Positions.Last_Index loop
         declare
            Compartments : String :=
              To_String (Shelving.Element (Positions (P).Y));
         begin
            Compartments (Positions (P).X .. Positions (P).X) := ".";
            Shelving.Replace_Element
              (Positions (P).Y, To_Unbounded_String (Compartments));
         end;
      end loop;
   end Remove_Paper_Rolls;

   procedure Execute (fichier : in String) is
      Input               : File_Type;
      Shelving            : Shelf_Vector.Vector := Shelf_Vector.Empty_Vector;
      Positions           : Paper_Roll_Positions_Vector.Vector :=
        Paper_Roll_Positions_Vector.Empty_Vector;
      Shelf_Length        : Natural := 0;
      Paper_Rolls_Removed : Natural := 0;
      Reponse             : Integer := 0;
      Reponse_2           : Integer := 0;
   begin
      Open (File => Input, Mode => In_File, Name => fichier);
      -- Get Data
      while not End_Of_File (Input) loop
         declare
            Line : Unbounded_String := To_Unbounded_String (Get_Line (Input));
         begin
            Shelving.Append ("." & Line & ".");
            if Shelf_Length = 0 then
               Shelf_Length := To_String (Line)'Length + 2;
            end if;
         end;
      end loop;
      Close (Input);

      Shelving.Prepend (Shelf_Length * ".");
      Shelving.Append (Shelf_Length * ".");

      Reponse := Calculate_Number_Of_Paper_Roll (Shelving, Positions);
      Reponse_2 := Reponse;

      loop
         Remove_Paper_Rolls (Shelving, Positions);
         Positions := Paper_Roll_Positions_Vector.Empty_Vector;
         Paper_Rolls_Removed :=
           Calculate_Number_Of_Paper_Roll (Shelving, Positions);
         --  Put_Line ("Removed" & Paper_Rolls_Removed'Img);
         Reponse_2 := Reponse_2 + Paper_Rolls_Removed;
         exit when Paper_Rolls_Removed = 0;
      end loop;

      Put_Line ("Results (part1) : " & Reponse'Img);
      Put_Line ("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line ("TEST");
   Execute ("data/test.txt");

   New_Line;
   Put_Line ("CHALLENGE DAY 04");
   Execute ("data/data.txt");
end Day04;
