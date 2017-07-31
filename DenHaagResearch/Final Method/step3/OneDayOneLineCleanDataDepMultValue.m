function [ TripDetail, rate_new_clean_data] = OneDayOneLineCleanDataDepMultValue( TripDetail)
%% 
%This function is deal with departure multipletimestamps issue after this
%function a departure multiple value becomes a single (selected from the
%multiple value) if none of mutilple value is realistic (e.g verify global
%constraint) the result is NaN.
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail
% Outputs
%   - TripDetail after cleaning multiple departure process
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/29
%% code

iDatacleaned = 0; %this figure corresponds to the number of data cleaned 
nTD = length(TripDetail);
for iTD =1:nTD
    depHasOneValue = hasOneValue(TripDetail(iTD).avlDeparture); 
    
    %--- check only multiple departure value---%
    if ~depHasOneValue           
        iDatacleaned = iDatacleaned+1;%number of raw cleaned in current TripDetail       
        gtfsTripID = TripDetail(iTD).gtfsTripID;
        [ PreStrictDepID ]  = PreDepNoneMult ( TripDetail,gtfsTripID, iTD );
        [ NextStrictDepID ] = NextDepNoneMult( TripDetail,gtfsTripID, iTD );
        
        %--- case 1 : previous and next departure exist ---%
        if ~ischar(PreStrictDepID) && ~ischar(NextStrictDepID)
            TimeTripgtfsPre  =   TripDetail(iTD).gtfsDeparture - TripDetail(PreStrictDepID).gtfsDeparture;
            TimeTripgtfsNext = - TripDetail(iTD).gtfsDeparture + TripDetail(NextStrictDepID).gtfsDeparture ;           
            TimeTripavlPre  = abs (   TripDetail(iTD).avlDeparture - TripDetail(PreStrictDepID).avlDeparture);
            TimeTripavlNext = abs ( - TripDetail(iTD).avlDeparture + TripDetail(NextStrictDepID).avlDeparture);
            %calculate the error for each timestamps the difference between AVL
            %tripTime(Next and Previous) and GTFS TripTime (next and previous)
            DeltaTime = abs(TimeTripgtfsNext-TimeTripavlPre) + abs(TimeTripgtfsPre-TimeTripavlNext);
            %select the one who minimize the error
            min_id=find(DeltaTime == min(DeltaTime));
            TripDetail(iTD).avlDeparture = TripDetail(iTD).avlDeparture(min(min_id));
            TripDetail(iTD).inferr = 2;
            
        %--- case 2 : next departure exist but previous departure doesn t ---%
        elseif ischar(PreStrictDepID) && ~ischar(NextStrictDepID)
            TimeTripgtfsNext = TripDetail(NextStrictDepID).gtfsDeparture - TripDetail(iTD).gtfsDeparture;
            TimeTripavlNext = abs (TripDetail(NextStrictDepID).avlDeparture - TripDetail(iTD).avlDeparture);
            %calculate the error for each timestamps the difference between AVL
            %tripTime(Next and Previous) and GTFS TripTime (next and previous)
            DeltaTime = abs(TimeTripgtfsNext-TimeTripavlNext);
            %select the one who minimize the error
            min_id  = find(DeltaTime == min(DeltaTime));
            TripDetail(iTD).avlDeparture = TripDetail(iTD).avlDeparture(min(min_id));
            TripDetail(iTD).inferr = 2;
            
        %--- case 3 : previous departure exist but next departure doesn t ---%
        elseif ~ischar(PreStrictDepID) && ischar(NextStrictDepID)
            TimeTripgtfsPre=TripDetail(iTD).gtfsDeparture - TripDetail(PreStrictDepID).gtfsDeparture;
            TimeTripavlPre = abs (TripDetail(iTD).avlDeparture - TripDetail(PreStrictDepID).avlDeparture);
            %calculate the error for each timestamps the difference between AVL
            %tripTime(previous) and GTFS TripTime (previous)
            DeltaTime = abs(TimeTripgtfsPre - TimeTripavlPre) ;
            %select the one who minimize the error
            min_id = find(DeltaTime == min(DeltaTime));
            TripDetail(iTD).avlDeparture=TripDetail(iTD).avlDeparture(min(min_id));
            TripDetail(iTD).inferr = 2;
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