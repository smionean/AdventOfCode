with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;


package body Advent.Day3 is

   type Direction_Type is (Up,Down,Right,Left);
   
   type Panneau_Electrique_Type is array (Natural range <>, Natural range <>) of Natural;

   type Info_Ligne_Record is
      record
         Direction : Direction_Type;
         Longueur  : Natural := 0;
   end record;
   
  package Vecteur_Ligne_Type is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                           Element_Type => Info_Ligne_Record );

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
          null;

         end;
      end loop;
      Close(Input);
      Put_Line("Reponse 1.0 : " & Somme'Img);
			Put_Line("Reponse 1.1 : " & Somme_2'Img);


      return Somme;
   end puzzle;

end Advent.Day3;
