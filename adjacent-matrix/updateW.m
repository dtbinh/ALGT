function L = updateW(options, f, X)
%UPDATEW.m���ڸ���Ȩ�ؾ���
%f   �ϴε����õ��ķ�������Ԥ����
%X�����ݾ�����label
%options   �ṹ��
%��������options.NN ���ڸ���
%��������options.GraphDistanceFunction  �������������ʱʹ�õĺ���, 'eucliden'
%��������options.GraphWeightParam  ����Ȩ�ؾ���ʱ�漰�ĳ�������
%                                                            ����˹�˺����Ĵ���,ȡ0��ʾʹ�����ֵ
%L��Laplacian Matrix,��ϡ�������ʽ�洢

n=size(X,1);
K = options.NN;
gamma_I = options.gamma_I;
gamma_X = options.gamma_X;
XDis = feval(options.GraphDistanceFunction, X, X);
fDis = feval(options.GraphDistanceFunction, f, f);
Dis = gamma_X*XDis+gamma_I*fDis;
[~,I] = sort(Dis, 2);
Ind = I(: , 2:( K+1));
 
%�����ڽӾ���
S = zeros(n, n);
for i=1:n
    ii = Ind(i, :);
    S(i, ii) = Dis(i, ii);
end

%����Ȩ�ؾ���
if  options.GraphWeightParam == 0
    S1 =S(:);
    t = max(S1);
else 
    t = options.GraphWeightParam;
end

 W = exp((-S.^2)/(2*t));
 W = W.*(S>0);
 
 %�Գƻ�
 W = W+((W~=W').*W');
 
 %����Laplacian Matrix
 d = sum(W,2);
 D = diag(d);
 if options.LaplacianNormalize==1
     D(D~=0)=sqrt(1./D(D~=0));
     L = eye(n) - D*W*D;
 else
     L = D-W;
 end
 L = sparse(L);
