function [Iout,whatScale,Voutx,Vouty,Voutz]=PlateFilter3D(I,I2,options)
%
% This function FRANGIFILTER3D uses the eigenvectors of the Hessian to
% compute the likeliness of an image region to vessels, according
% to the method described by Frangi
%
% Written by D.Kroon University of Twente (May 2009)
% 
% Constants vesselness function
%
% edited by Zhengda Li Aug 2017 for plate detection

defaultoptions = struct('ScaleRange', [1.5 3], 'ScaleRatio', 0.5, 'Alpha', 1, 'Beta', 1,'Gamma',0.01, 'verbose',true,'BlackWhite',true);

% Process inputs
if(~exist('options','var')) 
    options=defaultoptions; 
else
    tags = fieldnames(defaultoptions);
    for i=1:length(tags)
         if(~isfield(options,tags{i})),  options.(tags{i})=defaultoptions.(tags{i}); end
    end
    if(length(tags)~=length(fieldnames(options)))
        warning('FrangiFilter3D:unknownoption','unknown options found');
    end
end

% Use single or double for calculations
if(~isa(I,'double')), I=single(I); end

sigmas=options.ScaleRange(1):options.ScaleRatio:options.ScaleRange(2);
sigmas = sort(sigmas, 'ascend');

% Frangi filter for all sigmas
for i = 1:length(sigmas)
    % Show progress
    if(options.verbose)
        disp(['Current Plate Filter Sigma: ' num2str(sigmas(i)) ]);
    end
    
    % Calculate 3D hessian
    [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz] = Hessian3D(I,sigmas(i));

    if(sigmas(i)>0)
        % Correct for scaling
        c=(sigmas(i)^2);
        Dxx = c*Dxx; Dxy = c*Dxy;
        Dxz = c*Dxz; Dyy = c*Dyy;
        Dyz = c*Dyz; Dzz = c*Dzz;
    end
    
    % Calculate eigen values
    if(nargout>2)
        [Lambda1,Lambda2,Lambda3,Vx,Vy,Vz]=eig3volume(Dxx,Dxy,Dxz,Dyy,Dyz,Dzz);
    else
        [Lambda1,Lambda2,Lambda3]=eig3volume(Dxx,Dxy,Dxz,Dyy,Dyz,Dzz);
    end
    
    % Free memory
    clear Dxx Dyy  Dzz Dxy  Dxz Dyz;

    % Calculate absolute values of eigen values
    LambdaAbs1=abs(Lambda1);
    LambdaAbs2=abs(Lambda2);
    LambdaAbs3=abs(Lambda3);

    % The Vesselness Features
    %Ra=LambdaAbs1./LambdaAbs2;
    Rb=sqrt(LambdaAbs1.*LambdaAbs2)./LambdaAbs3;

    % Second order structureness. S = sqrt(sum(L^2[i])) met i =< D
   % S = sqrt(LambdaAbs1.^2+LambdaAbs2.^2+LambdaAbs3.^2);
    S = LambdaAbs3;
    B = 2*options.Alpha^2;  C = 2*options.Beta^2;
    G = 2*options.Gamma^2;
 %   T3 =    exp(-(C/LambdaAbs3.^2));
	
    % Free memory
    clear LambdaAbs1 LambdaAbs2 LambdaAbs3

    %Compute Vesselness function
   % T1 =    1-exp(-(Ra.^2./A));    
    T2 =    exp(-(Rb.^2./B));
    T0  = (1-exp(-S.^2./G));
    T1 =exp(-I2./C);
%    keyboard
    % Free memory
    clear S B C G Rb

    %Compute Vesselness function
%    Voxel_data = T0.*T1.*T2.*T3;
    Voxel_data = T0.*T2.*T1;
   
    % Free memory
%    clear T0 T1 T2 T3;
    clear T0 T2 T1
    if(options.BlackWhite)
        Voxel_data(Lambda3 > 0)=0;
    else
        Voxel_data(Lambda3 < 0)=0;
    end
        
    % Remove NaN values
    Voxel_data(~isfinite(Voxel_data))=0;

    % Add result of this scale to output
    if(i==1)
        Iout=Voxel_data;
        if(nargout>1)
            whatScale = ones(size(I),class(Iout));
        end
        if(nargout>2)
            Voutx=Vx; Vouty=Vy; Voutz=Vz;
        end
    else
        if(nargout>1)
            whatScale(Voxel_data>Iout)=i;
        end
        if(nargout>2)
            Voutx(Voxel_data>Iout)=Vx(Voxel_data>Iout);
            Vouty(Voxel_data>Iout)=Vy(Voxel_data>Iout);
            Voutz(Voxel_data>Iout)=Vz(Voxel_data>Iout);
        end
        % Keep maximum filter response
        Iout=max(Iout,Voxel_data);
    end
end

