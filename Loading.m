%Codey Nacke

close all

global L N W
L = 100; %Max size of generated boxes
N = 20; %Number of generated boxes
W = 1000; %Width of truck

schedule = 0.99; %Proportion of new temp to old one

plot = 1;


boxes = randi([20,L],N,2);  %Initial configuration
V = volume(boxes(:,:,end),plot); %Initializing temp
plot = 0;


startingD = V; %Stating temp


for index = 1:100
    boxes = boxes(:,:,end); %Every new itteration delete previous paths from structure
    Ea = volume(boxes(:,:,end),plot); %Get the energy of the current path
    plot = 0;
    Eai = Ea; %Also save as initial energy
    rate = []; %Initialize rate array
    equilib = 0; %Initialize terminator variable
    while equilib ~=1
    path_new = newPath(boxes(:,:,end)); %Generate a new path with function
    Ea_new = volume(path_new,plot); %Energy of new path
    dE = Ea_new-Ea; %Change in energy
    rate = [rate,dE]; %Update rate array
    if dE<=0 || rand < exp(-dE/V) %Conditons to accept change
        boxes = cat(3,boxes,path_new); %Accept the change
        Ea = Ea_new; %Update variables
        
    end

        if length(rate)>100 %If we have done 100 chagnes
            %If the average change over the last 100 changes has been small
            %or if we have reached 1000 trials
            if mean(abs(rate(end-99:end)))<Eai/20 || length(rate)>1000
                equilib = 1; %Terminate while loop
            end
        end
    end
    
    %Plotting
    %Only plot every 10th temperature (adjust for lowere schedules
    if mod(index,10)==0
        plot = (index/10)+1;
    else
        plot = 0;
    end
    
    V = V*schedule %Update the temp and also display it for progress stats
end

%Compare statistics
fprintf('The starting distance is %.4f\n',startingD)
fprintf('The ending distance is %.4f\n',Ea)


%Get the energy by finding the distance between all the points
function Ea = volume(boxes,plot)
    if plot~=0
        figure(plot)
    end
        global W
        Truck = zeros(W,W);
        position = [1,1];
        for i = 1:size(boxes,1)
            if (position(1)+boxes(i,1)) > W
                position(1) = 1;
            end
            
            [~,n] = find(Truck(position(1):position(1)+boxes(i,1),:));
            if isempty(n)
                position(2) = 1;
            else
                position(2) = max(n)+1;
            end

            Truck(position(1):position(1)+boxes(i,1),position(2):position(2)+boxes(i,2)) = 1;
            if plot~=0
                rectangle('Position',[position(1)-1 position(2)-1 boxes(i,1)+1 boxes(i,2)+1],'Curvature',0.1)
            end
%             imagesc(Truck)
            position(1) = position(1) + boxes(i,1)+1;

        end
        [~,n] = find(Truck);
        Ea = max(n)*W;
end

%New path by rversing the order of a random sequence
function boxes = newPath(boxes)
    M = length(boxes);
    i = randi(M);
    j = randi(M);
    boxes(i:j,:) = flipud(boxes(i:j,:));  
end







