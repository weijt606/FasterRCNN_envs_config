## Linux Install faster_rcnn in TNT (Matlab wrapper by ShaoqingRen):

### scripts for dataset
[creat_xml](https://github.com/weijt606/FasterRCNN_envs_config/blob/master/creat_label.m)  create the `.xml` file from `.mat` file as standard type of Faster RCNN dataset *write by* [wtliao](https://github.com/wtliao)

[png_jpg](https://github.com/weijt606/FasterRCNN_envs_config/blob/master/png_jpg.m) transfer Image type from `png` to `jpg`

[creat_label](https://github.com/weijt606/FasterRCNN_envs_config/blob/master/creat_label.m) write `.txt` for Image's label


#### Step1:  go into your path
`cd /home/Username` 

#### Step2: download faster_rcnn from github
`$ git clone --recursive https://ShaoqingRen/faster_rcnn.git`

#### Step3:  Compile file `Makefile.config`
`$ cd external/caffe`
> If there is no files of caffe, just download Caffe as before (Linux Install Caffe in TNT).

`$ cp Makefile.config.example Makefile.config`
`$ vim Makefile.config`
modify: `MATLAB_DIR :=` as
`MATLAB_DIR := /usr/local/MATLAB/R2014a`
> Tipp: It's better use Matlab_R2014a, I have tryed R2016b, there is many bugs.
> 
#### Step4: modify V1LayerParameter Layer type:
find the file `upgrade_proto.cpp`:
`$ cd /home/Username/faster_rcnn/external/caffe/src/caffe/util`
modify `upgrade_proto.cpp`:
`$ vim upgrade_proto.cpp`
after `case V1LayerParameter_LayerType_THRESHLOD:
	return "Threshold";`

add:
```
case V1LayerParameter_LayerType_RESHAPE:
	return "Reshape";
case V1LayerParameter_LayerType_ROIPOOLING:
	return "ROIPooling";
case V1LayerParameter_LayerType_SMOOTH_L1_LOSS:
	return "SmoothL1Loss"; 
```
then `Esc` add `:` `wq` return

#### Step5. Install Caffe to local 
`$ cd caffe`
`$ make clean`
`$ make all -j16`
`$ make test -j16`
`$ make runtest -j16`
`$ make matcaffe` Install matlab API, become MEX File
`$ make pycaffe` Install python API

#### Step6: Download Pre-trained Model:
in MATLAB run:
`$ run fetch_data/fetch_faster_rcnn_final_model.m`

#### Step7: run faster_rcnn in Matlab:
`$ run faster_rcnn_build.m`
and
`$ run startup.m`


#### Step8: test faster_rcnn:
`$ run experiments/script_faster_rcnn_demo.m`


#### Step9: Preparation for Training:
1. `Run fetch_data/fetch_model_ZF.m` to download an ImageNet-pre-trained ZF net.
2. `Run fetch_data/fetch_model_VGG16.m` to download an ImageNet-pre-trained VGG-16 net.
3. Download VOC 2007 and 2012 data to ./datasets


#### Step10: Training a model
1. `Run experiments/script_faster_rcnn_VOC2007_ZF.m` to train a model with ZF net. It runs four steps as follows:
- Train RPN with conv layers tuned; compute RPN results on the train/test sets.
- Train Fast R-CNN with conv layers tuned using step-1 RPN proposals; evaluate detection mAP.
- Train RPN with conv layers fixed; compute RPN results on the train/test sets.
- Train Fast R-CNN with conv layers fixed using step-3 RPN proposals; evaluate detection mAP.
- Note: the entire training time is ~12 hours on K40.
2. `Run experiments/script_faster_rcnn_VOC2007_VGG16.m` to train a model with VGG net.
- Note: the entire training time is ~2 days on K40.
3. Check other scripts in `./experiments` for more settings.

> Tipps:
1. The first time I run the `script_faster_rcnn_VOC2007_ZF.m`, ther is a error about `text_read`,  I think there is something wrong with `datasets`. You can fing in about 28th and 29th rows of `script_faster_rcnn_VOC2007_ZF.m` , it use `voc2007_trainval`. Open this file and modify  about 11th and14th rows, `trainval`  to `train`(or the other name, the train model in your model's name `/faster_rcnn/datasets/VOCdevkit2007/VOC2007/ImageSets/Main/*.txt/`). And then try again, it works.


2. when you run train Model in rcnn (Linux OX), there is a Error:
 `Check failure: fd != -1 (-1 vs. -1) File not find: .\models\rpn_prototxts\ZF\train_val.prototxt`
 Because `.\` is not a valid path in Ubuntu (Server athene of TNT use Ubuntu OX ).
 Solution: change all the `\\` to `/` in `./faster_rcnn/models/rpn_prorotexts/*.prototxt`  
 Attetion： modify every file under `./faster_rcnn/models/faster_rcnn_prototxts` und `./faster_rcnn/models/rpn_prororxts`


#### Step11. Training your own model:

1. Build your own Dataset (like VOCdevkit2007)
> My Datasets is NYU_deep data,  but in faster_rcnn we have to train the dataset, which like VOC2007 format -- Image name (000001.jpg), Boundingbox information -- .xml files. 
>  ther is three Conversion script to build Datasets:
datasets_tools:  
- creat_traintxt.m (link: http://blog.csdn.net/u014696921/article/details/52950218)
- creat_xml.m (by liao)
- png_jpg.m (by wei)

2. Build files in faster_rcnn
	- In `VOCdevkit2007/result` build a file with your Datasets' name like `NYU_rcnn`, and under this file build a file `Main`
	- In `VOCdevkit2007/local` build a file with your Datasets' name like `NYU_rcnn`

3. Modify code
	- In `datasets/VOCdevkit2007/VOCcode/VOCinit.m `
![Alt text](./1487103919715.png)
modify `VOC2007` to your datasets' name and
![Alt text](./1487103972796.png)
write your training classes as `plane`
> here you can know the number of your classes K

	- In `functions/fast_rcnn/fast_rcnn_train.m`
![Alt text](./1487103547598.png)
modify `val_iters` to  1/5 of your val
	- `funvtions/rpn/proposal_train.m `
	same as before
	- In `imdb/imdb_eval_voc.m`
![Alt text](./1487103714594.png)
modify to:
![Alt text](./1487103730351.png)

4. Modify model
	- In `models/fast_rcnn_prototxts/ZF/train_val.prototxt `
![Alt text](./1487103826043.png)
 K is number of classes in your own datasets
![Alt text](./1487104078556.png)
	- In `models/fast_rcnn_protoxtxs/ZF/test.prototxt `
![Alt text](./1487104103360.png)
same as before
	- In `models/fast_rcnn_prototxts/ZF_fc6/train_val.prototxt `
![Alt text](./1487104142535.png)
![Alt text](./1487104153469.png)
	- In `models/fast_rcnn_prototxts/ZF_fc6/test.prototxt `
![Alt text](./1487104177739.png)

> Attention:
> 1. If there is bug in your training, before start restart, don't forget delete old `output` and `imdb/cache`
> 2. xml must be same format as VOC2007(./datasets/VOCdevkit2007/VOC2007Annotations) `space`can not instead `tabel`
> 3. Modify the number of Iterations: in `./experiments/+Model/ZF_for_Faster_RCNN_VOC2007.m` the code `solver_30k40k` that menas use which file of Interations, you can open `./models/fast_rcnn_prototxts` and `./models/rpn_prototxts` build new `.prototxts` for your own Iterations. 
> 4. In `imdb\imdb_eval_voc.m`
>  modify `do_eval = (str2num(year) <= 2007) | ~strcmp(test_set,'test');  ` 
>  to
>   ` %do_eval = (str2num(year) <= 2007) | ~strcmp(test_set,'test');  
		do_eval = 1;  `
> 5.  2 usefull blogs for training faster_rcnn 
> link: http://blog.csdn.net/sinat_30071459/article/details/50546891 
> http://blog.csdn.net/u014696921/article/details/52950218

5. Run `experiments/script_faster_rcnn_VOC2007_ZF.m`
> stay your path just in 'faster_rcnn', not in 'experiments'

#### Step12. Test result of your own model
1. After training, at first open `output/faster_rcnn_final/faster_rcnn_VOC2007_ZF/detection_test.prototx`
delete layers until `relu5（include relu5)`
and then modify the data under `data`
![Alt text](./1487104681893.png)
and in layer `roi_pool5` modify :
![Alt text](./1487104706519.png)

2. Test:
- Open `\experiments\script_faster_rcnn_demo.m`.
- modify to your own model as: 
![Alt text](./1487104787662.png)
- modify to your own Images:
![Alt text](./1487104828761.png)
- If the number of classes of your own datasets more than VOC2007, modify `showboxes` to:
 ![Alt text](./1487104901026.png)
then you can run and test your model.





