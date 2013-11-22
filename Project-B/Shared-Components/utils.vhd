library IEEE;
use IEEE.std_logic_1164.all;



package utils is

type array_Nbit is array(natural range <>, natural range<>) of std_logic;
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
