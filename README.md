# ImageJ Macro (.ijm) 🔬

For ImageJ Macro format scripts (`.ijm`) files.

##  About StarUpMacro

StartUpMacro is the mother macro file that launches automatically when Imagej is opened. It contains multiple macros within itself which are displayed on `Imagej -> Plugins -> Macros` menu. 

### How to use StartUpMacro

Download the above ijm files ([startUpMacro](https://github.com/aNick256/Macros/blob/main/StartupMacros.fiji.ijm) , [MakeVideos](https://github.com/aNick256/Macros/blob/main/MakeVideos.ijm)) and copy them to "macros" folder where your imagej is installed (it is typically: `C:\Users\LocalAdmin\Downloads\Fiji.app\macros`). Let the new files replace the old ones. Once you do this you see appearance of new options in `Imagej -> Plugins -> Macros` menu (Fiji needs to be restarted if it was open during modifications).

As an alternative you can copy the content of [startUpMacro](https://github.com/aNick256/Macros/blob/main/StartupMacros.fiji.ijm) then go to `ImageJ -> Plugins -> Macros -> Startup Macros...` and paste there the copied codes (replace).

<img src="https://github.com/aNick256/Macros/blob/main/images/macros.svg"  width="700">

### Drift correction

The easiest way to correct drifts is to use **Auto drift-correction** macro. If you run this macro it will automatically correct your videos for drift and then create a subfolder in the directory of your images named drift_corrected and stores the drift corrected TIFs there. It also creates a subfolder named drift_data where it stores the drifted coordinates for each file. 

**Note 1**: The image series should be stored as an stack first (the macro wont work properly if you open it by .nd file)

**Note 2**: You need to install GDSC-SMLM plug-in in order to use this macro ([How to install?](https://gdsc-smlm.readthedocs.io/en/latest/installation.html)).

**Note 3**: This method is based on gaussian fitting and thereby pixel size is important and your image should have the correct scale (6.25 pixels/micron in TIRF1 and 7.76 pixels/micron in TIRF 2). SD of gaussian fitting depends on your experiment but it typically varies between 0.6 and 1.5.

![alt text](https://github.com/aNick256/Macros/blob/main/images/Auto_drift-correction.png)

There are two other options for drift correction which you can find it in the _correct drifts_ macro. Keep in mind that you need to feed these drift correction macro with the drifted coordinates for other drift correction methods. There are different ways that you can get this data e.g. Gaussian fit. My own preferred way to get this data is to use Mark 2 software (a tracking software). If the drift is unidirectional you can use "Unidirectional" method and correct the drift by manually selecting the initial and end position of a stationary point in your image.

![alt text](https://github.com/aNick256/Macros/blob/main/images/Correct_Drifts.png)


### Smart kymo

**Note**: [KymoResliceWide](https://github.com/ekatrukha/KymoResliceWide) plug-in should be already installed on your Fiji.

This macro is already included in the [StartupMacros.fiji.ijm](https://github.com/aNick256/Macros/blob/main/StartupMacros.fiji.ijm) so if you have copied StartupMacros.fiji.ijm into your macro folder you will get this macro in your Fiji macro list. It can create montaged kymographs of each channel and the composite image with scale bar and time bar (See an example below). For the first time it asks you about the content of each channel and then stores this information in a file called _Channel_data.txt_ in the "Kymograph" folder in the directory of the stack. It uses this stored information for every kymo that is used later out of any stack in this directory. So if you want to change the header of montaged kymo you have to delete this file manually. 

Sometimes it is the case that you have an interesting kymograph but you don't know from which microtubule it is made. In the new update the ROI of the line used to make the kymograph is stored in a subfolder called "ROIs" with the same name of the corresponding kymograph.

![alt text](https://github.com/aNick256/Macros/blob/main/images/Reslice__MAX__of_img1_1_Montage.jpg)

### Correct Shading

**Note**: Make sure [BaSiC](https://github.com/marrlab/BaSiC) plugin is installed on your Fiji. One way of doing this is to go to `ImageJ -> Help -> Update -> Manage update sites` and then check the checkbox for BaSiC website in the shown list. See a comparison of intensity profile in an unprocessed image (right) and an image that is being corrected for shading (left). 

![alt text](https://github.com/aNick256/Macros/blob/main/images/Shading_correction.png)

### Exposure variation

Removes the brightness fluctuations in the stacks

![Intensity_plot](https://github.com/aNick256/Macros/blob/main/images/exposure_variation.jpg)

![Kymo](https://github.com/aNick256/Macros/blob/main/images/exposure_variation_kymo.png)

### Edge Detector

The edge detector can be used to detect edges in images, primarily using the steepness of pixel intensity gradients within the selection rectangle as a marker. It is ideal for tracking microtubule edges in kymographs.

#### Usage Manual:

1. Open your image.
2. Drag and drop the `Edge_detector.ijm` file onto ImageJ and click "Run."
3. The wheel click will open the settings menu, which contains the following items:

   * **Rectangle Width and Height**: Sets the width and height of the scanning area within which you want to detect edges.
   * **Smoothing**: Applies the smooth function (`ImageJ/Process/Smooth`) the number of times specified by the entered value.
   * **Gradient Segment Length**: Specifies the length of the segment within which the steepness of the gradient is determined.
   * **Transition Detection Method**: Choose one of the following methods:
     * **Gradient**: Creates a point ROI (Region of Interest) at the site with the steepest intensity change within the gradient segment length in a given pixel row/column.
     * **Maximum**: Detects the pixel with the maximum intensity within the scanned pixel row/column. This could be useful in specific cases.
     * **Gaussian Fit**: Fits a Gaussian to the pixel row/column and creates a point ROI at the center of the Gaussian. This method may be useful for tracking diffusive particles in kymographs.

   * **Scan Direction**: Determines whether the scanning area is scanned row by row (X) or column by column (Y).
   * **Y Scan Direction**: The gradient function defaults to detecting transitions from higher to lower pixel intensities. If you want to detect edges that transition from high to low intensity (top to bottom), select `↑`. If the transition is from low to high intensity, select `↓`.
   * **Flip Image Horizontally**: Flips the image horizontally.
   * **Make Polyline**: Creates a polyline that connects the point ROIs. The number of points used to create the polyline can be at most the number of point ROIs, but the user can set a lower number to prevent sudden bends and jaggedness. Additionally, the "Fit Spline" option can make the polyline smoother.

4. After selecting your method, you can detect edges by positioning the scanning rectangle over your area of interest and clicking on the edges while holding the Shift key. To remove undesired points, wheel click on them while holding the Shift key. To remove all ROIs, left-click on the image and hold it for a second while moving the cursor.

5. Finally, hold the Control key and left-click to see the saving options. In this case, you will see the options used to categorize data in my experiments ('With NS' and 'Without NS'), but you can change these categories as needed. You can also check the `Close Kymo` option if you want the kymograph you analyzed to be closed after saving the coordinates of the edges.

6. By clicking OK in the prompt window, the macro will create a subdirectory in the image's directory called 'Shrinking_line'. The coordinates of the edges, along with the pixel intensities at those sites for each channel of the kymograph, will be saved in a `.csv` file.
