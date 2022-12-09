--+-------------------------------------------------------------------------+-- 
--|                                                                         |--
--|                                                                         |--
--|                                  TTT                                    |--
--|                                  TTT                                    |--
--|                                  TTT                                    |--
--|                           TTT           TTT                             |--
--|                           TTT           TTT                             |--
--|                           TTTTTTTTTTTTTTTTT                             |--
--|                           TTTTTTTTTTTTTTTTT                             |--
--|                           TTT           TTT                             |--
--|                           TTT           TTT                             |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2022 : 08
--|   * Name : Simon Be�n
--|   * Date : Thu 08 Dec 2022 09:24:52 PM EST
--|   
--|   * Filename : day08.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2022
--|                        Jour 08
--|
--|                 (en) : Advent Of Code Challenge 2022
--|                        Day 08
--|
--|   #AdaAdventOfCode22
--|
--+-------------------------------------------------------------------------+--
--|   * Changelog * 
--|
--|
--+-------------------------------------------------------------------------+--

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Day08 is

   package Type_Data is new Ada.Containers.Vectors(Index_Type   => Positive,
                                                     Element_Type => Unbounded_String);
   use Type_Data;

   type Type_Map is array(Positive range <>, Positive range <>) of Natural;

   type Type_Map_Dimension is
   record
      LAT : Natural :=0;
      LON : Natural :=0;
   end record;


   function Lookup_North (Latitude : in Natural; Longitude : in Natural; Map_Dimension : in Type_Map_Dimension; Map : in Type_Map; Scenic_Score : out Natural) return Boolean is
      Tree_Height : Natural := Map(Latitude, Longitude);
   begin
      Scenic_Score := 0;
      for LON in reverse 1..Longitude-1 loop
         Scenic_Score := Scenic_Score + 1;
         if Map(Latitude,LON) >= Tree_Height then
            return False;
         end if;
      end loop;
      return True;
   end Lookup_North;


   function Lookup_South (Latitude : in Natural; Longitude : in Natural; Map_Dimension : in Type_Map_Dimension; Map : in Type_Map; Scenic_Score : out Natural) return Boolean is
      Tree_Height : Natural := Map(Latitude, Longitude);
   begin
      Scenic_Score := 0;
      for LON in Longitude+1..Map_Dimension.LON loop
         Scenic_Score := Scenic_Score + 1;
         if Map(Latitude,LON) >= Tree_Height then
            return False;
         end if;
      end loop;
      return True;
   end Lookup_South;

   function Lookup_East (Latitude : in Natural; Longitude : in Natural; Map_Dimension : in Type_Map_Dimension; Map : in Type_Map; Scenic_Score : out Natural) return Boolean is
      Tree_Height : Natural := Map(Latitude, Longitude);
   begin
      Scenic_Score := 0;
      for LAT in Latitude+1..Map_Dimension.LAT loop
         Scenic_Score := Scenic_Score + 1;
         if Map(LAT,Longitude) >= Tree_Height then
            return False;
         end if;
      end loop;
      return True;
   end Lookup_East;

   function Lookup_West (Latitude : in Natural; Longitude : in Natural; Map_Dimension : in Type_Map_Dimension; Map : in Type_Map; Scenic_Score : out Natural) return Boolean is
      Tree_Height : Natural := Map(Latitude, Longitude);
   begin
      Scenic_Score := 0;
      for LAT in reverse 1..Latitude-1 loop
         Scenic_Score := Scenic_Score + 1;
         if Map(LAT,Longitude) >= Tree_Height then
            return False;
         end if;
         
      end loop;
      return True;
   end Lookup_West;

   procedure Init_Map(Map : in out Type_Map; Data : in Type_Data.Vector) is
      Longitudinal_Idx : Natural := 1;
   begin
        for I in Data.First_Index..Data.Last_Index loop
            declare
               Longitude_String : String := To_String(Data.Element(I));
            begin
               for C in 1..Longitude_String'Length loop
                     Map(C,Longitudinal_Idx) := Natural'Value(Longitude_String(C..C));                     
               end loop;
               Longitudinal_Idx := Longitudinal_Idx + 1;
            end; 
        end loop;
   end Init_Map;


   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      Data : Type_Data.Vector := Type_Data.Empty_Vector;
      Longitudinal_Length : Natural := 0;
      Latitudinal_Length : Natural := 0;
      Map_Dimension : Type_Map_Dimension := (LAT=>0, LON=>0);
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            Data.Append(To_Unbounded_String(Line));
            Map_Dimension.LON := Line'Length;
         end;
      end loop;
      Close(Input);

      Map_Dimension.LAT := Natural'Val(Data.Length);

      declare
         Map : Type_Map( 1..Map_Dimension.LAT ,1..Map_Dimension.LON ) := (others => (others => 0));
         R : Boolean := True;
         Scenic_Score_North : Natural := 0;
         Scenic_Score_South : Natural := 0;
         Scenic_Score_East : Natural := 0;
         Scenic_Score_West : Natural := 0;
         Max_Scenic_Score : Natural := 0;
      begin
         Init_Map(Map,Data);
         for LAT in 1..Map_Dimension.LAT  loop
            for LON in 1..Map_Dimension.LON loop
               R := Lookup_North(LAT,LON,Map_Dimension,Map,Scenic_Score_North) 
                     or Lookup_South(LAT,LON,Map_Dimension,Map,Scenic_Score_South)
                     or Lookup_East(LAT,LON,Map_Dimension,Map,Scenic_Score_East)
                     or Lookup_West(LAT,LON,Map_Dimension,Map,Scenic_Score_West);
               if R then
                  reponse := reponse + 1;
                  Max_Scenic_Score := Natural'Max(Max_Scenic_Score, (Scenic_Score_North*Scenic_Score_South*Scenic_Score_East*Scenic_Score_West));
               end if;
            end loop;
         end loop;
         Reponse_2 := Max_Scenic_Score;
      end;
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 08");
   Execute("data/data.txt");
end Day08;
