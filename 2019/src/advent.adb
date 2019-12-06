

package body advent is

   procedure Split (Chaine : in String;
                    Jeton : in String;
                    Vecteur : out Type_Vecteur_Natural.Vector) is
      Position : Natural := 0;                
   begin
      Position := Chaine'First;
      for i in Chaine'Range loop
         if Chaine(i) = ',' or i = Chaine'Last then
            Vecteur.Append(Natural'Value(ChaineePosition..i-1)));
            Position := i + 1;
         end if;
               
      end loop;        
   end Split;
            
   procedure Split (Chaine : in String;
                    Jeton : in String;
                    Vecteur : out Type_Vecteur_String.Vector) is
      Position : Natural := 0;
   begin
      Position := Chaine'First;
      for i in Cahine'Range loop
         if Chaine(i) = Jeton or i = Chaine'Last then
            Vecteur.Append(Chaine(Position..i-1));
            Position := i + 1;
          end if;
       end loop;        
   end Split;                   
 


   procedure init is
   begin
      null;
   end init;

end advent;
