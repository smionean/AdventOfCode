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
--|   * Project name : Advent of Code 2022 : 05
--|   * Name : Simon Be�n
--|   * Date : Lun  5 d�c 2022 09:42:38 EST
--|   
--|   * Filename : day05.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2022
--|                        Jour 05
--|
--|                 (en) : Advent Of Code Challenge 2022
--|                        Day 05
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
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;

procedure Day05 is

   package Type_Crate_Infos is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                     Element_Type => Unbounded_String);
   use Type_Crate_Infos;

   type Type_Crates_Stack is array(Positive range <>, Positive range <>) of String(1..1);

   
   type Action is record
      moves : Natural := 0;
      from  : Natural := 0;
      to    : Natural := 0;
   end record;

   package Actions_Infos is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                 Element_Type => Action);

   
   --
   -- Get_Action
   -- 
   function Get_Action (A_Strip : String) return Action is
      An_Action : Action;
      Position_Move : Positive := 1;
      Position_From : Positive := 1;
      Position_To : Positive := 1;
   begin
      -- move 1 from 2 to 1
      Position_Move := Index (A_Strip, "move ", 1);
      Position_From := Index (A_Strip, " from ", 1);
      Position_To := Index (A_Strip, " to ", 1);

      An_Action.moves := Natural'Value(A_Strip(A_Strip'First + 4..Position_From));
      An_Action.from := Natural'Value(A_Strip(Position_From + 6..Position_To));
      An_Action.to := Natural'Value(A_Strip(Position_To + 4..A_Strip'Last));

      Put_Line(An_Action.moves'Img&" "&An_Action.from'Img&" "&An_Action.to'Img);

      return An_Action;
   end Get_Action;

   --
   -- Init_Crates_Stack
   -- 
   procedure Init_Crates_Stack(Crate_Stack : in out Type_Crates_Stack; Column_Count : in Positive; Stack_Count : in Positive; Crate_Infos : in Type_Crate_Infos.Vector) is
      Stack_Line : Positive := Stack_Count;
   begin
        for I in reverse Crate_Infos.First_Index..Crate_Infos.Last_Index - 1 loop
            declare
               Info_String : String := To_String(Crate_Infos.Element(I));
            begin
               for C in 1..Column_Count loop
                     Crate_Stack(C,Stack_Line) := Info_String(4*C-2..4*C-2);                     
               end loop;
               Stack_Line := Stack_Line - 1;
            end; 
        end loop;
   end Init_Crates_Stack;

   --
   -- Move_Crates_Crane9000
   -- 
   procedure Move_Crates_Crane9000(Crates_Stack: in out Type_Crates_Stack; Stack_Count : in Positive; Actions : in Actions_Infos.Vector ) is
      Stack_Line : Positive := 1;
      Crate : String(1..1) := " "; 
   begin
      for A of Actions loop
         for M in 1..A.moves loop
            Stack_Line := 1;
            loop
               exit when Crates_Stack(A.from,Stack_Line) /= " " or Stack_Line = Stack_Count;
               Stack_Line := Stack_Line + 1;
            end loop;
            
            Crate := Crates_Stack(A.from,Stack_Line);
            Crates_Stack(A.from,Stack_Line) := " ";
            
            Stack_Line := 1;
            loop
               exit when Crates_Stack(A.to,Stack_Line) /= " " or Stack_Line = Stack_Count;
               Stack_Line := Stack_Line + 1;
            end loop;
            Crates_Stack(A.to,Stack_Line-1) := Crate;
         end loop;
      end loop;
   end Move_Crates;

   --
   -- Move_Crates_Crane9001
   -- 
   procedure Move_Crates_Crane9001(Crates_Stack: in out Type_Crates_Stack; Stack_Count : in Positive; Actions : in Actions_Infos.Vector ) is
      Stack_Line : Positive := 1;
      Crate : String(1..1) := " ";
      Crates_to_Move : String(1..Stack_Count) := (others=>' ');
   begin
      for A of Actions loop
         Crates_to_Move := (others => ' ');
         for M in 1..A.moves loop
            Stack_Line := 1;
            loop
               exit when Crates_Stack(A.from,Stack_Line) /= " " or Stack_Line = Stack_Count;
               Stack_Line := Stack_Line + 1;
            end loop;
            
            Crates_to_Move(M) := Crates_Stack(A.from,Stack_Line)(Crates_Stack(A.from,Stack_Line)'First);
            Crates_Stack(A.from,Stack_Line) := " ";
         end loop;

         Stack_Line := 1;
           loop
              exit when Crates_Stack(A.to,Stack_Line) /= " " or Stack_Line = Stack_Count;
              Stack_Line := Stack_Line + 1;
         end loop;
         for M in reverse 1..A.moves loop
         Put_Line(" --- "& Stack_Line'Img& " "&Crates_Stack(A.to,Stack_Line)&" "&Crates_to_Move(M));
            Stack_Line := Stack_Line-M;
            Crates_Stack(A.to,Stack_Line)(1) := Crates_to_Move(M);
         end loop;
      end loop;
   end Move_Crates_Crane9001;

   --
   -- Get_Top_Crates
   -- 
   procedure Get_Top_Crates(Crates_Stack: in out Type_Crates_Stack;Column_Count : in Positive; Stack_Count : in Positive) is
      Stack_Line : Positive := 1;
      Crate : String(1..1) := " "; 
   begin
      for C in 1..Column_Count loop
         Stack_Line := 1;
         loop
            exit when Crates_Stack(C,Stack_Line) /= " " ;
            Stack_Line := Stack_Line + 1;
         end loop;
         Put(Crates_Stack(C,Stack_Line));
      end loop;
      New_Line;
   end Get_Top_Crates;

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Crate_Info : Type_Crate_Infos.Vector := Type_Crate_Infos.Empty_Vector;
      Actions : Actions_Infos.Vector := Actions_Infos.Empty_Vector;
      Cargo_Info_Recovery_Done : Boolean := False;
      Columns_Count : Positive := 1;
      Stack_Count : Positive := 1;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            if not Cargo_Info_Recovery_Done and Line'Length /=0 then
               Crate_Info.Append(To_Unbounded_String(Line));
               Columns_Count := (Line'Length+1) / 4;
            elsif Cargo_Info_Recovery_Done and Line'Length /=0 then
               Actions.Append(Get_Action(Line));
            elsif Line'Length =0 then
               Cargo_Info_Recovery_Done := True;
            end if;
         end;
      end loop;
      Close(Input);

      Stack_Count := (Positive'Val(Crate_Info.Length) - 1)**3;

      -- Part 1
      declare
         Crates_Stack : Type_Crates_Stack(1..Columns_Count , 1..Stack_Count) := (others=>(others=>" "));
      begin
         Init_Crates_Stack(Crates_Stack,Columns_Count,Stack_Count,Crate_Info);
         Move_Crates_Crane9000(Crates_Stack,Stack_Count,Actions);
         Put("Results (part1) : " );
         Get_Top_Crates(Crates_Stack,Columns_Count,Stack_Count);
         New_line;
      end;

      declare
         Crates_Stack : Type_Crates_Stack(1..Columns_Count , 1..Stack_Count) := (others=>(others=>" "));
      begin
         Init_Crates_Stack(Crates_Stack,Columns_Count,Stack_Count,Crate_Info);
         Move_Crates_Crane9001(Crates_Stack,Stack_Count,Actions);
         Put("Results (part2) : " );
         Get_Top_Crates(Crates_Stack,Columns_Count,Stack_Count);
         New_line;
      end;

   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 05");
   Execute("data/data.txt");
end Day05;
