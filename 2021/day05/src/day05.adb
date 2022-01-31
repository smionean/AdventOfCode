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
-- Jour 05 / Day 05
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Maps ; use Ada.Strings.Maps;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Day05 is

   Comma : constant Character_Set := To_Set (',');
   
   type Type_Ocean_Floor is array (Natural range <>, Natural range <>) of Natural;
   
   type Point is record
      X : Natural := 0;
      Y : Natural := 0;
   end record;
     
   type Movement is record
      Start_Point : Point;
      End_Point : Point;
   end record;
   
   package Type_Movement_Vector is new Ada.Containers.Vectors(Index_Type   => Positive,              
							      Element_Type => Movement);
   use Type_Movement_Vector;
   
   function Parse_Point (A_String : in String) return Point is
      P : Point;
      F   : Positive;
      L   : Natural;
      I   : Natural := 1;
      X_Found : Boolean := False;
      Y_Found : Boolean := False;
   begin
      while I in A_String'Range loop
	
	 Find_Token (
	      Source  => A_String,
	      Set     => Comma,
	      From    => I,
	      Test    => Outside,
	      First   => F,
	      Last    => L);

	 exit when L = 0;

	 if not X_Found then
	    P.X := Natural'Value(A_String(F..L));
	    X_Found := True;
	 elsif X_Found and not Y_Found then
	    P.Y := Natural'Value(A_String(F..L));
	    Y_Found := True;
	 end if;
	 
	 I := L + 1;
      end loop;
      
      return P;
   end Parse_Point;
   
   function Parse(A_String : in String) return Movement is
      V : Movement;
      Position_Arrow : Natural := 0;
   begin
      Position_Arrow := Index (A_String, "->", 1);

      declare
	 Start_String : String := A_String(A_String'First..Position_Arrow-1);
	 L : Natural := A_String'Last-(Position_Arrow+3)+1;
	 End_String : String(1..L) := A_String(Position_Arrow+3..A_String'Last);
      begin
	 V.Start_Point := Parse_Point(Start_String);
	 V.End_Point := Parse_Point(End_String);
      end;
	 
      return V;
   end Parse;
   
   function Make_Moves(Movements : in Vector; X_Max : in Natural; Y_Max : in Natural; With_Diagonals : Boolean := False) return Natural is
      Ocean_Floor : Type_Ocean_Floor(0..X_Max,0..Y_Max) := (others => (others => 0));
      Counter : Natural := 0;
      X : Natural := 0;
      Y : Natural := 0;
   begin
      for M of Movements loop
	 if With_Diagonals or else (M.Start_Point.X = M.End_Point.X or M.Start_Point.Y = M.End_Point.Y) then
	    	    
	    X := M.Start_Point.X;
	    Y := M.Start_Point.Y;

	    while x /= M.End_Point.X or Y /= M.End_Point.Y loop
	       --Put_Line("0- "&X'img&" , "&Y'img);
	       Ocean_Floor(X,Y) := Ocean_Floor(X, Y) + 1;
	       Counter := (if Ocean_Floor(X, Y) = 2 then Counter+1 else Counter);
	       X := (if X/=M.End_Point.X then (if M.Start_Point.X < M.End_Point.X then X+1 else X-1 )else X);
	       Y := (if Y/=M.End_Point.Y then (if M.Start_Point.Y <  M.End_Point.Y then Y+1 else Y-1)else Y);
	    end loop;
	    Ocean_Floor(X,Y) := Ocean_Floor(X, Y) + 1;
	    Counter := (if Ocean_Floor(X, Y) = 2 then Counter+1 else Counter);
	    
	 end if;
      end loop;
      
      return Counter;
   end Make_Moves;
      
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Natural := 0;
      Reponse_2 : Natural := 0;
      M : Movement;
      Movement_Vector : Vector := Empty_Vector;
      Max_X : Natural := 0;
      Max_Y : Natural := 0;
   begin
      Open (File => Input,
	    Mode => In_File,
	    Name => fichier);
      While not  End_Of_File (Input) Loop
	 declare
	    Line : String := Get_Line (Input);
	 begin
	    M := Parse(Line);
	    Movement_Vector.Append(M);
	    Max_X := (if Max_X < M.Start_Point.X then M.Start_Point.X else (if Max_X < M.End_Point.X then M.End_Point.X else Max_X));
	    Max_Y := (if Max_Y < M.Start_Point.Y then M.Start_Point.Y else (if Max_Y < M.End_Point.Y then M.End_Point.Y else Max_Y));
	 end;
      end loop;
      Close(Input);

      Reponse := Make_Moves(Movement_Vector, Max_X, Max_Y);
      Reponse_2 := Make_Moves(Movement_Vector, Max_X, Max_Y,True);
      
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 05");
   Execute("data/data.txt");
end Day05;
