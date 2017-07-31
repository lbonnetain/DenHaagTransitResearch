function [ Network ] = Create_L_spaceNetworkID( Network )
%% 
% This is the function to create L_space network type "id" (cf DetectCorridor function)
% that means that link used by multiple routes must be considered as just one link (instead
% of one link for each route)
% 
%--------------------------------------------------------------------------
% Inputs
%   - Network aftre applying CreateNetwork function
% Outputs
%   - Network without "useless links"
%--------------------------------------------------------------------------
% Last updated by Bonnetain Loic, 2017/07/28
%% code 
[ Network ] = DetectCorridor( Network );

From_Stop_id = [Network.From_Stop_id];
To_Stop_id = [Network.To_Stop_id];

Nlink = length(Network);
%--- detect useless links ---%
for iLink = 1:Nlink
    if length(Network(iLink).Route_used_id)~=1
        id_corr_id = find(From_Stop_id == From_Stop_id(iLink)...
                        & To_Stop_id == To_Stop_id(iLink)) ;                
        for jCorr_id = 2:size( id_corr_id,2)
            Network(id_corr_id(jCorr_id)).Route_used_id='inutile';
        end
    end
    
end

%--- delete useless links ---%
iLink=1;
while iLink <= size(Network,2)
    if strcmp(Network(iLink).Route_used_id, 'inutile')
        Network(iLink)=[];
        iLink = iLink - 1;
    end
    iLink = iLink + 1; 
end

end

