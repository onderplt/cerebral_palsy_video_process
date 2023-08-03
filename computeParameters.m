function [Vsdx, Vsdy, Vsdr, Vxmean, Vymean, Vrmean, Cxtotal, Cytotal, Crtotal, Cxsd, Cysd, Csd, konumr_total, Qmean, Qtotal]=computeParameters(hl)
konumx=hl(:,7);
konumy=hl(:,8);
q=hl(:,3);
fs=100;
[b,a]=butter(4,10/(fs/2),'low');% 10 Hz Butterworth, 4. derece filtrre 
%konumx=filter(b,a,konumx);
%konumy=filter(b,a,konumy);
konumr=sqrt(konumx.*konumx+konumy.*konumy);%
dt=0.010; %100 Hz 
hizx=[];hizy=[];hizr=[];
N=length(konumx);

dx=konumx(2:N)-konumx(1:N-1);
dy=konumy(2:N)-konumy(1:N-1);
hizx=dx/dt;
hizy=dy/dt;
hizr=sqrt(hizx.*hizx+hizy.*hizy);

Vx = hizx;
Vy = hizy;
Vr = hizr;

ah_stdx=std(hizx);  
ah_stdy=std(hizy); 
ah_stdr=std(hizr); 

Vsdx=std(Vx);  
Vsdy=std(Vy); 
Vsdr=std(Vr); 

N=length(konumx);
tyolx=sum(abs(dx));
tyoly=sum(abs(dy));  % skalar
tyolr=sum(sqrt(dx.*dx+dy.*dy));

Cxtotal = tyolx;
Cytotal = tyoly;
Crtotal = tyolr;

Cxsd = std(konumx);
Cysd = std(konumy);
Csd = std(konumr);

ohizx=tyolx/(dt*(N-1));
ohizy=tyoly/(dt*(N-1));                     % skalar
ohizr=tyolr/(dt*(N-1));

Vxmean = ohizx;
Vymean = ohizy;
Vrmean = ohizr;
konumr_total = sum((konumr));

Qmean=mean(q);
Qtotal=sum(q);