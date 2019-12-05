with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;


package body Advent.Day2 is

   package vecteur_intcode_type is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                              Element_Type => Natural);
                                                       
                   
   procedure Appliquer_Operation_1(Position_Valeur_A : in Positive;
                                   Positive_Valeur_B : in Positive;
                                   Position_Reponse : in Positive;
                                   Vector_Intcode : in out vecteur_intcode_type.Vector) is
                                   
   begin
      null;
   end Appliquer_Operation_1;
   
   procedure Appliquer_Operation_2(Position_Valeur_A : in Positive;
                                   Positive_Valeur_B : in Positive;
                                   Position_Reponse : in Positive;
                                   Vector_Intcode : in out vecteur_intcode_type.Vector) is
                                   
   begin
      null;
   end Appliquer_Operation_2;
                                   
                                                                                        
   procedure Analyser(Vecteur_Intcode : in out vecteur_intcode_type.Vector) is
      i : Natural := 0;
   begin
      Vecteur_Intcode.Replace_Element(1,12);
      Vecteur_Intcode.Replace_Element(2,2);
      loop
         if Vecteur_Intcode.Element(i) = 1 then
            Vecteur_Intcode.Replace_Element(Vecteur_Intcode.Element(i+3),
                                        Vecteur_Intcode.Element(i+1)+Vecteur_Intcode.Element(i+2));
          
           -- Appliquer_Operation_1(Vecteur_Intcode.Element(i+1),
           --                       Vecteur_Intcode.Element(i+2),
           --                       Vecteur_Intcode.Element(i+3),
           --                       Vecteur_Intcode);
         elsif Vecteur_Intcode.Element(i) = 2 then
            Vecteur_Intcode.Replace_Element(Vecteur_Intcode.Element(i+3),
                                        Vecteur_Intcode.Element(i+1)*Vecteur_Intcode.Element(i+2));
           -- Appliquer_Operation_2(Vecteur_Intcode.Element(i+1),
           --                       Vecteur_Intcode.Element(i+2),
           --                       Vecteur_Intcode.Element(i+3),
           --                       Vecteur_Intcode);
         elsif Vecteur_Intcode.Element(i) = 99 then
            exit;
         end if;
         
         i := i + 4;
         exit when i > Vecteur_Intcode.Last_Index;
      end loop;
   end Analyser;

   
   function puzzle(fichier : in String) return Integer is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Vecteur_Intcode : vecteur_intcode_type.Vector;
      Position : Natural := 0;
      Position_Precedente : Natural := 0;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : String := Get_Line (Input)&",";
         begin
            --Put_Line(Line);
            -- recuperer code
            Position := Line'First;
            for i in Line'Range loop
               if Line(i) = ',' or i = Line'Last then
                  --Put_Line(Line(Position..i-1));
                  Vecteur_Intcode.Append(Natural'Value(Line(Position..i-1)));
                  Position := i + 1;
               end if;
               
            end loop;        
         end;
      end loop;
      Close(Input);
      -- analyser code
     Analyser(Vecteur_Intcode);
      Reponse := Vecteur_Intcode.Element(0);
      
      Put_Line("Reponse 2.0 : " & Reponse'Img);
      Put_Line("Reponse 2.1 : " & Reponse_2'Img);


      return Reponse;
   end puzzle;


end Advent.Day2;
