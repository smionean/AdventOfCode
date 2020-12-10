--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 8 / Day 8
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

package body Advent.Day8 is

   type Instruction_Type is ( nop , acc, jmp );
   type Instruction_Record is
      record
	 Instruction : Instruction_Type;
	 Instruction_Changed : Boolean := False;
	 Operation : Integer;
	 Executed : Boolean := False;
      end record;
   
     package Instruction_Vector is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                         Element_Type => Instruction_Record);
   
   function Test (Instructions_ref : in out Instruction_Vector.Vector ; Index_to_Change : in Natural; Accumulator : in out Integer) return Boolean is
      Instructions : Instruction_Vector.Vector := Instructions_Ref;
      Instruction_Cursor : Natural := 0;
      Instruction_Tmp : Instruction_Record;
      Test_Value : Integer := 0;
   begin
      
      Instruction_Tmp := Instructions.Element(Index_to_Change);
      if Instruction_Tmp.Instruction = nop then
	 Instruction_Tmp.Instruction := jmp;
      elsif Instruction_Tmp.Instruction = jmp then
	 Instruction_Tmp.Instruction := nop;
      end if;
      Instructions.Replace_Element(Index_to_Change,Instruction_Tmp);
            
      Instruction_Cursor := Instructions.First_Index;
      loop
	 
	 exit when Instruction_Cursor > Instructions.Last_Index 
	   or else Instruction_Cursor < Instructions.First_Index 
	   or else Instructions.Element(Instruction_Cursor).Executed;
	 
	 Instruction_Tmp := Instructions.Element(Instruction_Cursor);
	 Instruction_Tmp.Executed := True;
	 Instructions.Replace_Element(Instruction_Cursor,Instruction_Tmp);
	 	 
	 case Instructions.Element(Instruction_Cursor).Instruction is
	 when nop => 
	    Instruction_Cursor := Instruction_Cursor + 1;
	 when acc =>
	    Accumulator := Accumulator + Instructions.Element(Instruction_Cursor).Operation;
	    Instruction_Cursor := Instruction_Cursor + 1;
	 when jmp =>
	    Instruction_Cursor := Instruction_Cursor + Instructions.Element(Instruction_Cursor).Operation;	    
	 end case;
      end loop;
      Instruction_Tmp := Instructions.Element(Index_to_Change);
      if Instruction_Tmp.Instruction = nop then
	 Instruction_Tmp.Instruction := jmp;
      else
	 Instruction_Tmp.Instruction := nop;
      end if;
      Instructions.Replace_Element(Index_to_Change,Instruction_Tmp);
      
      if Instruction_Cursor = Instructions.Last_Index+1 then
	 return True;
      end if ;

      return False;
   end Test;
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Instructions : Instruction_Vector.Vector;
      Instruction_Cursor : Natural := 0;
      Instruction_Cursor_Last_Executed : Natural := 0;
      Instruction_Tmp : Instruction_Record;
      Accumulator : Integer := 0;
      Solution_Found : Boolean := False;
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
	    Instruction_Data : Instruction_Record;
	 begin
	    Instruction_Data.Instruction := Instruction_Type'Value(Line(1..3));
	    Instruction_Data.Operation := Integer'Value(Line(5..Line'Last));
	    Instructions.Append(Instruction_Data);
	 end;
      end loop;
      Close(Input);


      
      Instruction_Cursor := Instructions.First_Index;
      loop
	 exit when Instructions.Element(Instruction_Cursor).Executed;
	 Instruction_Tmp := Instructions.Element(Instruction_Cursor);
	 Instruction_Tmp.Executed := True;
	 Instructions.Replace_Element(Instruction_Cursor,Instruction_Tmp);
	 
	 Instruction_Cursor_Last_Executed := Instruction_Cursor;
	 
	 case Instructions.Element(Instruction_Cursor).Instruction is
	 when nop => 
	    Instruction_Cursor := Instruction_Cursor + 1;
	 when acc =>
	    Accumulator := Accumulator + Instructions.Element(Instruction_Cursor).Operation;
	    Instruction_Cursor := Instruction_Cursor + 1;
	 when jmp =>
	    Instruction_Cursor := Instruction_Cursor + Instructions.Element(Instruction_Cursor).Operation;
	 end case;
      end loop;
            
      Put_Line("Reponse (part1) : " & Accumulator'Img & " " & Instruction_Cursor'Img);
      
      -- Reinit status
      for I in Instructions.First_Index..Instructions.Last_Index loop
      	 Instruction_Tmp := Instructions.Element(I);
	 Instruction_Tmp.Executed := False;
	 Instructions.Replace_Element(I,Instruction_Tmp);
      end loop;
      
      -- Part 2
      Instruction_Cursor := Instructions.First_Index;
      loop
	 exit when Instruction_Cursor > Instructions.Last_Index or else Solution_Found ;
	 Accumulator := 0;
	 case Instructions.Element(Instruction_Cursor).Instruction is
	 when acc =>
	    null;
	 when jmp | nop =>
	    Solution_Found := Test(Instructions,Instruction_Cursor,Accumulator);
	 end case;
	 Instruction_Cursor := Instruction_Cursor + 1;
      end loop;
      
      Put_Line("Reponse (2) : " & Accumulator'Img & " " & Instruction_Cursor'Img);
      
   end Execute;


end Advent.Day8;
