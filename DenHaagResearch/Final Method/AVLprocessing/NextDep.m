function [ NextDepID ] = NextDep( TripDetail,gtfsTripID, CurrentID )
%%
%   This function find the next Departure time (different of NaN)
%   this departure can be the departure time of the currentID

%--------------------------------------------------------------------------
% Inputs
%   - NextDepID
% Outputs
%   - gtfsTripID
%   - TripDetail (with new raw for new trips)
%   - CurrentID 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06
%% code
rawID = find([TripDetail.gtfsTripID]==gtfsTripID);

LastRawID = rawID(length(rawID));
id = CurrentID ;
while id~=LastRawID & isnan(TripDetail(id).avlDeparture)
    
    id = id + 1 ;
    
end

if id == LastRawID
    
    NextDepID = 'NoNextDep';
    
else
    
    NextDepID = id;
    
end

end
