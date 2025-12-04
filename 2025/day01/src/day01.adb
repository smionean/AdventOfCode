--+-------------------------------------------------------------------------+--
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2022 : 01
--|   * Name : Simon Beàn
--|   * Date : Mon Dec  1 07:47:18 EST 2025
--|
--|   * Filename : day01.adb
--|
--|   * Description (fr) : Défi Calnedrier de l'Avent 2025
--|                        Jour 01
--|
--|                 (en) : Advent Of Code Challenge 2025
--|                        Day 01
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

procedure Day01 is

   type Dial_Type is mod 100;
   type Direction_Type is (L, R);

   function Calcul (Position : in Natural; Clicks : in Natural) return Integer
   is
      P : Natural := Position;
      C : Natural := Clicks;
      I : Natural := 0;
   begin
      C := C - P;
      P := 100 - P;
      I := 1 + C / 100;
      return I;
   end Calcul;

   procedure Execute (fichier : in String) is
      Input     : File_Type;
      Reponse   : Integer := 0;
      Reponse_2 : Integer := 0;
      Position  : Natural := 50;
      I         : Natural := 1;
   begin
      Open (File => Input, Mode => In_File, Name => fichier);
      -- Get Data
      while not End_Of_File (Input) loop
         declare
            Line      : String := Get_Line (Input);
            Direction : Direction_Type := L;
            Clicks    : Natural := 0;
            Passage   : Natural := 0;
         begin
            Direction := Direction_Type'Value (Line (1 .. 1));
            Clicks := Natural'Value (Line (2 .. Line'Last));

            case Direction is
               when L =>
                  if (Position - Clicks) < 0 then
                     if Position = 0 then
                        Passage := Clicks / 100;
                     else
                        Passage := (Clicks - Position) / 100 + 1;
                     end if;
                  end if;

                  Position := (Position - Clicks) mod 100;

               when R =>
                  if (Position + Clicks) > 100 then
                     Passage := (Position + Clicks) / 100;
                  end if;
                  Position := (Position + Clicks) mod 100;

            end case;
            if Position = 0 then
               Reponse := Reponse + 1;
            end if;

            if Passage > 0 then
               Reponse_2 := Reponse_2 + Passage;
            elsif Position = 0 then
               Reponse_2 := Reponse_2 + 1;
            end if;

         end;
         I := I + 1;
      end loop;
      Close (Input);

      Put_Line ("Results (part1) : " & Reponse'Img);
      Put_Line ("Results (part2) : " & Reponse_2'Img);

   end Execute;

begin
   Put_Line ("TEST");
   Execute ("data/test.txt");

   New_Line;
   Put_Line ("CHALLENGE DAY 01");
   Execute ("data/data.txt");
end Day01;
