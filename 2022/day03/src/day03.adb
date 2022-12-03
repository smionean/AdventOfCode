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
--|   * Project name : Advent of Code 2022 : 03
--|   * Name : Simon Be�n
--|   * Date : Fri 02 Dec 2022 05:32:40 PM EST
--|   
--|   * Filename : day03.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2022
--|                        Jour 03
--|
--|                 (en) : Advent Of Code Challenge 2022
--|                        Day 03
--|
--|   #AdaAdventOfCode22
--|
--+-------------------------------------------------------------------------+--
--|   * Changelog * 
--|
--|
--+-------------------------------------------------------------------------+--
pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Characters.Handling; use Ada.Characters.Handling;
with Ada.Containers; use Ada.Containers;
with Ada.Containers.Ordered_Sets;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Day03 is

   type Item is ('0','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
                  'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z');

   package Rucksack_Item_Type is new Ada.Containers.Ordered_Sets(Item);
   use Rucksack_Item_Type;

   package Rucksack_Vector is new Ada.Containers.Vectors(Index_Type   => Positive,              
						      Element_Type => Unbounded_String);

   package Items_Positions_Vector is new Ada.Containers.Vectors(Index_Type   => Positive,              
						      Element_Type => Item);                     

   function Find_Item ( Rucksack : in String) return Item is
      Half_Rucksack : Rucksack_Item_Type.set;
      An_Item : Item;
   begin
      for C in Rucksack'Last/2+1..Rucksack'Last loop
         An_Item := Item'Value(Rucksack(C)'Img);
         if not Half_Rucksack.Contains(An_Item) then
            Half_Rucksack.Insert(An_Item);
         end if;
         --Put(Rucksack(C)'Img);
      end loop;
      for C in Rucksack'First..Rucksack'Last/2 loop
         An_Item := Item'Value(Rucksack(C)'Img);
         if Half_Rucksack.Contains(An_Item) then
           return An_Item;
         end if;
        -- Put(Rucksack(C)'Img);
      end loop;
      return '0';
   end Find_Item;


   procedure Add_In_Rucksack_Set(Rucksack : in String; Rucksack_Set : in out Rucksack_Item_Type.Set; Positions : in out Items_Positions_Vector.Vector) is
      An_Item : Item;
   begin
      for C in Rucksack'First..Rucksack'Last loop
         An_Item := Item'Value(Rucksack(C)'Img);
         if not Rucksack_Set.Contains(An_Item) then
            Rucksack_Set.Insert(An_Item);
            Positions.Append(An_Item);
         end if;
      end loop;
   end Add_In_Rucksack_Set;



   function Find_Badge (Rucksack_Group : in Rucksack_Vector.Vector) return Item is
      Rucksack_1 : String := To_String(Rucksack_Group.Element(Rucksack_Group.First_Index));
      Rucksack_2 : String := To_String(Rucksack_Group.Element(Rucksack_Group.First_Index+1));
      Rucksack_3 : String := To_String(Rucksack_Group.Element(Rucksack_Group.Last_Index));
      Rucksack_Set_1: Rucksack_Item_Type.set := Rucksack_Item_Type.Empty_Set ;
      Rucksack_Set_2: Rucksack_Item_Type.set := Rucksack_Item_Type.Empty_Set;
      Rucksack_Set_3: Rucksack_Item_Type.set := Rucksack_Item_Type.Empty_Set;
      Rucksack_Intersection_Set : Rucksack_Item_Type.set;
      Positions_1 : Items_Positions_Vector.Vector := Items_Positions_Vector.Empty_Vector;
      Positions_2 : Items_Positions_Vector.Vector := Items_Positions_Vector.Empty_Vector;
      Positions_3 : Items_Positions_Vector.Vector := Items_Positions_Vector.Empty_Vector;
      Position : Positive := Positive'Last;
      An_Item : Item;
   begin
      Add_In_Rucksack_Set(Rucksack_1, Rucksack_Set_1, Positions_1);
      Add_In_Rucksack_Set(Rucksack_2, Rucksack_Set_2, Positions_2);
      Add_In_Rucksack_Set(Rucksack_3, Rucksack_Set_3, Positions_3);

      Rucksack_Intersection_Set := Rucksack_Set_1 and Rucksack_Set_2;
      Rucksack_Intersection_Set := Rucksack_Intersection_Set and Rucksack_Set_3;      

      if Rucksack_Intersection_Set.Length > 1 then
         for E of Rucksack_Intersection_Set loop
            if Positions_1.Find_Index(E) < Position then
               Position := Positions_1.Find_Index(E);
            end if;
         end loop;
         An_Item := Positions_1.Element(Position);
      else
         An_Item := Rucksack_Intersection_Set.First_Element;
      end if;

      return An_Item;
   end Find_Badge;

   procedure Execute(fichier : in String) is
      Input : File_Type;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
      C : Item := '0';
      B : Item := '0';
      Rucksack_Group : Rucksack_Vector.Vector := Rucksack_Vector.Empty_Vector ;
      Group_Iter : Natural := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            C := Find_Item(Line);
            Reponse := Reponse + Item'Pos(C);
            Rucksack_Group.Append(To_Unbounded_String(Line));
            Group_Iter := Group_Iter + 1;
            if Group_Iter = 3 then
               B := Find_Badge(Rucksack_Group);
               Reponse_2 := Reponse_2 + Item'Pos(B);
               Group_Iter := 0;
               Rucksack_Group := Rucksack_Vector.Empty_Vector;
            end if;
         end;
      end loop;
      Close(Input);
            
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   
   New_Line;
   Put_Line("CHALLENGE DAY 03");
   Execute("data/data.txt");
end Day03;
