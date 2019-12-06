with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;


package body Advent.Day3 is


begin
function puzzle(fichier : in String) return Integer is
      Input : File_Type;
      Valeur : Integer := 0;
      Valeur_2 : Integer := 0;
      Valeur_Initiale : Integer := 0;
      Somme : Integer := 0;
      Somme_2 : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
         Name => fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : String := Get_Line (Input);
         begin
            --Put_Line(Line);
            Valeur_Initiale := Integer'Value (Line);
            Valeur := calculer_carburant(Valeur_Initiale);
            Put_Line(Valeur'Img);
            Somme := Somme + Valeur;

            Valeur_2 := Valeur_Initiale;
            loop
               Valeur_2 := calculer_carburant(Valeur_2);
               Somme_2 := Somme_2 + Valeur_2;
               exit when Valeur_2 = 0;
            end loop;

         end;
      end loop;
      Close(Input);
      Put_Line("Reponse 1.0 : " & Somme'Img);
			Put_Line("Reponse 1.1 : " & Somme_2'Img);


      return Somme;
   end puzzle;

end Advent.Day3;