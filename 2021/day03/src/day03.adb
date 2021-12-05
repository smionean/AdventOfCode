--------------------------------------------
-- D�fi Calnedrier de l'Avent 2021
--   Advent Of Code Challenge 2021
--
-- #AdaAdventOfCode21
--
-- https://adventofcode.com
--
-- Simon Be�n : https://github.com/smionean
--
-- Jour 03 / Day 03
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

with Interfaces;
use Interfaces;

procedure Day03 is
  
   type binaire is mod 2;
   package Type_Vector_Data is new Ada.Containers.Vectors(Index_Type   => Positive,              
                                                          Element_Type => Natural);
   
   package Type_Vector_Binaire is new Ada.Containers.Vectors(Index_Type   => Positive,              
                                                          Element_Type => binaire);

   
   procedure Ajoute ( Valeur : IN Natural; Position : in Natural; Vect : IN OUT Type_Vector_Data.Vector ) is
      Vect_Tmp : type_vector_data.Vector;
   begin
      if Position <= Vect.Last_Index then
         Vect.Replace_Element(Position,Vect.Element(Position)+Valeur);
      else
         Vect.Append(Valeur);
      end if;
   end Ajoute;

   procedure Comptabilise (Vect : in out Type_Vector_Data.Vector; Vect_Binaire : in out Type_Vector_Binaire.Vector; Longueur : in Natural) is
   begin
      for I in Vect.First_Index..Vect.Last_Index loop
         if (Longueur-Vect.Element(I)) < Longueur/2 then
            Vect_Binaire.Append(1);
         else
            Vect_Binaire.Append(0);
         end if;
      end loop;
   end Comptabilise;

   function Analyse_Consommation (Vect : in Type_Vector_Binaire.Vector; Longueur: in Natural) return Integer is
      Index : Natural := Longueur;
      G : Unsigned_32 := 0;
      E : Unsigned_32 := 0;
   begin
      for I in Vect.First_Index..Vect.Last_Index loop
	 G := G or Shift_Left(Unsigned_32(Vect.Element(I)),Index-1);
	 E := E or Shift_Left((Unsigned_32(Vect.Element(I)+1)),Index-1);
	 
	 Put_Line(I'Img &" =>"&Vect.Element(I)'Img&" - "&G'Img);
	 Index := Index - 1;
      end loop;
      Put_Line(G'Img&" "&E'Img);
      return Integer(G*E);
   end Analyse_Consommation;
   
   function Analyse_Oxygene(Data : in Type_Vector_Data.Vector; Vect : in Type_Vector_Binaire.Vector;Longueur: in Natural) return Integer is
      
      function Filtre (Valeur : in Natural; Position : in Positive; Condition : in binaire) return Boolean is
      begin
	 return true;
      end Filtre;
      
      Data_Gamma : Type_Vector_Data.Vector := Type_Vector_Data.Empty_Vector;
      Data_Epsilon : Type_Vector_Data.Vector := Type_Vector_Data.Empty_Vector;
   begin
      for Position in Vect.First_Index..Vect.Last_Index loop
	 
	 for D in Data.Iterate loop
	    Put_Line("---> "&Integer'Image (Data(D)));
	    if Filtre(Data(D),Position,Vect.Element(Position)) then
	       Data_Gamma.Append(Data(D));
	    else
	       Data_Epsilon.Append(Data(D));
	    end if;
	 end loop;
New_Line;
--  	 if Vect.Element(Position) = 1 then
--  	  null;--  Filtre(Data_A_Jour,Position);
--  	 else
--  	    null;
--  	 end if;

      end loop;
      return 0;
   end Analyse_Oxygene;

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Data : Type_Vector_Data.Vector := Type_Vector_Data.Empty_Vector;
      Gamma_Epsilon : Type_Vector_Data.Vector := Type_Vector_Data.Empty_Vector;
      Gamma_Epsilon_Bits : Type_Vector_Binaire.Vector := Type_Vector_Binaire.Empty_Vector;
      Longueur_Data : Natural := 0;
      Longueur_Ligne : Natural := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
	    Line : String := Get_Line (Input);
         begin
            Longueur_Ligne := Line'Length;
	    Data.Append(Natural'Value("2#"&Line&"#"));
	    	    
	    --Word_IO.Put(Item);
            Longueur_Data := Longueur_Data + 1;
	    for I in Line'Range loop
	       --Put_Line("I "&I'Img);
               case Line(I) is
               when '1' =>  Ajoute(1,I,Gamma_Epsilon);
               when '0' => Ajoute(0,I,Gamma_Epsilon);
               when others => null;
               end case;
            end loop;
         end;
      end loop;

      Close(Input);
      
      Comptabilise(Gamma_Epsilon,Gamma_Epsilon_Bits,Longueur_Data);
      
      Reponse := Analyse_Consommation(Gamma_Epsilon_Bits,Longueur_Ligne);
            
      Reponse_2 := Analyse_Oxygene(Data,Gamma_Epsilon_Bits,Longueur_Ligne);
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 03");
   --Execute("data/data.txt");
end Day03;
