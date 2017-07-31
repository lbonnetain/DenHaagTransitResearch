function [ PreviousArrID ] = PreArr( TripDetail,gtfsTripID, CurrentID )
%%
%   This function find the previous Arrival time (different of NaN)
%this departure can be the arrival time of the currentID

%--------------------------------------------------------------------------
% Inputs
%   - PreviousArrID
% Outputs
%   - gtfsTripID
%   - TripDetail 
%   - CurrentID 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06
%% code
rawID = find([TripDetail.gtfsTripID]==gtfsTripID);
FirstRawID = rawID(1);
id = CurrentID ;
while id~=FirstRawID & isnan(TripDetail(id).avlArrival)    
    id = id -1 ;   
end
if id == FirstRawID   
    PreviousArrID = 'NoPrevviousArr';    
else    
    PreviousArrID = id;    
end
end

