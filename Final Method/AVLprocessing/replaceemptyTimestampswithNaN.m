function [ TripDetail ] = replaceemptyTimestampswithNaN( TripDetail )
%%
%   This function replaces empty timestamps with NaN for avlArrival time and 
%   avlDeparture time
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail
% Outputs
%   - TripDetail
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06
%% code
nTripDetail=length(TripDetail);
for iTripDetail = 1 : nTripDetail
    if isempty(TripDetail(iTripDetail).avlArrival)       
        TripDetail(iTripDetail).avlArrival = NaN;        
    end    
    if isempty(TripDetail(iTripDetail).avlDeparture)        
        TripDetail(iTripDetail).avlDeparture = NaN;        
    end
end
end

