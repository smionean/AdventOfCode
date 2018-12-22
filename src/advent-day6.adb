with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Characters.Handling; use Ada.Characters.Handling;
package body Advent.Day6 is

   
   type Point_Record is 
      record
         ID : Natural := 0;
         Distance_Minimal : Natural := 0;
         Aire : Natural := 0;
         Infinity : Boolean := False;
      end record;
   
   
   type Position_Record_Type is
      record
         X : Natural := 0;
         Y : Natural := 0;
         Info : Point_Record;
      end record;
   
   type Espace_Type is array (Natural range <>, Natural range <>) of Point_Record;
   
   package Vecteur_Position_Type is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                               Element_Type => Position_Record_Type);
    
   
   ------------------------------
   --
   ------------------------------
   function Norme_1(A : in Position_Record_Type; B : in Position_Record_Type) return Natural is
      X : Natural := 0;
      Y : Natural := 0;
   begin
      X := abs(A.X - B.X);
      Y := abs(A.Y - B.Y);
      --Put_Line ("Norm "&X'Img&" +"&Y'Img);
      return X+Y;
   end Norme_1; 
   
   ------------------------------
   --
   ------------------------------
   procedure Analyser_Points(Vecteur_Position : in out Vecteur_Position_Type.Vector; Point_Max : in Position_Record_Type) is
      Distance : Natural := 0;
      A : Position_Record_Type;
      B : Position_Record_Type;
   begin
      for i in 1..Vecteur_Position.Last_Index-1 loop
         A := Vecteur_Position.Element(i);
         A.Info.Distance_Minimal := Point_Max.X + Point_Max.Y;  -- Distance Max
         for j in 2..Vecteur_Position.Last_Index loop
            B := Vecteur_Position.Element(j);
            if A.Info.ID /= B.Info.ID then
               Distance := Norme_1(A,B);
               if Distance < A.Info.Distance_Minimal then
                  A.Info.Distance_Minimal := Distance;
               end if;
            end if;
         end loop;  
         Vecteur_Position.Replace_Element(i, A);
      end loop;
   end Analyser_Points;
   
   
   ------------------------------
   --
   ------------------------------
   procedure Analyser(Vecteur_Position : in out Vecteur_Position_Type.Vector; Point_Extreme : in Position_Record_Type) is
      Espace : Espace_Type(0..Point_Extreme.X+1, 0..Point_Extreme.Y+1);
      A : Position_Record_Type;
      P : Position_Record_Type;
      Distance : Natural := Point_Extreme.X+Point_Extreme.Y;
      Aire : Natural := 0;
      Norme : Natural := 0;
      Safe_Distance : Natural := 0;
      Safe_Distance_Area : Natural := 0;
      ID : Natural := 0;
   begin
      for i in 0..Point_Extreme.X+1 loop
         for j in 0..Point_Extreme.Y+1 loop
            Distance :=  Point_Extreme.X+Point_Extreme.Y;
            Safe_Distance := 0;
            A.X := i;
            A.Y := j;
            for p in 1..Vecteur_Position.Last_Index loop
               Norme := Norme_1(A,Vecteur_Position.Element(p));
               Safe_Distance := Safe_Distance + Norme;
               if Norme < Distance then
                  Distance := Norme;
                  ID := Vecteur_Position.Element(p).Info.ID;
               elsif Norme = Distance then
                  Distance := Norme;
                  ID := 0;
               end if;
            end loop;
            
            if Safe_Distance < 10_000 then
               Safe_Distance_Area := Safe_Distance_Area + 1;
            end if;
            
            Espace(i,j).ID := ID;
            if ID /= 0 then
               P := Vecteur_Position.Element(ID);
               P.Info.Aire := P.Info.Aire + 1;
               if i = 0 or i = Point_Extreme.X+1 or j = 0 or j = Point_Extreme.Y+1 then
                  P.Info.Infinity := True;
                  Espace(i,j).Infinity := True;
               end if;
               Vecteur_Position.Replace_Element(ID,P);
            end if;
            
         end loop;
      end loop;
      
      for i in Espace'Range(1) loop
         for j in Espace'Range(2) loop
            put(Espace(i,j).ID'Img&",");
         end loop;
         New_Line;
      end loop; 
      
      Aire := 0;
      for p in 1..Vecteur_Position.Last_Index loop
         
         if not Vecteur_Position.Element(p).Info.Infinity and Vecteur_Position.Element(p).Info.Aire > Aire then
            Aire := Vecteur_Position.Element(p).Info.Aire;
            ID := p;
            Put_Line(p'Img & " : " & Vecteur_Position.Element(p).Info.Aire'Img); 
         end if;
         
      end loop;
      
      Put_Line("Reponse1 : ("&ID'Img &") " & Aire'Img); 
      Put_Line("Reponse2 : "& Safe_Distance_Area'Img); 
  
      
   end Analyser;
   
   
   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String; Vecteur_Position : out Vecteur_Position_Type.Vector; Point_Extreme : out Position_Record_Type ) is
      Input : File_Type;
      Position_Fin : Natural := 0;
      No_Point : Natural := 1;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => Fichier);
      While not  End_Of_File (Input) Loop
         declare
            Data: String := Get_Line (Input);
            Position : Position_Record_Type;
         begin
            Position_Fin := Index (Data, ",", 1);
            Position.X := Integer'Value(Data(1..Position_Fin-1));
            Position.Y := Integer'Value(Data(Position_Fin+1..Data'Last));
            Position.Info.ID := No_Point;
            if  Position.X > Point_Extreme.X then
               Point_Extreme.X := Position.X;
            end if;
            if  Position.Y > Point_Extreme.Y then
               Point_Extreme.Y := Position.X;
            end if;
            No_Point := No_Point +1;          
           
            Vecteur_Position.Append(Position);            
         end;
      end loop;
      Close(Input);
   end Recuperer_Info;

   ------------------------------
   --
   ------------------------------
   function puzzle_1(fichier : in String) return Integer is
      Reponse : Integer := 0;
      Vecteur_Position : Vecteur_Position_Type.Vector;
      Point_Extreme : Position_Record_Type;
   begin
      Recuperer_Info(Fichier, Vecteur_Position, Point_Extreme);
      Put_Line(Point_Extreme.X'Img &" "&Point_Extreme.Y'Img);
      Analyser(Vecteur_Position,Point_Extreme);
      return Reponse;
   end puzzle_1;

end Advent.Day6;
