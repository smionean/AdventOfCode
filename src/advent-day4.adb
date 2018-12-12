with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Calendar;

package body Advent.Day4 is

   type Tissu_Type is array (Integer range <>, Integer range <>) of Integer;



   ------------------------------
   --
   ------------------------------
   procedure Decortiquer_Info (La_Ligne : in String) is
   begin
      null;
   end Decortiquer_Info;

   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String) is
      Input : File_Type;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => Fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : String := Get_Line (Input);
         begin
            Decortiquer_Info(Line);
         end;
      end loop;
      Close(Input);
   end Recuperer_Info;

   ------------------------------
   --
   ------------------------------


   ------------------------------
   --
   ------------------------------
   function puzzle_1(fichier : in String) return Integer is
      Reponse : Integer := 0;
   begin
      Recuperer_Info(Fichier);
      return Reponse;
   end puzzle_1;

end Advent.Day4;
