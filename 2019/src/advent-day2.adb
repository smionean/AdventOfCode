with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;


package body Advent.Day2 is

   package vecteur_intcode_type is new Ada.Containers.Vectors(Index_Type   => Positive,              
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
   
   begin
      for i in 1..Vecteur_Intcode.Last_Index loop
         if Vecteur_Intcode.Element(i) = 1 then
            Appliquer_Operation_1(Vecteur_Intcode.Element(i+1),
                                  Vecteur_Intcode.Element(i+2),
                                  Vecteur_Intcode.Element(i),
                                  Vecteur_Intcode);
         elsif Vecteur_Intcode.Element(i) = 2 then
    
         end if;
      end loop;
   end Analyser;

   
   function puzzle(fichier : in String) return Integer is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Vecteur_Intcode : vecteur_intcode_type;
      Position : Integer := 0;
      Position_Precedente : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
         Name => fichier);
      While not  End_Of_File (Input) Loop

         declare
            Line : String := Get_Line (Input);
         begin
            --Put_Line(Line);
            -- recuperer code
            Position := Index(Line,",",Position_Precedente);
            while Position <= Line'Length loop
               Vecteur_Intcode.Append(Natural'Value(Line(Position_Precedente..Position)));
               Position_Precedente := Position;
               Position := Index(Line,",",Position_Precedente);
            end loop;
            
            -- analyser code
            Analyser(Vector_Intcode);
            
         end;
      end loop;
      Close(Input);
      Put_Line("Reponse 2.0 : " & Reponse'Img);
      Put_Line("Reponse 2.1 : " & Reponse_2'Img);


      return Reponse;
   end puzzle;


end Advent.Day2;
