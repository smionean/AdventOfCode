--+-------------------------------------------------------------------------+-- 
--|                                                                         |--
--|                                                                         |--
--|                                  TTT                                    |--
--|                                  TTT                                    |--
--|                                  TTT                                    |--
--|                           TTT           TTT                             |--
--|                           TTT           TTT                             |--
--|                           TTTTTTTTTTTTTTTTT                             |--
--|                           TTTTTTTTTTTTTTTTT                             |--
--|                           TTT           TTT                             |--
--|                           TTT           TTT                             |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2022 : 09
--|   * Name : Simon Be�n
--|   * Date : Fri 09 Dec 2022 05:03:42 PM EST
--|   
--|   * Filename : day09.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2022
--|                        Jour 09
--|
--|                 (en) : Advent Of Code Challenge 2022
--|                        Day 09
--|
--|   #AdaAdventOfCode22
--|
--+-------------------------------------------------------------------------+--
--|   * Changelog * 
--|
--|
--+-------------------------------------------------------------------------+--
pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Containers.Ordered_Sets;

procedure Day09 is

   type Type_Direction is (U, D, R, L);

   type Type_Position is record
      X : Integer := 0;
      Y : Integer := 0;
   end record;

   package Set_Postion is new Ada.Containers.Ordered_Sets(Unbounded_String);
   use Set_Postion;

   type Type_Tail is record
      Actual_Position : Type_Position;
      Positions : Set_Postion.Set := Set_Postion.Empty_Set;
   end record;


   procedure Move_Head_Tail(Head : in out Type_Position; Tail : in out Type_Tail; Steps : in Integer; Direction : in Type_Direction) is
      Diff_X : Integer := 0;
      Diff_Y : Integer := 0;
   begin

      for S in 1..Steps loop
         case Direction is
            when U => 
               Head.Y := Head.Y + 1;              
            when D => 
               Head.Y := Head.Y - 1;
               
            when R => 
               Head.X := Head.X + 1;
            when L => 
               Head.X := Head.X - 1;
         end case;

         Diff_X := abs(Head.X - Tail.Actual_Position.X);
         Diff_Y := abs(Head.Y - Tail.Actual_Position.Y);
         if Diff_X>1 or Diff_Y>1 then
            case Direction is
               when U => Tail.Actual_Position.Y := Head.Y - 1; Tail.Actual_Position.X := Head.X;
               when D => Tail.Actual_Position.Y := Head.Y + 1; Tail.Actual_Position.X := Head.X;
               when R => Tail.Actual_Position.X := Head.X - 1; Tail.Actual_Position.Y := Head.Y;
               when L => Tail.Actual_Position.X := Head.X + 1; Tail.Actual_Position.Y := Head.Y;
            end case;

         end if;
         if not Tail.Positions.Contains(To_Unbounded_String(Tail.Actual_Position'Image)) then
            Tail.Positions.Insert(To_Unbounded_String(Tail.Actual_Position'Image));
         end if;
      end loop;
   end Move_Head_Tail;

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Direction : Type_Direction;
      Steps : Integer := 0;
      Head : Type_Position;
      Previous_Head : Type_Position;
      Tail : Type_Tail;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            Direction := Type_Direction'Value(Line(Line'first..Line'first));
            Steps := Integer'Value(Line(Line'first+1..Line'Last));
            Move_Head_Tail(Head, Tail, Steps, Direction);
            
         end;
      end loop;
      Close(Input);

      Put_Line("Results (part1) : " & Tail.Positions.Length'Img);
      Put_Line("Results (part2) : no solution yet");
      --Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 09");
   Execute("data/data.txt");
end Day09;
