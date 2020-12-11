--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 9 / Day 9
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

package body Advent.Day9 is

   package XMAS_Vector is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                         Element_Type => Long_Long_Integer);
   
   function Is_Valid_Number (Value : in Long_Long_Integer; 
			     Data : in XMAS_Vector.Vector;
			     First : in Natural;
			     Last : in Natural) return Boolean is
      Sum : Long_Long_Integer := 0;
   begin
      for V in First..Last loop
	 for W in First..Last loop
	    if V /= W then
	       if Data.Element(V)+Data.Element(W) = Value then
		  
		  return True;
	       end if;
	    end if;
	 end loop;
      end loop;
      return False;
   end Is_Valid_Number;
   
   function Find_Answer (Value : in Long_Long_Integer; 
			   Data : in XMAS_Vector.Vector;
			   First : in Natural;
			   Last : in Natural;
			   Reponse : out Long_Long_Integer) return Boolean is
      Sum : Long_Long_Integer := 0;
      Min : Long_Long_Integer := Value;
      Max : Long_Long_Integer := 0;
   begin
      for V in First..Last loop
	 Sum := Sum + Data.Element(V);
	 Min := Long_Long_Integer'Min(Min, Data.Element(V));
	 Max := Long_Long_Integer'Max(Max, Data.Element(V));
	 if Sum = Value then
	    Reponse := Min + Max;
	    return True;
	 elsif Sum > Value then
	    return False;
	 end if;
      end loop;
      return False;
   end Find_Answer;

			    procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse_2 : Long_Long_Integer := 0;
      XMAS_Data : XMAS_Vector.Vector;
      Invalid_Number : Long_Long_Integer := 0;
      Position : Natural := 0;
      First_Position : Natural := 0;
      Last_Position : Natural := 0;
      Set_Found : Boolean := False;
      Min : Long_Long_Integer := 0;
      Max : Long_Long_Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            XMAS_Data.Append(Long_Long_Integer'Value(Line));
         end;
      end loop;
      Close(Input);

      for C in XMAS_Data.First_Index+25 .. XMAS_Data.Last_Index loop
	 if not Is_Valid_Number(XMAS_Data.Element(C), XMAS_Data, C-25, C-1) then
	    Put_Line("Reponse (part1) : " & XMAS_Data.Element(C)'Img);
	    Invalid_Number := XMAS_Data.Element(C);
	    Position := C;
	    exit;
	 end if;
      end loop;
      
      for C in XMAS_Data.First_Index .. Position-1 loop
	 if Find_Answer(Invalid_Number,XMAS_Data, C, Position-1, Reponse_2) then
	    exit;
	 end if;
      end loop;
          
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
   end Execute;


end Advent.Day9;
