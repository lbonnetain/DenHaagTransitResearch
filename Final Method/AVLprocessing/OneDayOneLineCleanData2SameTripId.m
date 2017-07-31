function [ TripDetail, rate_clean_data] = OneDayOneLineCleanData2SameTripId( TripDetail ,TripSummary)
%%
%   This function allows to seperate trips with same tripID into different
%   trips saved in TripDetail. One of them is kept the other one is deleted

%--------------------------------------------------------------------------
% Inputs
%   - TripDetail
%   - TripSummary
% Outputs
%   - nb_new_clean_data
%   - TripDetail

%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06

%% code
[ DoublegtfsTripID ,TripSummary ] = detectTwoTripsSameTripID( TripDetail ,TripSummary );

%Initialization
NDoublegtfsTripID = length(DoublegtfsTripID);
idNewTrip = 0;
OneTripTime = 4000;
nb_clean_data = 0;

for iDoublegtfsTripID =1:NDoublegtfsTripID %loop in each TripID with this problem
    gtfsTripID = DoublegtfsTripID(iDoublegtfsTripID);    
    raw_gtfsTripID = find([TripDetail.gtfsTripID]==gtfsTripID);           
    for jrawgtfs = raw_gtfsTripID %loop in each stops of the trip       
        idNewTrip = idNewTrip +1;        
        % type of the problem solved
        TripDetail(jrawgtfs).inferr = 1;                
        %number of data where there is such a problem
        rate_clean_data = rate_clean_data+1; 
        
        isArrNan = isnan(TripDetail(jrawgtfs).avlArrival);
        isDepNan = isnan(TripDetail(jrawgtfs).avlDeparture);
        arrHasOneValue = hasOneValue(TripDetail(jrawgtfs).avlArrival);
        depHasOneValue = hasOneValue(TripDetail(jrawgtfs).avlDeparture);
        
        %--- case 1 : single value~NaN of avlArrivalTime ---%
        if arrHasOneValue && ~isArrNan            
            if abs(TripDetail(jrawgtfs).avlArrival-TripDetail(jrawgtfs).gtfsArrival) > OneTripTime
                TripDetail(jrawgtfs).avlArrival = NaN;                             
            end
        end    
        
        %--- case 2 : multiple value~NaN of avlArrivalTime---%        
        if ~arrHasOneValue           
            kDeleteId = 0 ;
            for IMultValue = [TripDetail(jrawgtfs).avlArrival].'
                kDeleteId = kDeleteId +1;
                if abs(IMultValue-TripDetail(jrawgtfs).gtfsArrival) > OneTripTime                    
                    %keep one value and save the other one in a new trip                    
                    TripDetail(jrawgtfs).avlArrival(kDeleteId) = [];
                    kDeleteId = kDeleteId - 1;
                    nb_clean_data = nb_clean_data+1;
                end
            end
        end
        
        %--- case 3 : single value~NaN of avlDepartureTime ---%       
        if depHasOneValue && ~isDepNan           
            if abs(TripDetail(jrawgtfs).avlDeparture-TripDetail(jrawgtfs).gtfsArrival) > OneTripTime
                TripDetail(jrawgtfs).avlDeparture = NaN;
            end           
        end
        
        %--- case 4 : multiple value~NaN of avlDepartureTime ---%    
        if ~depHasOneValue          
            kDeleteId = 0 ;
            for IMultValue = [TripDetail(jrawgtfs).avlDeparture].'
                kDeleteId = kDeleteId +1;
                if abs(IMultValue-TripDetail(jrawgtfs).gtfsArrival) > OneTripTime                                                       
                    %keep one value and save the other one in a new trip                
                    TripDetail(jrawgtfs).avlDeparture(kDeleteId) = [];
                    kDeleteId = kDeleteId - 1;
                end
            end
        end              
    end
end
rate_clean_data = nb_clean_data/length(TripDetail);
end
function val = hasOneValue(timeArray)

if length(timeArray) == 1
    val = true;
else
    val = false;
end

end