function [ TripDetail ] = OneDayOneLineFinalMethod( TripDetail,TripSummary )
%%
%   This function is the complete method to improve vehicules trajectories
%   thanks for AFC and gtfs Data. The initial data of arrival and departure
%   time are saved in avlArrival/avlDeparture, and the results of this
%   function (improved data) in estarrival/estdeparture data.
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail 
%   - TripSummuary
% Outputs
%   - TripDetail 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/31

%% code

[TripDetail(:).estArrival]=TripDetail(:).avlArrival;
[TripDetail(:).estDeparture]=TripDetail(:).avlDeparture;
[ TripDetail ] = OneDayOneLineOnBoardOccupancy( TripDetail );
[TripDetail(:).inferr]=deal(0);
curDirectory = pwd;
addpath(strcat(curDirectory,'\AVLprocessing'))
'step1'
%--- step 1 ---%
[ TripDetail, nb_new_clean_data ] = AVLpreprocessing( TripDetail,TripSummary );
addpath(strcat(curDirectory,'\step3'))
'step2'
%--- step 2 ---%
[ TripDetail ,rate_new_clean_data] = CleanedDataStep3( TripDetail,TripSummary );
addpath(strcat(curDirectory,'\Estimation'))
'step3'
%--- step 3 ---%
[TripDetail ] = InferrTrajectories_allTripMissing( TripDetail,TripSummary);

%--- exchange the value between estarrival/estdeparture and 
%                               avlArrival/avlDeparture ---%
mirror(length(TripDetail)).estArrival = 0;
mirror(length(TripDetail)).estDeparture = 0;
[mirror(:).avlArrival]=TripDetail(:).estArrival;
[mirror(:).avlDeparture]=TripDetail(:).estDeparture;
[TripDetail(:).estArrival]=TripDetail(:).avlArrival;
[TripDetail(:).estDeparture]=TripDetail(:).avlDeparture;
[TripDetail(:).avlArrival]=mirror(:).avlArrival;
[TripDetail(:).avlDeparture]=mirror(:).avlDeparture;
end

