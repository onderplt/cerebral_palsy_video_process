clc; clear all; close all;
selpath = uigetdir;
FILES = dir([selpath '\**\*.csv']);
F_names = {FILES.name};
for jj = 1 : length(F_names)
    BFileName = FILES(jj).name;
    F_FileName = fullfile(FILES(jj).folder, BFileName);
    %fprintf(1, 'Now reading %s\n', F_FileName);
    [data] = readmatrix(F_FileName);
    %dataMat = cell2mat(data(2:end,:));
    [Vsdx, Vsdy, Vsdr, Vxmean, Vymean, Vrmean, Cxtotal, Cytotal, Crtotal, Cxsd, Cysd, Csd, konumr_total, Qmean, Qtotal]=computeParameters(data);
    dataL = [Vsdx, Vsdy, Vsdr, Vxmean, Vymean, Vrmean, Cxtotal, Cytotal, Crtotal, Cxsd, Cysd, Csd, konumr_total, Qmean, Qtotal];
    labels = ["Vstdx: "; "Vstdy: "; "Vstdr: "; "Vxmean: "; "Vymean: "; "Vrmean: "; "Cxtotal: "; "Cytotal: "; "Crtotal: "; "Cxsd: "; "Cysd: "; "Csd: "; "konumr_total: "; "Qmean: "; "Qtotal"];
    patientName = FILES(jj).name;
    %repName = FILES(jj).name(end-7:end-4);
    for i=1:length(dataL)
        patientData(jj+1,i+1) = num2cell(dataL(i));
    end
    patientData(jj+1,1)=cellstr(patientName);
%     writeFileName = [patientName '.txt'];
%     fid =fopen(writeFileName, 'w' );
%     for i=1:length(dataL)
%         fprintf(fid, '%s', labels(i));
%         fprintf(fid, '%g\n', dataL(i));
%     end
%     fclose(fid);
end
for i=1:15
    patientData(1,i+1)=cellstr(labels(i));
end
writecell(patientData,'DenemeData.xls')