function [ X ] = read_input_count_tt( path,file_name )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    IDX_VAL= dlmread(char(strcat(path,file_name)));
    %IDX_VAL(:,2:3)=IDX_VAL(:,2:3)+1;
    IDX=IDX_VAL(:,1:3);
    VAL=IDX_VAL(:,4);
    
    
    size1=max(IDX(:,1));
    size2=max(IDX(:,2));
    size3=max(IDX(:,3));


    siz = [size1 size2 size3];
    X = sptensor(IDX,VAL,siz);


end

