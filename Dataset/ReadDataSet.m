%% Yash Patel and Shrenik Jain %%
% @yash0307


%% Modeling Mutual Context of Object and Human Pose in Human-Object Interaction Activities %%

% Clear all precious variables and screen. %
clear all
clc
warning off;
% Specify base path to the dataset. %
base_path = './pami2009_release/pami09_preRelease/';

% Specify the sports classifying for. %
activity_categories = {'cricket_batting', 'cricket_bowling', 'croquet', 'tennis_forehand', 'tennis_serve', 'volleyball_smash'};

% Specify Object categories. %
object_categories = {'batting_bat', 'batting_ball', 'batting_stumps', 'bowling_ball',... 
    'bowling_stumps', 'croquet_mallet', 'croquet_ball', 'croquet_hoop', 'forehand_ball',...
    'forehand_racquet', 'serve_ball', 'serve_racquet','smash_ball','smash_net'};

% Define a hash map for each actity to object. %
hash_activity_object = {1:3, 4:5, 6:8, 9:10, 11:12, 13:14};

% Loop over each activity category. %
activity_categories_size = size(activity_categories);
object_categories_size = size(object_categories);
for i=1:activity_categories_size(2)
    
    % Loop over each object for a activity type and load the objects. %
    for j=1:numel(hash_activity_object(i))
        
        % Load the object from training annotations. %
        load([base_path 'object_annotations/' object_categories{hash_activity_object{i}(j)}])
        
        % Store the loaded object in some variable. %
        objects{j} = object;
        
        % Clear object for next iteration. %
        clear object;
        
    end
    
    % Read each input image corresponding to each activity. %
    for j=1:30
        
        disp(['Showing' num2str(j)]);
        
        % Read corresponding image. %
        inp_image = imread(char(strcat(base_path,activity_categories(i),'/train/image',num2str(j, '%02d'), '.png')));
        
        % Read corresponding Human pose. %
        inp_human_pose = imread(char(strcat(base_path,activity_categories(i),'/silh/sil', num2str(j, '%02d'), '.png')));
        
        % Plot these input image and corresponding human pose image. %
        subplot(1,2,1);
        imshow(inp_image);
        subplot(1,2,2);
        imshow(inp_human_pose);
        subplot(1,2,1);
        hold on;
        % Mark corresponding object in input image. %
        for k=1:numel(hash_activity_object{i})
            n=1;
            while 1
                if objects{j}{k}(n,3)==0 && objects{j}{k}(n,4)==0
                    break;
                end
                plot([objects{j}{k}(n,1) objects{j}{k}(n,1)+objects{j}{k}(n,3)],[objects{j}{k}(n,2) objects{j}{k}(n,2)],'linewidth',3)
                plot([objects{j}{k}(n,1)+objects{j}{k}(n,3) objects{j}{k}(n,1)+objects{j}{k}(n,3)],[objects{j}{k}(n,2) objects{j}{k}(n,2)+objects{j}{k}(n,4)],'linewidth',3);
                plot([objects{j}{k}(n,1) objects{j}{k}(n,1)+objects{j}{k}(n,3)],[objects{j}{k}(n,2)+objects{j}{k}(n,4) objects{j}{k}(n,2)+objects{j}{k}(n,4)],'linewidth',3);
                plot([objects{j}{k}(n,1) objects{j}{k}(n,1)],[objects{j}{k}(n,2) objects{j}{k}(n,2)+objects{j}{k}(n,4)],'linewidth',3);
                n=n+1;
            end
        end
        pause();
        hold off;
    end
    
end
warning on;