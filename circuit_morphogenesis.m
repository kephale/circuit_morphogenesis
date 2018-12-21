function result = circuit_morphogenesis(reaction_lut, diff_r, random_seed, max_t,cycle_detection,display,width,height,cycle_memory)
% 
% Harrington, K.. A circuit basis for morphogenesis (2015). Theoretical Computer Science.
% doi:10.1016/j.tcs.2015.07.002
%

    addpath( 'convolve2' );

    if nargin < 5
        cycle_detection = 1;
    end
    if nargin < 6
        display = 1;
    end
    if nargin < 7
        width = 50; 
    end
    if nargin < 8
        height = 50;
    end
    if nargin < 9
        cycle_memory = max_t;
    end

    if diff_r(1) == 0
        diff_kernel1 = [1];
    else
        diff_kernel1 = double( getnhood( strel( 'diamond', diff_r(1) ...
                                                ) ) );
        diff_kernel1 = diff_kernel1 ./ sum( diff_kernel1(:) );
    end    
    if diff_r(2) == 0
        diff_kernel2 = [1];
    else
        diff_kernel2 = double( getnhood( strel( 'diamond', diff_r(2) ...
                                                ) ) );
        diff_kernel2 = diff_kernel2 ./ sum( diff_kernel2(:) );
    end
    

    num_cells = width * height;

    num_morphogens = log2(numel(reaction_lut));
    max_morphstates = 2 ^ num_morphogens;% max number at any cell
    

    rng( random_seed );

    %cycle_memory = 24;
    cycle_counts = [];

    state_history = zeros( max_morphstates, max_t + 1 );
    conc_history = zeros( num_morphogens+1, max_t + 1 );

    running = 1;
    t = 1;

    initial_state = randi(max_morphstates, [height, width]);

    % Partial checkerboard
    %initial_state = 1 + ( invhilb(width) > 0 ) + 2 * ( randi( 2, [ height, width ] ) - 1 );
    %initial_state = 1 + ( randi( 2, [ height, width ] ) - 1 ) + 2 * ( invhilb(width) > 0 );

    x = squeeze( initial_state );
    state_history(:,t) = hist( x(:), 4 )';

    c =  mod( ( x - 1 ), 2 ) > 0;
    conc_history(1,t) = sum( c(:) );
    for m = 2:num_morphogens
        c =  mod( floor( ( x - 1 ) / 2^(m-1) ), 2 ) > 0;
        conc_history(m,t) = sum( c(:) );            
    end
    conc_history(num_morphogens+1,t) = sum( conc_history(1:num_morphogens,t) ) / num_morphogens;

    prev_states = {};
    all_states = {};
    i = 1;% this should have been looped over

    cum_states = zeros( [ height width num_morphogens ] );
    
    while running && t <= max_t

        %x = squeeze(current_states(i, :, :));                
        %prev_states = hists{i};                

        % Update for reaction
        r = reaction_lut( x );

        m = 1;
        morph1 = ( mod( floor( ( r - 1 ) ./ 2.^(m-1) ), 2) );
        m = 2;
        morph2 = ( mod( floor( ( r - 1 ) ./ 2.^(m-1) ), 2) );

        % Periodic only
        morph1 = convolve2( morph1, diff_kernel1, 'circular' ) > 0.5;
        morph2 = convolve2( morph2, diff_kernel2, 'circular' ) > 0.5;

        % Save cumulative state info
        cum_states(:,:,1) = cum_states(:,:,1) + morph1;
        cum_states(:,:,2) = cum_states(:,:,2) + morph2;
        
        next_x = 1 + morph1 + 2 * morph2;

        if num_morphogens == 1
            figure(1);
            subplot(4,3,10);            
            imshow( x, [] );
            subplot(4,3,11);
            imshow( r, [] );
            subplot(4,3,12);
            imshow( next_x, [] );
        else
            x_img = mod( ( x - 1 ), 2 );
            r_img = mod( ( r - 1 ), 2 );
            next_x_img = mod( ( next_x - 1 ), 2 );
            for m = 2:num_morphogens
                x_img = cat( 3, x_img, mod( floor( ( x - 1 ) / 2^(m-1) ), 2 ) );
                r_img = cat( 3, r_img, mod( floor( ( r - 1 ) / 2^(m-1) ), 2 ) );
                next_x_img = cat( 3, next_x_img, mod( floor( ( next_x - 1 ) / 2^(m-1) ), 2 ) );
            end
            if num_morphogens < 3
                for m = 1:( 3 - num_morphogens )
                    x_img = cat( 3, x_img, zeros( size( x ) ) );
                    r_img = cat( 3, r_img, zeros( size( r ) ) );
                    next_x_img = cat( 3, next_x_img, zeros( size( next_x ) ) );
                end
            end

            if display == 1
                % Should do a greycode transform for the heatmap,
                % u=1,v=0 -> u=1,v=1 -> u=0,v=1
                sp_rows = 5;
                figure(1);
                clf;

                subplot(sp_rows,3,7);                                
                imshow( x_img, [] );

                subplot(sp_rows,3,8);
                imshow( r_img, [] );

                figure(1);
                subplot(sp_rows,1,1);
                [rcoords,F1D] = polarFourier1DProjection( mod( ( next_x - 1 ), 2 ) ); 
                F1D(isnan( F1D )) = 0;
                plot(rcoords,F1D); title('project1D(polar(fourier(m1)))'); %xlim([0 0.5]);
                ylim( [0 0.6] );

                for m = 2:num_morphogens
                    subplot(sp_rows,1,m);
                    [rcoords,F1D] = polarFourier1DProjection( mod( floor( ( next_x - 1 ) ./ 2.^(m-1) ), 2 ) );
                    F1D(isnan( F1D )) = 0;
                    plot(rcoords,F1D); title('project1D(polar(fourier(m+)))'); %xlim([0 0.5]);
                    ylim( [0 0.6] );
                end

                subplot(sp_rows,1,num_morphogens+2);
                plot( state_history'./num_cells );

                subplot(sp_rows,1,num_morphogens+3);
                plot( conc_history'./num_cells );
                drawnow;
            end
        end

        if numel( prev_states ) < cycle_memory 
            prev_states = [ x prev_states ];
        else
            prev_states = [ x prev_states(1:(end - 1)) ];
        end
        all_states = [ x all_states ];

        break_early = 0;
        for k = 1:numel( prev_states )
            if all( next_x(:) == prev_states{k}(:) )% && ( break_early > 0 )
                cycle_counts(i) = k;

                break_early = k;

                break;
            end
        end

        if break_early > 0
            disp( [ 'Cycle of length ' num2str( break_early ) ' at time ' num2str(t)] );
        end

        if break_early > 0 && cycle_detection
            running = 0;
            all_states = [ next_x all_states ];
        else
            x = next_x;
            t = t + 1;
        end
        state_history(:,t) = hist( x(:), 4 )';

        c =  mod( ( x - 1 ), 2 ) > 0;
        conc_history(1,t) = sum( c(:) );
        for m = 2:num_morphogens
            c =  mod( floor( ( x - 1 ) / 2^(m-1) ), 2 ) > 0;
            conc_history(m,t) = sum( c(:) );            
        end
        conc_history(num_morphogens+1,t) = sum( conc_history(1:num_morphogens,t) ) / num_morphogens;

        % Record history of 1D P-F projections of states
        % Record history of sum of each state
    
        %save_data = struct('h_slice', horizontal_slice, 'd_slice', diagonal_slice, 'diffs', diffs, 'cycles', cycle_counts);
        save_data = struct( 'cycles', cycle_counts, ...
                            'final_state_history', state_history(:,end), ...
                            'final_conc_history', conc_history(:,end), ...
                            'diff_r', diff_r, ...
                            'reaction_lut', reaction_lut, ...
                            'seed', random_seed, ...
                            'max_t', max_t, ...
                            'final_t', t, ...
                            'x', x, ...
                            'width', width, ...
                            'height', height, ...
                            'cum_states', cum_states );
        react_string = num2str(reaction_lut);
        react_string = react_string(react_string ~= ' ');
        if ~exist(num2str(random_seed), 'dir')
            mkdir(num2str(random_seed))
        end
        %diff_string = num2str( diff_r );
        %diff_string = diff_string(diff_string ~= ' ');
        diff_string = [ num2str( diff_r(1) ) 'x' num2str( diff_r(2) ) ];
        size_string = [ num2str( width ) 'x' num2str( height ) ];
        filename = strcat(num2str(random_seed), '/algmorph_react_', react_string, '_diff_', diff_string, '_seed_', num2str(random_seed), '_maxt_', num2str(max_t), '_size_', size_string, '.mat');
        %save(filename, 'save_data');
        
        result = save_data;
        result.state_history = state_history;
        result.conc_history = conc_history;
        result.all_states = all_states;
        
    end
end
