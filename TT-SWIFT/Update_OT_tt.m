function [OT,U] = Update_OT_tt(X,unq_nnz_col, r,K, options, U, V,PARFOR)



[~,phi1,phi2] = tt_transport_parameters(options);
%M = options.dist;

sinkhorn_iter=options.sinkhorn_iter;



[mFea,nSmp]=size(X);

% if alpha > 0
%     W = alpha*W;
%     DCol = full(sum(W,2));
%     D = spdiags(DCol,0,nSmp,nSmp);
%else
D = [];
%end

if isempty(U)
    U = abs(rand(mFea,r));
    V = abs(rand(nSmp,r));
end

%[U,V] = NormalizeUV(U, V, NormV, Norm);
nIter = 0;
%K = exp(-lambda * M - 1);
X=X(:,unq_nnz_col);
Xgl = X .^ phi2;


%while(maxErr > differror)
    % ===================== calculate best transport matrix ========================

%V=V(unq_nnz_col,:);
modProb = U * V';

Pgl = modProb .^ phi1;
%miu = ones(mFea, nSmp) / mFea;
miu = ones(mFea, length(unq_nnz_col)) / mFea;
niu = zeros(mFea, length(unq_nnz_col)) / mFea;
dldp = zeros(mFea, length(unq_nnz_col)) / mFea;



if (PARFOR==1)


    parfor j=1:size(miu,2)

        for ii = 1:sinkhorn_iter
            %ii
            miu(:,j) = Pgl(:,j) ./ max((K * (Xgl(:,j) ./ max(((K' * miu(:,j)).^phi2), 1e-30))).^phi1, 1e-30);
        end
        niu(:,j) = Xgl(:,j) ./ max(((K' * miu(:,j)).^phi2), 1e-30);

        dldp(:,j) = (miu(:,j) .* (K * niu(:,j))) ./ max(modProb(:,j), 1e-30);

    end
else

    for ii = 1:sinkhorn_iter
         miu = Pgl ./ max((K * (Xgl ./ max(((K' * miu).^phi2), 1e-6))).^phi1, 1e-6);
    end

    niu = Xgl ./ max(((K' * miu).^phi2), 1e-30);

    dldp = (miu .* (K * niu)) ./ max(modProb, 1e-30);
end

OT=dldp;

% ===================== update V ========================

%V = V .* (dldp' * U) ./ max(repmat(sum(U, 1), [nSmp, 1]), 1e-10);

% ===================== update U ========================
%if(itr==1)
    
%    U = U .* (dldp * V) ./ max(repmat(sum(V, 1), [mFea, 1]), 1e-30);
%end


    %%nIter = nIter + 1;s
%     if isempty(maxIter)
%         error('Not implemented!'); 
%     else
%         if nIter >= maxIter
%             maxErr = 0;
%         end
%     end
%end


%Wass_loss=0;%trace(dldp'*M);

nIter_final = nIter;
%[U_final,V_final] = NormalizeUV(U, V, NormV, Norm);
%U_final=U;

%==========================================================================
    
