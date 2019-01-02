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
         Etape_1 : Character := '-';
         Etape_2 : Character := '-';
      end record;
   
   type Donnees is array (Character range 'A'..'Z') of Noeud;
   
   ------------------------------
   --
   ------------------------------
   procedure Analyser (Data : in out Donnees; Premier : in Character; Sequence : in String ;Dernier : in Character; Sequence_Final : in out String) is
      
   begin
      null;
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
   procedure Recuperer_Info (Fichier : in String; Data : out Donnees; Premier : out Character; Sequence : out String) is
      Input : File_Type;
      Position : Natural := 1;
   begin
      Premier := '-';
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
            
            -- plus ou moins utile
            if Data(A).Etape_1 = '-' then
               Data(A).Etape_1 := B;
            elsif Data(A).Etape_1 > B then
               Data(A).Etape_2 := Data(A).Etape_1;
               Data(A).Etape_1 := B;
            else
               Data(A).Etape_2 := B;
            end if;
            -- fin
            
            Data(A).Branche(Character'Pos(B)-64) := B;
            Data(A).Nb_Branche := Data(A).Nb_Branche + 1;
            
            if Premier = '-' then
               Premier := A;
            end if;
            
            if Position <= Sequence'Length then
               Sequence(Position) := A;
               Position := Position + 1;
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
      Sequence : String (1..128);
      Dernier : Character := '-';
      Sequence_Final : String (1..26) := (others => '-');
   begin
      Recuperer_Info(Fichier,Data,Premier, Sequence);
      Dernier := Trouver_Dernier(Data);
      Analyser(Data           => Data,
               Premier        => Premier,
               Sequence       => Sequence,
               Dernier        => Dernier,
               Sequence_Final => Sequence_Final);
      
      
      for C in Data'Range loop
         Put_Line(C & " : " &Data(C).Branche );
      end loop;
      Put_Line(Sequence);
      return Reponse;
   end puzzle_1;

end Advent.Day7;
