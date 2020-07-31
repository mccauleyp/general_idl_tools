function youtube_popup, youtube_num, text, title=title

; ========================================================================================
;+
; PROJECT: 
;	mcCatalogs; General
;
; NAME: 
;	YOUTUBE_POPUP
;
; CATEGORY: 
;	HTML
;
; PURPOSE: 
;	Return the HTML code for a pop-up YouTube video player. 
;
; CALLING SEQUENCE:
;	result = youtube_popup(youtube_num, text [,title=title] )
;
; INPUTS: 
;	YOUTUBE_NUM - (String)
;				YouTube ID string for that movie or the full video URL. 
;	TEXT - (String)
;			Hyperlink text. Can also be HTML code for an image that links to the video 
;				when clicked. 
;
; OUTPUTS: 
;	RETURN - (String)
;			HTML code for pop-up video player.
;         
; KEYWORDS: 
;	TITLE - (String)
;			Optional input that will be written at the top of the video player.
;
; EXAMPLES:
;	IDL> link = youtube_popup('TBCJ6f8njtE', 'Click for video')
;	IDL> print, link
;	IDL> <a class="youtube" href="#" rel="TBCJ6f8njtE" title=" ">Click for video</a>
;
; NOTES:
;	The YouTube popup player requires that the JQuery and the jquery.youtubepopup.js 
;	packages be loaded into the HTML page. For example:
;
;		<script type="text/javascript" src="./scripts/jquery.min.js"></script>
; 
;		<link type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/redmond/jquery-ui.css" rel="stylesheet" />
;		<script type="text/javascript" src="./scripts/jquery-ui.min.js"></script>
;		<script type="text/javascript" src="./scripts/jquery.youtubepopup.js"></script>
;		<script type="text/javascript">
;			$(function () {
;			$("a.youtube").YouTubePopup({ autoplay: 1, draggable: true, hd: 1});
;			});
;		</script>
;
; MODIFICATION HISTORY: 
;	Long ago - Written by Patrick McCauley (pmccauley@cfa.harvard.edu)
;
;-
; ========================================================================================

if not keyword_set(title) then title = ' '

if strmid(youtube_num, 0, 4) eq 'http' then begin
	rel = strsplit(youtube_num, '=', /extract)
	youtube_num = rel[1]
endif

;if youtube_num eq '-' then output = text $
;else output = '<a class="youtube" href="#" rel="'+youtube_num+'" title="'+title+'">'+text+'</a>'

output = '<a class="youtube" href="#" rel="'+youtube_num+'" title="'+title+'">'+text+'</a>'

return, output
end
