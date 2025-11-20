% Break-even point calculation using recursive methods
% Problem: Revenue = Cost → 25Q = 1000 + 15Q → 10Q - 1000 = 0
% The break-even point is where total revenue equals total costs
clear
clc
% Parameters
price = 25;           % Selling price per unit
fixed_cost = 1000;    % Fixed costs that don't change with production volume
variable_cost = 15;   % Cost per unit that varies with production

% Define the function f(Q) = Revenue - Cost
% We want to find Q where f(Q) = 0 (break-even point)
f = @(Q) price*Q - (fixed_cost + variable_cost*Q);

% Analytical solution for verification
% Break-even formula: Q = Fixed Cost / (Price - Variable Cost)
analytical_solution = fixed_cost / (price - variable_cost);
fprintf('Analytical solution: Q = %.2f units\n\n', analytical_solution);

% Newton-Raphson method - uses function and its derivative
df = @(Q) price - variable_cost;  % Derivative is constant (10 in this case)
newton_result = newton_raphson(f, df, 50, 1e-6, 100);

% Secant method - doesn't require derivative, uses two initial points
secant_result = secant_method(f, 50, 150, 1e-6, 100);


% Newton-Raphson method for root finding
% Uses tangent lines to converge to the root quickly
function root = newton_raphson(f, df, x0, tol, max_iter, iter)
    % Handle optional iteration parameter for recursion
    if nargin == 5
        iter = 1;  % Initialize iteration counter on first call
    end
    
    % Safety check: stop if maximum iterations reached
    if iter >= max_iter
        root = x0;
        return;
    end
    
    % Newton-Raphson formula: x_new = x_old - f(x_old)/f'(x_old)
    x_new = x0 - f(x0) / df(x0);
    
    % Check convergence: if change is smaller than tolerance, we're done
    if abs(x_new - x0) < tol
        root = x_new;
        fprintf('Newton-Raphson: Q = %.2f units (%d iterations)\n', root, iter);
        return;
    end
    
    % Recursive call with updated guess
    root = newton_raphson(f, df, x_new, tol, max_iter, iter + 1);
end

% Secant method for root finding
% Uses secant lines (between two points) to approximate the root
function root = secant_method(f, x0, x1, tol, max_iter, iter)
    % Handle optional iteration parameter for recursion
    if nargin == 5
        iter = 1;  % Initialize iteration counter on first call
    end
    
    % Safety check: stop if maximum iterations reached
    if iter >= max_iter
        root = x1;
        return;
    end
    
    % Avoid division by zero
    if f(x1) == f(x0)
        root = x1;
        return;
    end
    
    % Secant method formula: 
    % x_new = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0))
    x_new = x1 - f(x1) * (x1 - x0) / (f(x1) - f(x0));
    
    % Check convergence: if change is smaller than tolerance, we're done
    if abs(x_new - x1) < tol
        root = x_new;
        fprintf('Secant method: Q = %.2f units (%d iterations)\n', root, iter);
        return;
    end
    
    % Recursive call with updated points (shift window forward)
    root = secant_method(f, x1, x_new, tol, max_iter, iter + 1);
end