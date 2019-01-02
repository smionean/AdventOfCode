with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Command_Line;      use Ada.Command_Line;
with Advent.Day1;
with Advent.Day2;
with Advent.Day3;
with Advent.Day4;
with Advent.Day5;
with Advent.Day6;
with Advent.Day7;

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
      Input := Question_Reponse("Donne le jour du defi :");
      --Put_Line(To_String (Input));



      exit when Input = "quit";

      if Input = "1" then
         Input := Question_Reponse("Donne le numero du puzzle :");
         if Input = "1" then
            --  Input := Question_Reponse("Donne le fichier des donnees :");
            tmp := Advent.Day1.puzzle_1("../data/j1p1.txt");
         else
            --  Input := Question_Reponse("Donne le fichier des donnees :");
            tmp := Advent.Day1.puzzle_2("../data/j1p1.txt");
         end if;
      elsif Input = "2" then
         Input := Question_Reponse("Donne le numero du puzzle :");
         if Input = "1" then
            --  Input := Question_Reponse("Donne le fichier des donnees :");
            tmp := Advent.Day2.puzzle_1("../data/j2p1.txt");
         else
            --  Input := Question_Reponse("Donne le fichier des donnees :");
            tmp := Advent.Day2.puzzle_2("../data/j2p1.txt");
         end if;
       elsif Input = "3" then
         tmp := Advent.Day3.puzzle_1("../data/j3p1.txt");
      elsif Input = "4" then
         tmp := Advent.Day4.puzzle_1("../data/j4p1.txt");
      elsif Input = "5" then
         tmp := Advent.Day5.puzzle_1("../data/j5p1.txt");
      elsif Input = "6" then
         tmp := Advent.Day6.puzzle_1("../data/j6p1.txt");
      elsif Input = "7" then
         tmp := Advent.Day7.puzzle_1("../data/j7p1.txt");
      end if;


   end loop;
end Main;
