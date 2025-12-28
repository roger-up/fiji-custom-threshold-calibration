/*
 * Macro to apply a calculated minimum threshold to each image 
 * based on the minimum value derived from the Otsu method.
 */

#@ File (label = "Input directory", style = "directory") input
#@ File (label = "Output directory", style = "directory") output
#@ String (label = "File suffix", value = ".tif") suffix

// Call the function to process the specified folder
process_folder(input);

// Function to scan folders/subfolders to find all images with the specified suffix
// NOTE: To avoid processing unwanted images, the input folder should not contain subfolders with unrelated images.
function process_folder(input) {
	list = getFileList(input);
	list = Array.sort(list);
	for (i = 0; i < list.length; i++) {
		if(File.isDirectory(input + File.separator + list[i]))
			process_folder(input + File.separator + list[i]);
		if(endsWith(list[i], suffix))
			process_file(input, output, list[i]);
	}
}

function process_file(input, output, file) {
	
	// Open each image
	path_input = input + File.separator;
	full_path_input = path_input + file;
	open(full_path_input); // The image is now open
	
	// Ensure image is 8-bit grayscale and configure threshold options (black background)
	run("8-bit");
	run("Options...", "iterations=1 count=1 black");
	
	// Calculate threshold using the Otsu method
	setAutoThreshold("Otsu dark no-reset");
	
	// Store the lower Otsu threshold value in a variable
	getThreshold(lowerThreshold, upperThreshold);
	minThresholdOtsu = lowerThreshold;
	
	// APPLY CUSTOM THRESHOLD CALCULATION HERE
	// Adjusting the Otsu value based on a fit correction
	minThresholdCalc = 0.7 * minThresholdOtsu + 72.3;

	// Apply the new calculated threshold
	setThreshold(minThresholdCalc, 255);
	
	run("Convert to Mask");
	
	// Save binary image in "BMP" format (commonly used in CTAn software)
	path_output = output + File.separator;
	full_path_output = path_output + file;
	saveAs("BMP", full_path_output);

	// Print calculated values (optional, for debugging)
	// print(minThresholdCalc);
	
	close(); // Close the image

}
