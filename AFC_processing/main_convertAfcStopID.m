clc;clear all;

%% add data path
addpath('D:\GitHub\DenHaagTransitResearch\dbconnection');
addpath('D:\GitHub\DenHaagTransitResearch\commondata');
load('RouteSet.mat');
load('DateList.mat');

%% get connected to the database. This is a local postgre database
DB.username = 'postgres';
DB.passwd = '8213162';
DB.name = 'den_haag_htm';
DB.schema = 'public';
conn = connectPostgreSQL(DB.username,DB.passwd,DB.name);
% set the data format
setdbprefs('DataReturnFormat','cellarray');

%% 
fidA = fopen('erroneous_data.csv','w');
fidB = fopen('htm_afc_rides_march.csv','w');
fprintf(fidB,['lineID,operatingdate,dirID,checkinstop,checkoutstop,'...
    'checkintime,checkouttime\n']);

%%
newLineList = [1,2,3,4,6,9,11,12,15,16,17,19,18,21,22,23,24,25,26,28];
nDates = length(DateList);


t = 1;
errorArray = [];
for curLineID = newLineList
    nErrors = 0;
    errorArray(t,1) = curLineID;
    for iDate = 1:nDates
        curDate = DateList(iDate).date;
        
        dayOfYear = 60 + str2num(curDate) - 20150301;
        
        %% STEP 1: get one-day demand of a line from the database
        query = ['select lineid,oriid,desid,oriname,desname,'...
            'checkintime,checkouttime, dayofyear from htm_afc where '...
            'lineid = ' int2str(curLineID) ' and ((dayofyear = '...
            int2str(dayOfYear) ' and checkintime <= 86400 and ' ...
            'checkintime >= 14400) or (dayofyear = ' int2str(dayOfYear + 1)...
            ' and checkintime < 14400)) order by checkintime '];
        
        data = fetch(conn,query);
        %% STEP 2: replace htm stop ids with gtfs stop ids by checking stop o/d names and sequence.
        % The most reliable way to achieve this replacement is to use names instead
        % of other id indecies.
        
        % find both directions' stops which have been ordered
        gtfsLineID = ['HTM:' num2str(curLineID)];
        % direction 0
        dirZeroIdx = find([RouteSet.direction_id] == 0 & ...
                           strcmp({RouteSet.id},gtfsLineID));
        dirZeroStopArray = RouteSet(dirZeroIdx).stops;
        % direction 1
        dirOneIdx = find([RouteSet.direction_id] == 1 & ...
                          strcmp({RouteSet.id},gtfsLineID));
        dirOneStopArray = RouteSet(dirOneIdx).stops;
       
        for i = 1:size(data,1)
            
            o_name = data{i,4};
            d_name = data{i,5};
            
            if data{i,2} == 30002
                o_name = 'Den Haag, Moerweg';
            end
            
            if data{i,3} == 30002
                d_name = 'Den Haag, Moerweg';
            end
            
            
            checkintime = data{i,6};
            checkouttime = data{i,7};
            tt = checkouttime - checkintime; % travel time between od
            % skip lines with abnormal trips with 'unidentified' stop 
            % names from database, and travel time > 60 min
            if strcmp(o_name,'Den Haag, Laan van Clingendael ')
                o_name = 'Den Haag, Laan van Clingendael';
            end
            if strcmp(d_name,'Den Haag, Laan van Clingendael ')
                d_name = 'Den Haag, Laan van Clingendael';
            end
            
            if strcmp(o_name,'Den Haag, Jozef Israelsplein')
                o_name = 'Den Haag, Jozef Israëlsplein';
            end
            if strcmp(d_name,'Den Haag, Jozef Israelsplein')
                d_name = 'Den Haag, Jozef Israëlsplein';
            end           
            
            if strcmp(o_name,'Rijswijk, Station Rijswijk')
                o_name = 'Rijswijk, Rijswijk Station';
            end    
            if strcmp(d_name,'Rijswijk, Station Rijswijk')
                d_name = 'Rijswijk, Rijswijk Station';
            end

            if strcmp(o_name,'Voorburg, Station Voorburg')
                o_name = 'Voorburg, Voorburg Station';
            end    
            if strcmp(d_name,'Voorburg, Station Voorburg')
                d_name = 'Voorburg, Voorburg Station';
            end

            if strcmp(o_name,'Voorburg, Mgr. van Steelaan')
                o_name = 'Voorburg , Mgr. van Steelaan';
            end    
            if strcmp(d_name,'Voorburg, Mgr. van Steelaan')
                d_name = 'Voorburg , Mgr. van Steelaan';
            end
            
            if strcmp(o_name,'Den Haag, Laan van Nieuw Oost Indie')
                o_name = 'Den Haag, Laan van Nieuw Oost Indië';
            end               
            if strcmp(d_name,'Den Haag, Laan van Nieuw Oost Indie')
                d_name = 'Den Haag, Laan van Nieuw Oost Indië';
            end         

            if strcmp(o_name,'Den Haag, Oude Waalsdorperweg')
                o_name = 'Den Haag, Waalsdorperweg';
            end               
            if strcmp(d_name,'Den Haag, Oude Waalsdorperweg')
                d_name = 'Den Haag, Waalsdorperweg';
            end     
            
            if tt > 5400 ...
                    || strcmp('unidentified', o_name)...
                    || strcmp('unidentified', d_name)
                
                fprintf(fidA,'%d;%d;%d;%s;%s;%d;%d;%d\n', data{i,1},data{i,2},...
                    data{i,3},data{i,4},data{i,5},data{i,6},data{i,7},data{i,8});
                nErrors = nErrors + 1; 
                continue;
            end
            % find seq id
            o_seqid_0 = find(strcmpi(dirZeroStopArray(:,3), o_name));
            d_seqid_0 = find(strcmpi(dirZeroStopArray(:,3), d_name));
            o_seqid_1 = find(strcmpi(dirOneStopArray(:,3), o_name));
            d_seqid_1 = find(strcmpi(dirOneStopArray(:,3), d_name));
                       
            if ~isempty(o_seqid_0) && ~isempty(d_seqid_0) &&...
                    ~isempty(o_seqid_1) && ~isempty(d_seqid_1)
                if o_seqid_0 < d_seqid_0
                    curDirID = 0;
                    o_id = dirZeroStopArray{o_seqid_0,2};
                    d_id = dirZeroStopArray{d_seqid_0,2};
                else
                    curDirID = 1;
                    o_id = dirOneStopArray{o_seqid_1,2};
                    d_id = dirOneStopArray{d_seqid_1,2};
                end
            else
                if ~isempty(o_seqid_0) && ~isempty(d_seqid_0)
                    curDirID = 0;
                    o_id = dirZeroStopArray{o_seqid_0,2};
                    d_id = dirZeroStopArray{d_seqid_0,2};  
                elseif ~isempty(o_seqid_1) && ~isempty(d_seqid_1)
                    curDirID = 1;
                    o_id = dirOneStopArray{o_seqid_1,2};
                    d_id = dirOneStopArray{d_seqid_1,2};
                else
                    % this is the problem case
                    fprintf(fidA,'%d;%d;%d;%s;%s;%d;%d;%d\n', data{i,1},...
                        data{i,2},data{i,3},data{i,4},data{i,5},...
                        data{i,6},data{i,7},data{i,8});
                    nErrors = nErrors + 1;
                    continue;
                end
            end

            if checkintime < 14400 % records after midnight
                checkintime = checkintime + 3600*24;
                checkouttime = checkouttime + 3600*24;
            end
            
            fprintf(fidB,'%d,%d,%s,%d,%d,%d,%d\n',curLineID,curDirID,...
                curDate,o_id,d_id,checkintime,checkouttime);
      
        end % end data loop
    end  % end date loop
    errorArray(t,2) = nErrors;
    t = t + 1;
    fprintf('line %d is finished.\n', curLineID);
end % end line loop

fclose(fidA);
fclose(fidB);