function [ NextStrictArrID ] = NextStrictArr( TripDetail,gtfsTripID, CurrentID )
%%
%   This function find the next Arrival time (different of NaN)
%   this departure can't be the actual time of the currentID

%--------------------------------------------------------------------------
% Inputs
%   - NextStrictArrID
% Outputs
%   - gtfsTripID
%   - TripDetail (with new raw for new trips)
%   - CurrentID 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06
%% code
rawID = find([TripDetail.gtfsTripID]==gtfsTripID);
LastRawID = rawID(length(rawID));
id = CurrentID + 1 ;
try
while id~=LastRawID & isnan(TripDetail(id).avlArrival)
    
    id = id +1 ;
    
end
catch
end
if id >= LastRawID    
    NextStrictArrID = 'NoNextStrictArr';    
else    
    NextStrictArrID = id;   
end
end
