function thetas = viveRotAnalysis(fileLocation)
%viveOrientationAnalysis takes in a folder location. The location should
% have only .csv files which contain position or rotation information from
% the Vive. Outputted is translations, which gives the experiment type,
% ratio between Vive and Vicon, and how much the Vive and Vicon traveled
% each.
%
%
% WARNING: xa,xb, and xy are determined from Vicon data files that
% are generated internally. It is up to the user to determine how
% to implement world coordinates or if they should be left out entirely.
cd(fileLocation)
files = dir('*.csv');
files = {files.name}';
c = 1;
thetas = cell(0);
lFile = length(files);
for i = length(files):-1:1
    fprintf('File %g/%g \n', lFile+1-i, lFile)
    % Filter out so that it's only controller 1
    if ~endsWith(files{i},'control1.csv')
        files(i) = [];
    else
        % Vive rotation angles
        vO = rotationExtract(files{i}(1:end-4));
        % Total angle from Vive between beginning and end
        [thetaV, ~] = rotComp(mean(vO(:,:,1:50),3), mean(vO(:,:,end-50:end),3));
        
        % World rotation angles
        load([files{i}(1:end-12) '.mat'], 'trajectories', 'MarkerNames', 'TrialInfo');
        
        [xa, xb, xy] = pickViveMarkers(trajectories, MarkerNames, TrialInfo, 'L');
        rotMatW = planeRotMats(xa,xb,xy);
        % Total angle of world between beginning and end
        [thetaW, ~] = rotComp(mean(rotMatW(:,:,1:100),3), mean(rotMatW(:,:,end-100:end),3));
        
        thetas{c,1} = pullCategory(files(i));
        thetas{c,2} = thetaV;
        
        thetas{c,3} = thetaW;
        c = c+1;
    end
end
end

function rotMatW = planeRotMats(xa,xb,xy)
%planeRotMats calculates a rotation matrix based on 3 positions
rotMatW = zeros(3,3,length(xa));

for f = 1:length(xa)
    % Calculate normal vectors from points xa,xb,xy
    nab = (xb(f,:)-xa(f,:))/norm(xb(f,:)-xa(f,:));
    nay = (xy(f,:)-xa(f,:))/norm(xy(f,:)-xa(f,:));
    
    n2 = nay;
    n3 = cross(nab,nay);
    n1 = cross(n2,n3);
    
%     disp(n2)
%     disp(n2/norm(n2))
%     fprintf('\n\n\n')

    n3 = n3/norm(n3);
    n1 = n1/norm(n1);
    
    rotMatW(:,:,f) = [n1; n2; n3];
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

function rotsM = rotationExtract(fileName)
% Load up the rotation file and extract the rotation matrices
rots = load([fileName 'RotMat.csv']);
rotsC = cell(length(rots)/3,1);
rotsM = zeros(3,3,length(rots)/3);
c=1;

for i = 1:3:length(rots)-2
    rotsC{c} = rots(i:i+2,:);
    rotsM(:,:,c) = rotsC{c};
    c = c+1;
end
end

function [theta, Q] = rotComp(Rv, Rw)
%rotComp compares rotation matrices. For more information see:
% http://www.boris-belousov.net/2016/12/01/quat-dist/
% Takes in two values, Rv and Rw. If they are 3D matrices, it calculates
% the anles between each rotation matrix. If Rv and Rw are single rotation
% matrices, it calculates theta between them.
theta = zeros(length(Rv),1);
Q = zeros(3,3,length(Rv));
if length(size(Rv))>2
    for frame = 1:length(Rv)
        Q(:,:,frame) = Rv(:,:,frame)*Rw(:,:,frame)';
        theta(frame) = acosd((trace(Q(:,:,frame))-1)/2);
    end
else
    Q = Rv*Rw';
    theta = acosd((trace(Q(:,:,1))-1)/2);
end

end