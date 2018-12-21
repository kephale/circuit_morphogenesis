function [truth_table] = gateToTruthTable( i, n )

if nargin < 2
    n = gateIDtoName( i );
end

if strcmp( n, 'false' )
    truth_table = [ 0 0 0 0 ];    
elseif strcmp( n, 'true' )
    truth_table = [ 1 1 1 1 ];    
elseif strcmp( n, 'and' )
    truth_table = [ 0 0 0 1 ];    
elseif strcmp( n, 'or' )
    truth_table = [ 0 1 1 1 ];
elseif strcmp( n, 'nand' )
    truth_table = [ 1 1 1 0 ];
elseif strcmp( n, 'nor' )
    truth_table = [ 1 0 0 0 ];    
elseif strcmp( n, 'xor' )
    truth_table = [ 0 1 1 0 ];
elseif strcmp( n, 'xnor')
    truth_table = [ 1 0 0 1 ];
elseif strcmp( n, 'in1' )
    truth_table = [ 0 1 0 1 ];
elseif strcmp( n, 'not1' )
    truth_table = [ 1 0 1 0 ];
elseif strcmp( n, 'in2' )
    truth_table = [ 0 0 1 1 ];
elseif strcmp( n, 'not2' )
    truth_table = [ 1 1 0 0 ];
elseif strcmp( n, '1imp2' )
    truth_table = [ 1 0 1 1 ];
elseif strcmp( n, '2imp1' )
    truth_table = [ 1 1 0 1 ];
elseif strcmp( n, '1nimp2' )
    truth_table = [ 0 1 0 0 ];
elseif strcmp( n, '2nimp1' )
    truth_table = [ 0 0 1 0 ];
end
    
    
    
    