--+-------------------------------------------------------------------------+-- 
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2022 : 02
--|   * Name : Simon Be�n
--|   * Date : Mon Dec  2 22:28:10 EST 2024
--|   
--|   * Filename : day02.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2023
--|                        Jour 02
--|
--|                 (en) : Advent Of Code Challenge 2023
--|                        Day 02
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

procedure Day02 is

   type Direction is (increase, decrease);

   type Reason is (change_direction, zero_diff);

   package Level_Vector is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                         Element_Type => Natural);

   
   
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input) & " ";
            Levels : Level_Vector.Vector;
            First : Natural := Line'First;
            Last  : Natural := Line'Last;
            Index : Natural := 0;
            Diff_Abs : Natural := 0;
            Diff : Integer := 0;
            Increase_Decrease_Reference : Direction;
            Increase_Decrease : Direction;
            Safe : Boolean := True;
            Safe_2 : Boolean := True;
            Removed : Boolean := False;
            Unsafe_Reason : Reason;
         begin
            loop
               Last := Ada.Strings.Fixed.Index(Line(First..Line'Last), " ");
               exit when Last = 0;
               Levels.Append(Natural'Value(Line(First .. Last-1)));
               First := Last + 1;
            end loop;

            Index := Levels.First_Index+1;
            loop
               exit when Index > Levels.Last_Index;
               Diff_Abs := abs(Levels.Element(Index-1)-Levels.Element(Index));
               Diff := Levels.Element(Index-1)-Levels.Element(Index);
               if Index = Levels.First_Index+1 then
                  Increase_Decrease_Reference := (if Diff<0 then decrease else increase);
               end if;
               Increase_Decrease := (if Diff<0 then decrease else increase);
               Safe := Safe and Diff_Abs<4 and Diff_Abs/=0 and Increase_Decrease_Reference = Increase_Decrease;
               
               if not Safe then
                  if  Increase_Decrease_Reference /= Increase_Decrease then
                     Safe_2 := Safe_2 and Diff_Abs<4 and Diff_Abs/=0 and not Removed;
                     Removed := True;
                  end if;
                  if Diff_Abs = 0 then
                     Safe_2 := Safe_2 and Diff_Abs<4 and Increase_Decrease_Reference = Increase_Decrease and not Removed;
                     Removed := True;
                  end if;
                  --  if Diff_Abs > 3 then
                  --     Safe_2 := Safe_2 and Diff_Abs/=0 and Increase_Decrease_Reference = Increase_Decrease and not Removed;
                  --     Removed := True;
                  --  end if;     
                  if not Removed then
                     Safe_2 := Safe_2 and Diff_Abs<4 and Diff_Abs/=0 and Increase_Decrease_Reference = Increase_Decrease;
                  end if;
               end if;
                  
               --  Put_Line (Levels.Element(Index-1)'Img&" "&Levels.Element(Index)'Img&" "&Diff_Abs'Img&" "&Safe'Image&" "&Safe_2'Image);

               Index := Index + 1;
            end loop;
            if Safe then
               Reponse := Reponse + 1;
            end if;
            if Safe_2 then
               Reponse_2 := Reponse_2 + 1;
            end if;
            New_Line;
         end;
      end loop;
      Close(Input);

            
      Put_Line("Results (part1) : " & Reponse'Img);
      --  Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 02");
   Execute("data/data.txt");
end Day02;
