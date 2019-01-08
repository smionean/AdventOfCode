with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Characters.Handling; use Ada.Characters.Handling;
package body Advent.Day7 is
   
   type Noeud is 
      record
         Branche : String (1..26) := (others => '-');
         Nb_Branche : Natural := 0;
         Noeud_Completay : Boolean := False;
         Parents : String (1..26) := (others => '-');
         Nb_Parents : Natural := 0;
      end record;
   
   type Donnees is array (Character range 'A'..'Z') of Noeud;
   
   type Arbre is array (Natural range 1..26) of String (1..13) ;
   
   
   ------------------------------
   --
   ------------------------------  
   function Donner_Prochaine_Branche(Branche : in out Noeud; Precedent : in Character) return Character is
      Reponse : Character := '-';
   begin
      if Branche.Nb_Branche > 0 then
         for C in Branche.Branche'Range loop 
            if Branche.Branche(C) /= '-' and Character'Pos(Branche.Branche(C)) > Character'Pos(Precedent) then
               Reponse := Branche.Branche(C);

               return Reponse;
            end if;
         end loop;
      end if;
      return Reponse;
   end Donner_Prochaine_Branche;
   
   ------------------------------
   --
   ------------------------------   
   procedure Ajouter (Sequence : in out String; Car : in Character) is
   begin
      for C in Sequence'Range loop
         if Sequence(C) = '-' or Sequence(C) = Car then
            Sequence(C) := Car;
            exit;
         end if;
      end loop;
   end Ajouter;
   
   ------------------------------
   --
   ------------------------------  
   function Contient (Parents : in String; Parent : in Character) return Boolean is
   begin
      for C in Parents'Range loop
         if Parents(C) = Parent then
            return True;
         end if;
      end loop;
      return False;
   end Contient;
   
   ------------------------------
   --
   ------------------------------
   procedure Analyser (Data : in out Donnees; Parent : in Character; Sequence : in String ;Dernier : in Character; Sequence_Final : in out String) is
      Prochain_Noeud : Character;
      Minimum : Natural := 30;
   begin
      Put_Line("Analyser : "& Parent & " / seq : "&Sequence & " "& Data(Parent).Nb_Parents'Img);
      
      if Data(Parent).Nb_Parents = 0 then
         Ajouter(Sequence_Final, Parent);
      end if;
      
      for S in Sequence'Range loop
         
         if Sequence(S) /= '-' and then Data(Sequence(S)).Nb_Parents > 0 then
            Put_Line("      Sequence(S) : "& Sequence(S) &" "&Data(Sequence(S)).Nb_Parents'Img);
            if Data(Sequence(S)).Parents(Character'Pos(Parent)-64) /= '-' then
               Data(Sequence(S)).Parents(Character'Pos(Parent)-64) := '-';
               Data(Sequence(S)).Nb_Parents := Data(Sequence(S)).Nb_Parents - 1;
            end if;
            
         end if;
         
      end loop;
      
      for S in Sequence'Range loop
           
         if Sequence(S) /= '-' then
            if Data(Sequence(S)).Nb_Parents = 0 or ( Data(Sequence(S)).Nb_Parents = 1 and Contient(Data(Sequence(S)).Parents,Parent)) then
               Put_Line("        : NO PARENT , nb_branche "&Sequence(S)&" "&Data(Sequence(S)).Nb_Parents'Img);
               Ajouter(Sequence_Final, Sequence(S));
               Prochain_Noeud := Sequence(S);               
               Put_Line("             PN -> "&Prochain_Noeud);
               if Prochain_Noeud /= '-' and then Data(Prochain_Noeud).Nb_Parents=0 then
                  Data(Prochain_Noeud).Nb_Parents := 0;
                  Data(Prochain_Noeud).Parents(Character'Pos(Parent)-64) := '-';
                  Analyser(Data        => Data,
                           Parent         => Prochain_Noeud,
                           Sequence       => Data(Prochain_Noeud).Branche,
                           Dernier        => Dernier,
                           Sequence_Final => Sequence_Final);
               end if;

            end if;
            
         end if;
      end loop;
   end Analyser;

   ------------------------------
   --
   ------------------------------
   function Trouver_Dernier (Data : in Donnees) return Character is
   begin
      for C in Data'Range loop
         if Data(C).Nb_Branche = 0 then
            return C;
         end if;
      end loop;
      return '+';
   end Trouver_Dernier;

   ------------------------------
   --
   ------------------------------
   function Trouver_Premier (Data : in Donnees; Parent : in Character) return Character is
   begin
      for C in Data'Range loop
         if Data(C).Nb_Parents = 0 and Character'Pos(C) > Character'Pos(Parent) then
            return C;
         end if;
      end loop;
      return '+';
   end Trouver_Premier;
   
   
   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String; Data : out Donnees; Premier : out Character; Sequence : out String) is
      Input : File_Type;
      Position : Natural := 1;
   begin
      Premier := '@';
      Sequence := (others => '-');
      Open (File => Input,
            Mode => In_File,
            Name => Fichier);
      While not  End_Of_File (Input) Loop
         declare
            Ligne : String := Get_Line (Input);
            A : Character;
            B : Character;
         begin
            A := Ligne(6);
            B := Ligne(37);
            Data(A).Branche(Character'Pos(B)-64) := B;
            Data(A).Nb_Branche := Data(A).Nb_Branche + 1;
            
            Data(B).Parents(Character'Pos(A)-64) := A;
            Data(B).Nb_Parents := Data(B).Nb_Parents + 1;
            
            if Premier = '-' then
               Premier := A;
            end if;
           
         end;
      end loop;
      Close(Input);
   end Recuperer_Info;

   ------------------------------
   --
   ------------------------------
   function puzzle_1(fichier : in String) return Integer is
      Reponse : Integer := 0;
      Data : Donnees;
      Premier : Character := '-';
      Sequence : String (1..26) := (others => '-');
      Dernier : Character := '-';
      Sequence_Final : String (1..26) := (others => '-');
   begin
      Recuperer_Info(Fichier,Data,Premier, Sequence);
      Dernier := Trouver_Dernier(Data);
      
      for C in Data'Range loop
         Put_Line(Data(C).Parents&" : "&C & " : " &Data(C).Branche &" - p: "&Data(C).Nb_Parents'Img);
      end loop;
      Premier := Trouver_Premier(Data,Premier);
      Sequence(Sequence'First):=Premier;
      while Data(Dernier).Nb_Parents /=0 loop
         Put_Line(Sequence);

         Analyser(Data           => Data,
                  Parent        => Premier,
                  Sequence       => Sequence,
                  Dernier        => Dernier,
                  Sequence_Final => Sequence_Final);
         Premier := Trouver_Premier(Data,Premier);
         Ajouter(Sequence,Premier);
         
      end loop;
      Ajouter(Sequence_Final, Dernier);

      Put_Line(Sequence_Final);
      for C in Data'Range loop
         Put_Line(Data(C).Parents&" : "& C & " : " &Data(C).Branche &" - p: "&Data(C).Nb_Parents'Img);
      end loop;

      return Reponse;
   end puzzle_1;

end Advent.Day7;
--FMEQHGIRSXNWZBLOTUDCAJPKVY
--FMEQHGIRSXNWZBLOTUDCAJPKVY

