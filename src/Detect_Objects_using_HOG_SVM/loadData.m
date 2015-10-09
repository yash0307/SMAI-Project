function loadData()
%   Yash Patel, @yash0307
%   LOADDATA(TARGETCLASS, NUMPOSIMAGES, NUMNEGIMAGES) allows specifying
%   the number of positive and negative images too.
%
%   The following variables are created in the workspace:
%
%   - trainImages: list of training image names.
%   - trainBoxes: 4 x N array of object bounding boxes
%   - trainBoxImages: for each box, the corresponding image.
%   - trainBoxLabels: the class label of the box (one of TARGETCLASS).
%   - trainBoxPatches: 64 x 64 x 3 x N array of box patches.
%
%   The same for the test data.

if nargin < 2
  numPosImages = 20 ;
end

if nargin < 3
  numNegImages = 20 ;
end
targetClass = 'cricket_batting';
%load('data/signs.mat', ...
%  'trainImages', ...
%  'trainBoxes', ...
%  'trainBoxImages', ...
%  'trainBoxLabels', ...
%  'trainBoxPatches', ...
%  'testImages', ...
%  'testBoxes', ...
%  'testBoxImages', ...
%  'testBoxLabels', ...
%  'testBoxPatches') ;
% Give corresponding training set. %
%if(strcmp(lower(targetClass), 'cricket_batting') == 0)
        target_url = '../../Dataset/pami2009_release/pami09_preRelease/cricket_batting/train/';
        for i=1:30
            target_url_image = strcat(target_url,'image',num2str(i,'%02d'), '.png');
            trainImages(i) = {target_url_image};
            trainBoxImages(i) = {target_url_image};
            testImages(i) = {target_url_image};
            testBoxImages(i) = {target_url_image};
        end
        trainImages = trainImages';
        testImages = testImages';
        trainBoxImages = trainBoxImages';
        testBoxImages = testBoxImages';
%end
% Specify the corresponding hash mapping. %
if isstr(targetClass)
  switch lower(targetClass)
    case 'cricket_batting', targetClass = [1], targetClass_num = 1;
  end
end
% Find trainBox and trainBoxImages. %
trainBoxes = zeros(4,30);
testBoxes  = zeros(4,30);
directories = {'cricket_batting','cricket_bowling','croquet','tennis_forehand','tennis_serve','volleyball_smash'};
nmatf = {1:3,4:5,6:8,9:10,11:12,13:14};
matfiles = {'batting_bat','batting_ball','batting_stumps','bowling_ball','bowling_stumps','croquet_mallet','croquet_ball','croquet_hoop','forehand_ball','forehand_racquet','serve_ball','serve_racquet','smash_ball','smash_net'};
directory = ['../../Dataset/pami2009_release/pami09_preRelease/' directories{targetClass_num} '/'];
for t=1:numel(nmatf{targetClass_num})
    load(['../../Dataset/pami2009_release/pami09_preRelease/object_annotations/' matfiles{nmatf{targetClass_num}(t)}])
    O{t} = object;
    clear object;
end
for t=1:1
      for f=1:30
      im = imread([directory 'train/image' num2str(f,'%02d') '.png']);
      n=1;
      %if(O{t}{f}(n,1)&&O{t}{f}(n,2)&&O{t}{f}(n,3)&&O{t}{f}(n,4))
      %  im_object = im(O{t}{f}(n,2):O{t}{f}(n,2)+O{t}{f}(n,4) , O{t}{f}(n,1):O{t}{f}(n,3)+O{t}{f}(n,1), :);
      %  imshow(im_object)
      %  pause()
      %else
      %  im_object = im(1:20,1:20, :);
      %  imshow(im_object)
      %  pause()
      %end
      %pause()
      if(O{t}{f}(n,2)+O{t}{f}(n,4) < size(im,1) && O{t}{f}(n,3)+O{t}{f}(n,1) < size(im,2))
          trainBoxes(2,f) = O{t}{f}(n,2);
          trainBoxes(1,f) = O{t}{f}(n,1);
          trainBoxes(4,f) = O{t}{f}(n,2)+O{t}{f}(n,4);
          trainBoxes(3,f) = O{t}{f}(n,3)+O{t}{f}(n,1);
          
          testBoxes(2,f) = O{t}{f}(n,2);
          testBoxes(1,f) = O{t}{f}(n,1);
          testBoxes(4,f) = O{t}{f}(n,2)+O{t}{f}(n,4);
          testBoxes(3,f) = O{t}{f}(n,3)+O{t}{f}(n,1);
      end
      end
end
trainBoxLabels = zeros(30,1);
testBoxLabels = zeros(30,1);
trainBoxPatches = zeros(64,64,3,30);
testBoxPatches = zeros(64,64,3,30);
for i = 1:30
    trainBoxLabels(i) = targetClass_num;
    testBoxLabels(i) = targetClass_num;
    file_path = strcat('../../Dataset/pami2009_release/pami09_preRelease/Objects/cricket_bat/image', num2str(i,'%02d'), '.png');
    im = imread(file_path);
    trainBoxPatches(:,:,1,i) = uint8(im(:,:,1));
    trainBoxPatches(:,:,2,i) = uint8(im(:,:,2));
    trainBoxPatches(:,:,3,i) = uint8(im(:,:,3));
    
    testBoxPatches(:,:,1,i) = uint8(im(:,:,1));
    testBoxPatches(:,:,2,i) = uint8(im(:,:,2));
    testBoxPatches(:,:,3,i) = uint8(im(:,:,3));
end
%====================================================%
%ok = ismember(trainBoxLabels, targetClass) ;
%trainBoxes = trainBoxes(:,ok) ;
%trainBoxImages = trainBoxImages(ok) ;
%trainBoxLabels = trainBoxLabels(ok) ;
%trainBoxPatches = trainBoxPatches(:,:,:,ok) ;

%ok = ismember(testBoxLabels, targetClass) ;
%testBoxes = testBoxes(:,ok) ;
%testBoxImages = testBoxImages(ok) ;
%testBoxLabels = testBoxLabels(ok) ;
%testBoxPatches = testBoxPatches(:,:,:,ok) ;

% Select a subset of training and testing images
%[~,perm] = sort(ismember(trainImages, trainBoxImages),'descend') ;
%trainImages = trainImages(vl_colsubset(perm', numPosImages, 'beginning')) ;

%[~,perm] = sort(ismember(testImages, testBoxImages),'descend') ;
%testImages = testImages(vl_colsubset(perm', numNegImages, 'beginning')) ;
  
vars = {...
  'trainImages', ...
  'trainBoxes', ...
  'trainBoxImages', ...
  'trainBoxLabels', ...
  'trainBoxPatches', ...
  'testImages', ...
  'testBoxes', ...
  'testBoxImages', ...
  'testBoxLabels', ...
  'testBoxPatches', ...
  'targetClass'} ;

for i = 1:numel(vars)
  assignin('caller',vars{i},eval(vars{i})) ;
end
