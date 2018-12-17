with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Containers.Ordered_Maps;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Calendar; use Ada.Calendar;
with Ada.Calendar.Formatting;
with Ada.Calendar.Arithmetic;
with GNAT.Calendar.Time_IO;
with Ada.Calendar.Time_Zones;

package body Advent.Day4 is


   type Dodo_Record is
      record
         Temps_Sommeil_Max : Duration := 0.0;
         Temps_Sommeil_Pour_Shift : Duration := 0.0;
         Nb_Jour_Avec_Dodo : Natural := 0;
         Nb_Jour_Travailles : Natural := 0;
         Jour : Ada.Calendar.Time;
      end record;

   package Dictionnaire_Elf is new Ada.Containers.Ordered_Maps(Key_Type     => Natural,  --Elf_Id
                                                               Element_Type => Dodo_Record );


   type Evenement_Type is (sleep,awake,change_shift);

   type Evenement_Record is
      record
         Evenement : Evenement_Type;
         Elf_Id : Natural;
         Jour : Ada.Calendar.Time;  -- yyyy mm dd
         Jour_Absolu : Ada.Calendar.Time; -- yyyy mm dd HH:MM:SS
      end record;



   package Dictionnaire_Horaire is new Ada.Containers.Ordered_Maps(Key_Type     => Natural,  -- Date en secondes yyyy-mm-dd HH:MM:SS
                                                                   Element_Type => Evenement_Record);

   --package dictionnaire_jours is new Ada.Containers.Ordered_Maps(Key_Type     => Ada.Calendar.Day_Duration, -- Date en secondes
   --                                                             Element_Type => Ada.Containers.Ordered_Maps.Map);



   ------------------------------
   --
   ------------------------------
   procedure Analyser_Evenement (Evenement : in String; Date_Absolu : in Ada.Calendar.Time ; Date : in Ada.Calendar.Time ; Info : out Evenement_Record) is
      Position_Espace : Natural := 1;
      Position_Diese: Natural := 1;
   begin
      Info.Jour := Date;
      Info.Jour_Absolu := Date_Absolu;
      Info.Elf_Id := 0;
      if Evenement = "falls asleep" then
         Info.Evenement := sleep;
      elsif Evenement = "wakes up" then
         Info.Evenement := awake;
      else
         Position_Diese := Index (Evenement, "#", Evenement'First);
         Position_Espace := Index (Evenement, " ", Position_Diese);
         declare
            Elf_Id : String := Evenement(Position_Diese+1..Position_Espace-1);
         begin
            Info.Elf_Id := Natural'Value(Elf_Id);
            Info.Evenement := change_shift;
         end;
      end if;
   end Analyser_Evenement;

   ------------------------------
   --
   ------------------------------
   procedure Decortiquer_Info (La_Ligne : in String; Les_Infos : in out Dictionnaire_Horaire.Map) is
      Position_Espace : Natural := 1;
      Position_Crochet: Natural := 1;
   begin
      Position_Espace := Index (La_Ligne, " ", 1);
      Position_Crochet := Index (La_Ligne, "]", 1);
      declare
         une_Date_Complete_Tmp : String := La_Ligne(La_Ligne'First + 1..Position_Crochet+2); -- Date Complet yyyy-mm-dd HH:MM:SS
         une_Date_Tmp : String := La_Ligne(La_Ligne'First + 1..Position_Espace-1); -- Date yyyy-mm-dd
         un_Evenement :  String:= La_Ligne(Position_Crochet + 2..La_Ligne'Last);
         une_Date_Complete : Natural;
         une_Date : Ada.Calendar.Time;
         un_Info_Evenement : Evenement_Record;
         Epoch : Ada.Calendar.Time;
      begin

         une_Date_Complete_Tmp(une_Date_Complete_Tmp'First..une_Date_Complete_Tmp'First+1):="20"; -- changer annee 1518 pour 2018
         une_Date_Complete_Tmp(une_Date_Complete_Tmp'Last-2..une_Date_Complete_Tmp'Last):=":00"; -- ajouter les secondes
         une_Date_Tmp(une_Date_Tmp'First..une_Date_Tmp'First+1):="20"; -- changer annee 1518 pour 2018

         --Ada.Calendar
         Epoch := GNAT.Calendar.Time_IO.Value(Date => une_Date_Complete_Tmp);
         une_Date_Complete := Natural( Ada.Calendar.Clock - Epoch ) ;
         une_Date := GNAT.Calendar.Time_IO.Value(Date => une_Date_Tmp) ;

         --Put_Line(une_Date_Complete'Img&" : "&un_Evenement);
         Analyser_Evenement(un_Evenement,Epoch,une_Date,un_Info_Evenement);

         Les_Infos.insert(une_Date_Complete, un_Info_Evenement);

      end;


   end Decortiquer_Info;

   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String;  Infos : out Dictionnaire_Horaire.Map) is
      Input : File_Type;

   begin
      Open (File => Input,
            Mode => In_File,
            Name => Fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : String := Get_Line (Input);
         begin
            Decortiquer_Info(Line,Infos);
         end;
      end loop;
      Close(Input);
   end Recuperer_Info;

   ------------------------------
   --
   ------------------------------
   function Affiche_Date(Date : in Ada.Calendar.Time) return String is
      Annee : Ada.Calendar.Year_Number;
      Mois : Ada.Calendar.Month_Number;
      Jour : Ada.Calendar.Day_Number;
      Heures : Ada.Calendar.Formatting.Hour_Number;
      Minutes : Ada.Calendar.Formatting.Minute_Number;
      Secondes : Ada.Calendar.Formatting.Second_Number;
      SubSecondes : Ada.Calendar.Formatting.Second_Duration;
   begin
      Ada.Calendar.Formatting.Split(Date       => Date,
                                    Year       => Annee,
                                    Month      => Mois,
                                    Day        => Jour,
                                    Hour       => Heures,
                                    Minute     => Minutes,
                                    Second     => Secondes,
                                    Sub_Second => SubSecondes,
                                    Time_Zone  => Ada.Calendar.Time_Zones.Time_Offset(-240));


      return Annee'Img & " -" & Mois'Img & " -" & Jour'Img &" -> "&Heures'Img&":"&Minutes'Img;
   end Affiche_Date;

   ------------------------------
   --
   ------------------------------
   function puzzle_1(fichier : in String) return Integer is
      use Ada.Calendar.Arithmetic;
      Reponse : Integer := 0;
      Infos : Dictionnaire_Horaire.Map;
      Curseur : Dictionnaire_Horaire.Cursor;
      Cle : Natural := 0;
      Elf_Id : Natural := 0;
      Sleep_Begins : Ada.Calendar.Time;
      Sleep_Ends : Ada.Calendar.Time;
      Sleep_Duration_seconde : Duration;
      Sleep_Duration_jour :  Ada.Calendar.Arithmetic.Day_Count;
      Sleep_Leap : Ada.Calendar.Arithmetic.Leap_Seconds_Count;
      Temps_Zero : Ada.Calendar.Time := Ada.Calendar.Time_Of(1970,1,1);
      Info_Elf : Dictionnaire_Elf.Map;
      Info_Dodo : Dodo_Record;

      Dodo_max : Duration :=0.0;
      Elf_Id_Dodo_max : Natural := 0;
      Avec_Dodo : Boolean := False;

      use Dictionnaire_Horaire;
   begin
      Recuperer_Info(Fichier, Infos);

      Curseur := Infos.Last;
      while Curseur /= No_Element loop
         Cle := Key(Curseur);
         Put_Line(Affiche_Date(Infos.element(Cle).Jour_Absolu)  &" = "& Infos.element(Cle).Elf_Id'Img&" "&Infos.element(Cle).Evenement'Img);

         case  Infos.element(Cle).Evenement is
            when change_shift =>
               if Avec_Dodo and Info_Elf.Contains(Elf_Id) then
                  Info_Dodo := Info_Elf.Element(Elf_Id);
                  Info_Dodo.Nb_Jour_Avec_Dodo := Info_Dodo.Nb_Jour_Avec_Dodo + 1;
                  Info_Elf.Replace(Elf_Id,Info_Dodo);
               end if;
               Elf_Id := Infos.element(Cle).Elf_Id;
               Avec_Dodo := False;
               Sleep_Begins := Temps_Zero;
               Sleep_Ends := Temps_Zero;
               Info_Dodo.Temps_Sommeil_Pour_Shift := 0.0;
               Info_Dodo.Nb_Jour_Travailles := Info_Dodo.Nb_Jour_Travailles + 1;
               if not Info_Elf.Contains(Elf_Id) then
                  Info_Dodo.Temps_Sommeil_Max := 0.0;
                  Info_Dodo.Jour := Infos.element(Cle).Jour;
                  Info_Elf.Insert(Elf_Id, Info_Dodo);
               end if;
            when sleep =>
               Sleep_Begins := Infos.element(Cle).Jour_Absolu;
               Avec_Dodo := True;
            when awake =>
               Sleep_Ends := Infos.element(Cle).Jour_Absolu;
               Difference(Left         => Sleep_Ends,
                          Right        => Sleep_Begins,
                          Days         => Sleep_Duration_jour,
                          Seconds      => Sleep_Duration_seconde,
                          Leap_Seconds => Sleep_Leap);

               Info_Dodo := Info_Elf.Element(Elf_Id);
               Info_Dodo.Temps_Sommeil_Pour_Shift := Info_Dodo.Temps_Sommeil_Pour_Shift + Sleep_Duration_seconde - 60.0;



               if Sleep_Duration_seconde >= Info_Elf.Element(Elf_Id).Temps_Sommeil_Max then
                  --Put_Line(Elf_Id'Img&" : "&Sleep_Duration_seconde'Img & " " & Info_Elf.Element(Elf_Id).Temps_Sommeil_Max'Img);
                  Info_Dodo.Temps_Sommeil_Max := Sleep_Duration_seconde - 60.0;
                  Info_Dodo.Jour := Infos.element(Cle).Jour;
               end if;

               Info_Elf.Replace(Elf_Id,Info_Dodo);

               if Sleep_Duration_seconde >= Dodo_max then
                  Dodo_max:=Sleep_Duration_seconde - 60.0;
                  Elf_Id_Dodo_max := Elf_Id;
               end if;


         end case;
         Previous(Curseur);
      end loop;

      New_Line;

      declare
         Curseur_Elf : Dictionnaire_Elf.Cursor;
         Max_Dodo : Duration := 0.0;
         Ratio : Float := 0.0;
         use Dictionnaire_Elf;
      begin
         Curseur_Elf := Info_Elf.First;
         while Curseur_Elf /= Dictionnaire_Elf.No_Element loop
            Cle := Key(Curseur_Elf);
            Ratio := Float(Info_Elf.Element(Cle).Nb_Jour_Travailles)/Float(Info_Elf.Element(Cle).Nb_Jour_Avec_Dodo);
            Put_Line(Cle'Img &" : "& Info_Elf.Element(Cle).Temps_Sommeil_Max'Img
                     &" "&Info_Elf.Element(Cle).Temps_Sommeil_Pour_Shift'Img
                     &" Ratio: "&Ratio'Img
                     &" dodo: "&Info_Elf.Element(Cle).Nb_Jour_Avec_Dodo'Img
                     &" travil: "&Info_Elf.Element(Cle).Nb_Jour_Travailles'Img) ;
            if Info_Elf.Element(Cle).Temps_Sommeil_Pour_Shift >= Max_Dodo then
               Max_Dodo := Info_Elf.Element(Cle).Temps_Sommeil_Pour_Shift;
            end if;

            Next(Curseur_Elf);
         end loop;
      end;



      Reponse := Elf_Id_Dodo_max * Integer(Dodo_max/60.0);
      Put_Line("ELF "&Elf_Id_Dodo_max'Img&" "&Dodo_max'Img &"="&Reponse'Img);

      return Reponse;
   end puzzle_1;

end Advent.Day4;
