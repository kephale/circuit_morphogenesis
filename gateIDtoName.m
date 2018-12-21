function [n] = gateIDtoName( i )


if isstr( i )
    n = i;
elseif i == 0
    n = 'false';
elseif i == 1
    n = 'true';
elseif i == 2
    n = 'and';
elseif i == 3
    n = 'or';
elseif i == 4
    n = 'nand';
elseif i == 5
    n = 'nor';
elseif i == 6
    n = 'xor';
elseif i == 7
    n = 'xnor';    
elseif i == 8
    n = 'in1';
elseif i == 9
    n = 'not1';
elseif i == 10
    n = 'in2';
elseif i == 11
    n = 'not2';
elseif i == 12
    n = '1imp2';
elseif i == 13
    n = '2imp1';
elseif i == 14
    n = '1nimp2';
elseif i == 15
    n = '2nimp1';
end
    
    
    
    