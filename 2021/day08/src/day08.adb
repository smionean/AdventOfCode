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
-- Jour 08 / Day 08
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Maps ; use Ada.Strings.Maps;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Characters.Handling; use Ada.Characters.Handling;

procedure Day08 is

   Seperator : constant Character_Set := To_Set ('|');
   Space : constant Character_Set := To_Set (' ');
   
   type Signal_Type is (a,b,c,d,e,f,g);   
   type Position_Type is (T, TL, TR, M, BL, BR, B);
   type Position_Array_Type is array (Position_Type) of Signal_Type;
   
   
   type Display_Type is (zero, one, two, three, four, five, six, seven, eight, nine);
      
   type Output_Display_Array is array (Display_Type) of Unbounded_String;  

   package Signals_Vector is new Ada.Containers.Vectors(Index_Type   => Positive,              
							Element_Type => Unbounded_String);
   
   procedure Parse(A_String : in String; Signals : in out Unbounded_String; Outputs : in out Unbounded_String  ) is
      F   : Positive;
      L   : Natural;
      I   : Natural := 1;

      Signals_Completed : Boolean := False;

   begin
      
      while I in A_String'Range loop
	 Find_Token
	   (Source  => A_String,
     Set     => Seperator,
     From    => I,
     Test    => Outside,
     First   => F,
     Last    => L);

	 exit when L = 0;

	 if not Signals_Completed then
	    Signals := To_Unbounded_String(A_String(F..L));
	 else
	    Outputs := To_Unbounded_String(A_String(F..L));
	 end if;
	 I := L + 1;
	 Signals_Completed := True;
      end loop;
   end Parse;
   
   function Find_1478(Outputs : in Unbounded_String) return Natural is
      A_String : String := To_String(Outputs);
      Results : Natural := 0;
      F   : Positive;
      L   : Natural;
      I   : Natural := 1;
      
   begin
      while I in A_String'Range loop
	 Find_Token
	   (Source  => A_String,
     Set     => Space,
     From    => I,
     Test    => Outside,
     First   => F,
     Last    => L);

	 exit when L = 0;

	 if A_String(F..L)'Length = 2 then -- 1
	    Results := Results + 1;
	 elsif A_String(F..L)'Length = 4 then -- 4
	    Results := Results + 1;
	 elsif A_String(F..L)'Length = 3 then -- 7
	    Results := Results + 1;
	 elsif A_String(F..L)'Length = 7 then -- 8
	    Results := Results + 1;
	 end if;
	 
	 I := L + 1;

      end loop;
      return Results;
   end Find_1478;
   
   function Decode(Signals : in Unbounded_String; Outputs : in Unbounded_String) return Natural is
      
      function Gives_Signal(String_A : in String; String_B : in String) return Signal_Type is
	 S : String (1..1) := " ";
	 Position : Natural := 0;
	 Signal : Signal_Type;
      begin
	 for C of String_A loop
	    S(1) := C;
	    Position := Index(String_B,S,1);
	    if Position = 0 then
	       Signal := Signal_Type'Value(S);
	    end if;
	 end loop;
	 return Signal;
      end Gives_Signal;

      
      function Contains(String_A : in String; String_B : in String) return Boolean is
	 S : String (1..1) := " ";
	 Position : Natural := 0;
      begin
	 for C of String_A loop
	    S(1) := C;
	    Position := Index(String_B,S,1);
	    if Position = 0 then
	       return False;
	    end if;
	 end loop;
	 return True;
      end Contains;
      
      function Equals (String_A : in String; String_B : in String) return Boolean is
	 
      begin
	 if String_A'Length /= String_B'Length then
	    return False;
	 end if; 
	 return Contains(String_A,String_B);
	 
      end Equals;
      
      Signals_String : String := To_String(Signals);
      Outputs_String : String := To_String(Outputs);
      Results : Natural := 0;
      F   : Positive;
      L   : Natural;
      I   : Natural := 1;
      Undecodes_Signals : Signals_Vector.Vector := Signals_Vector.Empty_Vector; 
      Key_Signals : Signals_Vector.Vector := Signals_Vector.Empty_Vector; 
      Decode_Table : Output_Display_Array;
      Schema : Position_Array_Type;
      Decoded_Output : String (1..4) := "0000";
      D : Positive := 1;
   begin
      while I in Signals_String'Range loop
	 Find_Token
	   (Source  => Signals_String,
     Set     => Space,
     From    => I,
     Test    => Outside,
     First   => F,
     Last    => L);

	 exit when L = 0;

	 if Signals_String(F..L)'Length = 2 then -- 1
	    Decode_Table(one):=To_Unbounded_String(Signals_String(F..L));
	 elsif Signals_String(F..L)'Length = 4 then -- 4
	    Decode_Table(four):=To_Unbounded_String(Signals_String(F..L));
	 elsif Signals_String(F..L)'Length = 3 then -- 7
	    Decode_Table(seven):=To_Unbounded_String(Signals_String(F..L));
	 elsif Signals_String(F..L)'Length = 7 then -- 8
	    Decode_Table(eight):=To_Unbounded_String(Signals_String(F..L));
	 else
	    Undecodes_Signals.Append(To_Unbounded_String(Signals_String(F..L)));
	 end if;
	 
	 I := L + 1;

      end loop;
      
      --Find Top
      -- Seven - One
      declare
	 String_One : String := To_String(Decode_Table(one));
	 String_Seven : String := To_String(Decode_Table(Seven));
	 Top : Signal_Type;
	 S : String (1..1) := " ";
	 Position : Natural := 0;
      begin
	 
	 for C of String_Seven loop
	    --Top := Signal_Type'Value(C);
	    S(1) := C;
	    Position := Index(String_One,S,1);
	    if Position = 0 then
	       Top := Signal_Type'Value(S);
	    end if;
	 end loop;
	 Schema(T) := Top;
      end;
      
      -- Find Bottom
      -- (Nine) - (Top + Four)
      for K of Undecodes_Signals loop
	 if To_String(K)'Length = 6 then
	    declare
	       String_Four_Top : String := To_String(Decode_Table(four))& To_Lower(Schema(T)'Img);
	       String_One : String := To_String(Decode_Table(one));
	       String_T : String := To_String(K);
	       Bottom : Signal_Type;
	    begin
	       --Find Nine and Bottom
	       if Contains(String_One, String_T) and Contains(String_Four_Top, String_T) then
		  Bottom := Gives_Signal(String_T,String_Four_Top);
		  Decode_Table(nine) := To_Unbounded_String(String_T);
		  Schema(B) := Bottom;
		  K := To_Unbounded_String("-");
	       end if;
	    end;
	 end if;
      end loop;
      
      --Find Bottom Left
      -- Eight - Nine
      declare
	 String_Eight : String := To_String(Decode_Table(eight));
	 String_Nine : String := To_String(Decode_Table(nine));
	 Bottom_Left : Signal_Type;
      begin
	 Bottom_Left := Gives_Signal(String_Eight,String_Nine);
	 Schema(BL) := Bottom_Left;
      end;
      
      --Find Three and M
      -- Three - (One + Top + Bottom)
      -- Length=5 and not Contains(BL) and Contains (One + Top + Bottom)      
      for K of Undecodes_Signals loop
	 if To_String(K)'Length = 5 then
	    declare
	       String_One_Top_Bottom : String := To_String(Decode_Table(one))& To_Lower(Schema(T)'Img)& To_Lower(Schema(B)'Img);
	       String_Bottom_left : String := To_Lower(Schema(BL)'Img);
	       String_T : String := To_String(K);
	       Middle : Signal_Type;
	    begin
	       --Find Three and Middle
	       if not Contains(String_Bottom_left, String_T) and Contains(String_One_Top_Bottom, String_T) then
		  Middle := Gives_Signal(String_T,String_One_Top_Bottom);
		  Decode_Table(three) := To_Unbounded_String(String_T);
		  Schema(M) := Middle;
		  K := To_Unbounded_String("-");
	       end if;
	    end;
	 end if;
      end loop;
      
      --Find Zero
      -- Eight - M
      for K of Undecodes_Signals loop
	 if To_String(K)'Length = 6 then
	    
	    declare
	       String_Eight : String := To_String(Decode_Table(eight));
	       String_Middle : String := To_Lower(Schema(M)'Img);
	       String_T : String := To_String(K);
	    begin
	       if not Contains(String_Middle, String_T) then
		  Decode_Table(zero) := To_Unbounded_String(String_T);
		  K := To_Unbounded_String("-");
	       end if;
	    end;
	 end if;
      end loop;
      
      
      --Find Six and TL
      -- 
      -- Length=5 and not Contains(BL) and Contains (One + Top + Bottom)      
      for K of Undecodes_Signals loop
	 if To_String(K)'Length = 5 then
	    declare
	       String_One_Top_Bottom : String := To_String(Decode_Table(one))& To_Lower(Schema(T)'Img)& To_Lower(Schema(B)'Img);
	       String_Bottom_left : String := To_Lower(Schema(BL)'Img);
	       String_T : String := To_String(K);
	       Middle : Signal_Type;
	    begin
	       --Find Three and Middle
	       if not Contains(String_Bottom_left, String_T) and Contains(String_One_Top_Bottom, String_T) then
		  Middle := Gives_Signal(String_T,String_One_Top_Bottom);
		  Decode_Table(three) := To_Unbounded_String(String_T);
		  Schema(M) := Middle;
		  K := To_Unbounded_String("-");
	       end if;
	    end;
	 end if;
      end loop;
      
      --Find Six and Top Right
      for K of Undecodes_Signals loop
	 if To_String(K)'Length = 6 then
	    Decode_Table(six) := K;
	    declare
	       String_Eight : String := To_String(Decode_Table(eight));
	       String_Six : String := To_String(K);
	       Top_Right : Signal_Type;
	    begin
	       Top_Right := Gives_Signal(String_Six,String_Eight);
	       Schema(TR) := Top_Right;
	       K := To_Unbounded_String("-");
	    end;
	 end if;
      end loop;
   
      -- Bottom Right
      declare
	 String_One : String := To_String(Decode_Table(one));
	 String_Top_Right : String := To_Lower(Schema(TR)'Img);
	 Bottom_Right : Signal_Type;
      begin
	 Bottom_Right := Gives_Signal(String_Top_Right,String_One);
      end;
      
      --Find Five
      --
      for K of Undecodes_Signals loop
	 if To_String(K)'Length = 5 then
	    declare
	       String_Six : String := To_String(Decode_Table(six));
	       String_Bottom_left : String := To_Lower(Schema(BL)'Img);
	       String_T : String := To_String(K);
	    begin
	       --Find Five and Middle
	       if Contains(String_T, String_Six)  then
		  Decode_Table(five) := To_Unbounded_String(String_T);
		  K := To_Unbounded_String("-");
	       end if;
	    end;
	 end if;
      end loop;     
      
      for K of Undecodes_Signals loop
	 if To_String(K) /= "-" then
	    Decode_Table(two) := K;
	 end if;
      end loop;
 
      F := 1;
      L := 0;
      I := 1;
      while I in Outputs_String'Range loop
	 Find_Token
	   (Source  => Outputs_String,
     Set     => Space,
     From    => I,
     Test    => Outside,
     First   => F,
     Last    => L);

	 exit when L = 0;

	 for I in Decode_Table'Range loop
	    if Equals(Outputs_String(F..L),To_String(Decode_Table(I))) then
	       Decoded_Output(D..D) := Trim(Display_Type'Pos(I)'Img,Both);
	    end if;	    
	 end loop;
	 --  
	 D := D+1;
	 I := L + 1;

      end loop;
      
      Results := Integer'Value(Decoded_Output);
      
      return Results;
   end Decode;

   
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
            
      Signals : Unbounded_String;
      Outputs : Unbounded_String;
      
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
	    Parse(Line,Signals,Outputs);
	    Reponse := Reponse + Find_1478(Outputs);
	    Reponse_2 := Reponse_2 + Decode(Signals, Outputs);
	    
	    
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
   Put_Line("CHALLENGE DAY 08");
   Execute("data/data.txt");
end Day08;
