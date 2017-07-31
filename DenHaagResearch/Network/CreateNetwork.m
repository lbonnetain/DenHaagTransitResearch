function [ Network ] = CreateNetwork(Network, Nlink,RouteSetDir,StopList, shapes,dir )
%% 
% This is the function to save all data needed to visualize the network
% from three soucres of data for one given direction.
% BE CAREFUL
% This function update the current network data, this need to be done
% to add data from the dir 1 and dir 0
%--------------------------------------------------------------------------
% Inputs
%   - shapes files (geometry of the network)
%   - RouteSet (composition of the network : routes and stop name)
%   - StopList (coordonate of each stop) this data set allow to merge
%   shapes and RoutSet data
% Outputs
%   - Network data which contains every links for all routes with different fields :
%     - dir -> direction
%     - Routes -> Routes name
%     - FromStop ID -> (beginning of the link) FromStop ID of RouteSet
%     - ToStop ID -> (end of the link) ToStop ID of RouteSet
%     - FromStop name
%     - ToStop name
%     - id Curve_coord -> double with the Raw_id in shape for the FromStop and
%                                         Raw_id in shape for the ToStop
%     - Curves_coords ->geometry of the link between (FromStop ID and ToStop ID)
%                       e.g all coordonate from shapes file of the link 
%--------------------------------------------------------------------------
% Last updated by Bonnetain Loic, 2017/07/28

%% code
iV_n = length([Network.dir])-1; %iV_n is the the id of the link in the network
nRoutes = size(RouteSetDir,2); % number of line

%Initialization
Network(Nlink).dir = 0;
DeltaNorm(Nlink).From = [0 0];
DeltaNorm(Nlink).To = [0 0];


for iRoute = 1 : nRoutes %go through each route
    
    Route = cell2mat(RouteSetDir(iRoute).stops(:,2)); 
    nLink = size(RouteSetDir(iRoute).stops,1)-1;
    
    for jLink = 1 : nLink %go through each link of iRoute
        
         iV_n = 1 + iV_n;
         
         %--- save usefull data ---%
         Network(iV_n).dir = dir; 
         Network(iV_n).Routes = RouteSetDir(iRoute).id;  
         Network(iV_n).From_Stop_id = Route(jLink);
         Network(iV_n).To_Stop_id = Route(jLink+1); 
         
         eps = 0.0005; % error uncertainity for matching the coordonate between 
                       % shape file and StopList
                       
         %---  find idFrom in shape file ---%
         idFrom = [StopList.id] == Route(jLink);
         Network(iV_n).From_Stop_name = StopList(idFrom).name;
         coord_From_Stop = [ StopList(idFrom).Y  StopList(idFrom).X ];
         id_From =find( abs(shapes(:,4) - coord_From_Stop(2)) < eps ...
                      & abs(shapes(:,3) - coord_From_Stop(1)) < eps ...
                      & shapes(:,1) == [RouteSetDir(iRoute).shape_id]);
                       
         DeltaFrom = shapes(id_From,3:4) - coord_From_Stop;
         NbFrom = length(id_From);
         if NbFrom ~=1             
             if NbFrom == 0                 
                 id_From = Network(iV_n-1).id_Curves_coords(1);                 
             else              
                 for iDF = 1 : length(DeltaFrom(:,1))
                     DeltaNorm(iV_n).From(iDF) = norm(DeltaFrom(iDF));
                 end
                 
                 id_From= min(id_From([DeltaNorm(iV_n).From] == ...
                                           min([DeltaNorm(iV_n).From])));  
             end
         end
         
         %---  find idTo in shape file---%
         idStop = [StopList.id]==Route(jLink+1) ;
         Network(iV_n).To_Stop_name = StopList(idStop).name;
         coord_To_Stop = [ StopList(idStop).Y  StopList(idStop).X ];
         id_To = find(abs(shapes(:,4)-coord_To_Stop(2)) < eps ...
                    & abs(shapes(:,3)-coord_To_Stop(1)) < eps ...
                    & shapes(:,1) == [RouteSetDir(iRoute).shape_id]);
  
         DeltaTo = shapes(id_To,3:4) - coord_To_Stop;
         NbTo = length(id_To);
         if NbTo ~=1             
             if NbTo == 0  
                 id_To = id_From ;  
             else 
                 for iDT = 1 : length(DeltaTo(:,1))
                     DeltaNorm(iV_n).To(iDT) = norm(DeltaTo(iDT));
                 end
                 id_To = min(id_To([DeltaNorm(iV_n).To] == ...
                                       min([DeltaNorm(iV_n).To])));
             end
         end

         Network(iV_n).id_Curves_coords = [id_From;id_To];
         Network(iV_n).Curves_coords = [shapes(id_From:id_To,3)...
                                        shapes(id_From:id_To,4)...
                                        shapes(id_From:id_To,5)];
    end   
    
end
