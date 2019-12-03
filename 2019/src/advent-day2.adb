with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;


package body Advent.Day2 is

   function puzzle(fichier : in String) return Integer is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
         Name => fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : String := Get_Line (Input);
         begin
            --Put_Line(Line);


         end;
      end loop;
      Close(Input);
      Put_Line("Reponse 2.0 : " & Reponse'Img);
			Put_Line("Reponse 2.1 : " & Reponse_2'Img);


      return Somme;
   end puzzle;


end Advent.Day2;
