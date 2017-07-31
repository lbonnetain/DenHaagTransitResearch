function [ Network ] = DetectCorridor( Network )
%% 
% This is the function to detect a "corridor"
% here a corridor is a link which is shared per multiple line
% There is two kind of corridor :
%   - id (several link with the same From_Stop_id and To_Stop_id)
%   - name (several link with the same From_Stop_id and To_Stop_id)
% Thus this function, for each link will save the routes using this link
% (in terms of ID and name)
%
%--------------------------------------------------------------------------
% Inputs
%   - Network aftre applying CreateNetwork function
% Outputs
%   - Network with two new fields : Route_used_id and Route_used_name
%--------------------------------------------------------------------------
% Last updated by Bonnetain Loic, 2017/07/28

%% code
Nlink = length(Network);
Network(Nlink).Route_used_id = [];
Network(Nlink).Route_used_name = [];

From_Stop_name = {Network.From_Stop_name};
From_Stop_id = [Network.From_Stop_id];
To_Stop_name = {Network.To_Stop_name};
To_Stop_id = [Network.To_Stop_id];

for iLink = 1 : Nlink
    
    id_corridor = From_Stop_id == From_Stop_id(iLink)...
                      & To_Stop_id == To_Stop_id(iLink);
    Network(iLink).Route_used_id = {Network(id_corridor).Routes};
    
    id_name_corridor = strcmp(From_Stop_name,From_Stop_name(iLink))...
                           & strcmp(To_Stop_name,To_Stop_name(iLink));
    Network(iLink).Route_used_name = {Network(id_name_corridor).Routes};
    
end
end

