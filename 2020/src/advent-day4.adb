--------------------------------------------
-- Défi Calnedrier de l'Avent 2020
--   Advent Of Code Challenge 2020
--
-- https://adventofcode.com
--
-- Simon Beàn : https://github.com/smionean
--
-- Jour 4 / Day 4
--------------------------------------------

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Fixed;  use Ada.Strings.Fixed;
with Ada.Text_IO.Text_Streams;  use Ada.Text_IO.Text_Streams;
with Ada.Characters.Handling; use Ada.Characters.Handling;

package body Advent.Day4 is
   
--  byr (Birth Year)
--  iyr (Issue Year)
--  eyr (Expiration Year)
--  hgt (Height)
--  hcl (Hair Color)
--  ecl (Eye Color)
--  pid (Passport ID)
--  cid (Country ID)
   type passport_keys is (BYR, IYR, EYR, HGT, HCL, ECL, PID, CID);
   type passport_data is array (passport_keys) of boolean;
   type passport_data_position is array (passport_keys) of Natural;
   
   function Strip_String(aString :in  String) return String is
      Pos_Begin : Natural := 0;
      Pos_End : Natural := 0;
   begin      
      Pos_Begin := Index(aString, ":",aString'First)+1;
      Pos_End := Index(aString, " ",aString'First);
      if Pos_End = 0 then
         Pos_End := aString'Last;
      else
         Pos_End := Pos_End - 1;
      end if;
      return aString(Pos_Begin..Pos_End);
   end Strip_String;
   
      
   function BYR_Is_Valide (Value : in String) return Boolean is
      Birth_Year : Natural := 0;
      Temp : String := Strip_String(Value);
   begin
      Birth_Year := Natural'Value(Temp);
      return 1920 <= Birth_Year and Birth_Year <= 2002;
   end BYR_Is_Valide;

   function IYR_Is_Valide(Value : in String) return Boolean is
      Issue_Year : Natural := 0;
      Temp : String := Strip_String(Value);
   begin
      Issue_Year := Natural'Value(Temp);
      return 2010 <= Issue_Year and Issue_Year <= 2020;
   end IYR_Is_Valide;
   
   function EYR_Is_Valide(Value : in String) return Boolean is
      Expiration_Year : Natural := 0 ;
      Temp : String := Strip_String(Value);
   begin
      Expiration_Year := Natural'Value(Temp);
      return 2020 <= Expiration_Year and Expiration_Year <= 2030;
   end EYR_Is_Valide;
   
   function HGT_Is_Valide(Value : in String) return Boolean is
      Unit_Position : Natural := 0;
      Temp : String := Strip_String(Value);
      Height : Natural := 0;
   begin
      if Temp'Length < 3  then
         return False;
      end if;
      
      if Index (Temp, "cm", Temp'First) = 0 and Index (Temp, "in", Temp'First) = 0 then
         return False;
      end if;
      
      Height := Natural'Value(Temp(Temp'First..Temp'Last-2));
      Unit_Position := Index (Temp, "cm", Temp'First);
      if Unit_Position > 0 then
         return 150 <= Height and Height <= 193;
      end if;
      Unit_Position := Index (Temp, "in", Temp'First);
      if Unit_Position > 0 then
         return 59 <= Height and Height <= 76;
      end if;
      return False;
   end HGT_Is_Valide;
   
   function ECL_Is_Valide(Value : in String) return Boolean is
      Temp : String := Strip_String(Value);
   begin
      if Temp = "amb" 
        or Temp = "blu" 
        or Temp = "brn"
        or Temp = "gry"
        or Temp = "grn"
        or Temp = "hzl"
        or Temp = "oth"
      then
         return True;
      end if;   
      return False;
   end ECL_Is_Valide;
   
   function HCL_Is_Valide(Value : in String) return Boolean is
      Temp : String := Strip_String(Value);
   begin
      if Temp'Length > 7 or Temp(Temp'First) /= '#' then
         return False;
      end if;
      
      declare
         hair_color : String := Temp(Temp'First+1 .. Temp'Last);
      begin
         for c of hair_color loop
            if not Is_Hexadecimal_Digit(c) then
               return False;
            end if;
         end loop;
      end;
      return True;
   end HCL_Is_Valide;
   
   function PID_Is_Valide(Value : in String) return Boolean is
      Temp : String := Strip_String(Value);
   begin
      if Temp'Length /= 9 then
         return False;
      end if;
      for c of Temp loop
         if not Is_Decimal_Digit(c) then
            return False;
         end if;
      end loop;
      return True;
   end PID_Is_Valide;   
   
   function CID_Is_Valide(Value : in String) return Boolean is
   begin
      return True;
   end CID_Is_Valide;  
   
   function Validate_Passport_Data(Data : in passport_data) return Boolean is
   begin
      return Data(BYR) and Data(IYR) and Data(EYR) and Data(HGT)
        and Data(HCL) and Data(ECL) and Data(PID);
   end Validate_Passport_Data;
   
   procedure Execute(fichier : in String) is
      Input : File_Type;
      Data : passport_data := (others => False);
      Data2 : passport_data := (others => False);
      Data_Position : passport_data_position := (others => 0);
      Space_Position : Natural := 0;
      Nb_Valid_Passports : Integer := 0;
      Nb_Valid_Passports2 : Integer := 0;
   begin
      Open (File => Input,
            Mode => In_File,
            Name => fichier);
      
      --Get data
      
      While not  End_Of_File (Input) Loop
         declare
            Line : String := Get_Line (Input);
         begin
            if Line = "" then
               if Validate_Passport_Data(Data) then
                  Nb_Valid_Passports := Nb_Valid_Passports + 1;
               end if;
               if Validate_Passport_Data(Data2) then
                  Nb_Valid_Passports2 := Nb_Valid_Passports2 + 1;
               end if;
               Data := (others => False);
               Data2 := (others => False);
               Data_Position := (others => 0);
            else
               Data_Position(BYR) := Index (Line, "byr:", 1);
               Data_Position(IYR) := Index (Line, "iyr:", 1);
               Data_Position(EYR) := Index (Line, "eyr:", 1);
               Data_Position(HGT) := Index (Line, "hgt:", 1);
               Data_Position(HCL) := Index (Line, "hcl:", 1);
               Data_Position(ECL) := Index (Line, "ecl:", 1);
               Data_Position(PID) := Index (Line, "pid:", 1);
               Data_Position(CID) := Index (Line, "cid:", 1);
               if Data_Position(BYR) > 0 then
                  Data(BYR) := True;
                  if BYR_Is_Valide(Line(Data_Position(BYR)..Line'Last)) then
                     Data2(BYR) := True;
                  end if;
               end if;
 
               if Data_Position(IYR) > 0 then
                  Data(IYR) := True;
                  if IYR_Is_Valide(Line(Data_Position(IYR)..Line'Last)) then
                     Data2(IYR) := True;
                  end if;
               end if;
               
               if Data_Position(EYR) > 0 then
                  Data(EYR) := True;
                  if EYR_Is_Valide(Line(Data_Position(EYR)..Line'Last)) then
                     Data2(EYR) := True;
                  end if;
               end if;
               
               if Data_Position(HGT) > 0 then
                  Data(HGT) := True;
                  if HGT_Is_Valide(Line(Data_Position(HGT)..Line'Last)) then
                     Data2(HGT) := True;
                  end if;
               end if;
               
               if Data_Position(HCL) > 0 then
                  Data(HCL) := True;
                  if HCL_Is_Valide(Line(Data_Position(HCL)..Line'Last)) then
                     Data2(HCL) := True;
                  end if;
               end if;               
               
               if Data_Position(ECL) > 0 then
                  Data(ECL) := True;
                  if ECL_Is_Valide(Line(Data_Position(ECL)..Line'Last)) then
                     Data2(ECL) := True;
                  end if;
               end if;

               if Data_Position(PID) > 0 then
                  Data(PID) := True;
                  if PID_Is_Valide(Line(Data_Position(PID)..Line'Last)) then
                     Data2(PID) := True;
                  end if;
               end if;
               
               if Data_Position(CID) > 0 then
                  Data2(CID) := True;
               end if;
               
            end if;
         end;
      end loop;
      if Validate_Passport_Data(Data) then
         Nb_Valid_Passports := Nb_Valid_Passports + 1;
      end if;
      Put_Line("Reponse (part1) : " & Nb_Valid_Passports'Img);
      if Validate_Passport_Data(Data2) then
         Nb_Valid_Passports2 := Nb_Valid_Passports2 + 1;
      end if;
      Put_Line("Reponse (part2) : " & Nb_Valid_Passports2'Img);
      Close(Input);
      
      
      --Put_Line("Reponse (part2) : " & Reponse_2'Img);
      
   end Execute;

end Advent.Day4;
