function [ PreviousStrictArrID ] = PreArrNoneMult( TripDetail,gtfsTripID, CurrentID )
%   This function find the Previous Arrival time (different of NaN)
%this departure can't be the actual time of the currentID and isn't a
%multiple value

%--------------------------------------------------------------------------
% Inputs
%   - PreviousStrictArrID
% Outputs
%   - gtfsTripID
%   - TripDetail (with new raw for new trips)
%   - CurrentID 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06

rawID = find([TripDetail.gtfsTripID]==gtfsTripID);

FirstRawID = rawID(1);
id = CurrentID - 1 ;

try
while id~=FirstRawID & (isnan(TripDetail(id).avlArrival) | length([TripDetail(id).avlArrival])>1)
    
    id = id - 1 ;
    
end
catch
end

if id == FirstRawID
    
    PreviousStrictArrID = 'NoPreviousStrictArr';
    
else
    
    PreviousStrictArrID = id;
    
end

end