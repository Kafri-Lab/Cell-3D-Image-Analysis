function field=CalcElementField(delta,position,base)
%calculate the cloud of any element
eleLen=ceil(delta)*6+1;
theta=position(1);
gamma=position(2);
R=[  cos(theta), -sin(theta), 0;cos(gamma)*sin(theta), ...
     cos(gamma)*cos(theta), -sin(gamma);...
     sin(theta)*sin(gamma), cos(theta)*sin(gamma),  cos(gamma)];
 R=R^-1;
 r=(eleLen-1)/2;
[xx,yy,zz]=meshgrid(-r:r,-r:r,-r:r);
coord=[xx(:),yy(:),zz(:)]*R;

coord=coord+r+1;
coord(coord<1)=1;
coord(coord>eleLen)=eleLen;
coord=round(coord(:,2))+round(coord(:,1)-1)*(eleLen)+round(coord(:,3)-1)*(eleLen*eleLen);
base=base(:);

field=reshape(base(coord),eleLen,eleLen,eleLen);
