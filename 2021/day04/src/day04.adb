--------------------------------------------
-- D�fi Calnedrier de l'Avent 2021
--   Advent Of Code Challenge 2021
--
-- #AdaAdventOfCode21
--
-- https://adventofcode.com
--
-- Simon Be�n : https://github.com/smionean
--
-- Jour 04 / Day 04
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Sets;
with Ada.Strings;       use Ada.Strings;
with Ada.Strings.Maps ; use Ada.Strings.Maps;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;

procedure Day04 is
   Whitespace : constant Character_Set := To_Set (' ');
   Comma : constant Character_Set := To_Set (',');

   type Dimension is range 1..6;
   type Type_Carte_Bingo is array (Dimension,Dimension) of Integer;

   package Type_Set_Natural is new Ada.Containers.Ordered_Sets(Natural);

   package Type_Vector_Natural is new Ada.Containers.Vectors(Index_Type   => Positive,              
                                                          Element_Type => Natural);

   type Type_Info_Carte is record
      Carte : Type_Carte_Bingo;
      Ensemble : Type_Set_Natural.Set;
      Gagnant : Boolean;
   end record;

   package Type_Vector_Bingo is new Ada.Containers.Vectors(Index_Type   => Positive,              
                                                          Element_Type => Type_Info_Carte);



   procedure Reinitialise_Carte_Bingo(Info_Carte : in out Type_Info_Carte) is
   begin
      Info_Carte.Carte := (1 => (0,0,0,0,0,5),
                2 => (0,0,0,0,0,5),
                3 => (0,0,0,0,0,5),
                4 => (0,0,0,0,0,5),
                5 => (0,0,0,0,0,5),
                6 => (5,5,5,5,5,5));
      Info_Carte.Ensemble := Type_Set_Natural.Empty_Set;
   end Reinitialise_Carte_Bingo;

   procedure Parse_Sequence(Sequence : in String; Vecteur_Sequence : in out Type_Vector_Natural.Vector) is
      F   : Positive;
      L   : Natural;
      I   : Natural := 1;
      Valeur : Natural := 0;
   begin
      while I in Sequence'Range loop
         Find_Token
            (Source  => Sequence,
             Set     => Comma,
             From    => I,
             Test    => Outside,
             First   => F,
             Last    => L);

         exit when L = 0;

         Valeur := Natural'Value(Sequence(F..L));
         Vecteur_Sequence.Append(Valeur);
         I := L + 1;
      end loop;
   end Parse_Sequence;

   procedure Parse_Ligne_Carte(Ligne : in String; Position : in Natural; Info_Carte : in out Type_Info_Carte) is
      F   : Positive;
      L   : Natural;
      I   : Natural := 1;
      Colonne : Natural := 1;
      Valeur : Natural := 0;
   begin
      while I in Ligne'Range loop
         Find_Token
            (Source  => Ligne,
             Set     => Whitespace,
             From    => I,
             Test    => Outside,
             First   => F,
             Last    => L);

         exit when L = 0;

         Valeur := Natural'Value(Ligne(F..L));
         
         Info_Carte.Carte(Dimension(Position),Dimension(Colonne)) := Valeur;
         Info_Carte.Ensemble.Insert(Valeur);
         I := L + 1;
         Colonne := Colonne + 1;
      end loop;
   end Parse_Ligne_Carte;

   procedure Ajoute_Carte(Info_Carte : in Type_Info_Carte; Vector_Carte : in out Type_Vector_Bingo.Vector) is
   begin
      Vector_Carte.Append(Info_Carte);
   end Ajoute_Carte;

   function Etampe_Total(Carte : in out Type_Carte_Bingo; Jeton : in Natural) return Boolean is
   begin
      for i in  1..5 loop
         for j in 1..5 loop
            if Carte(Dimension(i),Dimension(j)) = Jeton then
               Carte(Dimension(i),Dimension(j)) := -1;
               Carte(Dimension(i),6) := Carte(Dimension(i),6) - 1;
               Carte(6,Dimension(j)) := Carte(6,Dimension(j)) - 1; 
            end if;
         end loop;
      end loop;
      
      if Carte(6,3)=0 then
	 return True;
      end if;
	
      return False;
   end Etampe_Total;

   function Etampe(Carte : in out Type_Carte_Bingo; Jeton : in Natural) return Boolean is
   begin
      for i in  1..5 loop
         for j in 1..5 loop
            if Carte(Dimension(i),Dimension(j)) = Jeton then
               Carte(Dimension(i),Dimension(j)) := -1;
               Carte(Dimension(i),6) := Carte(Dimension(i),6) - 1;
               Carte(6,Dimension(j)) := Carte(6,Dimension(j)) - 1;
               if Carte(Dimension(i),6) = 0 or Carte(6,Dimension(j)) = 0 then
                  return True;
               end if; 
            end if;
         end loop;
      end loop;
      return False;
   end Etampe;
   
   function Joue(Jeton : in Natural; Vector_Carte : in out Type_Vector_Bingo.Vector) return Natural is
     -- Carte : Type_Info_Bingo;
      Est_Gagnant : Boolean := False;
   begin
      for I in Vector_Carte.Iterate loop
         if Vector_Carte(I).Ensemble.Contains(Jeton) then
            Est_Gagnant := Etampe(Vector_Carte(I).Carte, Jeton);
            if Est_Gagnant then
               return Type_Vector_Bingo.To_Index (I);
            end if;
         end if;
      end loop;
      return 0;
   end Joue;
   
   function Est_Dernier(Vector_Carte : in Type_Vector_Bingo.Vector) return Boolean is
      R : Boolean := True;
   begin
      for VC in Vector_Carte.Iterate loop
	 R:= R and Vector_Carte(VC).Gagnant;
      end loop;
      return R;
   end Est_Dernier;
   
   function Joue_Total(Jeton : in Natural; Vector_Carte : in out Type_Vector_Bingo.Vector) return Natural is
     -- Carte : Type_Info_Bingo;
      Est_Gagnant : Boolean := False;
   begin
      for I in Vector_Carte.Iterate loop
         if Vector_Carte(I).Ensemble.Contains(Jeton) then
            Est_Gagnant := Etampe(Vector_Carte(I).Carte, Jeton);
	    if Est_Gagnant then
	       Vector_Carte(I).Gagnant := True;
              -- return Type_Vector_Bingo.To_Index (I);
	    end if;
	    
	    if Est_Dernier(Vector_Carte) then
	       return Type_Vector_Bingo.To_Index (I);
	    end if;
         end if;
      end loop;
      
      
     -- Est_Dernier(Vecteur_Carte_2)
      return 0;
   end Joue_Total;
   
   function Calcule_Carte(Vector_Carte : in Type_Vector_Bingo.Vector; Carte_Gagnante : in Natural) return Natural is
      Somme : Natural := 0;
      Carte : Type_Carte_Bingo := Vector_Carte.Element(Carte_Gagnante).Carte;
   begin
      for i in  1..5 loop
	 for j in 1..5 loop   
	    if Carte(Dimension(i),Dimension(j)) /= -1 then
	       Somme := Somme + Carte(Dimension(i),Dimension(j));
	    end if;
         end loop;
      end loop;
      return Somme;
   end Calcule_Carte;
   

   
   procedure Affiche (Vector_Carte : in Type_Vector_Bingo.Vector) is
      
   begin
      for VC in Vector_Carte.Iterate loop
	 for i in  Dimension loop
	    for j in Dimension loop   
	       Put(Vector_Carte(VC).Carte(i,j)'Img &" ");
	    end loop;
	    New_Line;
	 end loop;
	 New_Line;
	 New_Line;
      end loop;
   end Affiche;
   
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Sequence_Lue : Boolean := False;
      Premier_Carte_Lue : Boolean := False;
      Position : Natural := 1;
      Vecteur_Sequence : Type_Vector_Natural.Vector := Type_Vector_Natural.Empty_Vector;
      Vecteur_Carte : Type_Vector_Bingo.Vector := Type_Vector_Bingo.Empty_Vector;
      Vecteur_Carte_2: Type_Vector_Bingo.Vector := Type_Vector_Bingo.Empty_Vector;
      Carte_Gagnante : Natural := 0;
      Numero_Gagnant : Natural := 0;
      Somme : Natural := 0;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Carte_Bingo : Type_Info_Carte := (Carte => ( 1 => (0,0,0,0,0,5),
                                          2 => (0,0,0,0,0,5),
                                          3 => (0,0,0,0,0,5),
                                          4 => (0,0,0,0,0,5),
                                          5 => (0,0,0,0,0,5),
                                          6 => (5,5,5,5,5,5)),
					Ensemble => Type_Set_Natural.Empty_Set,
					Gagnant => False);
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            if not Sequence_Lue then
               Parse_Sequence(Line,Vecteur_Sequence);
               Sequence_Lue := True;
            elsif Line = "" and Sequence_Lue and Premier_Carte_Lue then
               Ajoute_Carte(Carte_Bingo, Vecteur_Carte);
               Reinitialise_Carte_Bingo(Carte_Bingo);
               Position := 1;
            elsif Line /= "" and Sequence_Lue then
               Parse_Ligne_Carte(Line, Position, Carte_Bingo);
               Premier_Carte_Lue := True;
               Position := Position + 1;
            end if;
         end;
      end loop;
      Ajoute_Carte(Carte_Bingo, Vecteur_Carte);
      Close(Input);

      --Affiche(Vecteur_Carte);
      
      Vecteur_Carte_2 := Vecteur_Carte.Copy;
      
      for Jeton of Vecteur_Sequence loop
         Carte_Gagnante := Joue(Jeton,Vecteur_Carte);
         if Carte_Gagnante /= 0 then
            Numero_Gagnant := Jeton;
            Exit;
         end if;
      end loop;
     -- Affiche(Vecteur_Carte);
      --Put_Line(Numero_Gagnant'Img&" "&Carte_Gagnante'Img);
      
      Somme := Calcule_Carte(Vecteur_Carte,Carte_Gagnante);
      Reponse := Integer(Somme * Numero_Gagnant);

      Numero_Gagnant:=0;Carte_Gagnante:=0;
      for Jeton of Vecteur_Sequence loop
         Carte_Gagnante := Joue_Total(Jeton,Vecteur_Carte_2);
         if Carte_Gagnante /= 0 then
	    Numero_Gagnant := Jeton;
	   -- if Est_Dernier(Vecteur_Carte_2) then
	       exit;
	   -- end if;
         end if;
      end loop;
      --Put_Line(Numero_Gagnant'Img&" "&Carte_Gagnante'Img);
      Somme := Calcule_Carte(Vecteur_Carte_2,Carte_Gagnante);
      Reponse_2 := Integer(Somme * Numero_Gagnant);
      
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 04");
  Execute("data/data.txt");
end Day04;
