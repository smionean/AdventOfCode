package body Parallel_Analyse is

   function Calculate_Possibility ( Map : in type_vector_data.Vector )  return Long_Long_Integer is
      task type Analyse_Path is
         entry Set (Horizontal_Move : Natural; Vertical_Move : Natural);
         entry Report (Value : out Natural);
      end Analyse_Path;

      task body Analyse_Path is
         Total : Natural := 0;
         Horizontal_Position : Natural := 0;
         Vertical_Position : Natural := Map.First_Index;
         Horizontal_Move_Tmp : Natural;
         Vertical_Move_Tmp : Natural;
      begin
         accept Set(Horizontal_Move : Natural; Vertical_Move : Natural) do
            Horizontal_Move_Tmp := Horizontal_Move;
            Vertical_Move_Tmp := Vertical_Move;
         end Set;

--           for I in First..Last loop
--              Total := Total + Item(I);
--           end loop;


         while Vertical_Position <= Map.Last_Index loop
            declare
               Altitude : Line_Map :=  Map.Element(Vertical_Position);
               Adjusted_Horizontal_Position : Natural := Horizontal_Position mod Altitude'Length + 1;
            begin
               if Altitude(Adjusted_Horizontal_Position) = '#' then
                  Total := Total + 1;
               end if;
               --
               Horizontal_Position := Horizontal_Position + Horizontal_Move_Tmp;
               Vertical_Position := Vertical_Position + Vertical_Move_Tmp;
            end;
         end loop;

         accept Report (Value : out Natural) do
            Value := Total;
         end Report;

      end Analyse_Path;

      P1 : Analyse_Path;
      P2 : Analyse_Path;
      P3 : Analyse_Path;
      P4 : Analyse_Path;
      P5 : Analyse_Path;

      R1 : Natural;
      R2 : Natural;
      R3 : Natural;
      R4 : Natural;
      R5 : Natural;
   begin

      P1.Set(Horizontal_Move => 1 , Vertical_Move => 1 );
      P2.Set(Horizontal_Move => 3 , Vertical_Move => 1 );
      P3.Set(Horizontal_Move => 5 , Vertical_Move => 1 );
      P4.Set(Horizontal_Move => 7 , Vertical_Move => 1 );
      P5.Set(Horizontal_Move => 1 , Vertical_Move => 2 );

      P1.Report(R1);
      P2.Report(R2);
      P3.Report(R3);
      P4.Report(R4);
      P5.Report(R5);

      return Long_Long_Integer(R1) * Long_Long_Integer(R2) * Long_Long_Integer(R3) * Long_Long_Integer(R4) * Long_Long_Integer(R5);
   end Calculate_Possibility;


end Parallel_Analyse;
