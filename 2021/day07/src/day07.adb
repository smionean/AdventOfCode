--------------------------------------------
-- D�fi Calnedrier de l'Avent 2021
--   Advent Of Code Challenge 2021
--
-- #AdaAdventOfCode21
--
-- https://adventofcode.com
--
-- Simon Be�n : https://github.com/smionean
--
-- Jour 07 / Day 07
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Maps ; use Ada.Strings.Maps;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Day07 is

   Comma : constant Character_Set := To_Set (',');

   package Crabs_Position_Type is new Ada.Containers.Vectors(Index_Type   => Positive,              
							      Element_Type => Natural);
   use Crabs_Position_Type; 

   procedure Parse(A_String : in String; Crabs_Position : in out Vector; Min : out Natural; Max : out Natural ) is
      F   : Positive;
      L   : Natural;
      I   : Natural := 1;
      Position : Natural := 0;
      Nb_Positions : Natural := 0;

   begin
      Min := Natural'Last;
      Max := Natural'First;
      while I in A_String'Range loop
         Find_Token
            (Source  => A_String,
             Set     => Comma,
             From    => I,
             Test    => Outside,
             First   => F,
             Last    => L);

         exit when L = 0;

         Position := Natural'Value(A_String(F..L));
	 Crabs_Position.Append(Position);
	 Min := Natural'Min(Min,Position);
	 Max := Natural'Max(Max,Position);
         I := L + 1;
      end loop;
   end Parse;


   procedure Execute(fichier : in String) is
      Input : File_Type;
      Crabs_Position : Vector := Empty_Vector;
      Fuel : Natural := 0;
      Min_Range : Natural := 0;
      Max_Range : Natural := 0;
      Min_Fuel : Natural := Natural'Last;
      Reponse : Natural := 0;
      Reponse_2 : Natural := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            Parse(Line, Crabs_Position, Min_Range, Max_Range);
         end;
      end loop;
      Close(Input);

      for C in Min_Range..Max_Range loop
	 Fuel := 0;
	 for CC of Crabs_Position loop
	    Fuel := Fuel + abs(C-CC);
	 end loop;
	 Min_Fuel := Natural'Min(Min_Fuel,Fuel);
      end loop;
      Reponse := Min_Fuel;
      
      Min_Fuel := Natural'Last; 
      for C in Min_Range..Max_Range loop
	 Fuel := 0;
	 for CC of Crabs_Position loop
	    Fuel := Fuel + abs(C-CC)*(abs(C-CC)+1)/2;
	 end loop;
	 Min_Fuel := Natural'Min(Min_Fuel,Fuel);
      end loop;
      Reponse_2 := Min_Fuel;      
      
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 07");
   Execute("data/data.txt");
end Day07;
