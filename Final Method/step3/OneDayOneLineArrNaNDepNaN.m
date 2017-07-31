function [TripDetail] = OneDayOneLineArrNaNDepNaN( TripDetail,TripSummary)
%% 
%This function is to inferr somme arrival and departure missing timestamps
% when both of them are missing, this infrrence is always done for executed
% trip.
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail
% Outputs
%   - TripDetail 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/29

%% inferr missing part

existingtrip=[TripSummary(~isnan([TripSummary.avlHasData])==1).gtfsTripID];
nTD = length(TripDetail);
for iTD =1:nTD
    avlArr = TripDetail(iTD).avlArrival;
    avlDep = TripDetail(iTD).avlDeparture;    
    TripID = TripDetail(iTD).gtfsTripID;
    TripValidation = ~isempty(find (existingtrip==TripID, 1));
    %--- inferr arrival time and departure time if both are missing ---%
    % the missing timestamp need to belong to an executed trip 
    if isnan(avlArr) & isnan(avlDep) & TripValidation       
        TapInTime = [TripDetail(iTD).tapInTimes];        
        [ PreStrictDepID ]  = PreDepNoneMult( TripDetail,TripID, iTD );        
        [ NextStrictDepID ] = NextDepNoneMult( TripDetail,TripID, iTD );  
        if ~ischar( PreStrictDepID) & ~ischar(NextStrictDepID)  
            %inference thanks for the previous trip 
            ArrinferrPre  = TripDetail(iTD).gtfsArrival - TripDetail(PreStrictDepID).gtfsArrival ... 
                          + TripDetail(PreStrictDepID).avlDeparture;           
            %inferrence thanks for the next trip
            ArrinferrNext = TripDetail(iTD).gtfsArrival - TripDetail(NextStrictDepID).gtfsArrival...
                          + TripDetail(NextStrictDepID).avlDeparture; 
            %check if the ArrinferrPre verify global constraint
            if ArrinferrPre < TripDetail(iTD+1).avlArrival              
                TripDetail(iTD).avlArrival   = ArrinferrPre;
                TripDetail(iTD).avlDeparture = TripDetail(iTD).avlArrival;
                TripDetail(iTD).inferr = 6;     
            %check if the ArrinferrNext verify global constraint
            elseif ArrinferrNext > TripDetail(iTD-1).avlArrival & ~ischar(PreStrictDepID)            
                TripDetail(iTD).avlArrival   = ArrinferrNext;
                TripDetail(iTD).avlDeparture = TripDetail(iTD).avlArrival;
                TripDetail(iTD).inferr = 6;                
            end
        end
    end      
end
end

function val = hasOneValue(timeArray)
if length(timeArray) == 1
    val = true;
else
    val = false;
end
end
