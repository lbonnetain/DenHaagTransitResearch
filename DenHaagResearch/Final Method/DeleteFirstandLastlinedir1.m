function [ TripDetail ] = DeleteFirstandLastlinedir1( TripDetail )
%%
%   This function deletes the first and last trips (41 and 42) for direction 1 
%   beacause in many cases the data doesn t make sense
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail (with new raw for new trips
% Outputs
%   - TripDetail 
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/31

%% code

TripDetail([TripDetail.sequence]==1)=[];
TripDetail([TripDetail.sequence]==41)=[];
TripDetail([TripDetail.sequence]==42)=[];
end

