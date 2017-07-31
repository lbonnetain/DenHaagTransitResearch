function [ TripDetail ] = OneDayOneLineOnBoardOccupancy( TripDetail )
%%
%   This function calculates the load for each trip in TripDetail
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail (with new raw for new trips
% Outputs
%   - TripDetail 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/31

%% code
TripDetail(1).load = length(TripDetail(1).tapInTimes);
nTripDetail = length(TripDetail);
for iTripDetail=2:nTripDetail   
    nBoarding = length(TripDetail(iTripDetail).tapInTimes);    
    nAllighting = length(TripDetail(iTripDetail).tapOutTimes);    
    PreviousOnBoardOccupancy = TripDetail(iTripDetail-1).load;    
    TripDetail(iTripDetail).load = PreviousOnBoardOccupancy+nBoarding-nAllighting;    
    if TripDetail(iTripDetail).load<0
        %sommetimes load is equal to minus 1 due to wrong matchind or data
        %and need to be fixed at 0 for ploting correctly
        TripDetail(iTripDetail).load=0;
    end    
end
end

