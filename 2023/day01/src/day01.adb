--+-------------------------------------------------------------------------+-- 
--|                                                                         |--
--|                                                                         |--
--|                          github.com/smionean                            |--
--|                                                                         |--
--|                                                                         |--
--+-------------------------------------------------------------------------+--
--|   * Project name : Advent of Code 2023: 01
--|   * Name : Simon Be�n
--|   * Date : Fri 01 Dec 2023 04:46:26 PM EST
--|   
--|   * Filename : day01.adb
--|
--|   * Description (fr) : D�fi Calnedrier de l'Avent 2023
--|                        Jour 01
--|
--|                 (en) : Advent Of Code Challenge 2023
--|                        Day 01
--|
--|   #AdaAdventOfCode23
--|
--+-------------------------------------------------------------------------+--
--|   * Changelog * 
--|
--|
--+-------------------------------------------------------------------------+--

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Containers.Vectors;

procedure Day01 is

   function Find_Calibration (Line : in String) return Integer is
      Calibration : String(1..2) := "00";
   begin
      for I in Line'First..Line'Last loop
         if Line(I) in '0' .. '9' then
            Calibration(1) := Line(I);
            exit;
         end if;               
      end loop;
      for I in reverse Line'First..Line'Last loop
         if Line(I) in '0' .. '9' then
            Calibration(2) := Line(I);
            exit;
         end if;  
      end loop;
      return Integer'Value(Calibration);
   end Find_Calibration;


   procedure Execute(fichier : in String) is
      Input : File_Type;
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
            Line_2 : String := Line;
            Calibration_1 : String(1..2) := "00";
            Calibration_2 : String(1..2) := "00";
         begin
            Reponse := Reponse + Find_Calibration (Line);
            
            --second part
            for I in Line'First..Line'Last loop
              case Line(I) is
               when 'O'|'o' => 
                  if I+2 <= Line'Last and then Line(I..I+2) = "one" then
                     Line_2(I..I+2):="111";
                  end if;
               when 'T'|'t' => 
                  if I+2 <= Line'Last and then Line(I..I+2) = "two" then
                     Line_2(I..I+2):="222";
                  end if;
                  if I+4 <= Line'Last and then Line(I..I+4) = "three" then
                     Line_2(I..I+4):="33333";
                  end if;                  
               when 'F'|'f' =>
                  if I+3 <= Line'Last and then Line(I..I+3) = "four" then
                     Line_2(I..I+3):="4444";
                  end if;
                  if I+3 <= Line'Last and then Line(I..I+3) = "five" then
                     Line_2(I..I+3):="5555";
                  end if;                
               when 'S'|'s' => 
                  if I+2 <= Line'Last and then Line(I..I+2) = "six" then
                     Line_2(I..I+2):="666";
                  end if;
                  if I+4 <= Line'Last and then Line(I..I+4) = "seven" then
                     Line_2(I..I+4):="77777";
                  end if;
               when 'E'|'e' =>
                  if I+4 <= Line'Last and then Line(I..I+4) = "eight" then
                     Line_2(I..I+4):="88888";
                  end if;                
               when 'N'|'n' =>
                  if I+3 <= Line'Last and then Line(I..I+3) = "nine" then
                     Line_2(I..I+3):="9999";
                  end if;
               when others => null;
              end case;

            end loop;
            Reponse_2 := Reponse_2 + Find_Calibration (Line_2);
         end;
      end loop;
      Close(Input);

            
      Put_Line("Results (part1) : " & Reponse'Img);
      Put_Line("Results (part2) : " & Reponse_2'Img);
   end Execute;

begin
   Put_Line("TEST");
   Execute("data/test.txt");
   Execute("data/test2.txt");

   New_Line;
   Put_Line("CHALLENGE DAY 01");
   Execute("data/data.txt");
end Day01;
