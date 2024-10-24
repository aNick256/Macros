macro "Make videos" {

getDimensions(width, height, channels, slices, frames);
interval=getInfo("Frame interval (s)");
interval_message="The frame interval for TimeStamp is calculated by Stackbuilder and is: " + interval+ " s"
if(interval==""){
	interval = Stack.getFrameInterval()	;
	interval_message="Precise frame interval was not found. The nominal frame intrval is used for TimeStamp: " + interval+ " s";
}
frminterval=parseFloat(interval)/60 ; // s to ms and string to float  conversion
getPixelSize(unit, pixelWidth, pixelHeight);
scale=1/pixelWidth;
ch=newArray(4);
colors=newArray("Magenta", "Yellow", "Cyan", "Red", "Green", "Blue", "Grays");
Wavecolors=newArray();
WaveNames=newArray();
tmp=newArray();
orders=newArray("first", "second", "third", "forth");
Wave_array=newArray("642", "561", "488", "405");

for(i=1; i<=channels; i++){
	WaveNames[i-1]=getInfo("WaveName"+i+"");

	if(WaveNames[i-1]==""){
		WaveNames[i-1]=getString("Channel's wavelength data was not found. Enter the "+orders[i-1]+" wavelength (nm):", Wave_array[i-1]);
		}
	else {
		tmp=split(WaveNames[i-1], " "); 
		tirf_index = indexOf(WaveNames[i-1], "TIRF");
		if(tmp.length<2){
			WaveNames[i-1]=substring(WaveNames[i-1], tirf_index + 4, tirf_index + 7);}
		else{
			WaveNames[i-1]=substring(WaveNames[i-1], tirf_index + 5, tirf_index + 8);
			}}
			if(WaveNames[i-1]=="488")
				Wavecolors[i-1]=replace(WaveNames[i-1], "488", "Cyan");
				//Array.deleteValue(colors, "Cyan");
				//Array.concat("Cyan",colors); 

			if(WaveNames[i-1]=="561")
				Wavecolors[i-1]=replace(WaveNames[i-1], "561", "Yellow");
				//Array.deleteValue(colors, "Yellow");
				//Array.concat("Yellow",colors); 
			if(WaveNames[i-1]=="642")
				Wavecolors[i-1]=replace(WaveNames[i-1], "642", "Magenta");

			}


//get the location of the stacks
img_directory = getDirectory("image");
if( img_directory==""){
	// "Directory" is a metadata added after drift correction by GDSC SMLM
	img_directory=getInfo("Directory");
}




Dialog.create("Choose attributes");
Dialog.addNumber("scale (pixels/micron)", scale);
Dialog.addNumber("Movie frame rate",25);
Dialog.addCheckbox("1.5x lens", false)
Dialog.addCheckbox("Apply to all open images", false) ;
Dialog.addCheckbox("Add time stamper", true)
Dialog.addCheckbox("Add scale", true)
Dialog.addCheckbox("Save as avi", false)
Dialog.addCheckbox("Correct interframe exposure variation", true);
Dialog.addCheckbox("Substract background", true)
Dialog.addChoice("Choose contrast enhancement method:          ", newArray("Imagej default", "Treshold adjustment"));
for(i=0; i < channels; i++){
Array.deleteValue(colors, Wavecolors[i]);	
colors=Array.concat(Wavecolors[i] , colors);
Dialog.addChoice(WaveNames[i] + " channel color:          ", colors);

}
Dialog.addMessage(interval_message, 12, "Red");
Dialog.show();

pxlsize=Dialog.getNumber();
frmrate=Dialog.getNumber();
lens=Dialog.getCheckbox();
all_images=Dialog.getCheckbox();
timestamper=Dialog.getCheckbox();
ifscale=Dialog.getCheckbox();
SaveAsAVI=Dialog.getCheckbox();
exp_correction = Dialog.getCheckbox();
s_background=Dialog.getCheckbox();
contrast=Dialog.getChoice();
for(i=0; i < channels; i++){
ch[i]=Dialog.getChoice();

}

if(lens){pxlsize=1.5*pxlsize;}

if (SaveAsAVI) {
	if(img_directory==""){
		img_directory=getDir("Choose where you want to save avi files");
	}
	avi_location= img_directory + File.separator + "avi_videos" + File.separator ;
	File.makeDirectory(avi_location);
	dir = avi_location;
}
if(exp_correction){
	terget_channel = getNumber("Enter the channel number for correcting the brightness fluctuations ", 1);
}
number_of_images = 1;
if(all_images) number_of_images=nImages() ;
for (k=1; k<=number_of_images; k++)
{
selectImage(k);
if(exp_correction){
	exposure_correction(terget_channel);
}

slc_number=nSlices;
while(slc_number==1){
	k++;
	selectImage(k);
	slc_number=nSlices;
}
setSlice(floor(nSlices/2));
if(s_background){
	run("Subtract Background...", "rolling=20 stack");
}
Stack.getDimensions(w, h, channels, slices, frames);
if(contrast=="Treshold adjustment")
{
for (j=1; j<= channels; j++)
{
Stack.setChannel(j); 
run(ch[j-1]);
AUTO_THRESHOLD = 5000;
 getRawStatistics(pixcount);
 limit = pixcount/10;
 threshold = pixcount/AUTO_THRESHOLD;
 nBins = 256;
 getHistogram(values, histA, nBins);
 i = -1;
 found = false;
 do {
         counts = histA[++i];
         if (counts > limit) counts = 0;
         found = counts > threshold;
 }while ((!found) && (i < histA.length-1))
 hmin = values[i];
 
 i = histA.length;
 do {
         counts = histA[--i];
         if (counts > limit) counts = 0; 
         found = counts > threshold;
 } while ((!found) && (i > 0))
 hmax = values[i];

setMinAndMax(hmin, hmax);
run("Enhance Contrast", "saturated=0.35 process_all");
}}else {
for (j=1; j<= channels; j++)
{
Stack.setChannel(j);
run(ch[j-1]);
run("Enhance Contrast", "saturated=0.35 process_all");
}}

if (ifscale) {
run("Set Scale...", "distance="+pxlsize+" known=1 pixel=1 unit=micron");
run("Scale Bar...", "width=10 height=4 font=14 color=White background=None location=[Lower Right] bold overlay");}
if (timestamper) {

run("Time Stamper", "starting=0 interval="+frminterval+" x=2 y=2 font=12 decimal=0 anti-aliased or=min overlay");}
if(SaveAsAVI){
imageName = getTitle;
imageRawName=split(imageName,".");
run("AVI... ", "compression=JPEG frame=frmrate save=["+ dir + imageRawName[0]+".avi"+"]");
}
}}