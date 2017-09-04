% write xml from .mat for each image  by Wentong Liao

filepath = '/home/liao/rcnn-depth/eccv14-data/benchmarkData/gt_box_cache_dir_2/';
l = dir([filepath '*.mat']);
outputpath = '/home/weiji/tmp/xml/';
xml_name = '%06d.xml';
% space2 = '  '; % two blank spaces for indentation

for i=1:length(l) 
    load([filepath,l(i).name]) % load data
    f=fopen([outputpath sprintf(xml_name,i)],'w+');%open or create file for reading and writing;
    
    % begin to write
    fprintf(f,'%s\n','<annotation>');
    % dataset information
    fprintf(f,'%s\n',[char(9) '<folder>NYU2</folder>']);
    fprintf(f,'%s\n',[char(9) sprintf('<filename>%06d.jpg</filename>',i)]);
    fprintf(f,'%s\n',[char(9) '<source>']);
    fprintf(f,'%s\n',[char(9) char(9) '<database>The NYU Dataset2</database>']);
    fprintf(f,'%s\n',[char(9) char(9) '<annotation>PASCAL VOC2007</annotation>']);
    fprintf(f,'%s\n',[char(9) char(9) '<image>flickr</image>']);
    fprintf(f,'%s\n',[char(9) char(9) '<flickrid>321862192</flickrid>']);
    fprintf(f,'%s\n',[char(9) '</source>']);
    fprintf(f,'%s\n',[char(9) '<owner>']);
    fprintf(f,'%s\n',[char(9) char(9) '<flickrid>TNT</flickrid>']);
    fprintf(f,'%s\n',[char(9) char(9) '<name>Wentong Liao, Jiantong Wei</name>']);
    fprintf(f,'%s\n',[char(9) '</owner>']);
    fprintf(f,'%s\n',[char(9) '<size>']);
    fprintf(f,'%s\n',[char(9) char(9) '<width>500</width>']);
    fprintf(f,'%s\n',[char(9) char(9) '<height>333</height>']);
    fprintf(f,'%s\n',[char(9) char(9) '<depth>3</depth>']);
    fprintf(f,'%s\n',[char(9) '</size>']);
    fprintf(f,'%s\n',[char(9) '<segmented>0</segmented>']);
    for j = 1:length(rec.objects)
        fprintf(f,'%s\n',[char(9) '<object>']);
        fprintf(f,'%s\n',[char(9) char(9) sprintf('<name>%s</name>',rec.objects(j).class)]);
        fprintf(f,'%s\n',[char(9) char(9) '<pose>Frontal</pose>']);
        fprintf(f,'%s\n',[char(9) char(9) sprintf('<truncated>%d</truncated>',rec.objects(j).truncated)]);
        fprintf(f,'%s\n',[char(9) char(9) sprintf('<difficult>%d</difficult>',rec.objects(j).difficult)]);
        fprintf(f,'%s\n',[char(9) char(9) '<bndbox>']);
        fprintf(f,'%s\n',[char(9) char(9) char(9) sprintf('<xmin>%d</xmin>',rec.objects(j).bbox(1))]);
        fprintf(f,'%s\n',[char(9) char(9) char(9) sprintf('<ymin>%d</ymin>',rec.objects(j).bbox(2))]);
        fprintf(f,'%s\n',[char(9) char(9) char(9) sprintf('<xmax>%d</xmax>',rec.objects(j).bbox(3))]);
        fprintf(f,'%s\n',[char(9) char(9) char(9) sprintf('<ymax>%d</ymax>',rec.objects(j).bbox(4))]);
        fprintf(f,'%s\n',[char(9) char(9) '</bndbox>']);
        fprintf(f,'%s\n',[char(9) '</object>']);
    end
    fprintf(f,'%s\n','</annotation>');
    fclose(f);
end
    
    