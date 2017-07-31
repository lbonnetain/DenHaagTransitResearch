function [ TripDetail ,rate] = CleanedDataStep3( TripDetail,TripSummary )
%% 
%This function is to inferr somme arrival and/or departure missing timestamps
% and fix mutlitple timestamps issue. If arrival or departure inferred is
% unrealistic ,this is deleted in the function
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail
% Outputs
%   - TripDetail after cleaning data process
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/29
%% code
addpath('C:\Users\lbonnetain\Dropbox\TUD_Loic\FinalCodePaper\Final Method\AVLprocessing')

[ TripDetail, rate_1] = OneDayOneLineCleanDataArrMultValue( TripDetail);

[ TripDetail, rate_2] = OneDayOneLineCleanDataDepMultValue( TripDetail);

[ TripDetail, rate_3] = OneDayOneLineCleanDataArrDepTimeNoTapIn( TripDetail ,TripSummary);

[ TripDetail, rate_4] = OneDayOneLineGlobalConstraintlastverification( TripDetail );


[TripDetail] = OneDayOneLineArrNaNDepNaN( TripDetail,TripSummary);

rate =  rate_1 + rate_2 + rate_3 + rate_4;

end

