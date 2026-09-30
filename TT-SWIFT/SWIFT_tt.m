function [ P ] = SWIFT_tt( X,ranks, C1,C2,C3,options,seed,PARFOR )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%add packages
% Tensor Toolbox must already be on the MATLAB path.
%--------------------------------------------------------------

%Initializing parameters 



%tensor size
size_doc=size(X,1);
size_word1=size(X,2);
size_word2=size(X,3);

r1 = ranks(1);
r2 = ranks(2);


%Read the data

K={};
[rho,~,~] = tt_transport_parameters(options);
K{1} = exp(-rho * C1 - 1);%Cost for Patients

%1
%length(K{1})
K{2} = exp(-rho * C2 - 1); %Cost for Diag

%K{2}
%2
%length(K{2})
K{3} = exp(-rho * C3 - 1); %Cost for Med

%2
%length(K{3})



rng(seed);

G1=rand(size_doc,r1);
G2=rand(r1,size_word1,r2);
G3=rand(r2,size_word2);



N=length(size(X));





%MATRICIZE THE INPUT
X_mat={};
Unique_nz_col={};

 for n=1:N
        %Matricizattion
        if isnumeric(X)
            order = [n, setdiff(1:3,n,'stable')];
            X_mat{n} = reshape(permute(X,order),size(X,n),[]);
        else
            X_mat{n}=double(sptenmat(X, n));
        end
        Unique_nz_col{n}=unique_col_ind_tt(X_mat{n},0);

        fprintf('\n===== Initial mode-%d unfolding check =====\n', n);
        fprintf('size(X_mat{%d}) = [%d, %d]\n', n, size(X_mat{n},1), size(X_mat{n},2));
        fprintf('length(Unique_nz_col{%d}) = %d\n', n, length(Unique_nz_col{n}));
        fprintf('max(Unique_nz_col{%d}) = %d\n', n, max(Unique_nz_col{n}));
        fprintf('number of columns in X_mat{%d} = %d\n', n, size(X_mat{n},2));


 end



ITER=options.Total_iteration;



for itr=1:ITER
    if ~isfield(options,'verbose') || options.verbose, disp(itr); end

    
    Factors = {};
    Factors{1} = G1;
    Factors{2} = tt_core2_to_mat(G2);
    Factors{3} = G3';

    ENV={};
    ENV{1} = tt_env_mode1(G2,G3);
    ENV{2} = tt_env_mode2(G1,G3);
    ENV{3} = tt_env_mode3(G1,G2);

    KRP = {};
    for n = 1:N
        KRP{n}=ENV{n}(Unique_nz_col{n},:);
    end
    
    Optimal_Trans = {};


    for n=1:N

       rank_n = size(Factors{n},2);
       
       [OT] = Update_OT_tt(X_mat{n},Unique_nz_col{n}, rank_n,K{n}, options, Factors{n}, KRP{n},PARFOR);
       Optimal_Trans{n}=OT';
       

    end
    
    [G1,G2,G3]=Update_factor_tt(G1,G2,G3,Optimal_Trans,Unique_nz_col);

    
end
% for n=1:N
%    Factors{n}=Factors{n}./sum(Factors{n}); 
% end

P = struct();
P.G1 = G1;
P.G2 = G2;
P.G3 = G3;
P.ranks = [r1,r2];


end


