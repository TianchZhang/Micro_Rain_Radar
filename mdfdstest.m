mdf_DS = DS;
for ii = 1:31
    loc = min(find(DS(ii,:)>0));
    for il = loc:-1:2
        mdf_DS(ii,il-1) = mdf_DS(ii,il)-(mdf_DS(ii,il+1)-mdf_DS(ii,il))./2;
    end
end