function [ Network ] = Create_L_spaceNetworkName( Network )
%% 
% This is the function to create L_space network type "name" (cf DetectCorridor function)
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

From_Stop_name = {Network.From_Stop_name};
To_Stop_name = {Network.To_Stop_name};

%--- detect useless links ---%
Nlink = length(Network);
for iLink = 1:Nlink
    if length(Network(iLink).Route_used_name)~=1
        id_corr_id = find(strcmp(From_Stop_name,Network(iLink).From_Stop_name)...
                        & strcmp(To_Stop_name,Network(iLink).To_Stop_name)) ;
                        
        for jId_corridor_id = 2:size( id_corr_id,2)
            Network(id_corr_id(jId_corridor_id)).Route_used_name='inutile';
        end
    end
    
end

%--- delete useless links ---%
iLink=1;
while iLink <= size(Network,2)
    if strcmp(Network(iLink).Route_used_name, 'inutile')
        Network(iLink)=[];
        iLink = iLink - 1;
    end
    iLink = iLink + 1; 
end

end