% for i=1:size(rc1,3)
%     figure
%     imagesc(rc1(:,:,1))
%     figure
%     imagesc(a(:,:,1))
%     figure
%     imagesc(pc(:,:,1))
% end
% 
s1=rc1;
s2=rc2;
s3=zeros([1024,1024,3,size(s2,3)]);
for i=1:size(s2,3)
s3(:,:,:,i)=ind2rgb(S(:,:,i),1+jet(445));
end
s3=permute(s3,[1,2,4,3]);

%ss=permute(ss,[1,2,4,3]);