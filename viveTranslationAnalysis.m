function translations = viveTranslationAnalysis(fileLocation)
%viveTranslationAnalysis takes in a folder location. The location should
%have only .csv files which contain position or rotation information from
%the Vive. Outputted is translations, which gives the experiment type,
%ratio between Vive and Vicon, and how much the Vive and Vicon traveled
%each.
%
%
% WARNING: xa,xb, and xy are determined from Vicon data files that
% are generated internally. It is up to the user to determine how
% to implement world coordinates or if they should be left out entirely.
cd(fileLocation)
files = dir('*.csv');
files = {files.name}';
c = 1;
translations = cell(0);
lFile = length(files);

% Euclidean distance anonymous function
euclid3D = @(x1,x2,y1,y2,z1,z2) sqrt((x2-x1).^2 + (y2-y1).^2 + (z2-z1).^2);
for i = length(files):-1:1
    fprintf('File %g/%g \n', lFile+1-i, lFile)
    % Filter out so that it's only controller 1
    if ~endsWith(files{i},'control1.csv')
        files(i) = [];
    else
        % Total distance traveled by Vive between beginning and end
        traj = load(files{i});
        posStartVive = [mean(traj(1:50,1)), mean(traj(1:50,2)), mean(traj(1:50,3))];
        posEndVive = [mean(traj(end-50:end,1)), mean(traj(end-50:end,2)), mean(traj(end-50:end,3))];
        transVive = euclid3D(posStartVive(1), posEndVive(1), posStartVive(2), posEndVive(2),...
            posStartVive(3), posEndVive(3));
        
        % Total distance traveled by Vicon between beginning and end
        load([files{i}(1:end-12) '.mat'], 'trajectories', 'MarkerNames', 'TrialInfo');
        [xa, ~, ~] = pickViveMarkers(trajectories, MarkerNames, TrialInfo, 'L');
        posStartWorld = [mean(xa(1:100,1)), mean(xa(1:100,2)), mean(xa(1:100,3))];
        posEndWorld = [mean(xa(end-100:end,1)), mean(xa(end-100:end,2)), mean(xa(end-100:end,3))];
        
        transWorld = euclid3D(posStartWorld(1), posEndWorld(1), posStartWorld(2), posEndWorld(2),...
            posStartWorld(3), posEndWorld(3));
        
        translations{c,1} = pullCategory(files(i));
        translations{c,2} = transWorld/transVive;
        translations{c,3} = transWorld;
        translations{c,4} = transVive;
        c = c+1;
        
    end
end
end

function [xa, xb, xy] = pickViveMarkers(trajectories, MarkerNames, TrialInfo, hand)
%pickViveMarkers picks which Vive markers to use to calculate the LCS.
% This is done on the basis that the marker should have no place where it
% equals 0, because this would mean the trial is either cropped incorrectly
% or there is a missing marker.
%
% A reminder that markers should be gap filled as little as possible
% because it is possible to calculate the LCS on only 3 markers.
if strcmp(hand, 'R')
    RVW1 = trajectories{(strcmp(MarkerNames, 'Right VW1')),1}{1:TrialInfo.EndTrial,:};
    RVW2 = trajectories{(strcmp(MarkerNames, 'Right VW2')),1}{1:TrialInfo.EndTrial,:};
    RVW3 = trajectories{(strcmp(MarkerNames, 'Right VW3')),1}{1:TrialInfo.EndTrial,:};
    RVW4 = trajectories{(strcmp(MarkerNames, 'Right VW4')),1}{1:TrialInfo.EndTrial,:};
    RV = {RVW1 RVW2 RVW3 RVW4};
    for marker = 4:-1:1
        if any(RV{marker}) == 0
            RV(marker) = [];
        end
    end
    if length(RV)<3
        error('Not enough valid markers for this trial. Make sure the trial wasn''t cropped')
    end
    xa = RV{1};
    xb = RV{2};
    xy = RV{3};
else
    LVW1 = trajectories{(strcmp(MarkerNames, 'Left VW1')),1}{1:TrialInfo.EndTrial,:};
    LVW2 = trajectories{(strcmp(MarkerNames, 'Left VW2')),1}{1:TrialInfo.EndTrial,:};
    LVW3 = trajectories{(strcmp(MarkerNames, 'Left VW3')),1}{1:TrialInfo.EndTrial,:};
    LVW4 = trajectories{(strcmp(MarkerNames, 'Left VW4')),1}{1:TrialInfo.EndTrial,:};
    LV = {LVW1 LVW2 LVW3 LVW4};
    for marker = 4:-1:1
        if any(LV{marker}) == 0
            LV(marker) = [];
        end
    end
    if length(LV)<3
        error('Not enough valid markers for this trial. Make sure the trial wasn"t cropped')
    end
    xa = LV{1};
    xb = LV{2};
    xy = LV{3};
end
end

function cat = pullCategory(name)
name = split(name,'_');
cat = name{4};
end