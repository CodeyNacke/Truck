global L N W
L = 100; %Max size of generated boxes
N = 100; %Number of generated boxes
W = 1000; %Width of truck
limit = 1; %Lower temperature limit
schedule = 0.9; %Proportion of new temp to old one




boxes = randi([20,L],N,2);  %Initial configuration

figure(1)
    global W L N
    Truck = zeros(W,W);
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
            rectangle('Position',[position(1)-1 position(2)-1 boxes(i,1)+1 boxes(i,2)+1],'Curvature',0.1)
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
            rectangle('Position',[position(1)-1 position(2)-1 boxes(i,1)+1 boxes(i,2)+1],'Curvature',0.1)
%             imagesc(Truck)
            position(1) = position(1) + boxes(i,1)+1;
            
        end
        drawnow
        pause(0.01)
    end
    [~,n] = find(Truck);
    Ea = max(n)*W;