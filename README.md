# Makitronics ProMeasure
Create dimension drawings from any image with sub-millimeter accuracy using a quarter

## Overview ##
Ever found yourself reaching for calipers but either the battery ran out, or you're just not in your workshop? Makitronics ProMeasure was made for engineers and hobbyists who frequently want to take rough dimension drawings for 3D printing enclosures and other parts for existing objects.

Using just a top-view photo of your object taken 2-3 feet away, alongside a U.S. quarter, you can instantly get approximate dimensions for your physical part. Depending on your camera and the quality of the photo, you can achieve measurements with sub-millimeter accuracy (around +/- 0.3mm).

![](https://raw.githubusercontent.com/dominicklee/Makitronics-ProMeasure/master/img/screenshot.png)

## Usage ##

The tool is self-explanatory. To use:
1. Download the latest [release of ProMeasure](https://github.com/dominicklee/Makitronics-ProMeasure/releases). Choose between 32 and 64 bit.
2. Extract the zip file and run the `measure_image.exe` application.
3. Click "Load Image" button and browse for your JPG or PNG image.
4. To calibrate, drag an "ellipse" from one far end of the coin to the other side.
5. Now you can drag your mouse to take measurements in your image. If you restart the application, it should restore your image and its prior calibration.

Note: If you are getting incorrect measurements, delete the `data/settings.txt` file and restart the application. Perform calibration again by selecting the coin.