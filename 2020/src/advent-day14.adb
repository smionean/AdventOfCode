--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 14 / Day 14
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Maps;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;
with Ada.Strings.Maps.Constants;

package body Advent.Day14 is

   type Word is mod 2 ** 36;
   package Word_IO is new Ada.Text_IO.Modular_IO (Word);
   
   package Mem_Map is new Ada.Containers.Ordered_Maps(Key_Type     => Natural,
						      Element_Type => Word);
   
   Equal_Sign  : constant Ada.Strings.Maps.Character_Set := Ada.Strings.Maps.To_Set ("=");   
   
   function Convert_Mask (Mask : in String; Bit : in Character) return Word is
      Result : Word;
      Last : Natural;
      Mask_Local : String := Mask;
   begin
      for c of Mask_Local loop
	 if c = 'X' then
	    c := Bit;
	 end if;
      end loop;
      Word_IO.Get(From => "2#"&Mask_Local&"#",
		  Item => Result,
		  Last => Last);
      
      return Result;
   end Convert_Mask;
   
   function Get_Mem_Address(Data : in String) return Natural is
      
   begin
      --Put_Line(Data(Data'First+4..Data'Last-1));
      return Natural'Value(Data(Data'First+4..Data'Last-1));
   end Get_Mem_Address;
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;

      Mask_0 : Word;
      Mask_1 : Word;
      Memory_Map : Mem_Map.Map;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
	 declare
	    Line : String := Get_Line (Input);
	    First : Positive;
	    Last  : Natural := 0;
	    Next_Mask : Boolean := False;
	    Next_Mem : Boolean := False;
	    Mem_Address : Natural := 0;
	    Value : Word;
	    New_Value_0 : Word;
	    New_Value_1 : Word;
	    L : Positive;
	 begin
	    while Last < Line'Last loop
	       Ada.Strings.Fixed.Find_Token (Source => Line,
				      Set    => Equal_Sign,
				      From   => Last + 1,
				      Test   => Ada.Strings.Outside,
				      First  => First,
				      Last   => Last);

	       exit when Last < First;
	       --Put_Line(Line (First .. Last));
	       
	       if Next_Mask then
		  Mask_0 := Convert_Mask(Line (First+1 .. Last), '0');
		  Mask_1 := Convert_Mask(Line (First+1 .. Last), '1');
		  Next_Mask := False;
		  --Put_Line("--> mask "&Mask'Img);
	       elsif Next_Mem then
		  Word_IO.Get(From => Line(First+1 .. Last),
		             Item => Value,
		             Last => L);

		  -- Mask value
		  New_Value_0 := Value xor Mask_0;
		  New_Value_1 := Value and Mask_1;

		  -- New value		  
		  New_Value_0 := (New_Value_0 or New_Value_1) and Mask_1;

		  Next_Mem := False;
		  if not Memory_Map.Is_Empty and Memory_Map.Contains(Mem_Address) then
		     Memory_Map.Replace(Mem_Address, New_Value_0);
		  else
		     Memory_Map.Insert(Mem_Address, New_Value_0);
		  end if;
		  
		  
	       end if;
	       
	       if Line (First .. Last) = "mask " then
		  Next_Mask := True;
	       elsif Line (First .. First+1) = "me" then
		  Next_Mem := True;
		  Mem_Address := Get_Mem_Address(Line(First .. Last-1));
	       end if;
	 
	    end loop;
         end;
      end loop;
      Close(Input);

      declare
	 V : Long_Long_Integer := 0;
	 C : Mem_Map.Cursor;
	 use Mem_Map;
      begin
	 C := Memory_Map.First;
	 while C /= No_Element loop
	    V := V + Long_Long_Integer'Value(Memory_Map.Element(Key(C))'Img);
	    Next(C);
	 end loop;

	 Put_Line("Reponse (part1) : " & V'Img);
      end;
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
   end Execute;


end Advent.Day14;
