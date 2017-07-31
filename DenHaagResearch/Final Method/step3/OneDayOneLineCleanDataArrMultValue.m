function [ TripDetail, rate_new_clean_data] = OneDayOneLineCleanDataArrMultValue( TripDetail)
%% 
%This function is deal with arrival multipletimestamps issue after this
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
iDatacleaned = 0;
nTD = length(TripDetail);
for iTD =1:nTD 
    arrHasOneValue = hasOneValue(TripDetail(iTD).avlArrival); 
    
    %--- check only multiple arrival value---%
    if ~arrHasOneValue           
        iDatacleaned = iDatacleaned+1;        
        MultValues = [TripDetail(iTD).avlArrival].';       
        TapInTimes = [TripDetail(iTD).tapInTimes];        
        gtfsTripID = TripDetail(iTD).gtfsTripID;
        
        %--- check if there is TapIn for this stop ---%
        if isempty(TapInTimes) 
            %no tap in recorded
            [ PrevtrictArrID ]  = PreArrNoneMult( TripDetail,gtfsTripID, iTD );            
            [ NextStrictArrID ] = NextArrNoneMult( TripDetail,gtfsTripID, iTD );
            
            %--- case 1 : previous and next arrival exist ---%
            if ~ischar(PrevtrictArrID) && ~ischar(NextStrictArrID)                
                TimeTripgtfsPre  =   TripDetail(iTD).gtfsArrival - TripDetail(PrevtrictArrID).gtfsArrival;                
                TimeTripgtfsNext = - TripDetail(iTD).gtfsArrival + TripDetail(NextStrictArrID).gtfsArrival;
                TimeTripavlPre  = abs (   TripDetail(iTD).avlArrival - TripDetail(PrevtrictArrID).avlArrival);
                TimeTripavlNext = abs ( - TripDetail(iTD).avlArrival + TripDetail(NextStrictArrID).avlArrival);
                %calculate the error for each timestamps the difference between AVL
                %tripTime(Next and Previous) and GTFS TripTime (next and previous)
                DeltaTime = abs(TimeTripgtfsNext-TimeTripavlNext) + abs(TimeTripgtfsPre-TimeTripavlPre);
                %select the one who minimize the error
                min_id=find(DeltaTime==min(DeltaTime));
                TripDetail(iTD).avlArrival=TripDetail(iTD).avlArrival(min(min_id));                
                TripDetail(iTD).inferr = 2; 
                
            %--- case 2 : next arrival exist but previous arrival doesn t ---%    
            elseif ischar(PrevtrictArrID) && ~ischar(NextStrictArrID)                
                TimeTripgtfsNext = TripDetail(NextStrictArrID).gtfsArrival - TripDetail(iTD).gtfsArrival;
                TimeTripavlNext = abs (TripDetail(NextStrictArrID).avlArrival - TripDetail(iTD).avlArrival);
                %calculate the error for each timestamps the difference between AVL
                %tripTime(next) and GTFS TripTime (next)
                DeltaTime = abs(TimeTripgtfsNext - TimeTripavlNext);
                %select the one who minimize the error
                min_id=find(DeltaTime == min(DeltaTime));
                TripDetail(iTD).avlArrival = TripDetail(iTD).avlArrival(min(min_id));
                TripDetail(iTD).inferr = 2;
                
            %--- case 3 : previous arrival exist but next arrival doesn t ---%    
            elseif ~ischar(PrevtrictArrID) && ischar(NextStrictArrID)                
                TimeTripgtfsPre = TripDetail(iTD).gtfsArrival - TripDetail(PrevtrictArrID).gtfsArrival;                
                TimeTripavlPre = abs (TripDetail(iTD).avlArrival - TripDetail(PrevtrictArrID).avlArrival);
                %calculate the error for each timestamps the difference between AVL
                %tripTime(previous) and GTFS TripTime (previous)
                DeltaTime = abs(TimeTripgtfsPre-TimeTripavlPre); 
                %select the one who minimize the error
                min_id=find(DeltaTime == min(DeltaTime));
                TripDetail(iTD).avlArrival = TripDetail(iTD).avlArrival(min(min_id));
                TripDetail(iTD).inferr = 2;
            end
        else
            %tap in recorded
            TapIn = TapInTimes(1);
            %calculate the error for each timestamps the difference between AVL
            %arrival time and first tap in time recorded
            DeltaTime = abs(TapIn -MultValues);
            %select the one who minimize the error
            id_min = find (DeltaTime == min(DeltaTime));
            TripDetail(iTD).avlArrival = MultValues(min(id_min));
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