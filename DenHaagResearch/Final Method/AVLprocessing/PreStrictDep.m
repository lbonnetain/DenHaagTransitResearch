function [ PreviousDepID ] = PreStrictDep( TripDetail,gtfsTripID, CurrentID )
%%
%   This function find the previous Departure time (different of NaN)
%   this departure can't be the departure time of the currentID

%--------------------------------------------------------------------------
% Inputs
%   - PreviousDepID
% Outputs
%   - gtfsTripID
%   - TripDetail (with new raw for new trips)
%   - CurrentID 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06
%% code
rawID = find([TripDetail.gtfsTripID] == gtfsTripID);
FirsttRawID = rawID(1);
id = CurrentID - 1  ;
try
while id ~= FirsttRawID & isnan(TripDetail(id).avlDeparture)
    
    id = id - 1 ;   
end
catch 
end
if id <= FirsttRawID   
    PreviousDepID = 'NoPreviousDep';   
else   
    PreviousDepID = id;
end

end
