% 
function field=CalcVotingField(input, X, Y, Z)
delta=8;
steps=80;
thresh=0.005;
%matlabpool('open');
[LenX,LenY,LenZ]=size(input);
field=zeros(LenX,LenY,LenZ);
data=cell(steps,steps);

base=CalcBaseField(delta);
stepSize=2*pi/(steps-1);

for k=0:stepSize/2:pi
    for j=0:stepSize:2*pi  
        data{round(k/stepSize*2+1),round(j/stepSize+1)}=...
            CalcElementField(delta,[j,k],base);
    end
end
% ndata=cell(LenZ,1);
% for i=1:LenZ
%     ndata{i}=zeros(LenX,LenY,LenZ);
% end

cJ=atan(Y./(X+eps))+pi.*single(X<0)+pi*2*single(X>0&Y<0);
%cJ(cJ<0)=cJ(cJ<0)+2*pi;
cJ=round(cJ./stepSize)+1;
cK=acos(sqrt(X.^2+Y.^2)./sqrt(X.^2+Y.^2+Z.^2));
cK=round(cK./stepSize*2)+1;
len=(size(data{1,1})-1)./2;
lenX=len(1);lenY=len(2);lenZ=len(3);
                
for k=1:LenZ
    for j=1:LenY
        for i=1:LenX
            if(abs(input(i,j,k))>thresh)
                x=i;y=j;z=k;
                lx=min(x-1,lenX); rx=min(lenX,LenX-x);
                ly=min(y-1,lenY); ry=min(lenY,LenY-y);
                lz=min(z-1,lenZ); rz=min(lenZ,LenZ-z);               
                field(x-lx:x+rx,y-ly:y+ry,z-lz:z+rz)=field(x-lx:x+rx,y-ly:y+ry,z-lz:z+rz)+...
                    data{cK(i,j,k),cJ(i,j,k)}(lenX+1-lx:lenX+1+rx,lenY+1-ly:lenY+1+ry,lenZ+1-lz:lenZ+1+rz)...
                    .*input(i,j,k);
            end
        end        
    end
    disp(['Caculationg plane ', num2str(k)])
end

%matlabpool('close');