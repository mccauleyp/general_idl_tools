# General IDL Tools

This repository contains a collection of general-purpose IDL routines along with codes 
that are specific to Solar Physics applications but are not related to a specific 
instrument. 

## Contents and Usage

Each file includes a header with usage documentation. The following is a simple list 
of the subdirectories with brief descriptions of what each program does:

### Arrays and Images

* [adj_dist](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/adj_dist.pro):
Determine the physical distances between adjacent pixels in an irregular x/y grid to check the uniformity of the pixel scale.
* [array_continuous](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/array_continuous.pro):
Locate the continuous segments of a 1D array.
* [array_indices_1d](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/array_indices_1d.pro):
Perform inverse operation of the ARRAY_INDICES function, i.e., given 2D locations (coordinates), return 1D subscripts (as if returned from the WHERE function)
* [baseline_image](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/baseline_image.pro):
Given an image cube, return an image that represents the "baseline" (i.e. background) state.
* [clean_nans](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/clean_nans.pro):
Search an image for NaN or Inf pixels and replace with average value from the 5 nearest finite pixels.
* [correl_portion](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/correl_portion.pro):
Align a sequences of JPEG2000 images using cross correlation on a portion of the image.
* [edge_pixels](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/edge_pixels.pro):
Return the 1D subscripts of pixels along the border of a 2D array. 
* [fourier_annulus_taper](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/fourier_annulus_taper.pro):
Apply a cosine or linear taper to the Fast Fourier Transform of an image, such that beyond some innermost region, the FFT result smoothly falls to 0.
* [hanning_image](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/hanning_image.pro):
Applying a Hanning filter to suppress noise in an image.
* [mcbaseline](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/mcbaseline.pro):
Estimate baseline of input array (modified version of baseline procedure from the SOHO Library)
* [mcfilter_image](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/mcfilter_image.pro):
Convolve image with a Gaussian kernel (modified version of filter_image from NASA/GSFC Library).
* [multi_dilate](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/multi_dilate.pro):
Simple wrapper for DILATE to perform multiple dilations with the same kernel.
* [n_smallest](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/n_smallest.pro):
Find the n smallest values in an array and return an array of indices, as if from WHERE(). 
* [persistence_map](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/persistence_map.pro):
Generate a maximum or minimum value "persistence map" from a 3D data cube of images. The output image will contain the max or min value of every pixel across the set to capture feature evolution.  
* [pixel_path](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/pixel_path.pro):
Given a set of pixels that have been interactively selected by the user using PIXEL_SELECT, generate a smooth trajectory path with a polynomial fit and calculate the arclength along the path.
* [range_overlap](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/range_overlap.pro):
Determine if two or more ranges, [start, end], overlap. 
* [snr_img](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/snr_img.pro):
Return an image for which each pixel is the signal-to-noise ratio of the corresponding value in the input image.
* [time_sync](https://github.com/mccauleyp/general_idl_tools/blob/master/arrays_and_images/time_sync.pro):
Given an arbitrary number of overlapping time series, return matching sets of indices that can be used to sync the series as closely as possible.  

### Physics and Math

* [abs_cross](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/abs_cross.pro):
Return the absorption cross sections of HI, HeI, and HeII for a given wavelength in Angstroms.
* [abs_depth](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/abs_depth.pro):
Return the absorption depth given the measured intensity and assumed back/foreground.
* [abs_ratio](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/abs_ratio.pro):
Return the ratio of absorption cross sections.
* [alfven_speed](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/alfven_speed.pro):
Return Alfven speed for given magnetic field strength and density. Or return magnetic field strength or density given Alfven speed (see keywords)
* [anderson_darling_lognormal](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/anderson_darling_lognormal.pro):
Compute the Anderson-Darling goodness-of-fit statistic for a (log)normal fit.
* [density_models](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/density_models.pro):
Return one of several electron density models for the solar corona given a set of heights. 
* [density_to_frequency](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/density_to_frequency.pro):
Convert a density to the corresponding fundamental (or harmonic) plasma frequency.
* [expo_fit2](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/expo_fit2.pro):
Fit an exponential F(x) = a0*exp(-abs(x-a1)/a2)+a3 to data using CURVEFIT.
* [expo_linear_project](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/expo_linear_project.pro):
Project the linear+exponential (expo_linear) fit to a specified height. 
* [expo_linear](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/expo_linear.pro):
Simple function for the exponential+linear equation: y(t) = c0*exp((t-t0)/tau) + c1(t-t0) + c2
* [exponential](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/exponential.pro):
Simple function for the exponential function: y(x) = p[0]*exp((x-p[1])/p[2]) + p[3]
* [flare_class_to_num](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/flare_class_to_num.pro):
Convert flare class to a simple number for sorting. (A4.2 -> 0.42, M4.2 -> 3.42)
* [frequency_to_density](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/frequency_to_density.pro):
Convert a frequency to a density assuming that the frequency corresponds to the fundamental or harmonic electron plasma frequency.
* [lognormal_cdf](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/lognormal_cdf.pro):
Return the lognormal cumulative distribution function (CDF) for a given set of parameters and x positions. 
* [lognormal_pdf](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/lognormal_pdf.pro):
Return the lognormal probability distribution function (PDF) for a given set of parameters and x positions. 
* [newkirk_radius](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/newkirk_radius.pro):
Return the height of the plasma frequency layer in solar radii given the Newkirk (1961) background solar coronal electron density model. 
* [normal_cdf](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/normal_cdf.pro):
Return the normal cumulative distribution function (CDF) for a given set of parameters and x positions. 
* [plasma_beta](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/plasma_beta.pro):
Return the plasma beta given density, temperature, and magnetic field.
* [python_ad_test](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/python_ad_test.pro):
Perform a 2-sample Anderson Darling test using a Python script.
* [spot_map_uncertainty](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/spot_map_uncertainty.pro):
Calculate the uncertainty for a "spot mapping" radio observation (see notes).
* [tau_to_colden](https://github.com/mccauleyp/general_idl_tools/blob/master/physics_and_math/tau_to_colden.pro):
Convert optical depth (tau) to column density (N)

### Mapping

* [convert_map_units](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/convert_map_units.pro):
Convert the units of a SolarSoft map structure from arcsec to rsun or vice versa.
* [coords_to_map_data](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/coords_to_map_data.pro):
Given a SolarSoft map and coordinates in physical units (arcsec from Sun-center), return the data from those coordinates.
* [cutout_map](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/cutout_map.pro):
Generate a map from a cutout portion of an image.
* [match_map](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/match_map.pro):
Scale the units and clip the field-of-view of MAP2 to match that of MAP1.
* [mc_cnvt_coord](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/mc_cnvt_coord.pro):
Conversion between any 2 of 4 coord systems for solar images. Slightly modified version of CNVT_COORD.
* [pad_data](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/pad_data.pro):
Pad (fill around the edges of) a data array so that it matches the dimensions on the sky of a reference index.
* [pixel_map](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/pixel_map.pro):
Generate a structure containing the X, Y, and radial coordinates of every pixel in a solar image.
* [pixel_select](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/pixel_select.pro):
Interactively select a set of pixels on an image using CURSOR.
* [ring_metrics](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/ring_metrics.pro):
Given the output from SORT_INTO_RINGS, return the min, max, mean, median, and stdev values for each ring.
* [ring_wrapper](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/ring_wrapper.pro):
Combine PIXEL_MAP, SORT_INTO_RINGS, and RING_METRICS to generate a pixel map, sort it into rings, and return various values corresponding to each ring.
* [solar_angle_mask](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/solar_angle_mask.pro):
Identify pixels between two angles, measured counterclockwise from solar north. Optionally filter pixels based on radial distance.
* [sort_into_rings](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/sort_into_rings.pro):
Sort a PIXEL_MAP into rings, where ring membership is determined by a pixel's distance using a linear relationship between the range of radii and number of rings.
* [where_match](https://github.com/mccauleyp/general_idl_tools/blob/master/mapping/where_match.pro):
Given an array of 1D indices (from WHERE) for a solar observation, return the same for a different observation (i.e. find the overlapping coordinates and return as a WHERE result for the second observation)

### Plotting

* [caption](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/caption.pro):
An easier to way to place captions on plots than using XYOUTS. 
* [default_ps](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/default_ps.pro):
Create a PostScript container and return a structure with some default settings that can passed to the various plotting codes using the _extra keyword
* [draw_compass](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/draw_compass.pro):
Draw a compass on a plot.
* [goes_plotter](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/goes_plotter.pro):
Write a basic GOES plot to a PNG file given a time range.
* [mclinecolors](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/mclinecolors.pro):
Modified version of the LINECOLORS routine that adds 4 additional colors meant to be a bit easier for colorblind users to distinguish.
* [mcplot_image](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/mcplot_image.pro):
Wrapper for the SolarSoft PLOT_IMAGE code that allows tick mark colors that are different from the axes color.
* [mcplot_map](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/mcplot_map.pro):
Wrapper for the SolarSoft PLOT_MAP code that allows tick mark colors that are different from the axes color.
* [mcsungrid](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/mcsungrid.pro):
Modified version of SUNGRID to add some new features (see version history)
* [mcutplot_image](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/mcutplot_image.pro):
Modified version of UTPLOT_IMAGE that adds some features and makes some other small changes (see version history)
* [panel_positions](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/panel_positions.pro):
Return position arrays for multi-panel plot elements and provides platform to test panel layouts. 
* [plot_beam](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/plot_beam.pro):
Put a radio telescope's primary beam in the corner of another plot or image. 
* [rainbow_line_colors](https://github.com/mccauleyp/general_idl_tools/blob/master/plotting/rainbow_line_colors.pro):
Return integer values arbitrarily spaced across a rainbow color table to be used for line plots when you need many different colors.

### File IO

* [eps2png](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/eps2png.pro):
Convert an EPS file to a PNG file using the CONVERT command from ImageMagick
* [extract_frames](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/extract_frames.pro):
Extract frames from a movie file using FFMPEG.
* [ffmpeg_combine](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/ffmpeg_combine.pro):
Given a directory containing .mp4 files, combine them into a single .mp4
* [jp2_read](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/jp2_read.pro):
Read a JPEG2000 (JP2) image and convert its XML metadata into a structure format like that of a FITS file header. 
* [mcread_cube](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/mcread_cube.pro):
Read a tile-compressed FITS image cube written with McWRITE_CUBE
* [mcread](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/mcread.pro):
Wrapper code to read images and header structures from several instruments and file formats that I commonly use (.fits, .sav, .jp2)
* [mcwrite_cube](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/mcwrite_cube.pro):
Write a tile-compressed FITS image cube that can be read with McREAD_CUBE
* [program_list](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/program_list.pro):
Return a list of all the .pro files in a directory.
* [sort_data](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/sort_data.pro):
 Sort FITS files downloaded into a temporary staging directory into a specific directory structure based on the instrument.
* [symlink_tester](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/symlink_tester.pro):
Test symlinks and return only the links that aren't dangling (i.e. the thing they point to is still there)
* [symlinker](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/symlinker.pro):
Create a set of sequentially-named symlinks for files in a directory (e.g. 0001.ext, 0002.ext, ...)
* [textwrangler_syntax](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/textwrangler_syntax.pro):
Create a new version of 'IDL Configuration.plist', which is used by TextWrangler to color IDL syntax of user-created programs.
* [thumbnail_gif](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/thumbnail_gif.pro):
Make a thumbnail GIF animation from an image directory.
* [vso_download](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/vso_download.pro):
Simple wrapper that combines vso_search and vso_get.
* [wrangle](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/wrangle.pro):
Open an IDL file in TextWrangler from the command line from its name only.
* [xml_to_struct](https://github.com/mccauleyp/general_idl_tools/blob/master/file_io/xml_to_struct.pro):
Convert an XML string into an IDL structure with values casts as their appropriate data types (numbers will be typed as long or double)

### Strings

* [block](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/block.pro):
Given a string array, return the HTML code for a table "block" div element.
* [href](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/href.pro):
Return HTML hyperlink code given the URL(s) and corresponding text.
* [progress_bar](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/progress_bar.pro):
Provide a progress bar for routines with long FOR loops.
* [readstring](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/readstring.pro):
Read text file into a string array (modified version from external library).
* [str_pad](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/str_pad.pro):
Pad a string with spaces to a desired length
* [strip_html](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/strip_html.pro):
Remove HTML formatting tags from a string.
* [strnsignif](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/strnsignif.pro):
Convert a number to a string with a fixed number of significant digits (modified version from external library).
* [td](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/td.pro):
Return HTML table element code given some input string data.
* [test_hyperlink](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/test_hyperlink.pro):
Test a URL to see if it exists using WGET. 
* [txt_to_struct](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/txt_to_struct.pro):
Convert a delimited text file into an IDL structure. 
* [unix_escape](https://github.com/mccauleyp/general_idl_tools/blob/master/strings/unix_escape.pro):
Replace all of the special Unix characters in a string with that character plus the Unix escape character.


## Installation

To install, I recommend creating a .idl\_startup file if you don't have one already and 
declaring the IDL\_STARTUP variable in your .cshrc or .bashrc configuration file:

```bash
setenv IDL_STARTUP ~/.idl_startup
```

Then add add the following to your .idl\_startup file

```idl
!PATH = expand_path('+~/general_idl_tools') + ':' + !PATH
```

## Dependencies

Many of the programs include references to files in the 
[SolarSoft IDL](https://sohowww.nascom.nasa.gov/solarsoft/) libraries and a few contain 
references to the 
[Coyote IDL](http://www.idlcoyote.com/documents/programs.php) library. 
Dependencies to external libraries are noted in the "CALLS" section of the program 
headers. 

## Authors and acknowledgment

These codes were written by me (Patrick McCauley) except for a few instances of routines 
that I modified to add new features. See version histories for details. 

## License
[MIT](https://choosealicense.com/licenses/mit/)