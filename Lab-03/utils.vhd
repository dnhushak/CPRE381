library IEEE;
use IEEE.std_logic_1164.all;



package utils is

type array32_bit is array(natural range <>) of std_logic_vector(31 downto 0);
function to_std_logic(L: BOOLEAN) return std_ulogic;

end utils;



package body utils is

function to_std_logic(L: BOOLEAN) return std_ulogic is
    begin
        if L then
            return('1');
        else
            return('0');
        end if;
end function to_std_logic; 

end utils;
