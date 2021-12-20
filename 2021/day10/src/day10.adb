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
-- Jour 10 / Day 10
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Maps ; use Ada.Strings.Maps;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;

procedure Day10 is

   type Open_Bracket is ('(','<','{','[');
   
   package Stack_Vector is new Ada.Containers.Vectors(Index_Type   => Positive,              
						      Element_Type => Character);
   use Stack_Vector;
   
   package A_Data_Vector is new Ada.Containers.Vectors(Index_Type   => Positive,              
						       Element_Type => Long_Long_Integer);
   package A_Data_Vector_Sorter is new A_Data_Vector.Generic_Sorting;

   function Verify_Close(Nav : in out Vector; Closer : in Character) return Natural is
   begin
      case Closer is
      when ')' =>
	 if Nav.Last_Element = '(' then 
	    Nav.Delete_Last;
	 else
	    return 3;
	 end if; 
      when ']' =>
	 if Nav.Last_Element = '[' then 
	    Nav.Delete_Last;
	 else
	    return 57;
	 end if;
      when '}' => 
	 if Nav.Last_Element = '{' then 
	    Nav.Delete_Last;
	 else
	    return 1197;
	 end if;
      when '>' => 
	 if Nav.Last_Element = '<' then 
	    Nav.Delete_Last;
	 else
	    return 25137;
	 end if;
      when others => null;
      end case;
      return 0;
   end Verify_Close;
   
   function Complete_Data(Data : in String) return Long_Long_Integer is
      Nav : Vector := Empty_Vector;
      Error_Code : Natural := 0;
      Sum : Long_Long_Integer := 0;
      Point : Long_Long_Integer := 0;
   begin
      for C of Data loop
	 case C is
	 when '('|'['|'{'|'<' => 
	    Nav.Append(C);
	 when ')'|']'|'}'|'>' => 
	    Error_Code := Verify_Close(Nav,C);
	 when others => null;
	 end case;	 
      end loop;
                
      for C of reverse Nav loop
	 case C is
	 when '(' =>
	    Point := 1;
	 when '[' =>
	    Point := 2;
	 when '{' => 
	    Point := 3;
	 when '<' => 
	    Point := 4;
	 when others => null;
	 end case;
	 Sum := 5*Sum + Point;
      end loop;
      return Sum;
   end Complete_Data;
   
   function Find_Error(Data : in String) return Natural is
      Nav : Vector := Empty_Vector;
      Error_Code : Natural := 0;
   begin
      for C of Data loop
	 case C is
	 when '('|'['|'{'|'<' => 
	    Nav.Append(C);
	 when ')'|']'|'}'|'>' => 
	    Error_Code := Verify_Close(Nav,C);
	    if Error_Code /= 0 then
	       return Error_Code;
	    end if;
	       
	 when others => null;
	 end case;
	 
      end loop;
      return 0;
   end Find_Error;
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Data : A_Data_Vector.Vector := A_Data_Vector.Empty_Vector;
      Middle_Index : Natural := 0;
      Error_Code : Natural := 0;
      Reponse : Natural := 0;
      Reponse_2 : Long_Long_Integer := 0;
   begin
      Open (File => Input,
	    Mode => In_File,
	    Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
	 declare
	    Line : String := Get_Line (Input);
	 begin
	    Error_Code := Find_Error(Line);
	    Reponse := Reponse + Error_Code;
	    if Error_Code = 0 then
	       Data.Append(Complete_Data(Line));
	    end if;
	 end;
      end loop;

      A_Data_Vector_Sorter.Sort(Data);      
      Middle_Index := (Data.Last_Index+Data.First_Index)/2;
      Reponse_2 := Data.Element(Middle_Index);

      Close(Input);
          
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 10");
   Execute("data/data.txt");
end Day10;
