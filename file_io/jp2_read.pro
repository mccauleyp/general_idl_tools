pro jp2_read, file, index, data, nodata=nodata, short_index=short_index, xml=xml

; ========================================================================================
;+
; NAME: 
;   JP2_READ
;
; CATEGORY: 
;   File IO
;
; PURPOSE: 
;   Read a JPEG2000 (JP2) image and convert its XML metadata into a structure format like 
;   that of a FITS file header. 
;
; INPUTS: 
;   FILE = (String) '/path/to/file.jp2'
;
; OUTPUTS: 
;   INDEX = (Structure) XML metadata from the file as a structure
;
;   DATA = (Byte Array) 2- or 3- (if true color) dimensional byte-scaled image
;         
; KEYWORDS: 
;   NODATA = (Boolean) Set to just return INDEX (a little faster)
;
;   XML = (String) XML string that was converted into INDEX
;
;   SHORT_INDEX = (Boolean) Set to return a shortened version of INDEX that just contains
;                 the most relevant observational metadata for solar physics images. 
;                 This is mostly useful if there's some problem with the XML_TO_STRUCT 
;                 conversion process. 
;
; NOTES:
;   INDEX is produced from XML using XML_TO_STRUCT
;
;   You can return properties from the XML string as needed if you know the tag you're 
;   interested in. For instance: 
;       date_obs = get_xml_value(xml, 'DATE_OBS')
;
;   I use this routine mainly to read files produced from the Helioviewer project, which 
;   stores FITS data in the compressed jpeg2000 format with the standard FITS header 
;   stored as the XML metadata. 
;
; CALLS: 
;   XML_TO_STRUCT, BOX_MESSAGE, GET_XML_VALUE
;
; Written by Patrick McCauley (mccauley.pi@gmail.com)
;-
; ========================================================================================

if file_test(file) ne 1 then begin
	box_message, 'Oops, at least one input file in list doesn''t exist.'
	return
endif

obj =  OBJ_NEW('IDLffJPEG2000' , file, /PERSISTENT, /read, xml=xml)
obj -> IDLffJPEG2000::GetProperty, xml=xml
if not keyword_set(nodata) then data = obj->getdata()
obj_destroy, obj

if keyword_set(short_index) then begin
  
	date_obs = get_xml_value(index, 'DATE_OBS')
	exptime = get_xml_value(index, 'EXPTIME')
	wavelnth = get_xml_value(index, 'WAVELNTH')
	instrume = get_xml_value(index, 'INSTRUME')
	naxis1 = get_xml_value(index, 'NAXIS1') 
	naxis2 = get_xml_value(index, 'NAXIS2')
	xcen = get_xml_value(index, 'XCEN')
	ycen = get_xml_value(index, 'YCEN')
	crpix1 = get_xml_value(index, 'CRPIX1')
	crpix2 = get_xml_value(index, 'CRPIX2')
	cdelt1 = get_xml_value(index, 'CDELT1')
	cdelt2 = get_xml_value(index, 'CDELT2')
	crota = get_xml_value(index, 'CROTA')

	index = {date_obs:date_obs, exptime:exptime, wavelnth:wavelnth, instrume:instrume, $
			naxis1:naxis1, naxis2:naxis2, xcen:xcen, ycen:ycen, crpix1:crpix1, $
			crpix2:crpix2, cdelt1:cdelt1, cdelt2:cdelt2, crota:crota}
			
endif else index = xml_to_struct(xml)

return
end
