%% Yash Patel, @yash0307


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

% -------------------------------------------------------------------------
% Step 1.1: Visualize the training images
% -------------------------------------------------------------------------

figure(1) ; clf ;

%@yash0307, scale the image
% show the training object patches.
% Convert the cell to 4-D array.

% @yash0307, there isn't that bug here. The one that is present in
% cricket_ball dataset.
for i=1:30
    trainBoxPatchesArray(:,:,:,i) = trainBoxPatches{i};
end
subplot(1,2,1);
imagesc(vl_imarraysc(trainBoxPatchesArray)) ;
axis off ;
title('Training images (positive samples)') ;
axis equal ;


%@yash0307, generate average model
% Note : This depends on scale.
% This averaged model is obviously a very bad choice.
subplot(1,2,2) ;
imagesc(mean(trainBoxPatchesArray/255,4)) ;
box off ;
title('Average') ;
axis equal ;

% -------------------------------------------------------------------------
% Step 1.2: Extract HOG features from the training images
% -------------------------------------------------------------------------

% @yash, generate HOG feature based model.
% Note : We are limited by the small number of training images.
hogCellSize = 8 ;
trainHog = {} ;
for i = 1:size(trainBoxPatchesArray,4)
  trainHog{i} = vl_hog(single(trainBoxPatchesArray(:,:,:,i)), hogCellSize) ;
end
trainHog = cat(4, trainHog{:}) ;

% -------------------------------------------------------------------------
% Step 1.3: Learn a simple HOG template model
% -------------------------------------------------------------------------

w = mean(trainHog, 4) ;
save('data/signs-model-1.mat', 'w') ;
figure(2) ; clf ;
imagesc(vl_hog('render', w)) ;
colormap gray ;
axis equal ;
title('HOG model') ;

% -------------------------------------------------------------------------
% Step 1.4: Apply the model to a test image
% -------------------------------------------------------------------------
for givenTestImage=1:30
    im = imread(testImages{givenTestImage});
    im = im2single(im);
    % @yash0307, compute HOG on test image.
    % Apply computed HOG on HOG model.
    hog = vl_hog(im, hogCellSize);
    scores = vl_nnconv(hog, w, []);

    figure,
    imagesc(scores) ;
    title('Detection') ;
    colorbar ;

    % -------------------------------------------------------------------------
    % Step 1.5: Extract the top detection
    % -------------------------------------------------------------------------

    [best, bestIndex] = min(scores(:));
    [hy, hx] = ind2sub(size(scores), bestIndex) ;
    x = (hx - 1) * hogCellSize + 1 ;
    y = (hy - 1) * hogCellSize + 1 ;

    modelWidth = size(trainHog, 2) ;
    modelHeight = size(trainHog, 1) ;
    detection = [
      x - 0.5 ;
      y - 0.5 ;
      x + hogCellSize * modelWidth - 0.5 ;
      y + hogCellSize * modelHeight - 0.5 ;] ;

    figure,
    imagesc(im) ; axis equal ;
    hold on ;
    vl_plotbox(detection, 'g', 'linewidth', 5) ;
    title('Response scores') ;
end