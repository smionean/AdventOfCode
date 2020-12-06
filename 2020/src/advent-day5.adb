--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 5 / Day 5
--
-- Look at Maxim Reznik (https://github.com/reznikmm/ada-howto/blob/advent-2020/md/05/05.md)
-- for a better and beautiful solution
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;

package body Advent.Day5 is
   		
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Max_ID : Natural := 0;
      Reponse_2 : Integer := 0;
      Seats  : array (0 .. 2**10 - 1) of Boolean := (others => False);
   begin
      Open (File => Input,
            Mode => In_File,
            Name => fichier);
      
      --Get data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
            Row : String := Line(Line'First..Line'Last-3);
            Column : String := Line(Line'Last-2..Line'Last);
            Val : Integer := 0;
            Val_Row : Integer := 0;
            Val_Col : Integer := 0;
         begin
            for I in Row'First..Row'Last loop
               if Row(I) = 'F' then
                  Row(I) := '0';
               else
                  Row(I) := '1';
               end if;
            end loop;
            for I in Column'First..Column'Last loop
               if Column(I) = 'L' then
                  Column(I) := '0';
               else
                  Column(I) := '1';
               end if;
            end loop;         
            Val_Row := Integer'Value("2#"&Row&"#");
            Val_Col := Integer'Value("2#"&Column&"#");
            Val := Val_Row*8+Val_Col;  
            Seats(Val) := True;
            Max_ID := Natural'Max(Max_ID, Val);               
         end;
      end loop;
      Close(Input);
      
      -- This section was made by Maxim Reznik (https://github.com/reznikmm/ada-howto/blob/advent-2020/md/05/05.md)
      for J in Seats'First + 1 .. Seats'Last - 1 loop
         if Seats (J - 1 .. J + 1) = (True, False, True) then -- How cool is that!
            Reponse_2 := J;
         end if;
      end loop;
      
      Put_Line("Reponse (part1) : " & Max_ID'Img);
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
      
   end Execute;

end Advent.Day5;
