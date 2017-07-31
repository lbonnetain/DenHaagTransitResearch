function plotSpaceTimeDiagram_OneDayOneLine(TripDetail,TripSummary,routeCellArray,GraphSpec,diagramType)


switch diagramType
    case 'schedule'
        [firstDeparture,lastArrival] = plotScheduledTimetable(TripDetail,TripSummary,...
                                                              GraphSpec);
    case 'trajectory'
        [firstDeparture,lastArrival] = plotRealTrajectory(TripDetail,TripSummary,...
                                                            GraphSpec);
    case 'occupancy'
        [firstDeparture,lastArrival] = plotOccupancy(TripDetail,TripSummary,GraphSpec);
    otherwise 
        warning('Unexpected diagram type. No plot created.');
            
end

%% title
curTitle = ['Line ' int2str(GraphSpec.lineID) ' to ' GraphSpec.destName...
           ' (' int2str(GraphSpec.dirID) '), ' GraphSpec.date,' cleaned data'];
title(curTitle);

%% x axis
firstDeparture = 3600 * 6;
lastArrival = 3600 * 26;

xticks(3600*[4:26]);
xticklabels({'4','5','6','7','8','9','10','11','12','13','14','15',...
            '16','17','18','19','20','21','22','23','0','1','2'});
xlim([3600*(floor(firstDeparture/3600)), 3600*(ceil(lastArrival/3600))]);
xlabel('Time of day (h)');

%% y axis
ylim([1,size(routeCellArray,1)]);
yticks([1:size(routeCellArray,1)]);
yticklabels({routeCellArray{:,4}});

%% set font
set(gca,'FontSize',8);
end

%% plot the scheduled timetable
function [firstDeparture,lastArrival] = plotScheduledTimetable(...
                                            TripDetail,TripSummary,GraphSpec)
nRows = length(TripDetail);

firstDeparture = inf;
lastArrival = -1;

executingtrip=[TripSummary([TripSummary.executed]==1 ).gtfsTripID];



for iRow = 1:nRows-1
    if TripDetail(iRow+1).gtfsTripID ~= TripDetail(iRow).gtfsTripID 
        continue;
    end
    tripID = TripDetail(iTripDetail).gtfsTripID;
    
    isexecuted = ~isempty(find(executingtrip==tripID));
%     if TripDetail(iRow).scheduledDepartureTime < firstDeparture
%         firstDeparture = TripDetail(iRow).scheduledDepartureTime;
%     end
%    
    if isexecuted
        if TripDetail(iRow + 1).gtfsArrival > lastArrival
            lastArrival = TripDetail(iRow + 1).gtfsArrival;
        end

        x_1 = TripDetail(iRow ).gtfsArrival;
        x_2 = TripDetail(iRow + 1).gtfsArrival;
        y_1 = TripDetail(iRow).sequence;
        y_2 = TripDetail(iRow + 1).sequence;

        lh = plot([x_1,x_2],[y_1,y_2],GraphSpec.lineStyle);
        lh.Color = 'r';
        lh.LineWidth = GraphSpec.lineWidth;
        hold on;
        
    end
end
end

%% plot real trajecotry from AVL data
function [firstDeparture,lastArrival] = plotRealTrajectory(TripDetail,TripSummary,...
                                                            GraphSpec)
firstDeparture = inf;
lastArrival = -1;

executingtrip=[TripSummary([TripSummary.executed]==1 ).gtfsTripID];

itest=0;
a = colormap(hsv(5));
nRows = length(TripDetail);
for iRow = 1:nRows-1
%     iRow
%     
    tripID = TripDetail(iRow).gtfsTripID;

    isexecuted = ~isempty(find(executingtrip==tripID)) ;
    
    
    avlArr = TripDetail(iRow).estArrival;
    
    avlDep =  TripDetail(iRow).estDeparture;
    
    if length(avlArr)==1 && length(avlDep)==1 && isexecuted

        if TripDetail(iRow+1).gtfsTripID ~= TripDetail(iRow).gtfsTripID 
            continue;
        end

        if TripDetail(iRow).estDeparture < firstDeparture
            firstDeparture = TripDetail(iRow).estDeparture;
        end

        if TripDetail(iRow + 1).estArrival > lastArrival
            lastArrival = TripDetail(iRow + 1).estArrival;
        end
    %     
    
        if TripDetail(iRow ).sequence ==28
            itest= itest+1;
        end
        x_0 = TripDetail(iRow).estArrival;
        x_1 = TripDetail(iRow).estDeparture;
        x_2 = TripDetail(iRow + 1).estArrival;
        y_0 = TripDetail(iRow).sequence;
        y_1 = TripDetail(iRow).sequence;
        y_2 = TripDetail(iRow + 1).sequence;
        try
        lh = plot([x_0,x_1,x_2],[y_0,y_1,y_2],GraphSpec.lineStyle);

        lh.Color = 'b';

        lh.LineWidth = GraphSpec.lineWidth;
        catch


            'Probleme'
        end
        hold on;
        
    end


end

end

%% plot on-board occupancy
function [firstDeparture,lastArrival] = plotOccupancy(TripDetail,TripSummary,GraphSpec)

%% variable declarations
firstDeparture = inf;
lastArrival = -1;

%% colormap configuration
maxVal = 100;
minVal = 0;
cmap = jet(maxVal-minVal);
% cmap = flipud(cmap);

% plot
nRows = length(TripDetail);
for iRow = 1:nRows-1
    if TripDetail(iRow+1).gtfsTripID ~= TripDetail(iRow).gtfsTripID 
        continue;
    end
    
    if TripDetail(iRow).estDeparture < firstDeparture
        firstDeparture = TripDetail(iRow).estDeparture;
    end
    
    if TripDetail(iRow + 1).estArrival > lastArrival
        lastArrival = TripDetail(iRow + 1).estArrival;
    end
    
    x_0 = TripDetail(iRow).estArrival;
    x_1 = TripDetail(iRow).estDeparture;
    x_2 = TripDetail(iRow + 1).estArrival;
    y_0 = TripDetail(iRow).sequence;
    y_1 = TripDetail(iRow).sequence;
    y_2 = TripDetail(iRow + 1).sequence;
    
    lh = plot([x_0,x_1,x_2],[y_0,y_1,y_2],GraphSpec.lineStyle);
    occupancy = round(100 * TripDetail(iRow).load/150);
    lh.Color = cmap(min(100,occupancy+1),:); 
    lh.LineWidth = GraphSpec.lineWidth;
    hold on;
end

% show colorabr
colormap(cmap);
colorbar;
% change colorbar's tick
hcb = colorbar;
set(hcb,'Ticks',[0,0.2,0.4,0.6,0.8,1]);
set(hcb,'TickLabels',{'0','20','40','60','80','100'});

end



