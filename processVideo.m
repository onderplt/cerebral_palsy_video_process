clear all;
[filename,path] = uigetfile('*.avi');
fullname = fullfile(path,filename);
vid = videoread(fullname); % Raad video data into mg struct
vid = videocrop(mg); % Allow the user to crop the video from the first frame
thres = inputdlg('Enter threshold value for absolute difference merthod: ');
[~,vid] = videomotion(vid,'Diff',0,30,'Regular',thres);
totalPixels = video.obj.Width*video.obj.Height;
%Remove outlier values if difference between two frames is greater than some percentage of all pixels
k=1;
percentThresh = 0.8;
for i=1:length(video.qom)
    if(video.qom(i)>(totalPixels*255*percentThresh))
        continue;
    else
        qomtemp(k) = video.qom(i);
        k = k + 1;
    end
end
video.qom = qomtemp;
Qmean = mean(video.qom./(totalPixels*255));
Qtotal = sum(video.qom)/255;
Qtotalnormalized = sum(video.qom./(totalPixels*255));
Qsd = std(video.qom./(totalPixels*255));
%Qmax = max(mg.video.qom./(totalPixels*255));
CXtotal = sum(video.com(:,1));
CYtotal = sum(video.com(:,2));
CXmean = mean(video.com(:,1))/video.endtime;
CYmean = mean(video.com(:,2))/video.endtime;
Cx = video.com(:,1);
Cy = video.com(:,2);
Cr = sqrt(video.com(:,1).^2 + video.com(:,2).^2);
Crmean = mean(Cr)/video.endtime;
Crtotal = sum(Cr);
Csd = std( (Cr) / video.endtime );
Csdx = std(video.com(:,1) / video.endtime);
Csdy = std(video.com(:,2) / video.endtime);
dx = Cx(2:end)-Cx(1:end-1);
dy = Cy(2:end)-Cy(1:end-1);
dr = Cr(2:end)-Cr(1:end-1);
std_dx = std(dx);
std_dy = std(dy);
std_dr = std(dr);
dt = 0.033;

N=length(video.com(:,1));
tyolx=sum(abs(dx));
tyoly=sum(abs(dy));  % skalar
tyolr=sum(sqrt(dx.*dx+dy.*dy));

ohizx=tyolx/(dt*(N-1));
ohizy=tyoly/(dt*(N-1));                     % skalar
ohizr=tyolr/(dt*(N-1));

Vxmean = ohizx;
Vymean = ohizy;
Vrmean = ohizr;
% for i=1:length(Cr)-1
%     comtemp(i) = Cr(i)-Cr(i+1);
% end

Vx = dx/dt;
Vy = dy/dt;
Vr = dr/dt; 
Vxsd = std(Vx);
Vysd = std(Vy);
Vsd = std(Vr);
Vsdold = std(dr)/video.endtime;
% for i=1:length(comtemp)-1
%     asdtemp(i) = comtemp(i)-comtemp(i+1);
% end
% Asd = std(asdtemp)/mg.video.endtime;
%mg = mgvideorotate(mg,-90);
%mg = mgvideofilter(mg,'Spatial','Median',[3,3]);
%mg = mgmotionfilter(mg,'Regular',0.05);
imageSize = [video.obj.Width, video.obj.Height];
data = [Qtotal; Qtotalnormalized; Qmean; Qsd; Vxsd; Vysd; Vsd; Vsdold; Vxmean; Vymean; Vrmean; Csdx; Csdy; Csd; CXmean; CYmean; Crmean; CXtotal; CYtotal; Crtotal; std_dx; std_dy; std_dr; totalPixels; imageSize(1); imageSize(2)];
labels = ["Qtotal: "; "Qtotalnormalized: "; "Qmean: "; "Qsd: "; "Vxsd: "; "Vysd: "; "Vsd: "; "Vsdold: "; "Vxmean: "; "Vymean: "; "Vrmean: "; "Csdx: "; "Csdy: "; "Csdr: "; "CXmean: "; "CYmean: "; "Crmean: "; "CXtotal: "; "CYtotal: "; "Crtotal: "; "std_dx: "; "std_dy: "; "std_dr: "; "totalPixels: "; "imageSizeX: "; "imageSizeY: "];
fid =fopen('data_out.txt', 'w' );
for i=1:length(data)
    fprintf(fid, '%s', labels(i));
    fprintf(fid, '%g\n', data(i));
end
fclose(fid);
disp("Data is written to data_out.txt")