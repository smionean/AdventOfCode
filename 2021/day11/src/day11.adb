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
-- Jour 11 / Day 11
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Characters.Latin_1; -- There's also 'with ASCII;', but that's obsolete
with Ada.Strings.Fixed;
procedure Day11 is

   type Dimension is range 1..10;
   type Octopus_Flash_Type is mod 10;
   
   type Octopus_Status is record
      Energy : Octopus_Flash_Type := 0;
      Flashed : Boolean := False;
   end record;
   
   type Position is record
      X: Natural := 0;
      Y: Natural := 0;
   end record;
   
   
   package Flash_Vector is new Ada.Containers.Vectors(Index_Type   => Positive,              
						      Element_Type => Position);
   use Flash_Vector;
   
   type Octopus_Matrix_Type is array (1..10,1..10) of Natural; 
   Octopus_Matrix : Octopus_Matrix_Type ;
      
   procedure Print  is
   begin
      for Y in 1..10 loop
	 for X in 1..10 loop
	    
	    --'\e[0;32m'
	    --\e[0m
	    if Octopus_Matrix(X,Y) = 0 then
	       Put(Ada.Characters.Latin_1.ESC & "[" & Ada.Strings.Fixed.Trim("32", Ada.Strings.Left) & "m"&Octopus_Matrix(X,Y)'Img&" "&Ada.Characters.Latin_1.ESC & "[" & Ada.Strings.Fixed.Trim("0", Ada.Strings.Left) & "m");
	     --  null;
	    else
	       Put(Octopus_Matrix(X,Y)'Img&" ");
	    end if;
	    
	 end loop;
	 New_Line;
      end loop;
      
      Put(Ada.Characters.Latin_1.ESC & "[" & Ada.Strings.Fixed.Trim("10", Ada.Strings.Left) & "A");
      Put(Ada.Characters.Latin_1.ESC & "[" & Ada.Strings.Fixed.Trim("10", Ada.Strings.Left) & "D");
      delay Duration(0.05);
   end Print;
   
   
   procedure Propagate_Energy (X: in Natural; Y : in Natural) is
      XMIN : Natural := (if X-1 >= 1 then X-1 else X);
      XMAX : Natural := (if X+1 <= 10 then X+1 else X);
      YMIN : Natural := (if Y-1 >= 1 then Y-1 else Y);
      YMAX : Natural := (if Y+1 <= 10 then Y+1 else Y);
      Flash_Stack : Vector := Empty_Vector;
   begin
      for PX in XMIN .. XMAX loop
	 for PY in YMIN .. YMAX loop
	       Octopus_Matrix(PX,PY) := Octopus_Matrix(PX,PY) + 1;   
	       if Octopus_Matrix(PX,PY) = 10 then
		  Flash_Stack.Append((X=>PX, Y=>PY));
	       end if;
	 end loop;
      end loop;   

      for F of Flash_Stack loop
	 Propagate_Energy(F.X,F.Y);
      end loop;
      Flash_Stack := Empty_Vector;
   end Propagate_Energy;
   
   function Calculate_Flashes return Natural is
      Flashes : Natural := 0;
   begin
      for X in 1..10 loop
	 for Y in 1..10 loop
	    if  Octopus_Matrix(X,Y) > 9 then
	       Flashes := Flashes + 1;
	       Octopus_Matrix(X,Y) := 0;
	    end if;
	 end loop;
      end loop;
      return Flashes;
   end Calculate_Flashes;

   
   function Flash_Octopus (Number_Of_Step : in Natural) return Natural is
      Flashes : Natural := 0;
      Flash_Stack : Vector := Empty_Vector;
      Flashes_Step : Natural := 0;
      Step : Natural := 1;
      Result : Natural := 0;
   begin
      loop
	 for X in 1..10 loop
	    for Y in 1..10 loop
	       Octopus_Matrix(X,Y) := Octopus_Matrix(X,Y) + 1;
	       if Octopus_Matrix(X,Y) = 10 then
		  Flash_Stack.Append((X=>X, Y=>Y));
	       end if;
	    end loop;
	 end loop;
	-- 
	 for F of Flash_Stack loop
	    Propagate_Energy(F.X,F.Y);
	 end loop;
	 Flashes_Step := Calculate_Flashes;
	 Flashes := Flashes + Flashes_Step;
	 Flash_Stack := Empty_Vector;
	 Print;
	 
	 exit when Step = Number_Of_Step or Flashes_Step = 100;
	 Step := Step + 1;
      end loop;
      if Number_Of_Step = Natural'Last then
	 return Step;
      end if;
      return Flashes;
   end Flash_Octopus;
   
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      
      X : Natural := 1;
      Y : Natural := 1;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
	    Line : String := Get_Line (Input);
	    Val : String (1..1) := " ";
	 begin
	    X := 1;
	    for V of Line loop
	       Val(1) := V;
	       Octopus_Matrix(X,Y) := Natural'Value(Val);
	       X := (if X + 1 <= 10 then X+1 else X);
	    end loop;
	 end;
	 Y := (if Y + 1 <= 10 then Y+1 else Y);
      end loop;
      Close(Input);

      Print;
      
      Reponse := Flash_Octopus(100);
      Reponse_2 := 100+Flash_Octopus(Natural'Last);
      New_Line;
      New_Line;
      New_Line;
      New_Line;
      New_Line;
      New_Line;
      New_Line;
      New_Line;
      New_Line;
      New_Line;
      
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 11");
   Execute("data/data.txt");
end Day11;
