function [W,b] = unpacknet(theta, layers, inputsize)

    % Unpack weights into network architecture
    ind = 1;
    no_layers = length(layers); 
    wsize = inputsize * layers(1).len;
    bsize = layers(1).len;
    W{1} = reshape(theta(ind:ind - 1 + wsize), [inputsize, layers(1).len]);   ind = ind + wsize;
    b{1} = reshape(theta(ind:ind - 1 + bsize), [1, layers(1).len]);           ind = ind + bsize;
    
    for i=1:no_layers-1
        wsize = layers(i).len * layers(i+1).len;
        bsize = layers(i+1).len;
        W{i+1} = reshape(theta(ind:ind - 1 + wsize), [layers(i).len, layers(i+1).len]);   ind = ind + wsize;
        b{i+1} = reshape(theta(ind:ind - 1 + bsize), [1, layers(i+1).len]);               ind = ind + bsize;
    end


