function [W,b] = unpacknet_hessian(theta, layersizes)

    num_layers = numel(layersizes) - 1; 
    W = cell(num_layers, 1);
    b = cell(num_layers, 1);

    cur = 0;
    for i = 1:num_layers
        W{i} = reshape( theta((cur+1):(cur + layersizes(i)*layersizes(i+1)), 1), [layersizes(i+1) layersizes(i)] );
        cur = cur + layersizes(i)*layersizes(i+1);
        b{i} = reshape( theta((cur+1):(cur + layersizes(i+1)), 1), [layersizes(i+1) 1] );
        cur = cur + layersizes(i+1);
    end
end
