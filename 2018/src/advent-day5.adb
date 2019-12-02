with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Characters.Handling; use Ada.Characters.Handling;
package body Advent.Day5 is

  -- type Caracteres is array ('a'..'z') of Character;
   subtype Caracteres_L is Character range 'a' .. 'z';
   subtype Caracteres_M is Character range 'A' .. 'Z';
   
   function Efface (Data : in String; Position : in Positive; Count : in Natural ) return String is
      padding : String(1..Count) := (others=>' ');
   begin
--          Put_Line(Position'Img&" "&Count'Img&" "&Data&" -> "&Data(Data'First..Position-1) & Data(Position+Count..Data'Last));
      return Data(Data'First..Position-1) & Data(Position+Count..Data'Last)&padding;
   end Efface;
   
   ------------------------------
   --
   ------------------------------
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
   function Analyser_Polymere (Data : in String) return String is
      i : Positive := Data'First;
      Data_Reponse : String := Data;
   begin
      
      while i < Data_Reponse'Last loop
         if Analyser_Pairs(Data_Reponse(i), Data_Reponse(i+1)) then
            Data_Reponse := Efface(Data_Reponse,i,2);
            if i-4 > Data_Reponse'First then
               i := i-4;
            else
               i:=Data_Reponse'First;
            end if;
         else
            i:=i+1;
         end if;
      end loop;  
      return Data_Reponse;
   end Analyser_Polymere;

   
   function Analyser_Polymere (Data : in String; Molecule : in Character) return String is
      i : Positive := Data'First;
      Data_Reponse : String := Data;
   begin
      
      while i <= Data_Reponse'Last loop
         if To_Upper(Data_Reponse(i)) = Molecule then
            Data_Reponse := Efface(Data_Reponse,i,1);
            if i-4 > Data_Reponse'First then
               i := i-4;
            else
               i:=Data_Reponse'First;
            end if;
            
         else
            i:=i+1;
         end if;
      end loop; 
      return Data_Reponse;
   end Analyser_Polymere;
   
   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String) is
      Input : File_Type;
      Position_Fin : Natural := 0;
      Mini : Natural := 999;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => Fichier);
      While not  End_Of_File (Input) Loop
         declare
            Data: String := Get_Line (Input);
            Data2: String := Data;
         begin
            Data2:=Analyser_Polymere(Data);
            Position_Fin := Index (Data2, " ", 1)-1;
            Put_Line(Position_Fin'Img);
            Mini:=Position_Fin;
           
            for c in Caracteres_M loop
               Data2:=Analyser_Polymere(Data,c);
              -- Put_Line(Data2);
               Data2:=Analyser_Polymere(Data2);
              -- Put_Line(Data2);
               Position_Fin := Index (Data2, " ", 1)-1;
               Put_Line(c&" "&Position_Fin'Img);
               if Position_Fin<Mini then
                  Mini := Position_Fin;
               end if;
            end loop;
            
         end;
      end loop;
      Put_Line("Minimal "&Mini'Img);
      Close(Input);
   end Recuperer_Info;

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
