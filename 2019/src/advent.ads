with Ada.Containers.Vectors;


package Advent is
   package Type_Vecteur_Natural is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                           Element_Type => Natural);
  
   package Type_Vecteur_String is new Ada.Containers.Vectors(Index_Type   => Natural,              
                                                              Element_Type => String);
                                                              
   procedure Split (Chaine : in String;
                    Jeton : in String;
                    Vecteur : out Type_Vecteur_Natural.Vector); 
   procedure Split (Chaine : in String;
                    Jeton : in String;
                    Vecteur : out Type_Vecteur_String.Vector); 
                  
                     
   procedure init;

end Advent;
