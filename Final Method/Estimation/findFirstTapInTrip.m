function [ TripDetail, id_TapIn ] = findFirstTapInTrip( TripDetail ,gtfsTripID )
%%
%   This function find the id in TripDetail of the first tap on a trip for 
%   avl missing trip (e.g neither arrival and departure defined) but 
%   exectued trip (TapIn exists)
%--------------------------------------------------------------------------
% Inputs
%   - gtfsTripID
%   - TripDetail (with new raw for new trips
% Outputs
%   - TripDetail 
%   - id_TapIn 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/31

%% code
rawtripDetail = find ([TripDetail.gtfsTripID]==gtfsTripID);
id = rawtripDetail(1);

%--- find the first Tap in id ---%
while TripDetail(id).gtfsTripID ==  TripDetail(id+1).gtfsTripID ...
        & isempty(TripDetail(id).tapInTimes)    
    sametrip = TripDetail(id).gtfsTripID ==  TripDetail(id+1).gtfsTripID;
    findtapin = isempty(TripDetail(id).tapInTimes);    
    id = id +1;    
end
if TripDetail(id).gtfsTripID ~=  TripDetail(id+1).gtfsTripID
    id_TapIn = 'NoTapIn';    
else
    id_TapIn = id;    
    TripDetail(id).inferr = 5;
end

end

