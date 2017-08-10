function data=IntegField(Size,x,y,z,input,amplitude)
%sum all the voting tensors together
len=(size(input)-1)./2;
lenX=len(1);lenY=len(2);lenZ=len(3);
LenX=Size(1);LenY=Size(2);LenZ=Size(3);
data=zeros(LenX,LenY,LenZ);
lx=lenX; rx=lenX;
ly=lenY; ry=lenY;
lz=lenZ; rz=lenZ;
if x-1<lenX 
    lx=x-1 ;
end
if y-1<lenY 
    ly=y-1 ;
end
if z-1<lenZ 
    lz=z-1 ;
end
if LenX-x<lenX
    rx=LenX-x ;
end
if LenY-y<lenY
    ry=LenY-y ;
end
if LenZ-z<lenZ
    rz=LenZ-z;
end
data(x-lx:x+rx,y-ly:y+ry,z-lz:z+rz)=...
    input(lenX+1-lx:lenX+1+rx,lenY+1-ly:lenY+1+ry,lenZ+1-lz:lenZ+1+rz)...
    .*amplitude;