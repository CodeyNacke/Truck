%Codey Nacke

close all

global L N W
L = 100; %Max size of generated boxes
N = 200; %Number of generated boxes
W = 1000; %Width of truck

schedule = 0.99; %Proportion of new temp to old one

plot = 1;


boxes = randi([20,L],N,2);  %Initial configuration
V = volume(boxes(:,:,end),plot); %Initializing temp
plot = 0;


startingD = V; %Stating temp
index = 1;

for index = 1:1000
    boxes = boxes(:,:,end); %Every new itteration delete previous paths from structure
    Ea = volume(boxes(:,:,end),plot); %Get the energy of the current path
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
    %Only plot every 200th temperature (adjust for lowere schedules
    if mod(index,100)==0
        plot = 1;
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
    if plot
        figure()
    end
        global W L N
        Truck = zeros(W,L*N);
        position = [1,1];
        for i = 1:size(boxes,1)
            if (position(1)+boxes(i,1)) <= W
                [~,n] = find(Truck(position(1):position(1)+boxes(i,1),:));
                if isempty(n)
                    position(2) = 1;
                else
                    position(2) = max(n)+1;
                end

                Truck(position(1):position(1)+boxes(i,1),position(2):position(2)+boxes(i,2)) = Truck(position(1):position(1)+boxes(i,1),position(2):position(2)+boxes(i,2)) + 1;
                if plot
                    rectangle('Position',[position(1)-1 position(2)-1 boxes(i,1)+1 boxes(i,2)+1],'Curvature',0.1)
                end
    %             imagesc(Truck)
                position(1) = position(1) + boxes(i,1)+1;

            else
                position(1) = 1;
                [~,n] = find(Truck(position(1):position(1)+boxes(i,1),:));
                if isempty(n)
                    position(2) = 1;
                else
                    position(2) = max(n)+1;
                end
                Truck(position(1):position(1)+boxes(i,1),position(2):position(2)+boxes(i,2)) = Truck(position(1):position(1)+boxes(i,1),position(2):position(2)+boxes(i,2)) + 1;
                if plot
                    rectangle('Position',[position(1)-1 position(2)-1 boxes(i,1)+1 boxes(i,2)+1],'Curvature',0.1)
                end
    %             imagesc(Truck)
                position(1) = position(1) + boxes(i,1)+1;

            end
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







