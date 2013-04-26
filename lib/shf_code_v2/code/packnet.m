function theta = packnet(W, b)

    % Pack all the network weights into a single vector
    no_layers = length(W);
    theta = [];
    for i = 1:no_layers
        theta = [theta; W{i}(:); b{i}(:)];
    end


