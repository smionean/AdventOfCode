with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Characters.Handling; use Ada.Characters.Handling;
package body Advent.Day6 is

   type Espace_Type is array (Natural range <>, Natural range <>) of Character;

   type Position_Record_Type is
      record
         X : Natural := 0;
         Y : Natural := 0;
      end record;
   
   
   package Vecteur_Position_Type is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                               Element_Type => Position_Record_Type);
      
   ------------------------------
   --
   ------------------------------
   procedure Analyser(Point_Extreme : in Position_Record_Type) is
      Espace : Espace_Type(0..Point_Extreme.X+1, 0..Point_Extreme.Y+1) := (others => (others => ' '));
   begin
      null;
   end Analyser;
   
   
   ------------------------------
   --
   ------------------------------
   procedure Recuperer_Info (Fichier : in String; Vecteur_Position : out Vecteur_Position_Type.Vector; Point_Extreme : out Position_Record_Type ) is
      Input : File_Type;
      Position_Fin : Natural := 0;
      
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
            if  Position.X > Point_Extreme.X then
               Point_Extreme.X := Position.X;
            end if;
            if  Position.Y > Point_Extreme.Y then
               Point_Extreme.Y := Position.X;
            end if;
                        
            
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
      Point_Extreme : Position_Record_Type := (others => 0);
   begin
      Recuperer_Info(Fichier, Vecteur_Position, Point_Extreme);
      Put_Line(Point_Extreme.X'Img &" "&Point_Extreme.Y'Img);
      return Reponse;
   end puzzle_1;

end Advent.Day6;
