--+-------------------------------------------------------------------------+--
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2022 : 03
--|   * Name : Simon Beàn
--|   * Date : Wed Dec  3 16:13:55 EST 2025
--|
--|   * Filename : day03.adb
--|
--|   * Description (fr) : Défi Calnedrier de l'Avent 2025
--|                        Jour 03
--|
--|                 (en) : Advent Of Code Challenge 2025
--|                        Day 03
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
with Ada.Numerics.Big_Numbers.Big_Integers;
use Ada.Numerics.Big_Numbers.Big_Integers;

procedure Day03 is
   procedure Execute (fichier : in String) is
      Input     : File_Type;
      Reponse   : Integer := 0;
      Reponse_2 : Big_Natural := 0;
   begin
      Open (File => Input, Mode => In_File, Name => fichier);
      -- Get Data
      while not End_Of_File (Input) loop
         declare
            Line         : String := Get_Line (Input);
            Joltage      : String (1 .. 2) := "00";
            Joltage_12   : String (1 .. 12) := "000000000000";
            Battery      : String (1 .. 1) := "0";
            Max_Position : Natural := 1;
            Length       : Natural := 0;
         begin
            -- A --
            for C in 1 .. Line'Last - 1 loop
               Battery (1) := Line (C);
               if Integer'Value (Battery) > Integer'Value (Joltage (1 .. 1))
               then
                  Joltage (1 .. 1) := Battery;
                  Max_Position := C;
               end if;
            end loop;

            for C in Max_Position + 1 .. Line'Last loop
               Battery (1) := Line (C);
               if Integer'Value (Battery) > Integer'Value (Joltage (2 .. 2))
               then
                  Joltage (2 .. 2) := Battery;
                  Max_Position := C;
               end if;
            end loop;
            Reponse := Reponse + Integer'Value (Joltage);

            -- B --
            Max_Position := 0;
            for J in Joltage_12'Range loop
               for C in Max_Position + 1 .. Line'Last - (12 - J) loop
                  Battery (1) := Line (C);
                  if Integer'Value (Battery)
                    > Integer'Value (Joltage_12 (J .. J))
                  then
                     Joltage_12 (J .. J) := Battery;
                     Max_Position := C;
                  end if;
               end loop;
            end loop;

            -- Put_Line (Joltage_12);
            Reponse_2 := Reponse_2 + From_String (Joltage_12);

         end;
      end loop;
      Close (Input);

      Put_Line ("Results (part1) : " & Reponse'Img);
      Put_Line ("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line ("TEST");
   Execute ("data/test.txt");

   New_Line;
   Put_Line ("CHALLENGE DAY 03");
   Execute ("data/data.txt");
end Day03;
