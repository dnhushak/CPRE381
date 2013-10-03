package utils is

function to_std_logic(L: BOOLEAN) return std_logic is
    begin
        if L then
            return('1');
        else
            return('0');
        end if;
end function To_Std_Logic; 

end utils
