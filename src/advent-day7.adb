with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Characters.Handling; use Ada.Characters.Handling;
package body Advent.Day7 is

   
   type Noeud is 
      record
         Etape_1 : Character := '-';
         Etape_2 : Character := '-';
      end record;
   
   type Donnees is array (A..Z) of Noeud;
   
   ------------------------------
   --
   ------------------------------
   

   ------------------------------
   --
   ------------------------------
   function Trouve_Fin (Data : in Donnees) return Character is
   begin
      for C in Data'Range loop
         if Data(C).Etape_1 = '-' and Data(C).Etape_2 = '-' then
            return C;
         end if;
      end loop;
      return '+';
   end Trouve_Fin;
   
   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String; Data : out Donnees) is
      Input : File_Type;
   begin
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
            if Data(A).Etape_1 = '-' then
               Data(A).Etape_1 := B;
            elsif Data.Etape_1 > B then
               Data.Etape_2 := Data.Etape_1;
               Data.Etape_1 := B;
            else
               Data.Etape_2 := B;
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
   begin
      Recuperer_Info(Fichier,Data);
      return Reponse;
   end puzzle_1;

end Advent.Day7;
