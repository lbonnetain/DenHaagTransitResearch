function [ TripDetail, rate_new_clean_data] = OneDayOneLineGlobalConstraint( TripDetail )
%%
%this function is the verification that all avl arrival and departure
%verify the global constraint :
%PreviousDeparture < avlArrival < NextDeparture
%PreviousArrival < avlDeparture < NextArrival
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail
%   - rate_new_clean_data
% Outputs
%   - TripDetail
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06
%% code
iDatacleaned = 0;
nTD = length(TripDetail); 
for iTD = 1 : nTD    
    gtfsTripID = TripDetail(iTD).gtfsTripID;   
    isArrNan = isnan(TripDetail(iTD).avlArrival);
    isDepNan = isnan(TripDetail(iTD).avlDeparture);
    
    %--- verify the constraint for the arrival time ---% 
    if ~isArrNan          
        kDeleteId = 0 ;      
        for IMultValue = [TripDetail(iTD).avlArrival].'            
            kDeleteId = kDeleteId +1;            
            [ NextDepID ]           = NextDep( TripDetail,gtfsTripID, iTD );            
            [ PreviousStrictDepID ] = PreStrictDep( TripDetail,gtfsTripID, iTD );         
            if ~ischar(PreviousStrictDepID)                
                %previous departure time exist
                infValue = [TripDetail(PreviousStrictDepID).avlDeparture];                
                if IMultValue <= min(infValue)                    
                    %global constraint isn't verified so delete this
                    %arrival time
                    iDatacleaned = iDatacleaned+1;
                    TripDetail(iTD).avlArrival(kDeleteId) = [];
                    kDeleteId = kDeleteId - 1;                    
                    TripDetail(iTD).inferr = 2;
                    iDatacleaned = iDatacleaned + 1;
                end
            end                               
            if ~ischar(NextDepID)                
                %next departure time exist                
                supValue = [TripDetail(NextDepID).avlDeparture];               
                if IMultValue > max(supValue)                    
                    %global constraint isn't verified so delete this
                    %arrival time                                        
                    iDatacleaned = iDatacleaned+1;
                    TripDetail(iTD).avlArrival(kDeleteId) = [];
                    kDeleteId = kDeleteId - 1;                    
                    TripDetail(iTD).inferr = 2;
                    iDatacleaned = iDatacleaned+1;                
                end
            end           
        end       
    end
    
    %--- verify the constraint for the departure time ---% 
    if ~isDepNan                   
        kDeleteId = 0 ;        
        for IMultValue = [TripDetail(iTD).avlDeparture].'            
            kDeleteId = kDeleteId + 1;            
            [ PreviousArrID ]   = PreArr( TripDetail,gtfsTripID, iTD );            
            [ NextStrictArrID ] = NextStrictArr( TripDetail,gtfsTripID, iTD );
            if ~ischar(PreviousArrID)               
               %previous arrival time exists                
                infValue = [TripDetail(PreviousArrID).avlArrival];                
                if IMultValue < min(infValue)                     
                    %global constraint isn't verified so delete this
                    %departure time                                            
                    iDatacleaned = iDatacleaned + 1;                    
                    TripDetail(iTD).avlDeparture(kDeleteId) = [];
                    kDeleteId = kDeleteId - 1;                    
                    TripDetail(iTD).inferr = 2;
                    iDatacleaned = iDatacleaned+1;               
                end
            end               
            if ~ischar(NextStrictArrID)                
                %next arrival time exists                
                supValue = [TripDetail(NextStrictArrID).avlArrival];                
                if IMultValue >= max(supValue)
                    %global constraint isn't verified so delete this
                    %departure time                                            
                    iDatacleaned = iDatacleaned + 1;                
                    TripDetail(iTD).avlDeparture(kDeleteId) = [];
                    kDeleteId = kDeleteId - 1;                    
                    TripDetail(iTD).inferr = 2;
                    iDatacleaned = iDatacleaned+1;
                end                
            end            
        end
    end
end
[ TripDetail ] = replaceemptyTimestampswithNaN( TripDetail );
rate_new_clean_data = iDatacleaned / length(TripDetail);
end
function val = hasOneValue(timeArray)
if length(timeArray) == 1
    val = true;
else
    val = false;
end
end