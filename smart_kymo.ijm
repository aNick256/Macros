macro "Smart Kymo"{


f_interval=getInfo("Frame interval (s) ");
if(f_interval=="")
	f_interval=getNumber("Time interval was not found in the metadata. Enter the frame interval (s):", 1);


getPixelSize(unit, pixelWidth, pixelHeight);
if(pixelWidth==1){
	pixelWidth=getNumber("Enter pixel width in micrometer", 0.16);
	run("Set Scale...", "distance=1 known="+(pixelWidth)+" unit=micron");
}


Dialog.create("Kymogrph settings");
Dialog.addCheckbox("Adjust contrast for each channel manually", true);
Dialog.addCheckbox("Save kymographs", true);
Dialog.addNumber("Scale bar length (micron)", 5);
Dialog.addNumber("Time bar duration (min)", 1);
Dialog.addNumber("Header's font size", 18);
Dialog.addNumber("Scale bar text's font size", 12);
Dialog.addNumber("The width of the separator lines in the montaged image", 4);
Dialog.addNumber("The width of the selection line (to make kymographs)", 4);
Dialog.addChoice("Kymograph generation mode", newArray("Maximum", "Average"));

Dialog.show();
manual_contrast_adjust=Dialog.getCheckbox();
ifsave=Dialog.getCheckbox();
Scale_bar_size=Dialog.getNumber();
time_scale_duration=Dialog.getNumber();
FontSize=Dialog.getNumber();
scale_font_size=Dialog.getNumber();	
seperator_width=Dialog.getNumber();	
line_width=Dialog.getNumber();
kymo_mode=Dialog.getChoice();	

scale_bar=Scale_bar_size/pixelWidth;
time_scale=floor(time_scale_duration*60/parseInt(f_interval));
run("Line Width...", "line="+line_width);	

getDimensions(width, height, channels, slices, frames);	
dir=getDirectory("image");
if(dir=="")
	dir=getDir("Where do you want to store kymographs?");
kymo_folder=dir + File.separator + "Kymographs" + File.separator ;
File.makeDirectory(kymo_folder);
WaveNames=newArray();
Wavecolors=newArray();
Dialog.create("Channel Names");
Dialog.addMessage("What is inside each channel (e.g. tubulin, Nanospring, ...)?" );
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
		if(tmp.length<2){
			WaveNames[i-1]=substring(WaveNames[i-1], 5, 8);}
		else{
			WaveNames[i-1]=substring(WaveNames[i-1], 6, 9);
			}}
	if(WaveNames[i-1]=="642"){
		Wavecolors[i-1]=replace(WaveNames[i-1], "642", "Magenta");
		Dialog.addString("642 channel", "");
	}
	if(WaveNames[i-1]=="561"){
		Wavecolors[i-1]=replace(WaveNames[i-1], "561", "Yellow");
		Dialog.addString("561 channel", "");
	}
	if(WaveNames[i-1]=="488"){
		Wavecolors[i-1]=replace(WaveNames[i-1], "488", "Cyan");
		Dialog.addString("488 channel", "");
	}
}
for (i = 0; i < Wavecolors.length; i++){ 
	Stack.setChannel(i+1);
	run(Wavecolors[i]);}


if(!File.exists(kymo_folder + File.separator + "Channel_data.txt")){
Dialog.show();
channel_contents=newArray();
for(i=0; i<channels ; i++)
	channel_contents[i]=Dialog.getString();
f = File.open(kymo_folder+File.separator + "Channel_data.txt"); // display file open dialog
   //f = File.open("/Users/wayne/table.txt");
   // use d2s() function (double to string) to specify decimal places 
  for (i=0; i<channels; i++)
     print(f, channel_contents[i]);	
}
else {
	str_file=File.openAsString(kymo_folder+File.separator + "Channel_data.txt");
	channel_contents=split(str_file, "\n");
}


run("KymoResliceWide ", "intensity="+kymo_mode);
a=getTitle();
b=split(a,".");
getDimensions(width, height, channels, slices, frames);	


c=getFileList(kymo_folder);
k=1;
e=already_exists(a,c);
while(e){
	a=b[0] + "_" + k + ".tif";
	k++;
	e=already_exists(a,c);
}

rename(a);

newImage(a+"_Montage", "RGB", (channels+1)*(width+seperator_width)+ 2*seperator_width + scale_font_size, height+ FontSize + 3*seperator_width+ scale_font_size, 1);
setColor("Black");
fillRect(0, 0, (channels+1)*(width+seperator_width)-seperator_width, FontSize);
selectWindow(a);
Stack.setChannel(channels);
setFont("SansSerif", FontSize);
setJustification("center");
active_channel_array=newArray("1000","0100","0010","0001");

for (i = 0; i < channels; i++) {
	
selectWindow(a);
Stack.setChannel(i+1);
run("Enhance Contrast", "saturated=0.35");
if(manual_contrast_adjust){
	Stack.setActiveChannels(active_channel_array[i]);
	waitForUser("   This is '"+channel_contents[i]+"' channel.	 \n   Adjust the contrast then click on ok button to continue	");
}
Image.copy;


selectWindow(a+"_Montage");
Image.paste(i*(width+seperator_width),FontSize, "copy");
x=i*(width+seperator_width) + floor(width/2);
setColor(Wavecolors[i]);
Overlay.drawString(channel_contents[i], x, FontSize-3,0.0);
Overlay.show;
setColor("White");
fillRect(i*seperator_width+(i+1)*width, 0, seperator_width, height+FontSize);
}

selectWindow(a);
Stack.setActiveChannels("1111");
if(manual_contrast_adjust)
	waitForUser("Adjust the contrast of the composite picture \n then click on ok button to continue");
run("RGB Color");
Image.copy;
close(a + " (RGB)");
selectWindow(a+"_Montage");
Image.paste(channels*(width+seperator_width),FontSize, "copy");
x=channels*(width+seperator_width) + floor(width/2);
setColor("White");
Overlay.drawString("Merged", x, FontSize-3, 0.0);
Overlay.show
setColor("Black");
fillRect((channels+1)*(width+seperator_width), height + FontSize - time_scale, 4, time_scale); //Time bar
setFont("SansSerif", scale_font_size);
Overlay.drawString(time_scale_duration+" min", (channels+1)*(width+seperator_width) + scale_font_size + 2*seperator_width, height+FontSize + scale_font_size, 90.0);
makePoint((channels+1)*(width) + 2*seperator_width - scale_bar, height + FontSize + seperator_width); //Scale bar
run("Scale Bar...", "width="+scale_bar+" height=8 thickness=4 font=14 color=Black background=None location=[At Selection] horizontal bold hide overlay");
run("Select None");
micrometer=getInfo("micrometer.abbreviation");
Overlay.drawString(Scale_bar_size + " " + micrometer, (channels+1)*(width+seperator_width) -floor(scale_bar/2) -seperator_width,height+FontSize + 2*seperator_width + scale_font_size , 0.0);
Overlay.show;
Overlay.flatten;
close(a+"_Montage");

if(ifsave){
f=split(a,".");
saveAs("Tiff", ""+kymo_folder+ f[0]+ "_Montage");
selectWindow(a);

saveAs("Tiff", ""+kymo_folder+ a+"");
}
function already_exists(a,c){
	d=false;
	for(i=0; i < c.length ; i++){
		if(c[i]==a){
			d=true;
		}
	}
	return d;
}
}
