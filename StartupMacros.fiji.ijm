// "StartupMacros"
// The macros and macro tools in this file ("StartupMacros.txt") are
// automatically installed in the Plugins>Macros submenu and
//  in the tool bar when ImageJ starts up.

//  About the drawing tools.
//
//  This is a set of drawing tools similar to the pencil, paintbrush,
//  eraser and flood fill (paint bucket) tools in NIH Image. The
//  pencil and paintbrush draw in the current foreground color
//  and the eraser draws in the current background color. The
//  flood fill tool fills the selected area using the foreground color.
//  Hold down the alt key to have the pencil and paintbrush draw
//  using the background color or to have the flood fill tool fill
//  using the background color. Set the foreground and background
//  colors by double-clicking on the flood fill tool or on the eye
//  dropper tool.  Double-click on the pencil, paintbrush or eraser
//  tool  to set the drawing width for that tool.
//
// Icons contributed by Tony Collins.

// Global variables
var pencilWidth=1,  eraserWidth=10, leftClick=16, alt=8;
var brushWidth = 10; //call("ij.Prefs.get", "startup.brush", "10");
var floodType =  "8-connected"; //call("ij.Prefs.get", "startup.flood", "8-connected");

// The macro named "AutoRunAndHide" runs when ImageJ starts
// and the file containing it is not displayed when ImageJ opens it.

// macro "AutoRunAndHide" {}

function UseHEFT {
	requires("1.38f");
	state = call("ij.io.Opener.getOpenUsingPlugins");
	if (state=="false") {
		setOption("OpenUsingPlugins", true);
		showStatus("TRUE (images opened by HandleExtraFileTypes)");
	} else {
		setOption("OpenUsingPlugins", false);
		showStatus("FALSE (images opened by ImageJ)");
	}
}

UseHEFT();

// The macro named "AutoRun" runs when ImageJ starts.

macro "AutoRun" {
	// run all the .ijm scripts provided in macros/AutoRun/
	autoRunDirectory = getDirectory("imagej") + "/macros/AutoRun/";
	if (File.isDirectory(autoRunDirectory)) {
		list = getFileList(autoRunDirectory);
		// make sure startup order is consistent
		Array.sort(list);
		for (i = 0; i < list.length; i++) {
			if (endsWith(list[i], ".ijm")) {
				runMacro(autoRunDirectory + list[i]);
			}
		}
	}
}

var pmCmds = newMenu("Popup Menu",
	newArray("Help...", "Rename...", "Duplicate...", "Original Scale",
	"Paste Control...", "-", "Record...", "Capture Screen ", "Monitor Memory...",
	"Find Commands...", "Control Panel...", "Startup Macros...", "Search..."));

macro "Popup Menu" {
	cmd = getArgument();
	if (cmd=="Help...")
		showMessage("About Popup Menu",
			"To customize this menu, edit the line that starts with\n\"var pmCmds\" in ImageJ/macros/StartupMacros.txt.");
	else
		run(cmd);
}

macro "Abort Macro or Plugin (or press Esc key) Action Tool - CbooP51b1f5fbbf5f1b15510T5c10X" {
	setKeyDown("Esc");
}

var xx = requires138b(); // check version at install
function requires138b() {requires("1.38b"); return 0; }

var dCmds = newMenu("Developer Menu Tool",
newArray("ImageJ Website","News", "Documentation", "ImageJ Wiki", "Resources", "Macro Language", "Macros",
	"Macro Functions", "Startup Macros...", "Plugins", "Source Code", "Mailing List Archives", "-", "Record...",
	"Capture Screen ", "Monitor Memory...", "List Commands...", "Control Panel...", "Search...", "Debug Mode"));

macro "Developer Menu Tool - C037T0b11DT7b09eTcb09v" {
	cmd = getArgument();
	if (cmd=="ImageJ Website")
		run("URL...", "url=http://rsbweb.nih.gov/ij/");
	else if (cmd=="News")
		run("URL...", "url=http://rsbweb.nih.gov/ij/notes.html");
	else if (cmd=="Documentation")
		run("URL...", "url=http://rsbweb.nih.gov/ij/docs/");
	else if (cmd=="ImageJ Wiki")
		run("URL...", "url=http://imagejdocu.tudor.lu/imagej-documentation-wiki/");
	else if (cmd=="Resources")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/");
	else if (cmd=="Macro Language")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/macro/macros.html");
	else if (cmd=="Macros")
		run("URL...", "url=http://rsbweb.nih.gov/ij/macros/");
	else if (cmd=="Macro Functions")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/macro/functions.html");
	else if (cmd=="Plugins")
		run("URL...", "url=http://rsbweb.nih.gov/ij/plugins/");
	else if (cmd=="Source Code")
		run("URL...", "url=http://rsbweb.nih.gov/ij/developer/source/");
	else if (cmd=="Mailing List Archives")
		run("URL...", "url=https://list.nih.gov/archives/imagej.html");
	else if (cmd=="Debug Mode")
		setOption("DebugMode", true);
	else if (cmd!="-")
		run(cmd);
}

var sCmds = newMenu("Stacks Menu Tool",
	newArray("Add Slice", "Delete Slice", "Next Slice [>]", "Previous Slice [<]", "Set Slice...", "-",
		"Convert Images to Stack", "Convert Stack to Images", "Make Montage...", "Reslice [/]...", "Z Project...",
		"3D Project...", "Plot Z-axis Profile", "-", "Start Animation", "Stop Animation", "Animation Options...",
		"-", "MRI Stack (528K)"));
macro "Stacks Menu Tool - C037T0b11ST8b09tTcb09k" {
	cmd = getArgument();
	if (cmd!="-") run(cmd);
}

var luts = getLutMenu();
var lCmds = newMenu("LUT Menu Tool", luts);
macro "LUT Menu Tool - C037T0b11LT6b09UTcb09T" {
	cmd = getArgument();
	if (cmd!="-") run(cmd);
}
function getLutMenu() {
	list = getLutList();
	menu = newArray(16+list.length);
	menu[0] = "Invert LUT"; menu[1] = "Apply LUT"; menu[2] = "-";
	menu[3] = "Fire"; menu[4] = "Grays"; menu[5] = "Ice";
	menu[6] = "Spectrum"; menu[7] = "3-3-2 RGB"; menu[8] = "Red";
	menu[9] = "Green"; menu[10] = "Blue"; menu[11] = "Cyan";
	menu[12] = "Magenta"; menu[13] = "Yellow"; menu[14] = "Red/Green";
	menu[15] = "-";
	for (i=0; i<list.length; i++)
		menu[i+16] = list[i];
	return menu;
}

function getLutList() {
	lutdir = getDirectory("luts");
	list = newArray("No LUTs in /ImageJ/luts");
	if (!File.exists(lutdir))
		return list;
	rawlist = getFileList(lutdir);
	if (rawlist.length==0)
		return list;
	count = 0;
	for (i=0; i< rawlist.length; i++)
		if (endsWith(rawlist[i], ".lut")) count++;
	if (count==0)
		return list;
	list = newArray(count);
	index = 0;
	for (i=0; i< rawlist.length; i++) {
		if (endsWith(rawlist[i], ".lut"))
			list[index++] = substring(rawlist[i], 0, lengthOf(rawlist[i])-4);
	}
	return list;
}

macro "Pencil Tool - C037L494fL4990L90b0Lc1c3L82a4Lb58bL7c4fDb4L5a5dL6b6cD7b" {
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0)
		setColorToBackgound();
	draw(pencilWidth);
}

macro "Paintbrush Tool - C037La077Ld098L6859L4a2fL2f4fL3f99L5e9bL9b98L6888L5e8dL888c" {
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0)
		setColorToBackgound();
	draw(brushWidth);
}

macro "Flood Fill Tool -C037B21P085373b75d0L4d1aL3135L4050L6166D57D77D68La5adLb6bcD09D94" {
	requires("1.34j");
	setupUndo();
	getCursorLoc(x, y, z, flags);
	if (flags&alt!=0) setColorToBackgound();
	floodFill(x, y, floodType);
}

function draw(width) {
	requires("1.32g");
	setupUndo();
	getCursorLoc(x, y, z, flags);
	setLineWidth(width);
	moveTo(x,y);
	x2=-1; y2=-1;
	while (true) {
		getCursorLoc(x, y, z, flags);
		if (flags&leftClick==0) exit();
		if (x!=x2 || y!=y2)
			lineTo(x,y);
		x2=x; y2 =y;
		wait(10);
	}
}

function setColorToBackgound() {
	savep = getPixel(0, 0);
	makeRectangle(0, 0, 1, 1);
	run("Clear");
	background = getPixel(0, 0);
	run("Select None");
	setPixel(0, 0, savep);
	setColor(background);
}

// Runs when the user double-clicks on the pencil tool icon
macro 'Pencil Tool Options...' {
	pencilWidth = getNumber("Pencil Width (pixels):", pencilWidth);
}

// Runs when the user double-clicks on the paint brush tool icon
macro 'Paintbrush Tool Options...' {
	brushWidth = getNumber("Brush Width (pixels):", brushWidth);
	call("ij.Prefs.set", "startup.brush", brushWidth);
}

// Runs when the user double-clicks on the flood fill tool icon
macro 'Flood Fill Tool Options...' {
	Dialog.create("Flood Fill Tool");
	Dialog.addChoice("Flood Type:", newArray("4-connected", "8-connected"), floodType);
	Dialog.show();
	floodType = Dialog.getChoice();
	call("ij.Prefs.set", "startup.flood", floodType);
}

macro "Set Drawing Color..."{
	run("Color Picker...");
}

macro "-" {} //menu divider

macro "About Startup Macros..." {
	title = "About Startup Macros";
	text = "Macros, such as this one, contained in a file named\n"
		+ "'StartupMacros.txt', located in the 'macros' folder inside the\n"
		+ "Fiji folder, are automatically installed in the Plugins>Macros\n"
		+ "menu when Fiji starts.\n"
		+ "\n"
		+ "More information is available at:\n"
		+ "<http://imagej.nih.gov/ij/developer/macro/macros.html>";
	dummy = call("fiji.FijiTools.openEditor", title, text);
}

macro "Save As JPEG... [j]" {
	quality = call("ij.plugin.JpegWriter.getQuality");
	quality = getNumber("JPEG quality (0-100):", quality);
	run("Input/Output...", "jpeg="+quality);
	saveAs("Jpeg");
}

macro "Save Inverted FITS" {
	run("Flip Vertically");
	run("FITS...", "");
	run("Flip Vertically");
}

////////////////////////////////////////////////

// Imagej macros
// Ali Nick Maleki
// 12/8/2021

////////////////////////////////////////////////

macro "Correct drifts" {
// Ask for preffered rift correction method
Dialog.create("Correct Drifts");
Dialog.addChoice("Raw data source:          ", newArray("TrackMate", "Mark"));
Dialog.addChoice("Choose drift correction method:          ", newArray("Auto drift-correction","Point by point", "Unidirectional", "Interpolation"));
Dialog.addChoice("Choose image interpolation method:", newArray("Bicubic", "Bilinear"));
Dialog.addCheckbox("Save as Tiff", true)
Dialog.addCheckbox("Add scale bar and time stamper", false);
Dialog.show();
DataSource = Dialog.getChoice();
DCmethod  = Dialog.getChoice();
intmethod  = Dialog.getChoice();
SaveAsTiff=Dialog.getCheckbox();
scltime=Dialog.getCheckbox();
getPixelSize(unit, pixelWidth, pixelHeight);
if(DCmethod=="Auto drift-correction"){
	runMacro("Auto_drift-correction.ijm");
}else{
//Check if the pxel size correct
if(pixelWidth==1){
	Dialog.create("Scale");
	Dialog.addMessage("The image has no scale! \n \n");
	Dialog.addNumber("         Enter scale (pixel/micron):", 6.25);
	Dialog.addMessage("Tip: The scales for MDo TIRF1 and TIRF2 are \n 6.25 and 7.76 pixels/micron, respectively          ");
	Dialog.show();
	pixelWidth=Dialog.getNumber();
	run("Set Scale...", "distance="+pixelWidth+" known=1 pixel=1 unit=micron");
	}

if(DCmethod=="Unidirectional")
{
setSlice(1);
run("Enhance Contrast", "saturated=0.35");
Dialog.create("Coordinates");
Dialog.createNonBlocking("Selection");
Dialog.addMessage("Select the starting point");
Dialog.show();
getSelectionCoordinates(Sx, Sy);
n = nSlices;
setSlice(n);
Dialog.create("Coordinates");
Dialog.createNonBlocking("Selection");
Dialog.addMessage("Select the end point");
Dialog.show();
getSelectionCoordinates(Ex, Ey);
getDimensions(w, h, channels, slices, frames);

NofChannels=channels;
NoSlices=nSlices();
if(channels>1)
{
run("Split Channels");
NoSlices=NoSlices/NofChannels;
}

	dx=(Sx[0]-Ex[0])/(NoSlices-1);
    dy=(Sy[0]-Ey[0])/(NoSlices-1);

for (k = 1; k <= nImages();k++) {
selectImage(k);
run("Enhance Contrast", "saturated=0.35");
getDimensions(w, h, channels, slices, frames);
for (i = 1; i <= nSlices(); i++) {
//dispalcement in respect to the first slice
    xshift=i*dx;
    yshift=i*dy;
    
    makeRectangle(0, 0, w+xshift, h+yshift);
    setSlice(i);
    run("Translate...", "x=xshift y=yshift interpolation=intmethod");
    

}

run("Crop");
}
if(NofChannels>1)
{
run("Merge Channels...");
}}

	else {

	
// ask for a file to be imported
fileName = File.openDialog("Import drift data");
allText = File.openAsString(fileName);
tmp = split(fileName,".");
// get file format {txt, csv}
posix = tmp[lengthOf(tmp)-1];
// parse text by lines
text = split(allText, "\n");
 
// define array for points
var xpoints = newArray;
var ypoints = newArray; 
 
// in case input is in TXT format
if (posix=="txt") {	
	print("importing TXT point set...");
	//these are the column indexes
	hdr = split(text[0]);
	nbPoints = split(text[1]);
	iX = 0; iY = 1;
	// loading and parsing each line
	for (i = 2; i < (text.length); i++){
	   line = split(text[i]," ");
	   setOption("ExpandableArrays", true);   
	   xpoints[i-1] = parseFloat(line[iX]);
	   ypoints[i-1] = parseFloat(line[iY]);
	} 
// in case input is in CSV format
} else if (posix=="csv") {
	print("importing CSV point set...");
	//these are the column indexes
	hdr = split(text[0]);
	iLabel = 0; 
	if(DataSource=="Mark"){
	iX = 3; iY = 4;
		for (i = 1; i < (text.length); i++){
	   line = split(text[i],",");
	   setOption("ExpandableArrays", true);   
	   xpoints[i-1] = parseFloat(line[iX]);
	   ypoints[i-1] = parseFloat(line[iY]);
	   //print("p("+i+") ["+xpoints[i-1]+"; "+ypoints[i-1]+"]"); 
	} 
	}
	else{
		getPixelSize(unit, pixelWidth, pixelHeight);
		iX = 4; iY = 5;
		for (i = 4; i < (text.length); i++){
	   line = split(text[i],",");
	   setOption("ExpandableArrays", true);   
	   xpoints[i-4] = parseFloat(line[iX])/pixelWidth;
	   ypoints[i-4] = parseFloat(line[iY])/pixelWidth;
	}}
	// loading and parsing each line

// in case of any other format
} else {
	print("not supported format...");	
}

if (isOpen("Log")) {
         selectWindow("Log");
         run("Close" );}
getDimensions(w, h, channels, slices, frames);

NofChannels=channels;
if(channels>1)
{
run("Split Channels");
}
for (k = 1; k <= nImages();k++) {
selectImage(k);
run("Enhance Contrast", "saturated=0.35");
getDimensions(w, h, channels, slices, frames);

    dx=(xpoints[0]-xpoints[nSlices()-1])/(nSlices()-1);
    dy=(ypoints[0]-ypoints[nSlices()-1])/(nSlices()-1);

for (i = 1; i <= nSlices(); i++) {
//dispalcement in respect to the first slice
	
    if(DCmethod=="Point by point"){
    xshift=xpoints[0]-xpoints[i-1];
    yshift=ypoints[0]-ypoints[i-1];	
    }
    else {

    xshift=i*dx;
    yshift=i*dy;
    }
    makeRectangle(0, 0, w+xshift, h+yshift);
    setSlice(i);
    run("Translate...", "x=xshift y=yshift interpolation=intmethod");
    

}

run("Crop");
}
if(NofChannels>1)
{
run("Merge Channels...");
}
}

	
if(scltime)
{
runMacro("MakeVideos.ijm");
}

if (SaveAsTiff==true){
	dir = getDirectory("Choose a directory to save the Tiff file");
	title1=getTitle;
	title=split(title1,".");
	saveAs("Tiff", dir+title[0]+"_drift_corrected");
}
   
}}

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
/////////////////////////////////////////////////////////////////////////////////////////////////////////


macro "Split image" {
Dialog.create("Enter spliting parameters");
Dialog.addNumber("Horisintal divisions", 2);
Dialog.addNumber("Vertical divisions", 1);
Dialog.addCheckbox("Save", true)
Dialog.show();
SaveAsAVI=Dialog.getCheckbox();
if (SaveAsAVI) {
	dir = getDirectory("Choose a directory to save avi file");
}
nx=Dialog.getNumber();
ny=Dialog.getNumber();
id = getImageID(); 
ttl = getTitle;
title=replace( ttl , ".TIF" , "" ); 
getLocationAndSize(locX, locY, sizeW, sizeH); 
width = getWidth(); 
height = getHeight(); 
tileWidth = width/nx; 
tileHeight = height/ny; 
for (y = 0; y < ny; y++) { 
offsetY = y * height/ny; 
 for (x = 0; x < nx; x++) { 
offsetX = x * width/nx; 
selectImage(id); 
 call("ij.gui.ImageWindow.setNextLocation", locX + offsetX, locY + offsetY); 
tileTitle = title + " [" + x + "," + y + "]"; 
 run("Duplicate...", "duplicate title=&tileTitle");
makeRectangle(offsetX, offsetY, tileWidth, tileHeight); 
 run("Crop");

 if (SaveAsAVI) {
selectWindow(tileTitle);
saveAs("tiff",dir+tileTitle);
 }
//close(); 
} 
} 
selectImage(id); 
close(); 
}

// "Rotate Image"
// This macro rotates an image based on the angle
// of a straight line selection. The image is rotated
// so objects oriented similarly to the line 
// selection become horizontal.

  macro "Rotate Image" {
      requires("1.33o");
        W = getWidth;
  		H = getHeight;
      getLine(x1, y1, x2, y2, width);
      if (x1==-1)
           exit("This macro requires a straight line selection");
      angle = (180.0/PI)*atan2(y1-y2, x2-x1);
      newH=W*abs(cos(angle*PI/180))+H*abs(sin(angle*PI/180));
      newW=W*abs(sin(angle*PI/180))+H*abs(cos(angle*PI/180));
      Length=newW+newH;
      run("Canvas Size...", "width=newW height=newH position=Center zero");
      run("Arbitrarily...", "angle="+angle-90+" interpolate");
  }

     macro "Multiply pixel value" {
      setupUndo;
      Dialog.create("Multiply");
      Dialog.addNumber("Multiplication factor:", 2);
      Dialog.addNumber("Treshold:", 7000);
      Dialog.show();
      MF=Dialog.getNumber();
      Treshold=Dialog.getNumber();
      start = getTime();
      w = getWidth(); h = getHeight();
      for(i=1;i<=nSlices;i++){
      setSlice(i);
      for (y=0; y<h; y++) {
          for (x=0; x<w; x++) {
              v = getPixel(x, y);
              if(v>7000) {
              setPixel(x, y, v*MF); 
          }  
          if (y%20==0) showProgress(y, h);
      }
     showTime(start);
  }  showTime(start);
 }}
 
 macro "Stream to stack"{

title=getTitle();
getDimensions(width, height, channels, slices, frames);
Dialog.create("Number of wavelengths");
Dialog.addNumber("Enter number of channels:", 3);
Dialog.show();
channels=Dialog.getNumber();
setSlice(1);

for(j=1;j<=channels;j++){
	for(i=j; i<=slices;i=i+channels){
		selectWindow(title);
		setSlice(i);
		run("Duplicate...", "title=ch"+j+"_"+i+" duplicate range="+i+"-"+i+"");

	}
	}

//convert images to stack

Min_n_frames=slices;
ch_titles=newArray(channels);
for(i=1;i<=channels;i++){
	run("Images to Stack", "name=channel"+i+" title=ch"+i+"_ use");
	ch_titles[i-1]="channel"+i+"";
	selectWindow(ch_titles[i-1]);
	getDimensions(width1, height1, channels1, slices1, frames1);
	if(slices1<Min_n_frames){
		Min_n_frames=slices1;
	}
}

//Make number of slices equal to be able to merge them

for(i=1;i<=channels;i++){
	ch_ttl=ch_titles[i-1];
	selectWindow(ch_ttl);
	run("Duplicate...", "duplicate range=1-"+Min_n_frames+"");
	close(ch_ttl);
}
}
 
macro "TEM" {
dir = getDirectory("Choose a directory to save jpg file");
for (k=1; k<=nImages(); k++){
selectImage(k);
title=getTitle();
run("Enhance Contrast", "saturated=0.35 process_all");
wait(1000);
saveAs("Jpeg", dir+title);
}
}

  function showTime(start) {
      resetMinAndMax;
      showStatus(d2s((getTime()-start)*1000/(w*h), 2)+" microseconds/pixel");
  }
  
  
/////////////////////////////////////////////////////////////////////////////////////////////////// 
///////////////////////////////////////////////////////////////////////////////////////////////////  
///////////////////////////////////////////////////////////////////////////////////////////////////

 
   
macro "Auto drift-correction" {

    //to retain the metadata        
    info = getMetadata("info");
    gain = getInfo("Multiplication Gain");
    exposure = getInfo("Exposure");
    exposure_time = "";
    getPixelSize(unit, pixelWidth, pixelHeight);
    if (exposure != "")
        exposure_time = substring(exposure, 0, 3);

    getDimensions(width, height, channels, slices, frames);

    interval = getInfo("Frame interval (s)");

    while (true) {
        Dialog.create("Drift Settings");
        Dialog.addNumber("Gaussian fit SD", "0.8");
        Dialog.addNumber("EM-Gain", gain);
        Dialog.addNumber("Exposure time", exposure_time);
        Dialog.addNumber("Scale (" + unit + ")", pixelWidth);
        Dialog.addCheckbox("Video processing*", false);
        Dialog.addCheckbox("Save as TIF", true);
        Dialog.addCheckbox("Operate for large stacks", false);
        Dialog.addCheckbox("Apply to all stacks in this directory", false);
        Dialog.addCheckbox("Show drifted coordinate", false);
        Dialog.addChoice("Choose the primary channel for drift correction:", newArray("1", "2", "3", "4"));
        Dialog.addChoice("Storage location", newArray("Default", "Let me select"));
        Dialog.addMessage("* Video processing includes background substraction,\n adding scale bar, adding time stamp and saving as avi file", 12, "Red");
        Dialog.show();

        //obtain parameters from dialog
        Gs_SD = Dialog.getNumber();
        gain = Dialog.getNumber();
        exposure_time = Dialog.getNumber();
        pixelWidth = Dialog.getNumber();
        video_processing = Dialog.getCheckbox();
        Save_as_tiff = Dialog.getCheckbox();
        Big_tif = Dialog.getCheckbox();
        all_stacks = Dialog.getCheckbox();
        drft_show = Dialog.getCheckbox();
        Pchannel = Dialog.getChoice();
        storage = Dialog.getChoice();

        /////////////////////////////////

        img_directory = getDirectory("image");
        parent_folder_name = File.getName(img_directory);
        if (storage == "Let me select") {
            new_img_directory = getDirectory("Where do you want to store the drift corrected data");

            drift_folder = new_img_directory + parent_folder_name + "_drift_corrected" ;
            drift_data_folder = drift_folder + File.separator + "drift_data" ;
            temp_folder = new_img_directory + File.separator + "Temp";
        } else {
            drift_folder = img_directory + parent_folder_name + "_drift_corrected" ;
            drift_data_folder = drift_folder + File.separator + "drift_data" ;
            temp_folder = img_directory + File.separator + "Temp";
        }

        if (all_stacks) {
            file_list = getFileList(img_directory);
            D_corrected_tifs = getFileList(drift_folder);

            //Remove the already drift corrected files from the list
            for (i = 0; i < D_corrected_tifs.length; i++) {
                file_list = Array.deleteValue(file_list, D_corrected_tifs[i]);
            }

            tif_list = newArray();
            k = 0;
            for (i = 0; i < file_list.length; i++) {
                if (endsWith(file_list[i], ".tif")) {
                    tif_list[k] = file_list[i];
                    k++;
                }
            }

            while (tif_list.length > 0) {
                temp_title = getTitle();
                if (correct_drift(Gs_SD, drft_show, video_processing, Save_as_tiff, Big_tif, Pchannel)) {
                    tif_list = Array.deleteValue(tif_list, temp_title);
                    close(temp_title);
                    if (tif_list.length > 0) {
                        open(img_directory + File.separator + tif_list[0]);
                    }
                } else {
                    // Fitting failed, show error message and break out of the loop
                    showMessage("Fitting failed with the current parameters. Please try different values.");
                    break;
                }
            }
        } else {
            if (correct_drift(Gs_SD, drft_show, video_processing, Save_as_tiff, Big_tif, Pchannel)) {
                break; // Fitting successful, exit the loop
            } else {
                showMessage("Fitting failed with the current parameters. Please try different values.");
            }
        }

        if (all_stacks) {
            if (k == 0)
                print(" It seems these stacks are already drift-corrected.\n If you want to do drift correction anyways, you have to delete existing files in:\n " + drift_folder + "\n");
            print(k + " stacks were corrected for drifts. The drift-corrected stacks are stored at:\n" + drift_folder);
        }
    }
}

function correct_drift(Gs_SD, drft_show, video_processing, Save_as_tiff, Big_tif, Pchannel) {
    // function description
    getDimensions(width, height, channels, slices, frames);
    info = getMetadata("info");
    getPixelSize(unit, pixelWidth, pixelHeight);
    pixelwidth = pixelWidth * 1000;

    if (drft_show) {
        plot_drift = "plot_drift";
    } else {
        plot_drift = "";
    }

    ori_img_name = getTitle();

    if (channels > 1) {
        run("Split Channels");
        selectWindow("C" + Pchannel + "-" + ori_img_name);
    }

    img_name = getTitle();

    File.makeDirectory(drift_folder);
    File.makeDirectory(drift_data_folder);
    File.makeDirectory(temp_folder);
    img_name_raw = split(img_name, ".");
    drift_file = drift_data_folder + File.separator + img_name_raw[0] + ".tsv";

    if (channels > 1)
        Big_tif = false;

    if (Big_tif) {
        for (i = 1; i <= channels; i++) {
            selectWindow("C" + i + "-" + ori_img_name);
            setMetadata("Info", info);
            if (i != Pchannel) {
                saveAs("Tiff", "[" +temp_folder + File.separator + "C" + i + "-" + ori_img_name + "]");
                close("C" + i + "-" + ori_img_name);
            }
        }
    }

    if (channels > 1) {
        selectWindow(img_name);
    }

    run("Simple Fit", "  camera_type=EMCCD calibration=" + pixelwidth + " camera_bias=1 gain=" + gain + " exposure_time=" + exposure_time + " gaussian_sd=" + Gs_SD + "");

	logText = getInfo("log");
	inlog = indexOf(logText, "0 localisations") ;
	print(inlog) ;
while (inlog != -1) {

    close("Results");
    close("Fit Results");
    close("Log");
    gain = gain - 5;
    exposure_time = exposure_time - 5 ;
    Gs_SD = 0.5 + random()*2 ;
    if(gain <= 0){
    	gain = 5 + random()*200 ;
    	inlog = -1;
    	return false;

    }
        if(exposure_time <= 0){
    	exposure_time = 5 + random()*200 ;
    	inlog = -1;
		return false;
    }
    run("Simple Fit", "  camera_type=EMCCD calibration=" + pixelwidth + " camera_bias=1 gain=" + gain + " exposure_time=" + exposure_time + " gaussian_sd=" + Gs_SD + "");
	if(inlog != -1){
	logText = getInfo("log");
	inlog = indexOf(logText, "0 localisations") ;
	}
}

    close("Results");
    close("Fit Results");
    close("Log");

    run("Drift Calculator", "input=[" + img_name + " (LVM LSE)] method=[Reference Stack Alignment] max_iterations=50 relative_error=0.010 smoothing=0.25 limit_smoothing min_smoothing_points=10 max_smoothing_points=50 smoothing_iterations=1 " + plot_drift + " stack_image=[" + img_name + "] start_frame=1 frame_spacing=1 interpolation_method=Bicubic update_method=Update save_drift drift_file=[" + drift_file + "]" );

    if (Big_tif) {
        saveAs("Tiff", temp_folder + File.separator + "C" + Pchannel + "-" + ori_img_name);
        close("C" + Pchannel + "-" + ori_img_name);}
    requires("1.35r");
lineseparator = "\n";
cellseparator = "\t";

// copies the whole RT to an array of lines
lines = split(File.openAsString(drift_file), lineseparator);

// recreates the columns headers
labels = split(lines[0], cellseparator);
if (labels[0] == " ")
    k = 1; // it is an ImageJ Results table, skip first column
else
    k = 0; // it is not a Results table, load all columns
for (j = k; j < labels.length; j++)
    setResult(labels[j], 0, 0);

// dispatches the data into the new RT
run("Clear Results");
for (i = 1; i < lines.length; i++) {
    items = split(lines[i], cellseparator);
    for (j = k; j < items.length; j++)
        setResult(labels[j], i - 1, items[j]);
}
updateResults();

dash = substring(img_name, 2, 3);
C = substring(img_name, 0, 1);
if (dash == "-" && C == "C") {
    ori_img_name = substring(img_name, 3);
}

img_titles = newArray();
Two_ch_colors = newArray("Magenta", "Cyan");
three_ch_colors = newArray("Magenta", "Yellow", "Cyan");
// Apply drift

for (j = 1; j <= channels; j++) {
    if (channels == 1) {
        temp_img_name = ori_img_name;
    } else {
        temp_img_name = "C" + j + "-" + ori_img_name;
    }
    if (isOpen(temp_img_name) == false) {
        open(temp_folder + File.separator + "C" + j + "-" + ori_img_name);
    }
    selectWindow(temp_img_name);
    run("Enhance Contrast", "saturated=0.35");
    img_titles[j - 1] = "C" + j + "-" + ori_img_name;
    N_of_rsults = nResults;
    for (i = 0; i < N_of_rsults; i++) {
        dx = getResult("X", i);
        if (dx == NaN){
        	dxStr = getResultString("X", i);
        	dxStr = replace(dx, ",", ".");
        	dx = parseFloat(dxStr);
        }
        dy = getResult("Y", i);
        if (dy == NaN){
        	dyStr = getResultString("Y", i);
        	dyStr = replace(dx, ",", ".");
        	dy = parseFloat(dyStr);
        }
        makeRectangle(0, 0, width + dx, height + dy);
        setSlice(i + 1);
        run("Translate...", "x=dx y=dy interpolation=Bicubic");
    }
    run("Crop");

    if (Big_tif) {
        saveAs("Tiff", temp_folder + File.separator + "C" + j + "-" + ori_img_name);
        close("C" + j + "-" + ori_img_name);
    }
}

if (Big_tif) {
    for (j = 1; j <= channels; j++) {
        open(temp_folder + File.separator + "C" + j + "-" + ori_img_name);
    }
}

if (channels == 2) {
    run("Merge Channels...", "c1=" + img_titles[0] + " c2=" + img_titles[1] + " create ignore  ");
}
if (channels == 3) {
    run("Merge Channels...", "c1=" + img_titles[0] + " c2=" + img_titles[1] + " c3=" + img_titles[2] + " create ignore ");
}

selectWindow(ori_img_name);
info = info + "\n" + "Directory=" + img_directory;
setMetadata("Info", info);
close("Log");
close("Results");
if (video_processing) {
    runMacro("MakeVideos.ijm");
}

if (Save_as_tiff) {
    saveAs("Tiff", drift_folder + ori_img_name);
}

if (Big_tif) {
    for (j = 1; j <= channels; j++) {
        File.delete(temp_folder + File.separator + "C" + j + "-" + ori_img_name);
    }
}
File.delete(temp_folder);
close("Log");
return true; // Fitting successful
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////



macro "NS_position_calculator"{


dir=getDirectory("image");
title=getTitle();
Dialog.createNonBlocking("Select crop area");
Dialog.show();
setTool("rectangle");
run("Crop");
getDimensions(width, height, channels, slices, frames);


Dialog.create("Gaussian fitter");
Dialog.addCheckbox("Write in Metadata", true);
Dialog.addCheckbox("Save", true);
Dialog.addMessage("Select relevant channels:");
for(i=1; i <= channels; i++){
	Dialog.addCheckbox("Channel " + i, false);
}
Dialog.show();

st=newArray();
ch=newArray();
Wr_MtData=Dialog.getCheckbox();
ifsave=Dialog.getCheckbox();
for(i=0; i<channels; i++){
	ch[i]=Dialog.getCheckbox();
}

for(i=0; i<channels ; i++){
	if(ch[i]){
	st=GFitter(i+1,Wr_MtData);
	print("Chanel " + i+1 +", " + "Mode: " + st[0] + ", Mean: " + st[1] + ", std: " + st[2]);
	}
}

if(ifsave){
	NS_folder=dir + File.separator + "NS_rest_position";
	File.makeDirectory(NS_folder);
	saveAs("TIF", NS_folder + File.separator + title);
}


function GFitter(chnl,Wr_MtData){
info = getMetadata("info");
Stack.setChannel(chnl);
y_values=newArray();
y_line=newArray();
x_values=newArray(width);
x_o_values=newArray();
y_indices=newArray();
y_indices_2=newArray();
f = "y=a*exp(-(3.14*a*a*(pow((x - b),2))))";

for (i = 0; i < width; i++) {
x_values[i]=i;
}

mx_indx=0;
c=0;
for(j=0;j<height;j++){
	y_indices[height-1-j]=j;
	y_indices_2[j]=j;
  for(i=0;i<width;i++){
  	
  	y_values[c] = getPixel(i,j);
  	y_line[i]=getPixel(i,j);
  	Array.getStatistics(y_line, y_line_min, y_line_max, y_line_mean, y_line_stdDev);
  	if(y_line[i]==y_line_max){
  		mx_indx=i;
  	}
  	c = c+1;
  	}
  	
  	
if(mx_indx==0){

	y_line_trimmed=Array.slice(y_line,mx_indx,mx_indx+3);
 	x_values_trimmed=Array.slice(x_values,mx_indx,mx_indx+3);
 	Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_values[j]=Fit.p(1);
	
}
else if(mx_indx==width){
	y_line_trimmed=Array.slice(y_line-3,mx_indx,mx_indx);
 	x_values_trimmed=Array.slice(x_values-3,mx_indx,mx_indx);
 	Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_values[j]=Fit.p(1);
}
else if(mx_indx==1 || mx_indx==width-1){
	y_line_trimmed=Array.slice(y_line,mx_indx-1,mx_indx+1);
 	x_values_trimmed=Array.slice(x_values,mx_indx-1,mx_indx+1);
 	Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_values[j]=Fit.p(1);
	
}
else if(mx_indx==2 || mx_indx==width-2){
		y_line_trimmed=Array.slice(y_line,mx_indx-2,mx_indx+2);
 		x_values_trimmed=Array.slice(x_values,mx_indx-2,mx_indx+2);
 		Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_values[j]=Fit.p(1);
	
}
else{
  	 	
 y_line_trimmed=Array.slice(y_line,mx_indx-3,mx_indx+3);
 x_values_trimmed=Array.slice(x_values,mx_indx-3,mx_indx+3);
Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_values[j]=Fit.p(1);

  	}
}
//Fit.plot ;
//Plot.create("Fit results", "X", "Frame");
//Plot.add("circles", x_o_values, y_indices);
Array.getStatistics(x_o_values, x_o_values_min, x_o_values_max, x_o_values_mean, x_o_values_stdDev);
//print("mean x0 position: " + x_o_values_mean + " ± " + x_o_values_stdDev);
//Plot.setColor("Magenta");

makeSelection("point",x_o_values,y_indices_2);


mode = -1;
count_max = -1;
// go from min to max and count how often the numbers appear
for (search_num = x_o_values_min; search_num <= x_o_values_max; search_num++) { // works only with integer numbers
	count = 0;
	// count how often a given number appears
	for (j = 0; j < x_o_values.length; j++) {
		if (x_o_values[search_num] == x_o_values[j]) {
			count = count + 1;
		}
	}
	// keep the number which appears most often
	if (count > count_max) {
		count_max = count;
		mode = x_o_values[search_num];
	}
}

//print("Mode: "+ mode);
info=info + "\n" + "NS rest position (Mode, channel " + chnl + ")=" + mode ; 
info=info + "\n" + "NS rest position (Mean ± sd, channel " + chnl + ")=" + x_o_values_mean + " ± " + x_o_values_stdDev + "\n" ;	
selectWindow(title);
if(Wr_MtData){
setMetadata("Info", info);
}
A=newArray(mode, x_o_values_mean, x_o_values_stdDev);
return A;
}
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////



macro "x_O"{

getSelectionCoordinates(xpoints, ypoints);
j=round(ypoints[0]);
var x_o_vlaue;
getDimensions(width, height, channels, slices, frames);
x_values=newArray(width);
y_line=newArray(width);
f = "y=a*exp(-(3.14*a*a*(pow((x - b),2))))";

for (i = 0; i < width; i++) {
x_values[i]=i;
}

mx_indx=0;


  for(i=0;i<width;i++){
  	
  	y_line[i]=getPixel(i,j);
  	Array.getStatistics(y_line, y_line_min, y_line_max, y_line_mean, y_line_stdDev);
  	if(y_line[i]==y_line_max){
  		mx_indx=i;
  	}
  	}
 Array.show(y_line); 	
  	
if(mx_indx==0){

	y_line_trimmed=Array.slice(y_line,mx_indx,mx_indx+3);
 	x_values_trimmed=Array.slice(x_values,mx_indx,mx_indx+3);
 	Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_value=Fit.p(1);
	
}
else if(mx_indx==width){
	y_line_trimmed=Array.slice(y_line-3,mx_indx,mx_indx);
 	x_values_trimmed=Array.slice(x_values-3,mx_indx,mx_indx);
 	Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_value=Fit.p(1);
}
else if(mx_indx==1 || mx_indx==width-1){
	y_line_trimmed=Array.slice(y_line,mx_indx-1,mx_indx+1);
 	x_values_trimmed=Array.slice(x_values,mx_indx-1,mx_indx+1);
 	Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_value=Fit.p(1);
	
}
else if(mx_indx==2 || mx_indx==width-2){
		y_line_trimmed=Array.slice(y_line,mx_indx-2,mx_indx+2);
 		x_values_trimmed=Array.slice(x_values,mx_indx-2,mx_indx+2);
 		Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_value=Fit.p(1);
	
}
else{
  	 	
 y_line_trimmed=Array.slice(y_line,mx_indx-3,mx_indx+3);
 x_values_trimmed=Array.slice(x_values,mx_indx-3,mx_indx+3);
Fit.doFit(f, x_values_trimmed, y_line_trimmed);
  	  	x_o_value=Fit.p(1);

  	}
  	
print("X0= " + x_o_value);
}



////////////////////////////////////////////////////////////////////////////////////////////////////



macro "Smart Kymo"{
metadata = getMetadata("Info");
getDimensions(width, height, channels, slices, frames);	
dir=getDirectory("image");
if(dir == "")
	dir = getDir("Where do you want to store kymographs?");
kymo_folder = dir + "Kymographs" + File.separator ;
File.makeDirectory(kymo_folder);

f_interval=getInfo("Frame interval (s) ");
if(f_interval==""){
	f_interval=Stack.getFrameInterval();
	if(f_interval=="")
		f_interval=getNumber("Time interval was not found in the metadata. Enter the frame interval (s):", 1);
}

getPixelSize(unit, pixelWidth, pixelHeight);
if(pixelWidth==1){
	pixelWidth=getNumber("Enter pixel width in micrometer", 0.16);
	run("Set Scale...", "distance=1 known="+(pixelWidth)+" unit=micron");
}

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
  kymo_dir = dir + "Kymographs"  ;
  unkowkn_dir = kymo_dir + File.separator + "Unkown" + File.separator ;
  File.makeDirectory(unkowkn_dir);
  file_list = getFileList(kymo_dir);
  folder_list = newArray();
  subfolder_count = 0 ;
  for (i=0; i<file_list.length; i++) {
   	if (endsWith(file_list[i], "/")){
   		subfolder_name = split(file_list[i], "/") ;
   		if (subfolder_name[0] != "ROIs"){
   		folder_list[subfolder_count] = subfolder_name[0] ;
   		subfolder_count++ ;}
   		}
  }

Dialog.create("Kymograph settings");
Dialog.addCheckbox("Adjust contrast for each channel manually", true);
Dialog.addCheckbox("Save kymographs", true);
Dialog.addNumber("Scale bar length (micron)", 5);
Dialog.addNumber("Time bar duration (min)", 1);
Dialog.addNumber("Header's font size", 18);
Dialog.addNumber("Scale bar text's font size", 12);
Dialog.addNumber("The width of the separator lines in the montaged image", 4);
Dialog.addNumber("The width of the selection line (to make kymographs)", 3);
Dialog.addChoice("Kymograph generation mode", newArray("Maximum", "Average"));
for(i=0; i < channels; i++){
Array.deleteValue(colors, Wavecolors[i]);	
colors=Array.concat(Wavecolors[i] , colors);
Dialog.addChoice(WaveNames[i] + " channel color:          ", colors);
}
Dialog.addCheckbox("Replace this kymo to the most recently made existing kymograph in the directory", false);
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
for (i=0 ; i<channels; i++)
	Wavecolors[i]=Dialog.getChoice();


delete_last_kymo = Dialog.getCheckbox();

scale_bar = Scale_bar_size/pixelWidth;
time_scale = floor(time_scale_duration*60/parseInt(f_interval));
run("Line Width...", "line="+line_width);	





Dialog.create("Channel Names");
Dialog.addMessage("What is inside each channel (e.g. tubulin, Nanospring, ...)?" );

for(i=1; i<=channels; i++){

	if(WaveNames[i-1]=="642"){
		//Wavecolors[i-1]=replace(WaveNames[i-1], "642", "Magenta");
		Dialog.addString("642 channel", "");
	}
	if(WaveNames[i-1]=="561"){
		//Wavecolors[i-1]=replace(WaveNames[i-1], "561", "Yellow");
		Dialog.addString("561 channel", "");
	}
	if(WaveNames[i-1]=="488"){
		//Wavecolors[i-1]=replace(WaveNames[i-1], "488", "Cyan");
		Dialog.addString("488 channel", "");
	}
}
for (i = 0; i < Wavecolors.length; i++){ 
	Stack.setChannel(i+1);
	run(Wavecolors[i]);}

channel_contents=newArray(channels);
if(!File.exists(kymo_folder + File.separator + "Channel_data.txt")){
Dialog.show();
for(i=0; i<channels ; i++)
	channel_contents[i]=Dialog.getString();
f = File.open(kymo_folder+File.separator + "Channel_data.txt"); // display file open dialog
   //f = File.open("/Users/wayne/table.txt");
   // use d2s() function (double to string) to specify decimal places
  print(f, "The following fluorescent molecules/proteins have been used in this experiment:"); 
  for (i=0; i<channels; i++)
     print(f, WaveNames[i] + ":" +channel_contents[i]);	
}
else {
	str_file=File.openAsString(kymo_folder + File.separator + "Channel_data.txt");
	file_lines=split(str_file, "\n");
	for (i = 0; i < file_lines.length-1; i++){
		components_of_file_line=newArray();
		components_of_file_line=split(file_lines[i+1],":");
		channel_contents[i]=components_of_file_line[1];
	}
	}



ori_image_name=getTitle();
run("KymoResliceWide ", "intensity=" + kymo_mode);
a=getTitle();
b=split(a,".");
getDimensions(width, height, channels, slices, frames);	


rename("kymo1");		
if(channels>1){
newImage("kymo1_Montage", "RGB", (channels+1)*(width+seperator_width)+ 2*seperator_width + scale_font_size, height+ FontSize + 3*seperator_width+ scale_font_size, 1);
setColor("Black");
fillRect(0, 0, (channels+1)*(width+seperator_width)-seperator_width, FontSize);
selectWindow("kymo1");
Stack.setChannel(channels);
setFont("SansSerif", FontSize);
setJustification("center");
active_channel_array=newArray("1000","0100","0010","0001");

for (i = 0; i < channels; i++) {
	
selectWindow("kymo1");
Stack.setChannel(i+1);
run("Enhance Contrast", "saturated=0.35");
if(manual_contrast_adjust){
	Stack.setActiveChannels(active_channel_array[i]);
	waitForUser("   This is '"+channel_contents[i]+"' channel.	 \n   Adjust the contrast then click on ok button to continue	");
}
Image.copy;


selectWindow("kymo1_Montage");
Image.paste(i*(width+seperator_width),FontSize, "copy");
x=i*(width+seperator_width) + floor(width/2);
Wavecolors[i]=replace(Wavecolors[i], "Grays", "lightGray");
setColor(Wavecolors[i]);
Overlay.drawString(channel_contents[i], x, FontSize-3,0.0);
Overlay.show;
setColor("White");
fillRect(i*seperator_width+(i+1)*width, 0, seperator_width, height+FontSize);
}

selectWindow("kymo1");
Stack.setActiveChannels("1111");
if(manual_contrast_adjust)
	waitForUser("Adjust the contrast of the composite picture \n then click on ok button to continue");
run("RGB Color");
Image.copy;
close( "kymo1 (RGB)");
selectWindow("kymo1_Montage");
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
close("kymo1_Montage");
}
else{

	newImage("kymo1_Montage", "RGB", width + 3*seperator_width + scale_font_size, height+ FontSize + 3*seperator_width+ scale_font_size, 1);
	setColor("Black");
	fillRect(0, 0, width, FontSize);
	selectWindow("kymo1");
	setFont("SansSerif", FontSize);
	setJustification("center");
	run("Enhance Contrast", "saturated=0.35");
	if(manual_contrast_adjust){
	waitForUser("   This is '"+channel_contents[0]+"' channel.	 \n   Adjust the contrast then click on ok button to continue	");
	}
	Image.copy;
	selectWindow("kymo1_Montage");
	Image.paste(0,FontSize, "copy");
	x= floor(width/2);
	Wavecolors[0]=replace(Wavecolors[0], "Grays", "lightGray");
	setColor(Wavecolors[0]); 
	Overlay.drawString(channel_contents[0], x, FontSize-3,0.0);
	Overlay.show;
	setColor("White");
	fillRect(seperator_width+width, 0, seperator_width, height+FontSize);
	setColor("Black");
	fillRect(width+seperator_width, height + FontSize - time_scale, 4, time_scale); //Time bar
	setFont("SansSerif", scale_font_size);
	Overlay.drawString(time_scale_duration+" min", width + scale_font_size + 3*seperator_width, height+FontSize + scale_font_size, 90.0);
	makePoint(width - scale_bar, height + FontSize + seperator_width); //Scale bar
	run("Scale Bar...", "width="+scale_bar+" height=8 thickness=4 font=14 color=Black background=None location=[At Selection] horizontal bold hide overlay");
	run("Select None");
	micrometer=getInfo("micrometer.abbreviation");
	setJustification("Right");
	Overlay.drawString(Scale_bar_size + " " + micrometer, width  ,height+FontSize + 2*seperator_width + scale_font_size , 0.0);
	Overlay.show;
	Overlay.flatten;
	close("kymo1_Montage");
}

Dialog.create("Event category");
Dialog.addChoice("Select event category", folder_list );
Dialog.addString("Enter the new category here if none of the above matches", "");
Dialog.show();

event_type1 = Dialog.getChoice();
event_type = Dialog.getString();
if (event_type == "")
	event_type = event_type1 ;

save_folder = kymo_folder  + event_type + File.separator ;
File.makeDirectory(save_folder);

c=getFileList(save_folder);
k=1;
e=already_exists(a ,c);
while(e){
	a=b[0] + "_" + k + ".tif";
	k++;
	e=already_exists(a,c);
}

	if (delete_last_kymo){
		a=b[0] + "_" + k-2 + ".tif";
		if (k-2==0)
			a=b[0] + ".tif";
	}

if(ifsave){
f=split(a,".");
selectWindow("kymo1_Montage-1");
saveAs("Tiff", save_folder + f[0]+ "_" + event_type + "_Montage");
selectWindow("kymo1");
setMetadata("Info", metadata);
saveAs("Tiff", save_folder + f[0] );
ROI_folder=kymo_folder + File.separator + "ROIs" + File.separator ;
File.makeDirectory(ROI_folder);
selectWindow(ori_image_name);
roiManager("Add");
roiManager("select", 0);
roiManager("Save",ROI_folder + f[0] + "_" + event_type + ".roi");
selectWindow("ROI Manager");
run("Close");
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

////////////////////////////////////////////////////////////////////////////////////////


// Create and save kymographs together with the Line Coordinates

//macro "multi kymo save"{
//dir = getDirectory("Choose a Directory");
//title=getTitle();
//f_name=split(title, ".");
//lineWidth = 3;
//
//for (n=0; n< roiManager("count"); n++) {
//	
//	roiManager("select", n);
//	roiManager("Set Line Width", lineWidth);
//	run("KymoResliceWide ", "intensity=Maximum ignore");
//
//	if (n < 9) {
//		MT_num = "00" + (n+1);		
//	} else {
//		MT_num = "0" + (n+1); 
//	}
//
//	file_Kymo = dir + f_name[0] + MT_num + ".tif";
//	saveAs("Tiff", file_Kymo);
//	close();
//	
//	roiManager("Set Line Width", 1);
//	file_Cor = dir + f_name[0] + MT_num + ".txt"; 
//	slicenumber = getSliceNumber();
//	saveAs("XY Coordinates", file_Cor);
//}
//}



//
///////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////




macro "Dynamic instability analysis"{

getDimensions(width, height, channels, slices, frames);
getPixelSize(unit, pixelWidth, pixelHeight);
Dialog.create("Analysis");
Dialog.addNumber("Enter the line width to create kymograph", 3);
//Dialog.addChoice("Select microtubule channel", newArray("1","2","3","4"));
Dialog.addCheckbox("Save ROI source of the kymograph", true);
Dialog.addMessage("Add regions of interest to ROI manager by pressing the letter T on the keyboeard and then click ok. This will create multiple kymographs");
Dialog.show();
save_kymo_roi=Dialog.getCheckbox();
lineWidth = Dialog.getNumber();

image_dir = getDirectory("image");
dyn_inst_dir = image_dir + File.separator + "Dynamic_instability_analysis" ;
File.makeDirectory(dyn_inst_dir) ;
kymo_ROI_dir = dyn_inst_dir + File.separator + "Kymo_ROI" ;
File.makeDirectory(kymo_ROI_dir) ;
//Event_ROI_dir = dyn_inst_dir + File.separator + "Events_ROI" ;
//File.makeDirectory(Event_ROI_dir) ;

f_interval=getInfo("Frame interval (s) ");
if(f_interval==""){
	f_interval=Stack.getFrameInterval();
	if(f_interval=="")
		f_interval=getNumber("Time interval was not found in the metadata. Enter the frame interval (s):", 1);
}


if(pixelWidth==1){
	pixelWidth=getNumber("Enter pixel width in micrometer", 0.16);
	run("Set Scale...", "distance=1 known="+(pixelWidth)+" unit=micron");
}	


f_interval=parseFloat(f_interval)/60 ; //converting S to min
title =getTitle();
f_name = split(title, ".");
number_of_ROIs = roiManager("count");
roiManager("Show All with labels");
for(n=0 ; n < number_of_ROIs ; n++){
	
	selectWindow(title);
	roiManager("select", n);
	roiManager("Set Line Width", lineWidth);
	roiManager("Save",kymo_ROI_dir + File.separator + f_name[0] + "_" + n + ".roi");
	run("KymoResliceWide ", "intensity=Maximum ignore");
	rename("kymo_" + n);

}

selectWindow("ROI Manager");
roiManager("Delete");
Dialog.createNonBlocking("Select events");
Dialog.addMessage("Add events to ROI manager by pressing letter T on the keyboard.\n This macro is working on the assumption that MTs grow from left to right \n from a seed and then undergo catastrohe and reach zero length again");
Dialog.show();



V_g=newArray();
V_s=newArray();
growth_time=newArray();
catastrophe=newArray();

f = File.open(dyn_inst_dir + File.separator + title + "_Events.txt"); // display file open dialog
   //f = File.open("/Users/wayne/table.txt");
   // use d2s() function (double to string) to specify decimal places
print(f, "Growth rate (micron/min)" + "\t" + "Shrinkage rate (micron/min)" + "\t" + "Growth time (min)" + "\t" + "catastrophe rate (1/min)"); 

for (i=0; i<roiManager("count"); i++){
	roiManager("Select", i);
	Roi.getCoordinates(xpoints, ypoints);
	growth_time[i]=(ypoints[1] - ypoints[0])*f_interval;
	catastrophe[i]=1/growth_time[i];
	V_g[i] = (xpoints[1]-xpoints[0])*pixelWidth*catastrophe[i];
	V_s[i]=((xpoints[2]-xpoints[1])*pixelWidth)/((ypoints[2]-ypoints[1])*f_interval);
	print(f, V_g[i] + "\t" +  V_s[i] + "\t" + growth_time[i] + "\t" + catastrophe[i]); 

}

Array.getStatistics(V_g, V_g_min, V_g_max, V_g_mean, V_g_stdDev);
Array.getStatistics(V_s, V_s_min, V_s_max, V_s_mean, V_s_stdDev);
Array.getStatistics(catastrophe, catastrophe_min, catastrophe_max, catastrophe_mean, catastrophe_stdDev);

print(" Average growth rate= " + V_g_mean + " ± " + V_g_stdDev + "\n Average shrikage rate= " + V_s_mean + " ± " + V_s_stdDev+ "\n Average catasrophe rate= " + catastrophe_mean + " ± " + catastrophe_stdDev+ "\n N = " + roiManager("count"));
print(f," Average growth rate= " + V_g_mean + " ± " + V_g_stdDev + "\n Average shrikage rate= " + V_s_mean + " ± " + V_s_stdDev+ "\n Average catasrophe rate= " + catastrophe_mean + " ± " + catastrophe_stdDev+ "\n N = " + roiManager("count"));

}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

macro "Set MetaData"{
    metadata=getMetadata("Info");
    Dialog.create("MetaData");
    Dialog.addRadioButtonGroup("Choose MetaData Assiging method", newArray("From textbox below","Copy from a TIF file", "Import from a txt file"), 1, 3, "");
    Dialog.addMessage("\n");
    Dialog.addString("\n e.g.", "magnification=100x",20) ;
    Dialog.show();
    MD_choice = Dialog.getRadioButton();
    if(MD_choice == "From textbox below"){
        box_text = Dialog.getString();
        metadata = metadata + "\n" + box_text + "\n" ;
    }
    if(MD_choice == "Copy from a TIF file"){
        
	run("Bio-Formats", "open=" +  " color_mode=Default display_metadata rois_import=[ROI manager] view=[Metadata only] stack_order=Default");

	key_array = newArray();
	value_array = newArray();
	Line_array = newArray();
	N_result= getValue("results.count");

	for (i = 0; i < N_result; i++) {
    key_array[i] = getResultString("Key", i);
    value_array[i] = getResultString("Value", i);
    Line_array[i] = key_array[i] + " = " + value_array[i] ;
    //print(Line_array[i]);
    metadata = metadata + "\n" + Line_array[i] ;
    setMetadata("Info", metadata) ;
    metadata = getMetadata("Info") ;
}

run("Close");

    }
    if(MD_choice == "Import from a txt file"){
        file_path = File.openDialog("Choose the txt file to import metadata from");
        text_string = File.openAsString(file_path);
        text_string = text_string.replace("\t"," = ");
        metadata = metadata + "\n" + text_string;
    }
    setMetadata("Info", metadata);
    
run("Save");
}


macro "Correct Shading" {
    // Open the stack
    metadata = getMetadata("Info");
    MD_is_lost = false ;
    List.setCommands;
	if (List.get("BaSiC ") == "") {
		print("This macro requires BaSiC plugin to operate. Make sure you have installed it before using this macro.\n How to install? See: https://github.com/marrlab/BaSiC ");
		}
	getDimensions(width, height, n_channels, slices, frames);
	if (n_channels =="")
		getNumber("Number of channels in the stack:", 1);
		
	path = getDirectory("image");
	if(path =="") {
		showMessage("The file directory could be determined. Select the stack that you want to correct its shading.\n This reselection is to determine the location of the stack.");
    	path = File.openDialog("Choose the stack to open");
    	img_orig_title = File.getName(path);
    	parent_folder = File.getParent(path) + File.separator ;
    	MD_is_lost = true ;
		}
		else{
    parent_folder = path;
	img_orig_title = getTitle();}
	
	close(img_orig_title);
    File.openSequence(path, " filter=" + img_orig_title);
    img_seq_title = getTitle() ;

    // Ask the user to specify the number of channels
    
    merge_string = "";

    // Create a new substack for each channel
    for (c = 1; c <= n_channels; c++) {
        selectWindow(img_seq_title);
        run("Make Substack...", "slices=" + c + "-" + nSlices() + "-" + n_channels);
        new_title = "C" + c + "-" + img_orig_title ;
        rename(new_title);
        run("BaSiC ", "processing_stack=" + new_title + " flat-field=None dark-field=None shading_estimation=[Estimate shading profiles] shading_model=[Estimate flat-field only (ignore dark-field)] setting_regularisationparametes=Automatic temporal_drift=Ignore correction_options=[Compute shading and correct images] lambda_flat=0.50 lambda_dark=0.50");
        //selectWindow("Log");
        close(new_title);
        close("Flat-field:" + new_title);
        merge_string = merge_string + "c" + c + "=Corrected:" + new_title + " " ; 
    }
    // Close the original stack
    close(img_seq_title);
    merge_string = merge_string + "create";
    run("Merge Channels...", merge_string );

    img_orig_title_name = split(img_orig_title, ".");
    shading_corrected_img_title = img_orig_title_name[0] + "_shading_corrected.tif" ;
	rename(shading_corrected_img_title );
	selectWindow(shading_corrected_img_title );
	setMetadata("Info", metadata) ;

	// To add the original metadata to image
	
	if(MD_is_lost){
	run("Bio-Formats", "open=" + path +  " color_mode=Default display_metadata rois_import=[ROI manager] view=[Metadata only] stack_order=Default");

    key_array = newArray();
    value_array = newArray();
    Line_array = newArray();
    N_result= getValue("results.count");

    for (i = 0; i < N_result; i++) {
        key_array[i] = getResultString("Key", i);
        value_array[i] = getResultString("Value", i);
        Line_array[i] = key_array[i] + " = " + value_array[i] ;
        //print(Line_array[i]);
        metadata = metadata + "\n" + Line_array[i] ;
        setMetadata("Info", metadata) ;
        metadata = getMetadata("Info") ;
    }
    run("Close");
	}
	
	setMetadata("Info", metadata);
	saveAs("tif", parent_folder + shading_corrected_img_title );
}



macro "Process TIFs"{
openDir = getDirectory("Choose the directory of teh source files");
saveDir = openDir + File.separator + "SingleChannelTIFs" ;
if(!File.isDirectory(saveDir)){
	File.makeDirectory(saveDir);
}
filelist = getFileList(openDir) ;
Stack.getDimensions(width, height, channels, slices, frames);
refFrame = round(frames/2);
channelNumber = getNumber("Select channel", 1);
close();
for (i = 0; i < lengthOf(filelist); i++) {
    if (endsWith(filelist[i], ".tif")) { 
        open(openDir + File.separator + filelist[i]);
    	imgName = getTitle();
	run("Duplicate...", "duplicate channels=" + channelNumber + "-" + channelNumber + " frames=" + refFrame );
	run("Subtract Background...", "rolling=50 stack");
	saveAs("Tiff", saveDir + File.separator + imgName);
	close();
	close();
}
}
}






function exposure_correction(terget_channel) { 


title = getTitle();
meta_data = getImageInfo();
// Initialize arrays to store the background values
getDimensions(width, height, channels, Slices, frames);
backgroundValues = newArray(Slices);
itr_factor = 1 ;
if (channels>1){

itr_factor = channels ;
}
Stack.setChannel(terget_channel);
// Loop through each frame to find the background value
for (i = 1; i <= frames; i++) {
    // Select the current frame
    //setSlice(i);
    Stack.setFrame(i);

    // Get histogram of the current slice within the ROI
    nBins = 256;
    values = newArray(nBins);
    counts = newArray(nBins);
    getHistogram(values, counts, nBins);

    // Find the mode (most frequently occurring pixel value)
    maxCount = 0;
    modeValue = 0;
    for (j = 0; j < nBins; j++) {
        if (counts[j] > maxCount) {
            maxCount = counts[j];
            modeValue = values[j];
        }
    }

    // Store the mode value as the background value for this frame
    backgroundValues[i - 1] = modeValue;
}

minValue = backgroundValues[0];
Stack.setChannel(terget_channel);
for (i = 1; i < backgroundValues.length; i++) {
    if (backgroundValues[i] < minValue) {
        minValue = backgroundValues[i];
    }
}
a = 1 ;
// Loop through each frame and subtract (mean - minimum) from the whole image

    // Loop through each frame and subtract the computed value from each pixel
    for (i = 1; i <= frames; i++) {
        // Select the current frame
        //setSlice(i);
        Stack.setFrame(i);
        
        // Get the mode value for the current frame
        modeValue = backgroundValues[i - 1];
        
        // Iterate through all pixels and apply the subtraction formula
        for (y = 0; y < height; y++) {
            for (x = 0; x < width; x++) {
                pixelValue = getPixel(x, y);
                subtractValue = (1 + a * (pixelValue - modeValue)/modeValue)*(modeValue - minValue);
                newValue = pixelValue - subtractValue;
                setPixel(x, y, newValue);
            }
        }
    }

// Update the display
run("Enhance Contrast", "saturated=0.35");

// Close the Results table to clean up
close("Results");
}

macro "Correct interframe exposure variation"{
	getDimensions(width, height, channels, slices, frames);
	terget_channel = 1 ;
	if(channels>1)
	terget_channel = getNumber("Enter the target channel number to correct flickering", 1);
	exposure_correction(terget_channel);
}



////////////////////////////////////////////////////////////////////////////////////////////////////



macro "Edge detector" {
    // Initialize variables
    var width, height, x_points, y_points, imgID, pointsID;
    var scan_direction = "Y";
    var interval, unit, pixelWidth, pixelHeight;
    var y_scan_direction = "↓"; //↑↓
	var smoothing_number = 0 ;
	var close_kymo = true ;
	var detection_method = "Gradient" ;
	var RecWidth = 60;
	var RecHeight = 30 ;
    // Open the image if not already open
    imgID = getImageID();;
    Stack.setChannel(2);
    interval = getInfo("Frame interval (s)");
    getPixelSize(unit, pixelWidth, pixelHeight);
    if (interval == "") {
        interval = Stack.getFrameInterval();
        if (interval == "") {
            interval = 1;
        }
    }

    // Get image dimensions
    width = getWidth();
    height = getHeight();
    
    // Initialize arrays for transition points
    x_points = newArray(0);
    y_points = newArray(0);
    
    // Set up the interactive tool
    setTool("rectangle");
	selectImage(imgID);
    while (true) {

         

        width = getWidth();
    	height = getHeight();
    
		
		getCursorLoc(x, y, z, flags);
        
        if (flags == 8|87) { 
            roiManager("deselect");
            roiManager("delete");
            Overlay.remove;
            setTool("polyline");
            exit();
        } else if (flags == 16 |1) { 
            findTransitionPoints(x, y, scan_direction);
            
            wait(100);
        } else if (flags == (8 | 1)) { 
            removeROIs(x - (RecWidth / 2), y - (RecHeight / 2), x + (RecWidth / 2), y + (RecHeight / 2));
            wait(100);
        } else if (flags == (8 | 2)) {
            imageName = getTitle();
            saveROIsToCSV(imageName, 1);
		} else if (flags == (8)) {
			Dialog.create("Settings");
			Dialog.addSlider("Rectangle width", 2, 100, RecWidth);
			Dialog.addSlider("Rectangle height", 2, 100, RecHeight);
			Dialog.addSlider("smoothing", 0, 10, 0);
			Dialog.addRadioButtonGroup("Transition detection method", newArray("Gradient", "Maximum"), 1, 2, detection_method);
			Dialog.addRadioButtonGroup("Scan direction", newArray("X", "Y", "Both"), 1, 3, scan_direction);
			Dialog.addRadioButtonGroup("Y scan direction", newArray("↓", "↑"), 1, 2, y_scan_direction);
			Dialog.addCheckbox("Flip image horizontally", false);
			Dialog.addCheckbox("Make polyline", false);
			Dialog.show();
		    
		    RecWidth = Dialog.getNumber();
		    RecHeight = Dialog.getNumber();
		    smoothing_number = Dialog.getNumber();
		    detection_method = Dialog.getRadioButton();

		    scan_direction = Dialog.getRadioButton();
		    y_scan_direction = Dialog.getRadioButton();
		    flip_image = Dialog.getCheckbox();
		    make_polyline = Dialog.getCheckbox();
		    for(p=0 ; p<smoothing_number; p++){
		        run("Select All");
		        run("Smooth");
		    }
		    if(flip_image){
		        run("Select All");
		        run("Flip Horizontally");
		    }
		    if(make_polyline){
		        createPolylineFromROIs();
		    }
		    wait(100);
		} else if (flags == 16) {
			count = roiManager("count");
			if(count != 0){
            roiManager("deselect");
            roiManager("delete");}
            else{
            Overlay.remove;
            setTool("polyline");
            exit();
            }
            wait(100);
        }
        
        Overlay.remove ; 
        makeRectangle(x - (RecWidth / 2), y - (RecHeight / 2), RecWidth, RecHeight);
        Overlay.addSelection("yellow");
        Overlay.show;


        
        wait(50);
        
    }
    
function createPolylineFromROIs() {
    nRois = roiManager("count");
    if (nRois == 0) return;
    
    Dialog.create("Polyline Options");
    Dialog.addNumber("Number of points for polyline (max " + nRois + ")", nRois);
    Dialog.addCheckbox("Fit spline", false);
    Dialog.show();
    
    fitPoints = Dialog.getNumber();
    fitSpline = Dialog.getCheckbox();
    
    // Ensure fitPoints is within valid range
    fitPoints = Math.max(2, Math.min(fitPoints, nRois));
    
    x_points = newArray(nRois);
    y_points = newArray(nRois);
    
    for (i = 0; i < nRois; i++) {
        roiManager("select", i);
        Roi.getCoordinates(x, y);
        x_points[i] = x[0];
        y_points[i] = y[0];
    }
    
    // Sort points based on scanning direction
    if (scan_direction == "X") {
        // Sort based on y-points (low to high) for X-direction scanning
        for (i = 0; i < nRois - 1; i++) {
            for (j = 0; j < nRois - i - 1; j++) {
                if (y_points[j] > y_points[j + 1]) {
                    temp = y_points[j]; y_points[j] = y_points[j + 1]; y_points[j + 1] = temp;
                    temp = x_points[j]; x_points[j] = x_points[j + 1]; x_points[j + 1] = temp;
                }
            }
        }
    } else if (scan_direction == "Y") {
        // Sort based on x-points (low to high) for Y-direction scanning
        for (i = 0; i < nRois - 1; i++) {
            for (j = 0; j < nRois - i - 1; j++) {
                if (x_points[j] > x_points[j + 1]) {
                    temp = x_points[j]; x_points[j] = x_points[j + 1]; x_points[j + 1] = temp;
                    temp = y_points[j]; y_points[j] = y_points[j + 1]; y_points[j + 1] = temp;
                }
            }
        }
    }
    
    // Create arrays for the fitted points
    x_fit = newArray(fitPoints);
    y_fit = newArray(fitPoints);
    
    // Calculate the iteration step
    step = (nRois - 1) / (fitPoints - 1);
    
    // Fill the fitted arrays
    for (i = 0; i < fitPoints; i++) {
        index = Math.round(i * step);
        x_fit[i] = x_points[index];
        y_fit[i] = y_points[index];
    }
    
    // Create polyline
    if (fitSpline) {
        makeSelection("polyline", x_fit, y_fit);
        run("Fit Spline");
    } else {
        makeSelection("polyline", x_fit, y_fit);
    }
    
    Roi.setPosition(0, 0, 0);
    roiManager("add");
    newPolylineIndex = roiManager("count") - 1;
    roiManager("select", newPolylineIndex);
    roiManager("rename", "Polyline");
    
    // Remove all point ROIs
    for (i = nRois - 1; i >= 0; i--) {
        roiManager("select", i);
        roiManager("delete");
    }
    
    // Select and show the new polyline
    roiManager("select", 0);
    roiManager("show all without labels");
}
    // Chung-Kennedy filter function
    function chung_kennedy_filter(x, M, K, p) {
        N = x.length;
        y = newArray(N);
        for (i = 0; i < N; i++) {
            if (i < M) {
                sum = 0;
                for (j = 0; j <= i; j++) {
                    sum += x[j];
                }
                y[i] = sum / (i + 1);
            } else if (i >= N - M) {
                sum = 0;
                for (j = i; j < N; j++) {
                    sum += x[j];
                }
                y[i] = sum / (N - i);
            } else {
                forward = 0;
                backward = 0;
                V_f = 0;
                V_b = 0;
                for (j = 0; j < M; j++) {
                    forward += x[i + j];
                    backward += x[i - M + 1 + j];
                }
                forward /= M;
                backward /= M;
                for (j = 0; j < M; j++) {
                    V_f += (x[i + j] - forward) * (x[i + j] - forward);
                    V_b += (x[i - M + 1 + j] - backward) * (x[i - M + 1 + j] - backward);
                }
                V_f /= M;
                V_b /= M;
                W_f = 1 / pow(V_f + K, p);
                W_b = 1 / pow(V_b + K, p);
                y[i] = (W_f * forward + W_b * backward) / (W_f + W_b);
            }
        }
        return y;
    }

function findTransitionPoints(centerX, centerY, scan_direction) {
    startX = Math.max(0, centerX - RecWidth / 2);
    endX = Math.min(width - 1, centerX + RecWidth / 2);
    startY = Math.max(0, centerY - RecHeight / 2);
    endY = Math.min(height - 1, centerY + RecHeight / 2);

    x_points = newArray(0);
    y_points = newArray(0);

    if (scan_direction == "Y" || scan_direction == "Both") {
        for (x = startX; x <= endX; x++) {
            column = newArray(endY - startY + 1);
            for (y = startY; y <= endY; y++) {
                column[y - startY] = getPixel(x, y);
            }
            if (y_scan_direction == "↑") {
                column = Array.reverse(column);
            }
            filtered_column = chung_kennedy_filter(column, 5, 3, 20);
            if (detection_method == "Gradient") {
                y_transition = find_y_transition(filtered_column);
            } else {
                y_transition = find_max_value(column);
            }

            if (y_transition >= 0) {
                if(y_scan_direction == "↓"){
                    y_transition_global = startY + y_transition;
                }
                else {
                    y_transition_global = endY - y_transition;
                }
                x_points = Array.concat(x_points, x);
                y_points = Array.concat(y_points, y_transition_global);
            }
        }
    }

    if (scan_direction == "X" || scan_direction == "Both") {
        for (y = startY; y <= endY; y++) {
            row = newArray(endX - startX + 1);
            for (x = startX; x <= endX; x++) {
                row[x - startX] = getPixel(x, y);
            }
            filtered_row = chung_kennedy_filter(row, 5, 3, 20);

            if (detection_method == "Gradient") {
                x_transition = find_x_transition(filtered_row);
            } else {
                x_transition = find_max_value(row);
            }
            if (x_transition >= 0) {
                x_transition_global = startX + x_transition;
                x_points = Array.concat(x_points, x_transition_global);
                y_points = Array.concat(y_points, y);
            }
        }
    }

    // Remove existing ROIs in the area
    nRois = roiManager("count");
    for (i = nRois - 1; i >= 0; i--) {
        roiManager("select", i);
        getSelectionBounds(rx, ry, rw, rh);
        if (rx >= startX && rx <= endX && ry >= startY && ry <= endY) {
            roiManager("delete");
        }
    }
    
    // Add new points as ROIs
    for (i = 0; i < x_points.length; i++) {
        makePoint(x_points[i], y_points[i]);
        Roi.setPosition(0, 0, 0);
        roiManager("add");
        roiManager("select", roiManager("count")-1);
        roiManager("rename", "x=" + x_points[i] + ", y=" + y_points[i]);
    }
    roiManager("show all without labels");
}





function find_y_transition(column) {
	 
    gradient = newArray(column.length - 1);
    for (i = 0; i < column.length - 1; i++) {
        gradient[i] = column[i + 1] - column[i];
    }
    max_grad = 1e9;  // Initialize to a large positive number
    max_index = -1;
    min_threshold = 5; // Adjust this value to change sensitivity
    for (i = 0; i < gradient.length; i++) {
        if (gradient[i] < max_grad && abs(gradient[i]) > min_threshold) {
            max_grad = gradient[i];
            max_index = i;
        }
    }

    if (max_index >= 0) {
        // Interpolate for sub-pixel accuracy
        if (max_index > 0 && max_index < gradient.length - 1) {
            y1 = abs(gradient[max_index - 1]);
            y2 = abs(gradient[max_index]);
            y3 = abs(gradient[max_index + 1]);
            offset = 0.5 * (y1 - y3) / (y1 - 2*y2 + y3);
            return max_index + offset;
        }
    }

    return max_index;
}


function find_x_transition(row) {
	 
    gradient = newArray(row.length - 1);
    for (i = 0; i < row.length - 1; i++) {
        gradient[i] = row[i + 1] - row[i];
    }
    max_grad = -1;
    max_index = -1;
    min_threshold = 5; // Adjust this value to change sensitivity
    for (i = 0; i < gradient.length; i++) {
        if (abs(gradient[i]) > abs(max_grad) && abs(gradient[i]) > min_threshold && gradient[i] < 0) {
            max_grad = gradient[i];
            max_index = i;
        }
    }

    if (max_index >= 0) {
        // Interpolate for sub-pixel accuracy
        if (max_index > 0 && max_index < gradient.length - 1) {
            y1 = abs(gradient[max_index - 1]);
            y2 = abs(gradient[max_index]);
            y3 = abs(gradient[max_index + 1]);
            offset = 0.5 * (y1 - y3) / (y1 - 2*y2 + y3);
            return max_index + offset;
        }
    }

    return max_index;
}

    return max_index;
}

    function removeROIs(startX, startY, endX, endY) {
        nRois = roiManager("count");
        for (i = nRois - 1; i >= 0; i--) {
            roiManager("select", i);
            getSelectionBounds(rx, ry, rw, rh);
            if (rx >= startX && rx <= endX && ry >= startY && ry <= endY) {
                roiManager("delete");
            }
        }
    }

function saveROIsToCSV(imageName, iteration) {
    nRois = roiManager("count");
    if (nRois == 0) return;
    Dialog.create("Shrinking type");
    Dialog.addRadioButtonGroup("Is this even with NS or without NS", newArray("Without NS" , "With NS"), 1, 2, "Without NS");
    Dialog.addCheckbox("Close kymo", close_kymo);
    Dialog.show();
    eventType = Dialog.getRadioButton();
    close_kymo = Dialog.getCheckbox();
    filename = imageName + "_" + iteration + ".csv";
    if(eventType == "With NS")
        filename = "With_NS_" + imageName + "_" + iteration + ".csv";
    
    dir = getDirectory("image");
    if (dir == ""){
        dir = getDirectory("Choose directory for saving coordinates");
    }
        
    Path = dir + File.separator + "shrinking_line" + File.separator;
    filePath = Path + filename;
    
    if (!File.exists(Path)){
        File.makeDirectory(Path);
    }
    
    filelist = getFileList(Path);

    while (arrayContains(filelist, filename)) {
        iteration++;
        filename = imageName + "_" + iteration + ".csv";
        filePath = Path + filename;
    }
	//xyCoor = newArray();
    csvContent = "X,Y,PixelValue\n";
    for (i = 0; i < nRois; i++) {
        roiManager("select", i);
        roiName = Roi.getName();
        xyCoor = split(roiName , ",");
        x = parseFloat(substring(xyCoor[0], 2));
        y = parseFloat(substring(xyCoor[1], 3));
        pxValue = getPixel(round(x), round(y));
        csvContent = csvContent + (x*pixelWidth) + "," + (y*interval) + "," + pxValue + "\n";
    }

    File.saveString(csvContent, filePath);
    if(close_kymo){

            roiManager("deselect");
            roiManager("delete");
//            Overlay.remove;
//            setTool("polyline");
            imgID = getImageID();
            selectImage(imgID);
            img_name = getTitle();
            close(img_name) ;
            //print(imgID + " is closed");
			imgID = getImageID();
            selectImage(imgID);
            
            //exit();
    }
}
    // Function to check if an array contains a specific value
    function arrayContains(arr, value) {
        for (i = 0; i < arr.length; i++) {
            if (arr[i] == value) return true;
        }
        return false;
    }
}
function find_max_value(array) {
    max_value = 0;
    max_index = -1;
    for (i = 0; i < array.length; i++) {
        if (array[i] > max_value) {
            max_value = array[i];
            max_index = i;
        }
    }
    return max_index;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

macro "Speed calculator"{
selection_type = selectionType();
if(selection_type == 5){


getPixelSize(unit, pixelWidth, pixelHeight);
if(unit == "µm" || unit == "micron" || unit == "microns"){
run("Set Measurements...", "area mean modal min centroid perimeter bounding fit shape median skewness stack display redirect=None decimal=3");
run("Measure");

length = getResult("Length", nResults-1);
angle = getResult("Angle", nResults-1);
angle = angle * PI / 180 ;
width = length * cos(angle) ;
height = length * sin(angle);
close("Results");





height = height/pixelHeight ;
f_interval=getInfo("Frame interval (s) ");
if(f_interval==""){
	f_interval=Stack.getFrameInterval();
	if(f_interval=="")
		f_interval=getNumber("Time interval was not found in the metadata. Enter the frame interval (s):", 1);
}

speed = -60*width/(height*f_interval) ;
speed_nm_s = speed*1000/60 ;
print("speed is: " + speed + " " + unit + "/min  (" + speed_nm_s + " nm/s)");

print("(Pixel width: " + pixelWidth + " " + unit + ", Time frame: " + f_interval + " s)");
}
else {
	showMessage("Set the image scale to micron");
	exit ;

}}
else{
	showMessage("A straight line is needed for growth/shrinkage rate calculation");
	exit ;
}
}
