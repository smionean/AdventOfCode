with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Maps;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Calendar;
with GNAT.Calendar.Time_IO;

package body Advent.Day4 is

type Evenement_Type is (sleep,awake,change_shift);

type Evenement_Record is
record
Evenement : Evenement_Type;
Elf_Id : Natural;
end record;


package dictionnaire_horaire is new Ada.Containers.Ordered_Maps(Key_Type => Ada.Calendar.Day_Duration,  -- Heure en secondes
  Element_Type => Evenement_Record);

     package dictionnaire_jour is new Ada.Containers.Ordered_Maps(Key_Type     => Ada.Calendar.Day_Duration, -- Date en secondes
                                                                     Element_Type => dictionnaire_horaire);



   ------------------------------
   --
   ------------------------------
   procedure Decortiquer_Info (La_Ligne : in String, Les_Info : in out dictionnaire_jour.Map) is
      Position_Espace : Natural := 1;
      Position_Crochet: Natural := 1;
   begin
      Position_Espace := Index (La_Ligne, " ", 1);
      Position_Crochet := Index (La_Ligne, "]", 1);
      declare
         une_Date_Tmp : String := La_Ligne(La_Ligne'First + 1..Position_Espace-1);
         une_Heure_Tmp : String := La_Ligne(Position_Espace+1..Position_Crochet-1);
         un_Evenement :  String:= La_Ligne(Position_Crochet + 2..La_Ligne'Last);
         une_Date : Ada.Calendar.Day_Duration;
         une_Heure : Ada.Calendar.Day_Duration;
      begin
         une_Date_Tmp(une_Date_Tmp'First..une_Date_Tmp'First+1):="20"; -- changer annee 1518 pour 2018
         --une_Date_Tmp(une_Date_Tmp'Last-2..une_Date_Tmp'Last):=":00"; -- ajouter les secondes

         Put_Line(une_Date_Tmp&" "&un_Evenement);

         une_Date := Ada.Calendar.Seconds(Date => GNAT.Calendar.Time_IO.Value(Date => une_Date_Tmp) );
         une_Heure := Ada.Calendar.Seconds(Date => GNAT.Calendar.Time_IO.Value(Date => une_Heure_Tmp) );

      end;


   end Decortiquer_Info;

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
            Line : String := Get_Line (Input);
         begin
            Decortiquer_Info(Line);
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

end Advent.Day4;
