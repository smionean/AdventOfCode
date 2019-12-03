with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Ordered_Sets;
with Ada.Containers.Vectors;
--  with Ada.Containers.Functional_Maps;

package body Advent.Day1 is

   function puzzle_1(fichier : in String) return Integer is
      Input : File_Type;
      Valeur : Integer := 0;
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
            Valeur := Integer'Value (Line);
            Valeur := Valeur / 3 - 2;
            Put_Line(Valeur'Img);
            Somme := Somme + Valeur;



         end;
      end loop;
      Close(Input);
      Put_Line("Reponse 1.0 : " & Somme'Img);



      return Somme;
   end puzzle_1;


   -- function puzzle_2(fichier : in String) return Integer is
   --    package ensemble_type is new Ada.Containers.Ordered_Sets(Integer);
   --    use ensemble_type;

   --    package vecteur_type is new Ada.Containers.Vectors(Index_Type => Positive,
   --                                                       Element_Type =>  Integer);
   --    --use vecteur_type;


   --    procedure Remplir_Vecteur(Fichier : in String; Vecteur : out vecteur_type.Vector) is
   --       Input : File_Type;
   --    begin
   --       Open (File => Input,
   --       Mode => In_File,
   --       Name => fichier);
   --       While not  End_Of_File (Input) Loop

   --          declare
   --             Line : String := Get_Line (Input);
   --             Un_Nombre : String := Line(2..Line'Last);
   --          begin
   --             Put_Line(Line);
   --             Vecteur.Append(Integer'Value (Line));
   --          end;
   --       end loop;
   --       Close(Input);
   --    end Remplir_Vecteur;

   --    function Analyser (Vecteur : in vecteur_type.Vector; Somme : in out Integer; Ensemble :in out ensemble_type.Set ) return Boolean is

   --    begin
   --       Put_Line(" =============== ");
   --       for I in 1..Vecteur.Last_Index loop
   --          Put_Line(" - V : "&Vecteur.Element(I)'Img);
   --          Somme := Somme + Vecteur.Element(I);

   --          if not Ensemble.Is_Empty and Ensemble.Contains(Somme) then
   --             Put_Line("Reponse puzzle 2 : "&Somme'Img);
   --             return True;
   --            --Trouvay := True;
   --          else
   --             --Put_Line(" - insert : "&Somme'Img);
   --             Ensemble.Insert(Somme);
   --          end if;


   --       end loop;

   --       return False;
   --    end Analyser;



   --    Input : File_Type;
   --    Reponse : Integer := 0;
   --    Nouvelle_Frequence : Integer := 0;
   --    Ensemble : ensemble_type.Set;
   --    Cursor : ensemble_type.Cursor;
   --    Trouvay : Boolean := False;
   --    Vecteur : vecteur_type.Vector;
   -- begin
   --    Remplir_Vecteur(Fichier => fichier, Vecteur => Vecteur);

   --    loop
   --       Trouvay := Analyser(Vecteur  => Vecteur,
   --                           Somme    => Reponse,
   --                           Ensemble => Ensemble);
   --       exit when Trouvay;
   --    end loop;



   --    Put_Line("Reponse puzzle 2  : "&Reponse'Img);
   --    return Reponse;
   -- end puzzle_2;

end Advent.Day1;
