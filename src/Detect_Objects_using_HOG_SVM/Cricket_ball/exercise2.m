%% Yash Patel, yash0307

% -------------------------------------------------------------------------
% Step 1.0: Load training data
% -------------------------------------------------------------------------

setup ;


% @yash0307 : Implementation level detail -> From loadData Patches are used
% as cell. Converted to 4-D array here. God Knows why I have to do this.
% But, I don't give a shit since it works :P

%HOG = VL_HOG(IM, CELLSIZE) computes the HOG features for image IM and the 
%specified CELLSIZE. IM can be either grayscale or colour in SINGLE storage
%class. HOG is an array of cells: its number of columns is approximately 
%the number of columns of IM divided by CELLSIZE and the same for the 
%number of rows. The third dimension spans the feature compoents.

% Load the training and testing data (trainImages, trainBoxes, ...)
% The functio takes the ID of the type of traffic sign we want to recognize
% 1 is the 30 km/h speed limit

%@yash0307, loadDa'trainImages', ...
%  'trainBoxes', ...
%  'trainBoxImages', ...
%  'trainBoxLabels', ...
%  'trainBoxPatches', ...
%  'testImages', ...
%  'testBoxes', ...
%  'testBoxImages', ...
%  'testBoxLabels', ...
%  'testBoxPatches', ...
%  'targetClass'} ;ta gives the following

loadData;
%@yash0307, scale the image
% show the training object patches.
% Convert the cell to 4-D array.

% @yash0307, due to some bug with dataset. I did this :D if condition
% thing.
for i=1:30
    if(size(trainBoxPatches{i},3) == 3)
        trainBoxPatchesArray(:,:,:,i) = trainBoxPatches{i};
    else
        trainBoxPatchesArray(:,:,1,i) = zeros(size(trainBoxPatches{i}));
        trainBoxPatchesArray(:,:,2,i) = zeros(size(trainBoxPatches{i}));
        trainBoxPatchesArray(:,:,3,i) = zeros(size(trainBoxPatches{i}));
    end
end

% Compute HOG features of examples (see Step 1.2)
hogCellSize = 8 ;
trainHog = {} ;
for i = 1:size(trainBoxPatches,4)
  trainHog{i} = vl_hog(single(trainBoxPatchesArray(:,:,:,i)), hogCellSize) ;
end
trainHog = cat(4, trainHog{:}) ;

% Learn a trivial HOG model (see Step 1.3)
w = mean(trainHog, 4) ;
save('data/cricket_bat-model-1.mat', 'w', 'targetClass') ;

figure(2) ; clf ;
imagesc(vl_hog('render', w)) ;
colormap gray ; axis equal off ;
title('Trivial HOG model') ;

% -------------------------------------------------------------------------
% Step 2.1: Multi-scale detection
% -------------------------------------------------------------------------

% Scale space configuraiton
minScale = -1 ;
maxScale = 3 ;
numOctaveSubdivisions = 3 ;
scales = 2.^linspace(...
  minScale,...
  maxScale,...
  numOctaveSubdivisions*(maxScale-minScale+1)) ;


im = imread(testImages{16}) ;
im = im2single(im) ;

figure(5) ; clf ;
detection = detectAtMultipleScales(im, w, hogCellSize, scales) ;

figure(6) ; clf ;
imagesc(im) ; axis equal off ; hold on ;
vl_plotbox(detection, 'g', 'linewidth', 2) ;
title('Trivial detector output') ;

% -------------------------------------------------------------------------
% Step 2.2: Collect positive and negative trainign data
% -------------------------------------------------------------------------

% Collect positive training data
pos = trainHog ;

% Collect negative training data
neg = {} ;
modelWidth = size(trainHog, 2) ;
modelHeight = size(trainHog, 1) ;
for t=1:numel(trainImages)
  % Get the HOG features of a training image
  t = imread(trainImages{t}) ;
  t = im2single(t) ;  
  hog = vl_hog(t, hogCellSize) ;
  
  % Sample uniformly 5 HOG patches
  % Assume that these are negative (almost certain)
  width = size(hog,2) - modelWidth + 1 ;
  height = size(hog,1) - modelHeight + 1 ;
  index = vl_colsubset(1:width*height, 10, 'uniform') ;

  for j=1:numel(index)
    [hy, hx] = ind2sub([height width], index(j)) ;
    sx = hx + (0:modelWidth-1) ;
    sy = hy + (0:modelHeight-1) ;
    neg{end+1} = hog(sy, sx, :) ;
  end
end
neg = cat(4, neg{:}) ;

% -------------------------------------------------------------------------
% Step 2.3: Learn a model with an SVM
% -------------------------------------------------------------------------

numPos = size(pos,4) ;
numNeg = size(neg,4) ;
C = 10 ;
lambda = 1 / (C * (numPos + numNeg)) ;

% Pack the data into a matrix with one datum per column
x = cat(4, pos, neg) ;
x = reshape(x, [], numPos + numNeg) ;

% Create a vector of binary labels
y = [ones(1, size(pos,4)) -ones(1, size(neg,4))] ;

% Learn the SVM using an SVM solver
w = vl_svmtrain(x,y,lambda,'epsilon',0.01,'verbose') ;

% Reshape the model vector into a model HOG template
w = single(reshape(w, modelHeight, modelWidth, [])) ;
save('data/signs-model-2.mat', 'w', 'targetClass') ;

% Plot model
figure(7) ; clf ;
imagesc(vl_hog('render', w)) ;
colormap gray ; axis equal off ;
title('SVM HOG model') ;

% -------------------------------------------------------------------------
% Step 2.4: Evaluate learned model
% -------------------------------------------------------------------------

% Compute detections
figure(8) ; clf ;
detection = detectAtMultipleScales(im, w, hogCellSize, scales) ;

% Plot top detection
figure(9) ; clf ;
imagesc(im) ; axis equal off ; hold on ;
vl_plotbox(detection, 'g', 'linewidth', 2) ;
title('SVM detector output') ;