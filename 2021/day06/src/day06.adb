--------------------------------------------
-- Défi Calnedrier de l'Avent 2021
--   Advent Of Code Challenge 2021
--
-- #AdaAdventOfCode21
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 06 / Day 06
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;

with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Maps ; use Ada.Strings.Maps;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Day06 is

   Comma : constant Character_Set := To_Set (',');
   
   subtype Long_Long_Natural is Long_Long_Integer range 0 .. Long_Long_Integer'Last;
   type Lanternfish_Life_Type is mod 9;
   type Lanterfish_Population_Type  is array (Lanternfish_Life_Type) of Long_Long_Natural;
   
   procedure Parse(A_String : in String; Lanternfish_Population : in out Lanterfish_Population_Type) is
      F   : Positive;
      L   : Natural;
      I   : Natural := 1;
      Valeur : Lanternfish_Life_Type := 0;
   begin
      while I in A_String'Range loop
         Find_Token
            (Source  => A_String,
             Set     => Comma,
             From    => I,
             Test    => Outside,
             First   => F,
             Last    => L);

         exit when L = 0;

         Valeur := Lanternfish_Life_Type'Value(A_String(F..L));
	 Lanternfish_Population(Valeur) := Lanternfish_Population(Valeur) + 1;
         I := L + 1;
      end loop;
   end Parse;
   
   function Create(Lanternfish_Population : in out Lanterfish_Population_Type; Days : in Natural := 80) return Long_Long_Natural is
      Days_Left : Natural := Days; 
      Lanternfish_Population_Next_Day : Lanterfish_Population_Type := (others => Long_Long_Natural'First);
      Sum : Long_Long_Natural := 0; 
      P : Lanternfish_Life_Type := 0;
   begin
      while Days_Left /= 0 loop

	 for L in Lanternfish_Population'Range loop
	    if Lanternfish_Population(L) > 0 then
	       if L = 0  then
		  Lanternfish_Population_Next_Day(6) :=  Lanternfish_Population(L);	  
	       end if;
	       
	       if L-1 = 6 then
		  Lanternfish_Population_Next_Day(L-1) := Lanternfish_Population_Next_Day(L-1) + Lanternfish_Population(L);
	       else
		  Lanternfish_Population_Next_Day(L-1) := Lanternfish_Population(L);
	       end if;
	    end if;
	    
	 end loop;
	 Lanternfish_Population := Lanternfish_Population_Next_Day;
	 Lanternfish_Population_Next_Day := (others => Long_Long_Natural'First);
	 
	 Days_Left := Days_Left - 1;
      end loop;
      
      	 for L in Lanternfish_Population'Range loop
	    Sum := Sum + Lanternfish_Population(L);
	 end loop;
      
      return Sum;
   end Create;
   
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Long_Long_Natural := 0;
      Reponse_2 : Long_Long_Natural := 0;
      Lanternfish_Population : Lanterfish_Population_Type := (others => Long_Long_Natural'First);
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
	    Parse(Line,Lanternfish_Population);
	    Reponse := Create(Lanternfish_Population);
	    Reponse_2 := Create(Lanternfish_Population,256-80);
         end;
      end loop;
      Close(Input);

 
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 06");
   Execute("data/data.txt");
end Day06;
