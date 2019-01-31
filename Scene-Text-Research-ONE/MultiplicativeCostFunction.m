function [J, grad] = MultiplicativeCostFunction(theta, X_pos, X_neg,lambda,multiplier)
%COSTFUNCTION Compute cost and gradient for logistic regression
%   J = COSTFUNCTION(theta, X, y) computes the cost of using theta as the
%   parameter for logistic regression and the gradient of the cost
%   w.r.t. to the parameters.



% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost of a particular choice of theta.
%               You should set J to the cost.
%               Compute the partial derivatives and set grad to the partial
%               derivatives of the cost w.r.t. each parameter in theta
%
% Note: grad should have the same dimensions as theta
%

pos_h = sigmoid(transpose(theta)*X_pos)';
pos_m = size(X_pos,2);
neg_h = sigmoid(transpose(theta)*X_neg)';
neg_m = size(X_neg,2);

J  = -2*multiplier*(sum(log(pos_h)));


J  =J + (-2)*(sum(log(1-neg_h)));

J = J + (lambda*(transpose(theta(2:end))*theta(2:end)));


grad = 2*multiplier*(X_pos*(pos_h-1));

grad = grad + 2*(X_neg*(neg_h));

grad(2:end) = grad(2:end) +  2*lambda*theta(2:end);



J = J/(2*(multiplier*pos_m) + 2*neg_m);

grad = grad./(2*(multiplier*pos_m) + 2*neg_m);

% =============================================================

end
