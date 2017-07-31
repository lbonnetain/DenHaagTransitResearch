function [ TripDetail ] = inferrdTripafterFirstTapIn( TripDetail,id_TapIn, gtfsTripID )
%%
%   This function inferr all arrival and departure after the first tap in
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
Lasttid = rawtripDetail(length(rawtripDetail));
id = id_TapIn ;
while id~=Lasttid    
    TapInTime = [TripDetail(id+1).tapInTimes];
    if ~isempty(TapInTime)
        %if tap in exists arrival = first tap in time and departure =
        %arrival (but need to verify global constraint)
        constraint = TapInTime(1)> TripDetail(id).avlArrival;
        TripDetail(id+1).inferr=5;           
        if constraint
            TripDetail(id+1).avlArrival = TapInTime(1);            
        else             
            TripDetail(id+1).avlArrival=TripDetail(id+1).gtfsArrival - TripDetail(id).gtfsArrival+TripDetail(id).avlArrival;
        end        
        TripDetail(id+1).avlDeparture= TripDetail(id+1).avlArrival;       
    else 
        %if there is no tap in use scheduled trip time to inferr arrival 
        TripDetail(id+1).avlArrival=TripDetail(id+1).gtfsArrival - TripDetail(id).gtfsArrival+TripDetail(id).avlArrival;
        TripDetail(id+1).avlDeparture= TripDetail(id+1).avlArrival;        
        TripDetail(id+1).inferr=5;
    end
    id = id +1;   
end
end

