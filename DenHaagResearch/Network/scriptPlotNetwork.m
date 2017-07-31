clear all
close all

tic
%% IMPUT

load('RouteSet.mat')
load('StopList.mat')
shapes = csvread('shapes.txt',1);

dir=1; % can be changed : 0 or 1 (usefull only for the plot)

%% script
[Nlink]=CalculateNbLinkNetwork(RouteSet);
Network(Nlink).dir = 1; %initilialization

%direction 0
RouteSetDir = RouteSet([RouteSet.direction_id]==0);
[ Network ] = CreateNetwork(Network,Nlink, RouteSetDir,StopList, shapes,0 );
%direction 1
RouteSetDir = RouteSet([RouteSet.direction_id]==1);
[ Network ] = CreateNetwork(Network,Nlink, RouteSetDir,StopList, shapes,1 );

%plot the whole network
fig = figure;
set(fig, 'Units', 'Normalized', 'Position', [0 0 1 1]);
Routes = {RouteSetDir.id};

for iRoutes = Routes
    PlotNetworkOneLineOneDir(Network, iRoutes,0 );
end
toc
