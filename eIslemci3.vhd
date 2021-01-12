-- Islemci tasarimi
-- Hazirlayan Guzin Kanburoglu 365254

library ieee;
use ieee.std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity eIslemci3 is
generic(n:natural:=8);
port( s, r,secme : in std_logic; --Reset
        kmt: in std_logic_vector(2*n-1 downto 0) -- 16 bit giris secme    
);
end entity;

Architecture struct of eIslemci3 is

TYPE tMEM IS ARRAY(0 TO 63) OF std_logic_vector(n-1 DOWNTO 0);
SIGNAL Ram : tMEM;  -- RAM

TYPE tREG IS ARRAY(0 TO 15) OF std_logic_vector(n-1 DOWNTO 0);
SIGNAL Reg : tREG;

TYPE tROM IS ARRAY(0 to 31)of std_logic_vector(n-1 DOWNTO 0);           
  
  --rom bellek
  Constant ROMbellek: tROM := (
  0 => "01100101",
  1 => "10010001",
  2 => "10100010",
  3 => "01100100",
  4 => "01100100",
  5 => "10100101",
  6 => "00000110",
  7 => "00000111",
  8 => "00100000",
  9 => "00001001",
  10 => "01001010",
  11 => "01001011",
  12 => "00001010",
  13 => "01101101",
  14 => "00010101",
  15 => "01011000",
  16 => "01100000",
  17 => "00000011",
  18 => "01111110",
  19 => "00001010",
  20 => "01100101",
  21 => "00010101",
  22 => "00010101",
  23 => "01101110",
  24 => "00101010",
  25 => "01000100",
  26 => "00111100",
  27 => "10101010",
  28 => "00000000",
  29 => "11001010",
  30 => "00000101",
  31 => "11001010");
  
  Begin -- mimari

Komut:
process(s, r)
Begin
     If( Rising_edge(s) ) then
     if(r='1')then
     if(secme='1')then
      Ram(to_integer(unsigned(Kmt(7 downto 0)))) <= "ZZZZZZZZ";   
    else
      Reg(to_integer(unsigned(Kmt(11 downto 8)))) <="ZZZZZZZZ";
    end if;
  end if;
  
    else
     Case Kmt(15 downto 12) is -- en anlamli 4 bit
	When "0000" =>
	    null;   -- islem yok... 

	When "0001" =>  
		Reg(to_integer(unsigned(Kmt(11 downto 8)))) <= Kmt(7 downto 0);  

	When "0010" =>  
		Reg(to_integer(unsigned(Kmt(11 downto 8))))  <= 
		Reg(to_integer(unsigned(Kmt(7 downto 4))));

	When "0011" =>                                                                                                               
	  Ram( to_integer(unsigned(Kmt(7 downto 0))) ) <= 
			Reg(to_integer(unsigned(Kmt(11 downto 8))));
			
	When "0100" =>                                                 
	  Reg(to_integer(unsigned(Kmt(11 downto 8))))  <= 
		Ram(  to_integer(unsigned(Kmt(7 downto 0)) ))  ;
			
	When "0101" =>
	Reg(to_integer(unsigned(Kmt(11 downto 8))))  <= 
			Ram(to_integer(unsigned( Reg( to_integer(unsigned(Kmt(7 downto 0)))  ))))  ;
			
  When "0110" =>  
 	 		Reg(to_integer(unsigned(Kmt(11 downto 8)))) <= Rombellek(to_integer(unsigned(Kmt(7 downto 0))));
   
 	When "0111" =>  
           Reg( to_integer(unsigned(Kmt(11 downto 8))) )   <= 
				std_logic_vector( 
					unsigned(Reg( to_integer(unsigned(Kmt(11 downto 8)))))
					 + unsigned(Kmt (7 downto 0)));
	
 	When "1000" =>  
           Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= 
			std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4)))))   
			+ unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  );
			
	When "1001" =>                                              
			  Reg( to_integer(unsigned(Kmt(11 downto 8))) )   <= 
				std_logic_vector( 
					unsigned(Reg( to_integer(unsigned(Kmt(11 downto 8)))))
					 - unsigned(Kmt (7 downto 0)));
					 
	When "1010" =>                                                                                                               
			  Reg( to_integer(unsigned(Kmt(11 downto 8)) ))   <= 
 			std_logic_vector( unsigned(Reg( to_integer(unsigned(Kmt(7 downto 4)))))   
			/ unsigned(Reg( to_integer(unsigned(Kmt(3 downto 0)))))  );
			
 When "1011" => 
       Reg(to_integer(unsigned(Kmt(11 downto 8))))   <= 
				std_logic_vector( 
				  unsigned(Reg( to_integer(unsigned(Kmt(11 downto 8)))))
					  * unsigned(ROMbellek(to_integer(unsigned(Kmt(7 downto 0))))));
					  
	When "1100" => 
			  	   Ram( to_integer(unsigned(Kmt(7 downto 0)) ))   <= 
			std_logic_vector( unsigned(Ram( to_integer(unsigned(Kmt(7 downto 0)))))   
			and unsigned(Reg( to_integer(unsigned(Kmt(11 downto 8)))))  );
					 
	When "1101" =>
	    Reg(to_integer(unsigned(Kmt(11 downto 8))) )   <= 
				std_logic_vector( 
					unsigned(Reg( to_integer(unsigned(Kmt(11 downto 8)))))
					 or unsigned(Kmt (7 downto 0)));
			
 When "1110" =>
      Reg(to_integer(unsigned(Kmt(11 downto 8)))) <= 
			 std_logic_vector(unsigned(Reg(to_integer(unsigned(Kmt(7 downto 4))))) xor
			unsigned(Reg(to_integer(unsigned(Kmt (3 downto 0))))));
				 
When "1111" =>
   Reg(to_integer(unsigned(Kmt(11 downto 8)))) <= 
			 std_logic_vector(unsigned(Reg(to_integer(unsigned(Kmt(7 downto 4))))) xnor
			unsigned(Reg(to_integer(unsigned(Kmt (3 downto 0))))));
			
When others => 
	    null;
	    end case;  
   end if;
end Process;
end struct;
    

