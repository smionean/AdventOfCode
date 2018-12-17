with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

package body Advent.Day5 is

 package Vecteur_Caracteres_Type is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                             Element_Type => Character);
use Vecteur_Caracteres_Type;


 function Analyser_Pairs(Gauche , Droite : in Character) return Boolean is
 begin
 if Character'Pos(Gauche)=Character'Pos(Droite)-32 or Character'Pos(Gauche)-32=Character'Pos(Droite) then
 return True;
 end if;
 return False;
 end Analyser_Pairs;
 
   ------------------------------
   --
   ------------------------------
   function Analyser_Polymere (Data : in out String) return Boolean is
   l : Character := ' ';
   r : Character := ' ';
   Analysay : Boolean := False;
   begin
    for c in Data'First..Data'Last-1 loop
    if Analyser_Pairs(Data(c), Data(c+1)) then
    Data(c) := '';
    Data(c+1):= '';
    Analysay := True;
    end if;
    end loop
    if Analysay then
    return Analyser_Polymere(Data);
    else
    return Analysay;
    end if;
   end Analyser_Polymere;

   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String) is
      Input : File_Type;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => Fichier);
      While not  End_Of_File (Input) Loop
         declare
            Data: String := Get_Line (Input);
            Vecteur_Caracteres : Vecteur_Caracteres_Type.Vector;
         begin
            Analyser_Polymere(Data);
         end;
      end loop;
      Close(Input);
   end Recuperer_Info;

   ------------------------------
   --
   ------------------------------


   ------------------------------
   --
   ------------------------------
   function puzzle_1(fichier : in String) return Integer is
      Reponse : Integer := 0;
   begin
      Recuperer_Info(Fichier);
      return Reponse;
   end puzzle_1;

end Advent.Day5;
