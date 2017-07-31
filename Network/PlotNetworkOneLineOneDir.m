function [  ] = PlotNetworkOneLineOneDir(Network, line, dir )
%% 
% This is the function to hold on the line in the current figure.
% WARNING this function plot the line if it exists a figure ; the
% function doesn t create a figure by itself
%--------------------------------------------------------------------------
% Inputs
%   - Network aftre applying CreateNetwork function
%     - line
%     - direction
% Outputs
%   - no outpout 
%--------------------------------------------------------------------------
% Last updated by Bonnetain Loic, 2017/07/28

%% code

idV_n = find(strcmp({Network.Routes},line)==1 & [Network.dir]==dir);
Nlink = length(idV_n);
Xvalue = []; 
Yvalue = [];

for iLink= 1:Nlink

    Xvalue = vertcat(Xvalue, Network(idV_n(iLink)).Curves_coords(:,1));
    Yvalue = vertcat(Yvalue,Network(idV_n(iLink)).Curves_coords(:,2));

end

plot(Yvalue,Xvalue,'Color',[0.6 0.6 0.6]);
hold on;
end

