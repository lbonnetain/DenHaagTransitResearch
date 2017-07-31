function [] = OneOneLinePlotVehiculesTrajectories(TripDetail,TripSummary, curDirID, lineID,RouteSet )
%%
%   This function plot vehicule trajectories before and after improved data
%   process
%--------------------------------------------------------------------------
% Inputs
%   - TripDetail 
%   - TripSummary 
%   - curDirID 
%   - lineID 
%   - RouteSet
% Outputs
%--------------------------------------------------------------------------
% Last updated by Loic Bonnetain, 2017/07/31

%% code 
fig = figure;

%--- keep one direction direction data ---%
[ TripDetail ] = DeleteFirstandLastlinedir1( TripDetail );
curTripIDArray = [TripSummary([TripSummary.dirID] == curDirID).gtfsTripID]';
[logicIdx,~] = ismember([TripDetail.gtfsTripID],curTripIDArray);
curTripDetail = TripDetail(logicIdx);

%--- route definition ---%
routeCellArray = RouteSet(([RouteSet.lineID] == lineID &...
                           [RouteSet.direction_id] == curDirID)).stops; 
for iStop = 1:size(routeCellArray,1)
    tmpStr = strsplit(routeCellArray{iStop,3},', ');
    routeCellArray{iStop,4} = tmpStr{1,2}(1:4);
end

%--- Graph propreties ---%
GraphSpec.destName = RouteSet(([RouteSet.lineID] == lineID) &...
                    ([RouteSet.direction_id] == curDirID)).destination;
GraphSpec.dirID = curDirID;
GraphSpec.lineID = lineID;
GraphSpec.date = strcat(TripSummary(1).date(end-1:end),'-July-2017');
GraphSpec.color = 'b';
GraphSpec.capacity = 151;
GraphSpec.lineStyle = '-';
GraphSpec.lineWidth = 1;

%--- plot graph ---%
set(fig,'Units','Normalized','Outerposition',[0.3 0.3 0.6 0.6]);
subplot(1,2,1)
plotSpaceTimeDiagram_OneDayOneLine(curTripDetail,TripSummary,routeCellArray,GraphSpec,'trajectory');
subplot(1,2,2)
plotSpaceTimeDiagram_OneDayOneLine_originaldata(curTripDetail,TripSummary,routeCellArray,GraphSpec,'trajectory')
hold on

end

