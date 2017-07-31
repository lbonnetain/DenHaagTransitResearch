function [ TripDetail, rate_new_clean_data ] = AVLpreprocessing( TripDetail,TripSummary )
%%
% This function is to solve some problems with AVL records :
%Two different trips with one TripID, detect such a situation and create a
%new tripID in TripSummuray and save the timestamps in TripDetail
%Unrealistic records (which don t verify global constraint)
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail
% Outputs
%   - TripDetail with avl preprocessing
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/06
%% code 
[ TripDetail, rate_1] = OneDayOneLineCleanData2SameTripId( TripDetail,TripSummary );
[ TripDetail, rate_2] = OneDayOneLineGlobalConstraint( TripDetail );

rate_new_clean_data = rate_1 + rate_2;
end

