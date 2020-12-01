with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Command_Line;      use Ada.Command_Line;
with Advent.Day1;
-- with Advent.Day2;
-- with Advent.Day3;
-- with Advent.Day4;
-- with Advent.Day5;
-- with Advent.Day6;
-- with Advent.Day7;

procedure Main is

   function Question_Reponse(Question : in String) return Unbounded_String is
      Input         : Unbounded_String;
      Console_Input : String (1 .. 128);
      Last          : Natural;
   begin
      Put(Question & " ");
      Get_Line (Console_Input, Last);
      Input := To_Unbounded_String (Console_Input (1 .. Last));
      --Put_Line(To_String (Input));
      return Input;
   end Question_Reponse;

   Input         : Unbounded_String;
   --  Reponse       : String (1..128);
   tmp : Natural := 0;
begin

   loop
      Input := Question_Reponse("Donne le jour du defi (quit pour quitter):");
      --Put_Line(To_String (Input));



      exit when Input = "quit";

      if Input = "1" then
         tmp := Advent.Day1.Execute("../data/advent01.txt");
      --elsif Input = "2" then
      --   tmp := Advent.Day2.Execute("../data/advent02.txt");
      --elsif Input = "2a" then
      --   tmp := Advent.Day2.Execute("../data/advent02a.txt");
      --elsif Input = "3" then
      --   tmp := Advent.Day3.Execute("../data/advent03.txt");
      --elsif Input = "3a" then
      --   tmp := Advent.Day3.Execute("../data/advent03.txt");
      end if;


   end loop;
end Main;
