function [xs, is] = conjgrad(Afunc, b, x0, miniters, maxiters, theta, X, Y, params, Mdiag)

    % Conjugate gradient optimization
    % Afunc: function to compute B * x
    % x0: starting point
    % Mdiag: pre-conditioner

    if ~exist('Mdiag', 'var') || isempty(Mdiag)
        Mdiag = ones(length(b), 1);
    end

    % Initalizations
    is = zeros(maxiters, 1);
    xs = cell(maxiters, 1);
    vals = zeros(maxiters, 1);
    params.computeGV = 1;
    r = Afunc(theta, X, Y, params, x0, params.acts) - b;
    params.computeGV = 0;
    y = r ./ Mdiag;
    p = -y;
    x = x0;
    %val = 0.5 * ((-b + r)'*x);

    % Main loop
    for i = 1:maxiters

        % Compute Gauss-Newton vector product
        params.computeGV = 1;
        Ap = Afunc(theta, X, Y, params, p, params.acts);
        params.computeGV = 0;
        pAp = p' * Ap;

        % Sanity check for negative curvature
        if pAp < 0 
            disp('Negative curvature!');
            break;
        end

        % Updates
        alpha = (r' * y) ./ pAp;
        x = x + alpha * p;
        r_new = r + alpha * Ap;
        y_new = r_new ./ Mdiag;
        beta = (r_new' * y_new) ./ (r' * y);
        p = -y_new + beta * p;
        r = r_new;
        y = y_new; 
        val = 0.5 * ((-b + r)' * x);
        vals(i) = val;

        % Update solutions (x) and iterations (i)
        is(i) = i;
        xs{i} = x;

    end
    
    
