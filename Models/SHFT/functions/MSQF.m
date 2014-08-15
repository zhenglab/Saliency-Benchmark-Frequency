
function  [S]=MSQF(img,f,M,N)  %%%

LW=LengthWidth(img);   %%%
[m n]=size(LW);        %%%
 Sall=zeros(M,N);
 M1=round(0.5*M);
 M2=round(0.5*N);

mu = unit(quaternion(1,1,1)); 
FL = qfft2(f, mu, 'L') ./ sqrt(M*N);
A=abs(FL);
FL=FL./A;
A=log(1+fftshift(A));
qall=0;
%%%for k=1:8
%%%Ak = imfilter(A, fspecial('gaussian',5,1));
for i=1:m 
    if LW(i,1)~=0
        Ak(:,:,i) = imfilter(A, fspecial('gaussian',min(M,N),1.2*M/(max(LW(i,1),LW(i,2)))));%%%
        %Ak(:,:,i) = imfilter(A, fspecial('gaussian',min(M,N),7));%%%
        %Ak = imfilter(A, fspecial('gaussian',5,LW(2,1)*LW(2,2)));
        Ak(:,:,i)=exp(fftshift(Ak(:,:,i)))-1;   %???
        FL_filted=Ak(:,:,i).*FL;
        FIL = iqfft2(FL_filted, mu, 'L') .* sqrt(M*N);
        FIL=abs(FIL);
        FIL(:,:,i) = mat2gray(FIL);
        SMs(:,:,i)=FIL(:,:,i).^2;
        Mid=LengthWidth(img);
        Dist(1,i)=sqrt((Mid(i,1)-M1).^2+(Mid(i,2)-M2).^2);
        q(1,i)=gaussmf(Dist(1,i),[M 0]);
        qall=qall+q(1,i);
        Sall=Sall+q(1,i).*SMs(:,:,i);
    end
end

S=Sall./qall;

%     Ak = imfilter(A, fspecial('gaussian',min(M,N),1.5*256/183));%%%
%     %Ak(:,:,i) = imfilter(A, fspecial('gaussian',min(M,N),7));%%%
%     %Ak = imfilter(A, fspecial('gaussian',5,LW(2,1)*LW(2,2)));
%     Ak=exp(fftshift(Ak))-1;   %???
%     FL_filted=Ak.*FL;
%     FIL = iqfft2(FL_filted, mu, 'L') .* sqrt(M*N);
%     FIL=abs(FIL);
%     FIL = mat2gray(FIL);
%     SMs=FIL.^2;
%     sms = imfilter(SMs, fspecial('gaussian',[7 7],16));
%     Mid=LengthWidth(img);
%     Dist=sqrt((Mid-M1).^2+(Mid-M2).^2);
%     q=gaussmf(Dist,[M 0]);
%     qall=qall+q;
%     S=(S+q.*SMs)./qall;

