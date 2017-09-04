filepath = '/data/activity/NYU_dataset2/colorImage/';
f = dir([filepath '*.png']);

file_name = '%06d.jpg';
   
    fil = {f.name};  
    for k = 1:numel(fil)
      name = sprintf(file_name,k);
      file = fil{k};
      im_in = imread(file);
      imwrite(im_in,['/home/weiji/tmp/JPEGImages/',name]);
    end
