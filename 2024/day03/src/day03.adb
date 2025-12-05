--+-------------------------------------------------------------------------+-- 
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2022 : 3
--|   * Name : Simon Be�n
--|   * Date : Tue Dec  3 22:31:15 EST 2024
--|   
--|   * Filename : day3.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2023
--|                        Jour 3
--|
--|                 (en) : Advent Of Code Challenge 2023
--|                        Day 3
--|
--|   #AdaAdventOfCode23
--|
--+-------------------------------------------------------------------------+--
--|   * Changelog * 
--|
--|
--+-------------------------------------------------------------------------+--

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed; 
with Ada.Characters.Handling; use Ada.Characters.Handling;

procedure Day3 is
   
   
   
   function Is_Valid(S : in String) return Boolean is
   begin
      for I in S'Last..S'Last loop
         if not Is_Digit(S(I))  then
            return False;
         end if;
      end loop;
      return True;
   end Is_Valid;

   function mul(C : in String) return Natural is
      Index_Comma : Natural := 0;
      A : Natural := 0;
      B : Natural := 0;
   begin
      Index_Comma := Ada.Strings.Fixed.Index(C(C'First..C'Last), ",");
      if Index_Comma = 0 then
         return 0;
      end if;
      if Is_Valid(C(C'First+1..Index_Comma-1)) then
         A := Natural'Value( C(C'First+1..Index_Comma-1) );
      end if;
      if Is_Valid(C(Index_Comma+1..C'Last-1)) then
         B := Natural'Value(C(Index_Comma+1..C'Last-1));
      end if;
      return A*B;
   end mul;


   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Procced : Boolean := True;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
            Index_End : Natural := 0;
            Index_Start : Natural := 0;
            Index_Close : Natural := 0;
            Index_Comma : Natural := 0;
            Index_Do : Natural := 0;
            Index_Dont : Natural := 0;
         begin
            Index_Start := Line'First;
            Index_Do := Line'First;
            Index_Dont := Ada.Strings.Fixed.Index(Line(Line'First..Line'Last), "don't()");
            loop
               Index_Start := Ada.Strings.Fixed.Index(Line(Index_Start..Line'Last), "mul(");
               Index_Do := Ada.Strings.Fixed.Index(Line(Index_Do..Line'Last), "do()");
               if Index_Dont < Index_Start and Index_Do < Index_Dont then
                  Procced := False;
               end if;
               exit when Index_Start = 0;
               Index_Close := Ada.Strings.Fixed.Index(Line(Index_Start..Line'Last), ")");
               exit when Index_Close = 0 or Index_Start+3 > Line'Last;
               -- mul(123,123)
               if (Index_Close-Index_Start)<12 then
                  declare
                     Command : String := Line(Index_Start+3..Index_Close);
                  begin
                     if Procced then
                        Reponse_2 := Reponse_2 + mul(Command);
                     end if;
                     Reponse := Reponse + mul(Command);
                  end;
                  Index_Start := Index_Close;
               else
                  Index_Start := Index_Start + 4;
                 -- if Index_Dont>Index_Start
               end if;
            end loop;
            

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
   Put_Line("CHALLENGE DAY 3");
   --Execute("data/data.txt");
end Day3;
