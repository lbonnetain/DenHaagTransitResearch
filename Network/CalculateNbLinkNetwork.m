function [Nlink]=CalculateNbLinkNetwork(RouteSet)
%%
%--------------------------------------------------------------------------
% Inputs
%   - RouteSet (composition of the network : routes and stop name)
% Outputs
%   - Nlink number total of link in the network
%--------------------------------------------------------------------------
% Last updated by Bonnetain Loic, 2017/07/28

%% code
Nlink = 0;
NRoute = size(RouteSet,2);
for iRoute = 1 : NRoute  
    Nlink = Nlink + size(RouteSet(iRoute).stops,1) - 1;
end
end