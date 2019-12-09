with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;


package body Advent.Day2 is

   package vecteur_intcode_type is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                              Element_Type => Natural);
   type Opcode_Range is range 0..99; 
                                                                                                                            
   procedure Analyser(Nom : in Opcode_Range; Verbe : in Opcode_Range; Vecteur_Intcode : in out vecteur_intcode_type.Vector ) is
      i : Natural := 0;
      Valeur : Natural := 0;
      Position : Natural := 0;
   begin
      Vecteur_Intcode.Replace_Element(1,Natural(Nom));
      Vecteur_Intcode.Replace_Element(2,Natural(Verbe));

       
      loop
         if (i+3) > Vecteur_Intcode.Last_Index or else Vecteur_Intcode.Element(i+3) > Vecteur_Intcode.Last_Index then
            exit;
         end if;
         
         if Vecteur_Intcode.Element(i) = 1 then
            Valeur := Vecteur_Intcode.Element(Vecteur_Intcode.Element(i+1))+Vecteur_Intcode.Element(Vecteur_Intcode.Element(i+2));
            Position := Vecteur_Intcode.Element(i+3);
            Vecteur_Intcode.Replace_Element(Position,Valeur);
             i:=i+4;

         elsif Vecteur_Intcode.Element(i) = 2 then
            Valeur := Vecteur_Intcode.Element(Vecteur_Intcode.Element(i+1))*Vecteur_Intcode.Element(Vecteur_Intcode.Element(i+2));
            Position := Vecteur_Intcode.Element(i+3);
            Vecteur_Intcode.Replace_Element(Position,Valeur);
            i:=i+4;
         elsif Vecteur_Intcode.Element(i) = 99 then
            exit;
         else
            i:=i+1;
         end if;
         
         exit when i > Vecteur_Intcode.Last_Index;
      end loop;
            
   end Analyser;

   
   function puzzle(fichier : in String) return Integer is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Vecteur_Intcode : vecteur_intcode_type.Vector;
      Vecteur_Intcode_Initial : vecteur_intcode_type.Vector;
      Position : Natural := 0;
      Position_Precedente : Natural := 0;
      Combi_Trouvee : Boolean := False;
      N : Natural := 0;
      V : Natural := 0;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : String := Get_Line (Input)&",";
         begin
            -- recuperer code
            Position := Line'First;
            for i in Line'Range loop
               if Line(i) = ',' or i = Line'Last then
                  Vecteur_Intcode_Initial.Append(Natural'Value(Line(Position..i-1)));
                  Position := i + 1;
               end if;
               
            end loop;        
         end;
      end loop;
      Close(Input);
      Vecteur_Intcode := Vecteur_Intcode_Initial;
      Analyser(Nom => 12, Verbe => 2,Vecteur_Intcode => Vecteur_Intcode);
      Reponse := Vecteur_Intcode.Element(0);
      
      
      
      for Nom in Opcode_Range loop
         for Verbe in Opcode_Range loop
            Vecteur_Intcode := Vecteur_Intcode_Initial;
            Analyser(Nom             => Nom,
                     Verbe           => Verbe,
                     Vecteur_Intcode => Vecteur_Intcode);
            if Vecteur_Intcode.Element(0) = 19690720 then
               Combi_Trouvee := True;
               N := Natural(Nom);
               V := Natural(Verbe);
               exit;
            end if;   
         end loop;
         exit when Combi_Trouvee;
      end loop;
      
      Reponse_2 := N*100+V;
      
      Put_Line("Reponse 2.0 : " & Reponse'Img);
      Put_Line("Reponse 2.1 : " & Reponse_2'Img);


      return Reponse;
   end puzzle;


end Advent.Day2;
