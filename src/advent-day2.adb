with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Ordered_Sets;
with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Maps;
--  with Ada.Containers.Functional_Maps;

package body Advent.Day2 is

   subtype longueur_id is Integer range 1..26;
   subtype id_type is String (longueur_id);
   type id_data is
      record
         id : id_type;
         minimal_diff : natural := 30;
         id_position : Positive := 1;
      end record;

   package vecteur_string_type is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                             Element_Type => id_data);

   procedure Recuperer_ID (Fichier : in String; Vecteur_ID : out vecteur_string_type.Vector) is
      Input : File_Type;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => Fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : id_type := Get_Line (Input);
            a_data_id : id_data;
         begin
            a_data_id.id := Line;
            -- Put_Line(Line & " " & Line'Size'Img);
            Vecteur_ID.Append(a_data_id);
         end;
      end loop;
      Close(Input);
   end Recuperer_ID;

   ------------------------------
   --
   ------------------------------
   function puzzle_1(fichier : in String) return Integer is

      package dictionnaire_alpha_type is new Ada.Containers.Ordered_Maps(Key_Type     => Character,
                                                                         Element_Type => Natural);

      type tableau_compte is array (1..2) of Natural;

      procedure Analyser_Un_ID (ID : in id_type; Tableau : in out tableau_compte) is
         dictionnaire : dictionnaire_alpha_type.Map;
         car : Character;
         compte : Natural := 0;
         Trouvay_2 : Boolean := False;
         Trouvay_3 : Boolean := False;
      begin
         Put_Line(ID);
         for I in 1..ID'Length loop
            car := ID(I);
            if not dictionnaire.Is_Empty and dictionnaire.Contains(car) then
               compte := dictionnaire.Element(car) + 1;
               if compte = 2 and not Trouvay_2 then
                  Tableau(1) := Tableau(1) + 1;
                  Trouvay_2 := True;
                  Put_Line("  c2 ("&car&")");
               elsif compte = 3 and not Trouvay_3 then
                  Tableau(2) := Tableau (2) + 1;
                  Trouvay_3 := True;
                   Put_Line("  c3 ("&car&")");
               end if;
               dictionnaire.Replace(car,compte);
            else
               dictionnaire.Insert(car,1);
            end if;

         end loop;

      end Analyser_Un_ID;

      Reponse : Integer := 0;
      Vecteur_ID : vecteur_string_type.Vector;
      Tableau : tableau_compte;
   begin
      Recuperer_ID(Fichier,Vecteur_ID);
      Tableau(1) := 0;
      Tableau(2) := 0;
      for i in 1..Vecteur_ID.Last_Index loop
         Analyser_Un_ID(Vecteur_ID.Element(I).id, Tableau);

      end loop;
      Put_Line("Tableau   : "& Tableau(1)'Img & " " & Tableau(2)'Img);
         Reponse := Tableau(1)*Tableau(2);

      Put_Line("Reponse puzzle 1  : "&Reponse'Img);
      return Reponse;
   end puzzle_1;

   ------------------------------
   --
   ------------------------------




   function puzzle_2(fichier : in String) return Integer is

      function Calcule_Diff(ID_Pattern : in out id_data; ID_Comparay : in id_data) return Natural is
         total_diff : Natural := 0;
      begin
         for c in 1..ID_Pattern.id'Length loop
            if ID_Pattern.id(c) /= ID_Comparay.id(c) then
               total_diff := total_diff + 1;
            end if;
         end loop;
         Put_Line(ID_Pattern.id &" "& ID_Comparay.id & " " & total_diff'Img );
         return total_diff;


      end Calcule_Diff;

      procedure Affiche_Reponse(ID_Pattern : in id_data; ID_Comparay : in id_data) is
      begin
         Put_Line( "----------------" );
         for c in 1..ID_Pattern.id'Length loop
            if ID_Pattern.id(c) = ID_Comparay.id(c) then
               put(ID_Pattern.id(c));
            end if;
         end loop;
         New_Line;
         Put_Line( "----------------" );

      end Affiche_reponse;

      Vecteur_ID : vecteur_string_type.Vector;
      Position : Positive := 1;
      Total_Diff : Natural := 40;
      Variable_Id_Data : id_data;
   begin
      Recuperer_ID(Fichier,Vecteur_ID);

      for i in 1..Vecteur_ID.Last_Index loop
         Variable_Id_Data := Vecteur_ID.Element(i);
         for j in i..Vecteur_ID.Last_Index loop
            if i /= j then
               Total_Diff := Calcule_Diff(Variable_Id_Data,Vecteur_ID.Element(j));
               if Total_Diff < Variable_Id_Data.minimal_diff then
                  Variable_Id_Data.minimal_diff := Total_Diff;
                  Variable_Id_Data.id_position := j;

               end if;
            end if;
         end loop;
         Vecteur_ID.Replace_Element(Index    => i,
                                          New_Item => Variable_Id_Data);
      end loop;

      Total_Diff := Vecteur_ID.Element(1).minimal_diff;
      Put_Line("---  : " & Vecteur_ID.Element(1).minimal_diff'Img );
      for i in 2..Vecteur_ID.Last_Index loop
         Put_Line("---  : " & Vecteur_ID.Element(i).minimal_diff'Img );
         if  Vecteur_ID.Element(i).minimal_diff < Total_Diff then
            Total_Diff := Vecteur_ID.Element(i).minimal_diff;
            Position := i;
         end if;
      end loop;




      Put_Line("Reponse puzzle 2 position  : " & Position'Img );
      Put_Line("Reponse puzzle 2 id1 : " & Vecteur_ID.Element(Position).id & " " & Vecteur_ID.Element(Position).minimal_diff'Img);

      Put_Line("Reponse puzzle 2 id2 : " & Vecteur_ID.Element(Vecteur_ID.Element(Position).id_position).id & " " & Vecteur_ID.Element(Position).id_position'Img);

      Affiche_Reponse(Vecteur_ID.Element(Position),  Vecteur_ID.Element(Vecteur_ID.Element(Position).id_position));

      return Position;
   end puzzle_2;

end Advent.Day2;
