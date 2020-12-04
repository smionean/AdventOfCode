with Ada.Containers.Vectors;
package Parallel_Analyse is
   --type Data_Array is array(Integer range <>) of Integer;
   --type Data_Access is access all Data_Array;

   subtype Line_Map is  String(1..31);
   package type_vector_data is new Ada.Containers.Vectors(Index_Type   => Natural,
                                                         Element_Type => Line_Map);

   function Calculate_Possibility ( Map : in type_vector_data.Vector )  return Long_Long_Integer;
end Parallel_Analyse;
