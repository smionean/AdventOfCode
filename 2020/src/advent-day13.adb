--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 13 / Day 13
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;
with Ada.Strings.Fixed;
with Ada.Strings.Maps;

package body Advent.Day13 is

   package Bus_Vector is new Ada.Containers.Vectors(Index_Type   => Natural,              
						    Element_Type => Natural);
   package Bus_Sorter is new Bus_Vector.Generic_Sorting;
   
   Comma  : constant Ada.Strings.Maps.Character_Set :=
     Ada.Strings.Maps.To_Set (",");
   
   procedure Get_In_Service_Buses(Schedule : in String; Buses : in out Bus_Vector.Vector) is
      First : Positive;
      Last  : Natural := 0;
   begin
      
      while Last < Schedule'Last loop
	 Ada.Strings.Fixed.Find_Token (Source => Schedule,
				Set    => Comma,
				From   => Last + 1,
				Test   => Ada.Strings.Outside,
				First  => First,
				Last   => Last);

	 exit when Last < First;

	 if Schedule (First .. Last) /= "x" then
	    Buses.Append(Natural'Value(Schedule (First .. Last)));
	 end if;
	 
      end loop;
      Bus_Sorter.Sort(Buses);
   end Get_In_Service_Buses;
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Timestamp : Natural := 0;
      Buses : Bus_Vector.Vector;
      Bus_ID : Natural := 0;
      Wait_Time : Natural := 0;
      Reponse : Integer := 0;
      Reponse_2 : Integer := 0;
   begin
      Open (File => Input,
         Mode => In_File,
            Name => fichier);
      -- Get Data
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
	 begin
	    if Timestamp = 0 then
	       Timestamp := Natural'Value(Line);
	    else
	       Get_In_Service_Buses(Line,Buses);
	    end if;
         end;
      end loop;
      Close(Input);

      Wait_Time := Timestamp;
      for B of Buses loop
	 
	 declare
	    t : Natural := 0;
	 begin
	    t := Timestamp / B;
	    t := t * B + B;
	    t := t - Timestamp;
	    if t < Wait_Time then
	       Wait_Time := t;
	       Bus_ID := B;
	    end if;
	 end;
      end loop;
      Reponse := Bus_ID * Wait_Time;
      Put_Line("Reponse (part1) : " & Reponse'Img & " / bus_id : " & Bus_ID'Img & " Wait_Time : " & Wait_Time'Img);
      Put_Line("Reponse (part2) : " & Reponse_2'Img);
   end Execute;


end Advent.Day13;
