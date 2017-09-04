% write .txt for Image's label

fid = fopen('train.txt','w');
for i = 1:1449 
    fprintf(fid,'%06d\n',i);
end
fclose(fid);


