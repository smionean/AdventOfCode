with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Calendar;

package body Advent.Day4 is

   type Tissu_Type is array (Integer range <>, Integer range <>) of Integer;

   type tissu_info is
      record
         id : Natural;
         pos_x : Natural := 0;
         pos_y : Natural := 0;
         lng_x : Natural := 0;
         lng_y : Natural := 0;
      end record;

   package vecteur_ids is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                     Element_Type => tissu_info);


   ------------------------------
   --
   ------------------------------
   procedure Decortiquer_Info (La_Ligne : in String; L_Info : out tissu_info) is
      --  #1 @ 493,113: 12x14
      --  #id @ pos_x,pos_y: lng_x x lng_y

      Position_Arobas : Natural := 1;
      Position_Virgule : Natural := 1;
      Position_2Point : Natural := 1;
      Posiotn_X : Natural := 1;

   begin

      Position_Arobas := Index (La_Ligne, "@", 1);
      Position_Virgule :=  Index (La_Ligne, ",", 1);
      Position_2Point := Index (La_Ligne, ":", 1);
      Posiotn_X := Index (La_Ligne, "x", 1);

      declare
         Un_ID : String := La_Ligne(La_Ligne'First + 1..Position_Arobas-1);
         Position_X : String := La_Ligne(Position_Arobas+ 1..Position_Virgule-1);
         Position_Y : String := La_Ligne(Position_Virgule+ 1..Position_2Point-1);
         Lng_X : String := La_Ligne(Position_2Point+ 1..Posiotn_X-1);
         Lng_Y : String := La_Ligne(Posiotn_X+ 1..La_Ligne'Last);
      begin
         L_Info.id := Natural'Value(Un_ID);
         L_Info.pos_x := Natural'Value(Position_X);
         L_Info.pos_y := Natural'Value(Position_Y);
         L_Info.lng_x := Natural'Value(Lng_X);
         L_Info.lng_y := Natural'Value(Lng_Y);
         Put_line(Un_ID & " ; " & Position_X & ","&Position_Y&" "&Lng_X&"-"&Lng_Y);
      end;


   end Decortiquer_Info;

   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String; Vecteur_Info_Tissu : out vecteur_ids.Vector) is
      Input : File_Type;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => Fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : String := Get_Line (Input);
            Tissu_Data : tissu_info;
         begin
            Decortiquer_Info(Line, Tissu_Data);
            Vecteur_Info_Tissu.Append(Tissu_Data);
         end;
      end loop;
      Close(Input);
   end Recuperer_Info;

   ------------------------------
   --
   ------------------------------
   procedure Analyser_Tissus (Vecteur_Info_Tissu : in vecteur_ids.Vector; Le_Tissus : in out Tissu_Type) is
      Conflit : Natural := 0;
      Conflit_By_Id : Natural := 0;
   begin
      for i in 1..Vecteur_Info_Tissu.Last_Index loop
         Conflit_By_Id:=0;
         for x in Vecteur_Info_Tissu.Element(i).pos_x+1..Vecteur_Info_Tissu.Element(i).pos_x+1+Vecteur_Info_Tissu.Element(i).lng_x-1 loop
            for y in Vecteur_Info_Tissu.Element(i).pos_y+1..Vecteur_Info_Tissu.Element(i).pos_y+1+Vecteur_Info_Tissu.Element(i).lng_y-1 loop
               --  Put_Line("X: "&x'Img&" Y: "&y'Img);
               if x < 1000 and y < 1000 then
                  if Le_Tissus(x,y) = 0 or Le_Tissus(x,y) = Vecteur_Info_Tissu.Element(i).id then
                     Le_Tissus(x,y) := Vecteur_Info_Tissu.Element(i).id;
                  elsif Le_Tissus(x,y) > 0 then
                     Le_Tissus(x,y) := 0 - Vecteur_Info_Tissu.Element(i).id;
                     Conflit := Conflit + 1;
                     Conflit_By_Id := Conflit_By_Id + 1;
                  elsif Le_Tissus(x,y) < 0 then
                     Conflit_By_Id := Conflit_By_Id + 1;
                  end if;
               end if;
            end loop;
         end loop;
         if Conflit_By_Id = 0 then
            Put_Line("Pas de conflit pour "&Vecteur_Info_Tissu.Element(i).id'Img);
         end if;
      end loop;
      Put_Line("Reponse jour 3 puzzle 1 : "&Conflit'Img);
   end Analyser_Tissus;


   ------------------------------
   --
   ------------------------------
   function puzzle_1(fichier : in String) return Integer is
      Reponse : Integer := 0;
      Vecteur_Info_Tissu : vecteur_ids.Vector;
       Le_Tissus : Tissu_Type(1..1000,1..1000) :=  (others => (others => 0));
   begin
      Recuperer_Info(Fichier,Vecteur_Info_Tissu);
      Analyser_Tissus(Vecteur_Info_Tissu, Le_Tissus);
      Analyser_Tissus(Vecteur_Info_Tissu, Le_Tissus);
      return Reponse;
   end puzzle_1;



end Advent.Day4;
