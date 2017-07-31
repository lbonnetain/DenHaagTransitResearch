function [ TripDetail ] = inferrdTripbeforeFirstTapIn( TripDetail, id_TapIn, gtfsTripID )
%%
%   This function inferr all arrival and departure before the first tap in
%   id (cf findFirstTapIN function).
%--------------------------------------------------------------------------
% Inputs
%   - gtfsTripID
%   - TripDetail (with new raw for new trips
%   - id_TapIn
% Outputs
%   - TripDetail 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/31

%% code
rawtripDetail = find ([TripDetail.gtfsTripID]==gtfsTripID);
Firstid = rawtripDetail(1);
id = id_TapIn;
TripDetail(id_TapIn).avlArrival = TripDetail(id_TapIn).tapInTimes(1);
TripDetail(id_TapIn).avlDeparture =TripDetail(id_TapIn).tapInTimes(1);

%--- inferr both arrival and departure before first tap in id ---%
while id~=Firstid    
    TripDetail(id-1).avlArrival = - TripDetail(id).gtfsArrival + TripDetail(id-1).gtfsArrival...
                                  + TripDetail(id).avlArrival;    
    TripDetail(id).avlDeparture = TripDetail(id).avlArrival;   
    TripDetail(id).inferr = 5;   
    id = id -1;     
end
end

