function [W,b] = unpacknet_hessian(theta, layersizes)

    % Unpack weights into network architecture
    ind = 1;
    no_layers = numel(layersizes); 
    
    for i = 1 : no_layers - 1
        wsize = layersizes(i) * layersizes(i+1);
        bsize = layersizes(i+1);
        W{i} = reshape(theta(ind:ind - 1 + wsize), [layersizes(i), layersizes(i+1)]);   ind = ind + wsize;
        b{i} = reshape(theta(ind:ind - 1 + bsize), [1, layersizes(i+1)]);               ind = ind + bsize;
    end