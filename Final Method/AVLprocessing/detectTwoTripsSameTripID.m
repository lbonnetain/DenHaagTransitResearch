function [ DoublegtfsTripID ,TripSummary ] = detectTwoTripsSameTripID( TripDetail ,TripSummary )

%this function allow to detct the TripID in TripDetail
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail ,TripSummary
% Outputs
%   - DoublegtfsTripID (TripID in avl data with two dirrents trips)
%   - TripSummary (with new raw with new trips)
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06

%% Initialization

NumberNewTrip = 0;
OneTripTime = 4000; % time reference for considering it s reliable to make
                    % the assumption that two timestamps belong to two
                    % different trips
DoublegtfsTripID = [];     
kNewgtfsTripIDArr = 0;
kNewgtfsTripIDDep = 0;
nTripDetail = length(TripDetail);

%% find the tripID with more than two trips

for iTripDetail =2:nTripDetail    
    %new tripID -> intialisation of kNewgtfsTripIDArr and kNewgtfsTripIDDep
    if TripDetail(iTripDetail).gtfsTripID ~= TripDetail(iTripDetail-1).gtfsTripID
        kNewgtfsTripIDArr = 0;       
        kNewgtfsTripIDDep = 0;    
    end
    
    arrHasOneValue = hasOneValue(TripDetail(iTripDetail).avlArrival);
    depHasOneValue = hasOneValue(TripDetail(iTripDetail).avlDeparture);
    
    %--- case 1 : multiple arrival timestamps ---%
    if ~arrHasOneValue                   
        MultValue=[TripDetail(iTripDetail).avlArrival].';        
        %check if Multipe value of verify avlArrivalTime - gtfsArrivalTime
        %>(gtfsPreviousHeadway + gtfsNextheadway)
        for IMultValue = MultValue            
            if abs(IMultValue-TripDetail(iTripDetail).gtfsArrival)>OneTripTime                
                kNewgtfsTripIDArr = kNewgtfsTripIDArr + 1;                
            end            
        end
    end   
    
    %--- case 2 : multiple departure timestamps ---%
    if ~depHasOneValue                 
        for IMultValue = [TripDetail(iTripDetail).avlDeparture].'            
            %check if Multipe value of verify avlDepartureTime - gtfsDepartureTime
            %>(gtfsPreviousHeadway + gtfsNextheadway            
            if abs(IMultValue-TripDetail(iTripDetail).gtfsArrival) > OneTripTime                
                kNewgtfsTripIDDep = kNewgtfsTripIDDep + 1;                 
            end 
        end
    end  
    
    %if this condition is verified more than NTrip/2 for arrival and
    %departure, we consider there is two trip with the same TripID
    if kNewgtfsTripIDArr>7 && ...
       kNewgtfsTripIDDep>12 & ...
       sum(DoublegtfsTripID==[TripDetail(iTripDetail).gtfsTripID ]) == 0        
        NumberNewTrip = NumberNewTrip +1;       
        DoublegtfsTripID = horzcat(DoublegtfsTripID,[TripDetail(iTripDetail).gtfsTripID]);
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
