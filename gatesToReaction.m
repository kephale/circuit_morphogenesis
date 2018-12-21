function rxn = gatesToReaction( g1, g2 )
% note these are actually reversed, g2 is g1 and vice versa

tt1 = gateToTruthTable( g1 );
tt2 = gateToTruthTable( g2 );

rxn = ones([1 4]);
for k = 1:4
    rxn(k) = 1 + tt2(k) + 2 * tt1(k);
end


