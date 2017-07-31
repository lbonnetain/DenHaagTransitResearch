function [TripDetail ] = InferrTrajectories_allTripMissing( TripDetail,TripSummary)
%%
%   function who inferr a trip when avl data is missing for the whole trip
%   using tap in recorded and scheduled time.
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail (with new raw for new trips
%   - TripSummary
% Outputs
%   - TripDetail 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/31

%% inferr missing part

missingtrip=[TripSummary([TripSummary.nStopsWithArrivalTs]==0 &[TripSummary.executed]==1 ).gtfsTripID];
for iMissingTrip= missingtrip
    [ TripDetail, id_TapIn ] = findFirstTapInTrip( TripDetail ,iMissingTrip );
    if ~ischar(id_TapIn)        
        [ TripDetail ] = inferrdTripbeforeFirstTapIn( TripDetail, id_TapIn, iMissingTrip );
        [ TripDetail ] = inferrdTripafterFirstTapIn( TripDetail,id_TapIn, iMissingTrip );       
    end     
end  

end