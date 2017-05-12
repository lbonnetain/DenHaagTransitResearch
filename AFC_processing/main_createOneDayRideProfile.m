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
nDates = length(DateList);
for curLineID = 3
    for iDate = 1:nDates
        curDate = DateList(iDate).date;
        %% STEP 1: get one-day demand of a line from the database
        query = ['select lineid,dirid,operatingdate,checkinstopid,'...
                 'checkoutstopid,checkintime,checkouttime from htm_afc '...
                 'where lineid = ' int2str(curLineID) ' and operatingdate'...
                 '= ' curDate ' order by checkintime'];
             
        data = fetch(conn,query);
        singleRideArray = cell2mat(data);
        datafilename = ['ride_line' int2str(curLineID) '_' curDate '.mat'];
        save(datafilename,'singleRideArray');
        singleRideArray = [];
    end
end

close(conn);
             