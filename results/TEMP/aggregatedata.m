count_numparametersets=count_numparametersets1+count_numparametersets2...
    +count_numparametersets3+count_numparametersets4;%+count_numparametersets5...
%     +count_numparametersets6+count_numparametersets7+count_numparametersets8...
%     +count_numparametersets9;%+count_numparametersets10+count_numparametersets11;

ind = find(minquant1==0,1,'first')-1;
if isempty(ind)==0
    minquant1=minquant1(1:ind);
    paramval1=paramval1(:,1:ind);
end

ind = find(minquant2==0,1,'first')-1;
if isempty(ind)==0
    minquant2=minquant2(1:ind);
    paramval2=paramval2(:,1:ind);
end

ind = find(minquant3==0,1,'first')-1;
if isempty(ind)==0
    paramval3=paramval3(:,1:ind);
    minquant3=minquant3(1:ind);
end

ind = find(minquant4==0,1,'first')-1;
if isempty(ind)==0
    minquant4=minquant4(1:ind);
    paramval4=paramval4(:,1:ind);
end

% ind = find(minquant5==0,1,'first')-1;
% if isempty(ind)==0
%     minquant5=minquant5(1:ind);
%     paramval5=paramval5(:,1:ind);
% end
% 
% ind = find(minquant6==0,1,'first')-1;
% if isempty(ind)==0
%     paramval6=paramval6(:,1:ind);
%     minquant6=minquant6(1:ind);
% end
% 
% ind = find(minquant7==0,1,'first')-1;
% if isempty(ind)==0
%     minquant7=minquant7(1:ind);
%     paramval7=paramval7(:,1:ind);
% end
% 
% ind = find(minquant8==0,1,'first')-1;
% if isempty(ind)==0
%     minquant8=minquant8(1:ind);
%     paramval8=paramval8(:,1:ind);
% end
% 
% ind = find(minquant9==0,1,'first')-1;
% if isempty(ind)==0
%     minquant9=minquant9(1:ind);
%     paramval9=paramval9(:,1:ind);
% end

% ind = find(minquant10==0,1,'first')-1;
% if isempty(ind)==0
%     minquant10=minquant10(1:ind);
%     paramval10=paramval10(:,1:ind);
% end
% 
% ind = find(minquant11==0,1,'first')-1;
% if isempty(ind)==0
%     minquant11=minquant11(1:ind);
%     paramval11=paramval11(:,1:ind);
% end

minquant=[minquant1 minquant2 minquant3 minquant4];% minquant5 minquant6 ...
%     minquant7 minquant8 minquant9];% minquant10 minquant11];
paramval=[paramval1 paramval2 paramval3 paramval4];% paramval5 paramval6 ...
%     paramval7 paramval8 paramval9];% paramval10 paramval11];