function [W,b] = unpacknet_hessian(theta, layersizes)

    % Unpack weights into network architecture
    ind = 1;
    no_layers = length(layersizes); 
    
    for i=1:no_layers
        wsize = layers(i).len * layers(i+1).len;
        bsize = layers(i+1).len;
        W{i+1} = reshape(theta(ind:ind - 1 + wsize), [layers(i).len, layers(i+1).len]);   ind = ind + wsize;
        b{i+1} = reshape(theta(ind:ind - 1 + bsize), [1, layers(i+1).len]);               ind = ind + bsize;
    end


