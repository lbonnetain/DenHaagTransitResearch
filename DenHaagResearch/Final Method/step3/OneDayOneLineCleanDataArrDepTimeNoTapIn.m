function [ TripDetail, rate_new_clean_data] = OneDayOneLineCleanDataArrDepTimeNoTapIn( TripDetail,TripSummary )
%function which infers arrival and departure time (when it doesn t exist)
%the assumption here is there is if arrival or departure time is not deifined,
% so there isn t tap in, the bus didn t stop and so arrival time = departure 
%--------------------------------------------------------------------------
% Outputs
%   - TripDetail (with some arrival time inferred)
%   - rate_new_clean_data
% Imputs
%   - TripDetail
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06

iDatacleaned = 0;
executingtrip=[TripSummary([TripSummary.executed]==1 ).gtfsTripID];
nDT = length(TripDetail);
for iTD =1:nDT    
    isArrNan = isnan(TripDetail(iTD).avlArrival);
    isDepNan = isnan(TripDetail(iTD).avlDeparture);
    arrHasOneValue = hasOneValue(TripDetail(iTD).avlArrival);
    depHasOneValue = hasOneValue(TripDetail(iTD).avlDeparture); 
    
    TapIn = TripDetail(iTD).tapInTimes;    
    tripID = TripDetail(iTD).gtfsTripID;    
    isexecuted = ~isempty(find(executingtrip==tripID));
    
    %--- chek if arrival and departure are single Value (can be NaN) ---%
    %timestamp needs to belong to exectued trip
    if arrHasOneValue && depHasOneValue & isexecuted               
        %if arr is NaN but dep exists -> arrival time = departure time 
        if isArrNan && ~isDepNan            
            iDatacleaned = iDatacleaned+1;            
            TripDetail(iTD).inferr = 3;            
            TripDetail(iTD).avlArrival = TripDetail(iTD).avlDeparture;
        end
        %if dep is NaN but arr exists -> departure time = arrival time 
        if ~isArrNan && isDepNan 
            iDatacleaned = iDatacleaned+1;
            TripDetail(iTD).inferr = 3;
            TripDetail(iTD).avlDeparture = TripDetail(iTD).avlArrival;
        end
    end    
end
rate_new_clean_data = iDatacleaned/length(TripDetail);
end

function val = hasOneValue(timeArray)
if length(timeArray) == 1
    val = true;
else
    val = false;
end
end
