%% Yash Patel, @yash0307 %

% Extract and save objects saperately. %

clear all
directories = {'cricket_batting','cricket_bowling','croquet','tennis_forehand','tennis_serve','volleyball_smash'};
nmatf = {1:3,4:5,6:8,9:10,11:12,13:14};
matfiles = {'batting_bat','batting_ball','batting_stumps','bowling_ball','bowling_stumps','croquet_mallet','croquet_ball','croquet_hoop','forehand_ball','forehand_racquet','serve_ball','serve_racquet','smash_ball','smash_net'};
warning off;

counter = 1;
for d=1:6

directory = ['./' directories{d} '/'];

for t=1:numel(nmatf{d})
    load(['object_annotations/' matfiles{nmatf{d}(t)}])
    O{t} = object;
    clear object;
end

for t=1:numel(nmatf{d})
      for f=1:30
      im = imread([directory 'train/image' num2str(f,'%02d') '.png']);
      n = 1;
          if(O{t}{f}(n,2)+O{t}{f}(n,4) < size(im,1) && O{t}{f}(n,3)+O{t}{f}(n,1) < size(im,2))
            if(O{t}{f}(n,1)&&O{t}{f}(n,2)&&O{t}{f}(n,3)&&O{t}{f}(n,4))
                im_object = imresize(im(O{t}{f}(n,2):O{t}{f}(n,2)+O{t}{f}(n,4) , O{t}{f}(n,1):O{t}{f}(n,3)+O{t}{f}(n,1), :), [64 64]);
                imwrite(im_object, char(strcat('./Objects/cricket_bat/', 'image',num2str(counter,'%02d'), '.png')));
                imshow(im_object)
            else
                im_object = imresize(im(1:20, 1:20, :), [64 64]);
                imwrite(im_object, char(strcat('./Objects/cricket_bat/', 'image',num2str(counter,'%02d'), '.png')));
                imshow(im_object)
            end
            counter = counter + 1;
            pause()
          end
      end
      
      
      hold off;
end

end
warning on;