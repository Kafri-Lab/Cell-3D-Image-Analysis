function field=CalcBaseField(delta)
%calculate the cloud of a single normal element
eleLen=ceil(delta)*6+1;
[x1,y1,z1]=meshgrid(-(eleLen-1)/2:1:(eleLen-1)/2,-(eleLen-1)/2:1:(eleLen-1)/2,-(eleLen-1)/2:1:(eleLen-1)/2);
field=mvnpdf([x1(:),y1(:),z1(:)], [0,0,0],[delta,delta,delta/40]);
field=reshape(field,eleLen,eleLen,eleLen);

% 
% c=-16*log(0.1)*(delta-1)/(pi*pi);
% field=zeros(eleLen,eleLen,eleLen);
% X=0;
% Y=0;
% Z=1;
% for i=1:eleLen
%     for j =1:eleLen
%         for k = 1:eleLen
%             x=i-(eleLen+1)/2;
%             y=j-(eleLen+1)/2;
%             z=k-(eleLen+1)/2;
%             l=sqrt(x*x+y*y+z*z);
%             if l==0
%                 field(i,j,k)=200/delta/delta/delta;
%             else
%                 theta=acos(abs((z*Z+x*X+y*Y)/(sqrt(X*X+Y*Y+Z*Z))/l));
%                 kappa=1/(sin(theta)+0.001);
% %                 field(i,j,k)=exp(-(l*l+c*kappa*kappa*4+z*z/3)/(delta*delta))*2;
%                 field(i,j,k)=exp(-(l*l+c*kappa*kappa*4)/(delta*delta))*2;                     
%             end            
%             
%         end
%     end
% end

field=field./(sum(sum(sum(field))));
