%% Making example figures

pkg load image;

%aggregate_reaction_classes([0 0],1,1); aggregate_reaction_classes([1 10],1,0); aggregate_reaction_classes([10 1],0,1); aggregate_reaction_classes([10 10],0,0);

seed = 17;

%reaction_lut = gatesToReaction( 'nor', 'nor' ); diff_r = [ 0 0 ];
%reaction_lut = gatesToReaction( 'xor', 'not1' ); diff_r = [ 1 10 ]; % Mixed long term dynamics

%reaction_lut = gatesToReaction( 'false', 'in1' ); diff_r = [ 8 0 ]; % Stationary finite wavelength
reaction_lut = gatesToReaction( 'not2', 'false' ); diff_r = [ 15 7 ]; % Oscillatory finite wavelength

%reaction_lut = gatesToReaction( 'and', '1imp2' ); diff_r = [ 1 10 ]; % Oscillatory finite wavelength (old)
%reaction_lut = gatesToReaction( '2imp1', 'xnor' ); diff_r = [ 1 10 ]; % Stationary finite wavelength (old)

%reaction_lut = gatesToReaction( 'false', 'not1' ); diff_r = [ 1 1 ]; % Stationary short wavelength (must enable checkerboard in RD function)
%reaction_lut = gatesToReaction( 'or', 'xor' ); diff_r = [ 1 1 ]; % Oscillatory short wavelength
%reaction_lut = gatesToReaction( 'nand', 'and' ); diff_r = [ 0 0 ]; % Stationary long wavelength
%reaction_lut = gatesToReaction( 'true', 'nand' ); diff_r = [ 10 0 ]; % Oscillatory long wavelength


%reaction_lut = gatesToReaction( 'nand', 'in1' ); diff_r = [ 1 1 ]; 

close all;
%reaction_lut = gatesToReaction( '1nimp2', 'in1' ); diff_r = [ 1 1 ]; % Mixed long term dynamics

%reaction_lut = gatesToReaction( 'xor', 'in1' ); diff_r = [ 1 10 ]; % Mixed long term dynamics
%reaction_lut = gatesToReaction( '1nimp2', 'in1' ); diff_r = [ 1 10 ]; % Mixed long term dynamics

% New
%reaction_lut = gatesToReaction( 'false', 'in1' ); diff_r = [ 1 10 ]; % Stationary finite wavelength
%reaction_lut = gatesToReaction( 'not2', 'false' ); diff_r = [ 10 1 ]; % Oscillatory finite wavelength

%reaction_lut = gatesToReaction( 'xor', 'not1' ); diff_r = [ 1 10 ]; % Mixed long term dynamics
%reaction_lut = gatesToReaction( 'or', 'not1' ); diff_r = [ 0 0 ]; % Stationary short wavelength
%reaction_lut = gatesToReaction( 'or', 'xor' ); diff_r = [ 1 1 ]; % Oscillatory short wavelength
%reaction_lut = gatesToReaction( 'nand', 'and' ); diff_r = [ 1 1 ]; % Stationary long wavelength
%reaction_lut = gatesToReaction( 'true', 'nand' ); diff_r = [ 10 10 ]; % Oscillatory long wavelength

%reaction_lut = gatesToReaction( 'in2', 'xor' ); diff_r = [ 1 1 ]; % Oscillatory short wavelength
%reaction_lut = gatesToReaction( '1nimp2', 'in1' ); diff_r = [ 1 10 ]; % Mixed long term dynamics

width = 500;
height = 500;
maxt = 100;
num_cells = width*height;
display = 0;
num_morphogens = 2;

react_string = num2str(reaction_lut);
react_string = react_string(react_string ~= ' ');

diff_string = [ num2str( diff_r(1) ) 'x' num2str( diff_r(2) ) ];
size_string = [ num2str( width ) 'x' num2str( height ) ];
        
basename = [ 'algmorph_react_' react_string '_diff_' diff_string '_seed_' num2str(seed) '_maxt_' num2str(maxt) '_size_' size_string ];
%filename = [ num2str(seed) '/' basename '.mat' ];

%plot_example( filename, basename );

result = circuit_morphogenesis( reaction_lut, diff_r, seed, maxt ,1,display,width,height,maxt );

fig = figure(1);
%set( fig, 'Color', 'white', 'Position', [0 0 1000 500] );
set( fig, 'Color', 'white', 'Position', [0 0 1000 175] );
clf;
%num_sps = 5;
num_sps = min( result.final_t + 1, 5 );
for st = 1:num_sps
    %subplot(3,num_sps,st);
    subplot(1,num_sps,st);
    x = result.all_states{( num_sps - st + 1 )};% will need to remove this + 1
    x_img = mod( ( x - 1 ), 2 );
    for m = 2:num_morphogens
        x_img = cat( 3, x_img, mod( floor( ( x - 1 ) / 2^(m-1) ), 2 ) );
    end
    if num_morphogens < 3
        for m = 1:( 3 - num_morphogens )
            x_img = cat( 3, x_img, zeros( size( x ) ) );
        end
    end
    imshow( x_img );
    imwrite( x_img(:,:,2), 'output_img.png' );
    %title( [ ' time = ' num2str( result.final_t - ( num_sps - st ) - 1) ] );
    title( [ ' time = ' num2str( result.final_t - ( num_sps - st ) ) ] );
end

fig2 = figure(2);
%set( fig, 'Color', 'white', 'Position', [0 0 1000 500] );
set( fig2, 'Color', 'white', 'Position', [0 0 1000 200] );
clf;

%subplot(2,1,1);
subplot(1,1,1);
%plot( result.state_history'./num_cells );
hold all;
for k = 1:size( result.state_history, 1 )    
    col = [ 0 0 0 ];
    if k == 1
        col = [ 0 0 0 ];
    elseif k == 2
        col = [ 1 0 0 ];
    elseif k == 3
        col = [ 0 1 0 ];
    elseif k == 4
        col = [ 0.6 0.6 0 ];
    end
    plot( result.state_history(k,1:result.final_t-1)'./num_cells, 'Color', col );
end
drawnow;

%subplot(2,1,2);
%plot( result.conc_history'./num_cells );
% hold all;
% for k = 1:2
%     col = [ 0 0 0 ];
%     if k == 1
%         col = [ 1 0 0 ];
%     elseif k == 2
%         col = [ 0 1 0 ];
%     end
%     plot( result.conc_history(k,1:result.final_t-1)'./num_cells, 'Color', col );
% end
% drawnow;

export_fig( fig2, [ basename '_conc.pdf' ] );
disp( [ 'Writing ' basename '_conc.pdf' ] );

export_fig( fig, [ basename '.pdf' ] );
disp( [ 'Writing ' basename '.pdf' ] );

