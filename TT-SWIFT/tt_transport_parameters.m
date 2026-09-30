function [rho, phi1, phi2] = tt_transport_parameters(options)
% Explicit paper parameters take precedence; retain legacy lambda/gamma.
if isfield(options,'rho'), rho = options.rho; else, rho = options.lambda; end
if isfield(options,'lambda1'), l1 = options.lambda1; else, l1 = options.gamma; end
if isfield(options,'lambda2'), l2 = options.lambda2; else, l2 = options.gamma; end
validateattributes(rho,{'numeric'},{'scalar','real','finite','positive'});
validateattributes(l1,{'numeric'},{'scalar','real','finite','positive'});
validateattributes(l2,{'numeric'},{'scalar','real','finite','positive'});
phi1 = 1 - 1/(1 + l1*rho);
phi2 = 1 - 1/(1 + l2*rho);
end
