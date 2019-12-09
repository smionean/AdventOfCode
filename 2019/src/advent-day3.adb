with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams; use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

package body Advent.Day3 is

   type Direction_Type is (Up,Down,Right,Left);
   
   type Dimension_2_Type is array (Integer range <>, Integer range <>) of Character;

   type Info_Ligne_Record is
      record
         Direction : Direction_Type;
         Longueur  : Natural := 0;
      end record;
   
   type Info_Panneau_Record is
      record
         X : Integer := 0;
         X_MIN : Integer := 0;
         Y : Integer := 0;
         Y_MIN : Integer := 0;
      end record;
   
  package Vecteur_Ligne_Type is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                           Element_Type => Info_Ligne_Record );


  --package Vecteur_Lignes_Type is new Ada.Containers.Vectors(Index_Type  => Positive,
  --                                                         Element_Type => Vecteur_Ligne_Type.Vector );

   type Liste_Lignes_Type is array (Natural range <>) of Vecteur_Ligne_Type.Vector;
   type Liste_Panneau_Type is array (Natural range <>) of Info_Panneau_Record;
   
   
   procedure Recuperer_Info_Point(Point : in String; 
                                  Info_Ligne : out Info_Ligne_Record) is
      
   begin
      case Point(Point'First) is
         when 'U' => Info_Ligne.Direction := Up;
         when 'D' => Info_Ligne.Direction := Down;
         when 'R' => Info_Ligne.Direction := Right;
         when 'L' => Info_Ligne.Direction := Left;
         when others => Put_Line("Oups");
      end case;
      Info_Ligne.Longueur := Natural'Value(Point(Point'First + 1..Point'Last));
   end Recuperer_Info_Point;
   
   
   
   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info_Ligne (Chaine : in String; 
                             Ligne : out Vecteur_Ligne_Type.Vector ) is
      Position : Natural := Chaine'First;
      Info_Ligne : Info_Ligne_Record;
   begin
      for i in Chaine'Range loop
         if Chaine(i) = ',' or i = Chaine'Last then
            Recuperer_Info_Point(Chaine(Position..i-1), Info_Ligne);
            Ligne.Append(Info_Ligne);
            Position := i + 1;
         end if;
               
      end loop; 
      
   end Recuperer_Info_Ligne;
   
   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String; 
                             Lignes : out Liste_Lignes_Type ) is
      Input : File_Type;
      Ligne : Vecteur_Ligne_Type.Vector;
      I : Natural := Lignes'First;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => Fichier);
      While not  End_Of_File (Input) and I <= Lignes'Last Loop
         declare
            Data: String := Get_Line (Input);
         begin
            Recuperer_Info_Ligne(Data,Ligne);
            Lignes(I) := Ligne;
            I := I + 1;
         end;
      end loop;
      Close(Input);
   end Recuperer_Info;
  
   ------------------------------
   --
   ------------------------------
   procedure Evaluer_Espace (Lignes : in Liste_Lignes_Type; 
                             Info_Panneau : out Info_Panneau_Record) is
      Info_Panneaux : Liste_Panneau_Type(Lignes'First..Lignes'Last);
      Longueur : Natural := 0;
      X_MAX : Integer := 0;
      X_MIN : Integer := Integer'Last;
      Y_MAX : Integer := 0;
      Y_MIN : Integer := Integer'Last;
   begin
      
      for I in Lignes'Range loop
         for J in Lignes(I).First_Index..Lignes(I).Last_Index loop
            Longueur := Lignes(I).Element(J).Longueur;
            case Lignes(I).Element(J).Direction is
               when Up => Info_Panneaux(I).Y := Info_Panneaux(I).Y + Longueur ;
               when Down => Info_Panneaux(I).Y := Info_Panneaux(I).Y - Longueur ;
               when Right => Info_Panneaux(I).X := Info_Panneaux(I).X + Longueur ;
               when Left => Info_Panneaux(I).X := Info_Panneaux(I).X - Longueur ;
            end case; 
         end loop;         
      end loop;
      
      for I in Info_Panneaux'Range loop
         if Info_Panneaux(I).X > X_MAX then
            X_MAX := Info_Panneaux(I).X;
         end if;
         if Info_Panneaux(I).Y > Y_MAX then
            Y_MAX := Info_Panneaux(I).Y;
         end if;      
         if Info_Panneaux(I).X < X_MAX then
            X_MIN := Info_Panneaux(I).X;
         end if;
         if Info_Panneaux(I).Y < Y_MAX then
            Y_MIN := Info_Panneaux(I).Y;
         end if;  
      end loop;
      
      Info_Panneau.X := X_MAX;
      Info_Panneau.Y := Y_MAX;
      Info_Panneau.X_MIN := X_MIN;
      Info_Panneau.Y_MIN := Y_MIN;
      
   end Evaluer_Espace;

   procedure Deplacer_Vers_Haut(Panneau : in out Dimension_2_Type;
                                Position_Point : in out Info_Panneau_Record;
                                Longueur : in Natural;
                                Distance_M : in out Natural) is                          
   begin
      for i in Position_Point.Y .. Position_Point.Y+Longueur loop
          
         if Panneau (Position_Point.X , i) /= 'o' then
            if Position_Point.X + i < Distance_M then
               Distance_M := Position.X + i;
            end if;
         end if;
         Panneau(Position_Point.X,i) := 'a';
      end loop;
      Position_Point.Y := Position_Point.Y + Longueur;
   end Deplacer_Vers_Haut;              


 procedure Deplacer_Vers_Bas(Panneau : in out Dimension_2_Type;
                                Position_Point : in out Info_Panneau_Record;
                                Longueur : in Natural;
                                Distance_M : in out Natural) is                          
   begin
      for i in reverse Position_Point.Y .. Position_Point.Y-Longueur loop
          
         if Panneau (Position_Point.X , i) /= 'o' then
            if Position_Point.X + i < Distance_M then
               Distance_M := Position.X + i;
            end if;
         end if;
         Panneau(Position_Point.X,i) := 'a';
      end loop;
      Position_Point.Y := Position_Point.Y - Longueur;
   end Deplacer_Vers_Haut;              


 procedure Deplacer_Vers_Droite(Panneau : in out Dimension_2_Type;
                                Position_Point : in out Info_Panneau_Record;
                                Longueur : in Natural;
                                Distance_M : in out Natural) is                          

   begin
      for i in Position_Point.X .. Position_Point.X+Longueur loop
          
         if Panneau (i,Position_Point.Y) /= 'o' then
            if Position_Point.Y + i < Distance_M then
               Distance_M := Position.Y + i;
            end if;
         end if;
         Panneau(i,Position_Point.Y) := 'a';
      end loop;
      Position_Point.X := Position_Point.X + Longueur;
   end Deplacer_Vers_Haut;              

 procedure Deplacer_Vers_Gauche(Panneau : in out Dimension_2_Type;
                                Position_Point : in out Info_Panneau_Record;
                                Longueur : in Natural;
                                Distance_M : in out Natural) is                          
   begin
      for i in reverse Position_Point.X .. Position_Point.X-Longueur loop
          
         if Panneau (i,Position_Point.Y) /= 'o' then
            if Position_Point.Y + i < Distance_M then
               Distance_M := Position.Y + i;
            end if;
         end if;
         Panneau(i,Position_Point.Y) := 'a';
      end loop;
      Position_Point.X := Position_Point.X - Longueur;
   end Deplacer_Vers_Haut;              


   ------------------------------
   --
   ------------------------------
   function Analyser (Lignes : in Liste_Lignes_Type; 
                      Info_Panneau : in Info_Panneau_Record) return Integer is
      Panneau : Dimension_2_Type (Info_Panneau.X_MIN .. Info_Panneau.X , Info_Panneau.Y_MIN .. Info_Panneau.Y) := (others => 'o', others => 'o');
      Info_Panneau_Analyse : Info_Panneau_Record;
      Longueur : Natural := 0;
      Distance_M : Natural := Natural'Last;
   begin
      
      for I in Lignes'Range loop
         Info_Panneau_Analyse.X := 0;
         Info_Panneau_Analyse.Y := 0;
         for J in Lignes(I).First_Index..Lignes(I).Last_Index loop
            Longueur := Lignes(I).Element(J).Longueur;
            case Lignes(I).Element(J).Direction is
               when Up => Info_Panneau_Analyse.Y := Deplacer_Vers_Haut(Panneau, Info_Panneau_Analyse, Longueur, Distance_M);
               when Down => Info_Panneau_Analyse.Y := Deplacer_Vers_Bas(Panneau, Info_Panneau_Analyse, Longueur, Distance_M);
               when Right => Deplacer_Vers_Droite(Panneau, Info_Panneau_Analyse, Longueur, Distance_M);
               when Left => Info_Panneau_Analyse.X := Deplacer_Vers_Gauche(Panneau, Info_Panneau_Analyse, Longueur, Distance_M);
            end case; 
         end loop;         
      end loop;
      return Distance_M;
   end Analyser;
   
   
   ------------------------------
   --
   ------------------------------
   function puzzle(Fichier : in String) return Integer is
      Lignes : Liste_Lignes_Type(1..2);
      Info_Panneau : Info_Panneau_Record;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
   begin
      Recuperer_Info(Fichier,Lignes);
      Evaluer_Espace(Lignes,Info_Panneau);
      Reponse := Analyser(Lignes,Info_Panneau);

      Put_Line("Reponse 3.0 : " & Reponse'Img);
      Put_Line("Reponse 3.1 : " & Reponse_2'Img);


      return Reponse;
   end puzzle;

end Advent.Day3;
