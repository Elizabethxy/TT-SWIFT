
function [ H ] = KL_update_rule_tt( V,W,H )

%V=W*H'

myeps= 1e-26;
n=size(H,2);


H = H .* (W'*(V./(W*H + myeps)))./(sum(W)'*ones(1,n));

H = H + (H<myeps) .* myeps;


end

% function [ H ] = KL_update_rule( WTV,WTW,H )
% 
% %V=W*H'
% 
% myeps= 1e-16;
% %n=size(H,2);
% 
% %H = H .* (W'*(V./(W*H + myeps)))./(sum(W)'*ones(1,n));
% H = H .* (WTV) ./ (WTW * H);
% H = H + (H<myeps) .* myeps;
% 
% 
% end
