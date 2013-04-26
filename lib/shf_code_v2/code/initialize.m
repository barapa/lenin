function theta = initialize(params)

    inputsize = params.inputsize;
    layers = params.layers;
    initcoeff = 0.25;
    numconn = 5;

    no_layers = length(layers);
    if strcmp(layers(1).actfun, 'ReLU')
        shift = 0.1;
    else
        shift = 0;
    end
    b{1} = zeros(1, layers(1).len) + shift;

    %W{1} = zeros(inputsize, layers(1).len);
    %for j = 1:inputsize
    %    idx = ceil(layers(1).len * rand(1, numconn));
    %    W{1}(j, idx) = randn(numconn, 1);
    %end
    %W{1} = initcoeff * W{1};
    
    r  = sqrt(6) / sqrt(inputsize + layers(1).len + 1);
    W{1} = rand(inputsize, layers(1).len) * 2 * r - r;

    for i=2:no_layers

        if strcmp(layers(i).actfun, 'ReLU')
            shift = 0.1;
        else
            shift = 0;
        end

        b{i} = zeros(1, layers(i).len) + shift;

        %W{i} = zeros(layers(i-1).len, layers(i).len);
        %for j = 1:layers(i-1).len
        %    idx = ceil(layers(i).len * rand(1, numconn));
        %    W{i}(j, idx) = randn(numconn, 1);
        %end
        %W{i} = initcoeff * W{i};
        
        r  = sqrt(6) / sqrt(layers(i-1).len + layers(i).len + 1);
        W{i} = rand(layers(i-1).len, layers(i).len) * 2 * r - r;

    end

    % Pack it up, pack it in
    theta = packnet(W, b);



