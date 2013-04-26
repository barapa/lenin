function theta = maxnorm(theta, params)

    % Maxnorm
    L = round(sqrt(params.inputsize));

    % Unpack theta
    [W, b] = unpacknet(theta, params.layers, params.inputsize);

    % Clip norms
    for i = 1:length(W)

        colw = sum(W{i}.^2, 1) + eps;
        NW = repmat(colw > L, size(W{i}, 1), 1);
        NW = bsxfun(@times, NW, sqrt(L) ./ sqrt(colw));
        NW(NW == 0) = 1;
        W{i} = W{i} .* NW;

        colb = sum(b{i}.^2) + eps;
        NB = repmat(colb > L, size(b{i}, 1), 1);
        NB = bsxfun(@times, NB, sqrt(L) ./ sqrt(colb));
        NB(NB == 0) = 1;
        b{i} = b{i} .* NB;

    end

    % Packnet
    theta = packnet(W, b);

