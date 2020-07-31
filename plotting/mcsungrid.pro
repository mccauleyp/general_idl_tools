PRO mcsungrid,kP,kB0,kL0,CENTER=center, $
            SUNRADIUS=sunradius, $
            COLOR=color, HEADER=header, $
            GRID=grid, SIZE=ksize, LABEL=label, $
            LATITUDES=lat, LONGITUDES=lon, $
            LATLAB=latlab, LONLAB=lonlab, $
            PIXELDIAMETER=pixeldiameter, CHARSIZE=charsize, THICK=thick, $
            linestyle=linestyle, nogrid=nogrid, clip=clip, const_thick=const_thick
            
; ========================================================================================
;+
;   NOTE: This is a slightly modified version of SUNGRID to add some new features (see 
;   version history)
;
; NAME:
;	MCSUNGRID
;
; PURPOSE:
;	Overlay a latitude and longitude grid on a solar image plotted on arcsec coordinates. 
;	Modified version of SUNGRID to work more easily on an arcsecond coordinate system. 
;
; CATEGORY:
;	Plotting
;
; CALLING SEQUENCE:
;	MCSUNGRID, P, B0, L0
;
; INPUTS:
;	P: Position angle of the solar axis
;	B0: Latitude of the sub-terrestrial point 
;	L0: Longitude of the sub-terrestrial point
;
; OPTIONAL INPUT PARAMETERS:
;	None
;
; KEYWORD PARAMETERS:
;	CENTER: gives the [x,y] coorinates of the center of 
;		the solar disk (on which the coordinate grid
;		should be centered) in the image. Default is 
;		[512,512]
;	NOGRID:  If set, no grid will be drawn on the sun
;	SUNRADIUS: Factor to multiply the radius of the sun.
;		Default is SUNRADIUS=1. Then the sun has a 
;               diameter of 489 pixels (corresponding to PICO)
;	COLOR:  Color index for both grids; if COLOR is set
;		color and CORONACOLOR are ignored.
;       CHARSIZE: giving the charsize of the labelling. By
;               default the charsize is chosen automatically.
;	HEADER: If an imageheader (PICO-Format!!) is given, 
;               the P, B0 and L0
;		as well as the apparent solar diameter 
;		will be automatically calculated taking the 
;		data of header.time_obs and header.date_obs
;		and the EPHEMERIS procedure. The center of 
;               the grid will be either centered on header.hole
;               or, if present and not [0,0,0,0] on header.sun.
;	GRID:   If a named and not undefined variable is spe-
;		cified with this keyword, the existing screen
;		is not overplotted but the grid is returned in
;		this variable (by passing to the 'Z' device).
;	SIZE:   The size of the image in pixels. Default is 
;		[1024,1024]. If size is scalar, the image is
;               assumed to be quadratic.
;	LABEL:  If set, coordinate sytems will be labeled
;       LATLAB: An array indicating the latitudes to be labelled.
;               By default: latlab=[-60,-30,0,30,60].
;               LABEL must be set
;       LONLAB: Same as for latlab. Default: intervals of 30 deg.
;               LABEL must be set
;       LATITUDES: An array indicating which latitude circles
;               shall be drawn. By default: each 15 degrees. 
;       LONGITUDES: Same as for latitudes. Default: 15 degree
;               spaces.
;
; OUTPUTS:
;	None. If grid is not set, the image displayed on the
;	screen will be overplotted.
;
; OPTIONAL OUTPUT PARAMETERS:
;	None
;
;       EXAMPLE: 
;		plot_image, bytarr(4096,4096), scale=0.6, origin=[-2048.5,-2048.5]*0.6
;		mcsungrid, 0, 5, 0, color=150
;
; COMMON BLOCKS:
;	None
;
; SIDE EFFECTS:
;	A displayed image will be overplotted
;
; RESTRICTIONS:
;	Up to now, the procedure only works for non-scalable
;       devices (X, WIN, Z etc.) and not yet for the PS-device.
;       However Parts of the solar disk can be drawn! The entire
;       grid has not to be drawn anymore.
;
; PROCEDURE:
;	Straightforward using the map drawing facilities
;	MAP_SET and MAP_GRID of IDL. The procedure is highly
;	adapted to PICO instrumental parameters.
;       V2.0 Does not use the MAP functions anymore in order
;       to be able to draw the equator instead of the central
;       latitude circle on the disk
;
; MODIFICATION HISTORY:
;	Written V1.0 16-OCT-1994 Pic Du Midi
;       V2.0 Completely self written without IDL-functions MAP_GRID
;       and MAP_SET: 10-APR-1996 Alexander Epple, MPAE Lindau
;
;	modified by pmccauley to work more easily on an arcsecond grid and to include nosun keyword
;-
; ========================================================================================

if not keyword_set(clip) then clip = [!x.crange[0], !y.crange[0], !x.crange[1], !y.crange[1]]

if n_elements(linestyle) eq 0 then linestyle=0
IF NOT KEYWORD_SET(thick) THEN thick = 1
IF (N_ELEMENTS(sunradius) EQ 0) THEN sunradius=960
IF (N_ELEMENTS(color) EQ 0) THEN color=255
IF (N_ELEMENTS(ksize) EQ 0) THEN siz=1024 ELSE siz=ksize
IF (N_ELEMENTS(siz) EQ 1) THEN siz=[siz,siz]
IF (N_ELEMENTS(center) EQ 0) THEN center=[0,0]
IF (N_ELEMENTS(lonlab) EQ 0) THEN lonlab=30*INDGEN(12)
IF (N_ELEMENTS(latlab) EQ 0) THEN latlab=30*INDGEN(5)-60
label=KEYWORD_SET(label)

;--------------------------------------------------------------------------
; If an imageheader is given with the call take out all information 
; about disk orientation and size
;--------------------------------------------------------------------------
IF (N_ELEMENTS(header) GT 0) THEN BEGIN
; The following can be erased by time...
;    date=STRUPCASE(header.date_obs)
;    time=header.time_obs
    
;    year=FIX('19'+STRMID(date,7,2))
;    imonth=STRMID(date,3,3)
;    index=WHERE(imonth EQ ['JAN','FEB','MAR','APR','MAY','JUN', $
;                           'JUL','AUG','SEP','OCT','NOV','DEC'])
;    month=index(0)+1
;    day=FIX(STRMID(date,0,2))
;    hour=FIX(STRMID(time,0,2))
;    minute=FIX(STRMID(time,3,2))
;    
;    l0=0
;    EPHEMERIS,YEAR=year,MONTH=month,DAY=day,HOUR=hour,MINUTE=minute, $
;      L0=l0, B0=b0, P=p, SOLDIST=sunrad
;    sunrad=1./sunrad
;    IF (header.orient EQ 2) THEN p=0		; The image is rotated
;    ; so that heliographic north
;    ; is already up
    l0=0
    EPHEMERIS,HEADER=header, L0=l0, B0=b0, P=p, SOLDIST=sunrad
    IF (header.orient EQ 2) THEN P=0
    P=!DTOR*P
    B0=!DTOR*B0
    L0=!DTOR*L0
ENDIF ELSE BEGIN
    P=!DTOR*kP
    B0=!DTOR*kB0
    L0=!DTOR*kL0
ENDELSE

;###############################################################################
; Define some constants for the grid
;###############################################################################

epsilon=1E-4        ; a constant slightly greater than 0
;thick=1             ; The normal thickness of the grid lines
n=200               ; The normal number of points out of which a grid line consists
r=sunradius  ; The radius of the solar disk to be drawn. sunradius=1 by default
                    ; The normal charsize for the labels
IF (N_ELEMENTS(charsize) EQ 0) THEN charsize=(r*4./450)>1  

IF (N_ELEMENTS(pixeldiameter) NE 0) THEN r=pixeldiameter/2.

IF (N_ELEMENTS(grid) GT 0) THEN BEGIN
    olddev=!D.NAME
    SET_PLOT,'z'
    DEVICE,SET_RESOLUTION=[siz(0),siz(1)]
    ERASE
ENDIF

if keyword_set(nogrid) then begin
	lthick=thick
	goto, skippy
endif

; create the array with the latitudes and longitudes to be drawn 

IF (N_ELEMENTS(lat) NE 0) THEN BEGIN
    B_arr=!DTOR*lat
ENDIF ELSE BEGIN
    B_arr=!DTOR*[-90, -75, -60, -45, -30, -15, 0, 15, 30, 45, 60, 75, 90]
ENDELSE

IF (N_ELEMENTS(lon) NE 0) THEN BEGIN
    L_arr=!DTOR*lon
ENDIF ELSE BEGIN
    L_arr=!DTOR*[0, 15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180, $
                 195, 210, 225, 240, 255, 270, 285, 300, 315, 330, 345]             
ENDELSE

n_b=N_ElEMENTS(B_arr)
n_L=N_ELEMENTS(L_arr)

;###############################################################################
; Erzeugung der Drehmatrix
;###############################################################################

; Transformation to rotate the sun to a certain central meridian
D1=[[ cos(L0), 0,-sin(L0)], $
    [       0, 1,       0], $
    [sin(L0), 0, cos(L0)]]

; Transformation to take into account the central latitude
D2=[[ 1,      0,        0], $
    [0, cos(B0), -sin(B0)], $
    [0, sin(B0),  cos(B0)]]

; Transformation to take into account the position angle
D3=[[cos(P), -sin(P), 0], $
    [sin(P),  cos(P), 0], $
    [     0,       0, 1]]

; Final rotation of the coordinate points
D=D1#D2#D3

;###############################################################################
; Latitude circles
;###############################################################################

FOR i=0,n_b-1 DO BEGIN
    b=B_arr(i)
    if keyword_set(const_thick) then lthick = thick $
    	else IF (b EQ 0) THEN lthick=thick ELSE lthick=thick
    	;else IF (b EQ 0) THEN lthick=2*thick ELSE lthick=thick
    
; determine the necessary number of points (as a function of latitude)
    IF (ABS(b) GE !PI/2.) THEN n_akt=1 ELSE n_akt=ABS(FIX(n*cos(b)))
; begin to calculate the latitude circles at the meridian which is
; just behind the sun (central meridian + 180 deg.)
    l=2*!PI*FINDGEN(n_akt+1)/n_akt+L0+!PI
; If B0 is between 90 and 270 degrees begin to calculate the latitude
; circles at another longitude
    IF (cos(B0) LE 0) THEN l=l-!PI
    
; determine the [x,y,z] coordinates for the point on the circle
    x=r*sin(l)*cos(b)
    y=r*MAKE_ARRAY(n_akt+1,/FLOAT,VALUE=1.)*sin(b)
    z=r*cos(l)*cos(b)
    
; rotate the points to reflect the (P,B0,L0) orientation (matrix
; multiplication with the rotation matrix)
    xn=D(0,0)*x+D(1,0)*y+D(2,0)*z
    yn=D(0,1)*x+D(1,1)*y+D(2,1)*z
    zn=D(0,2)*x+D(1,2)*y+D(2,2)*z
    
    xn=xn+center(0)
    yn=yn+center(1)
    
; Plot all the points for which z>0 (visible points of the grid)
    ;index=WHERE(zn GE -epsilon, count)
    index=WHERE(zn GE -epsilon, count)    
    IF (count GT 0) THEN BEGIN
        PLOTS,xn(index(0)),yn(index(0)), /DATA, THICK=lthick, COLOR=color, linestyle=linestyle, clip=clip, noclip=0
        FOR k=1,count-1 DO BEGIN
            PLOTS,xn(index(k)),yn(index(k)), /CONT, /DATA, THICK=lthick, COLOR=color, linestyle=linestyle, clip=clip, noclip=0
        ENDFOR
    ENDIF
ENDFOR

;###############################################################################
; Longitude circles
;###############################################################################

b=!PI*(FINDGEN(n+1))/n
b=b-!pi/2

FOR i=0,n_l-1 DO BEGIN
    l=L_arr(i)
    if keyword_set(const_thick) then lthick = thick $
    	else IF ((!RADEG*l MOD 90) EQ 0) THEN lthick=thick ELSE lthick=thick
    	;else IF ((!RADEG*l MOD 90) EQ 0) THEN lthick=2*thick ELSE lthick=thick
    
; determine the [x,y,z] coordinates for the point on the circle
    x=r*sin(l)*cos(b)
    y=r*sin(b)
    z=r*cos(l)*cos(b)
    
; rotate the points to reflect the (P,B0,L0) orientation (matrix
; multiplication with the rotation matrix)
    xn=D(0,0)*x+D(1,0)*y+D(2,0)*z
    yn=D(0,1)*x+D(1,1)*y+D(2,1)*z
    zn=D(0,2)*x+D(1,2)*y+D(2,2)*z
    
    xn=xn+center(0)
    yn=yn+center(1)
    
; Plot all the points for which z>0 (visible points of the grid)

    index=WHERE(zn GE -epsilon,count)
    index=WHERE(zn GE -epsilon, count)    
    IF (count GT 2) THEN BEGIN
        PLOTS,xn(index(0)),yn(index(0)),/DATA,THICK=lthick, COLOR=color, linestyle=linestyle, clip=clip, noclip=0
        FOR k=1,count-1 DO BEGIN
            PLOTS,xn(index(k)),yn(index(k)),/CONT,/DATA, THICK=lthick, COLOR=color, linestyle=linestyle, clip=clip, noclip=0
        ENDFOR
    ENDIF
ENDFOR

skippy:
; Draw the enclosing circle around the sun
phi=2*!PI*FINDGEN(n+1)/n
xn=r*cos(PHI)+center(0)
yn=r*sin(PHI)+center(1)
index=WHERE(xn ge !x.crange[0] AND xn le !x.crange[1] AND $
			yn ge !y.crange[0] AND yn le !y.crange[1], count)
PLOTS,xn,yn,/DATA, COLOR=color, linestyle=linestyle, clip=clip, noclip=0, thick=lthick


;###############################################################################
; Do the labelling of the circles ...
;###############################################################################

IF KEYWORD_SET(label) THEN BEGIN
    
; first longitude
    labpos=FLTARR(3,N_ELEMENTS(lonlab))                ; x,y,z koordin, number of label
    FOR i=0,N_ELEMENTS(lonlab)-1 DO BEGIN
        labpos(*,i)=r*[sin(!DTOR*lonlab(i)),0,cos(!DTOR*lonlab(i))]
        labpos(*,i)=TRANSPOSE(D)#labpos(*,i)
    ENDFOR
    
    index=WHERE(labpos(2,*) GE r/3., count)
    IF (count GT 0) THEN BEGIN
        FOR i=0,count-1 DO BEGIN
            XYOUTS,labpos(0,index(i))+center(0)-r/60., $
              labpos(1,index(i))+center(1)+r/60., $
              STRTRIM(STRING(lonlab(index(i))),2), $
              /DATA,ORIENTATION=90,CHARSIZE=charsize,CHARTHICK=charsize, COLOR=color
        ENDFOR
    ENDIF

; then latitude
    labpos=FLTARR(3,N_ELEMENTS(latlab))

;    l=!DTOR*15*(FIX(!RADEG*l0+7.5)/15)        ; central meridian at which the label 
                                              ; will be drawn
    l=l0
    FOR i=0,N_ELEMENTS(latlab)-1 DO BEGIN
        labpos(*,i)=r*[sin(l)*cos(!DTOR*latlab(i)), $
                       sin(!DTOR*latlab(i)), $
                       cos(l)*cos(!DTOR*latlab(i))]

        labpos(*,i)=TRANSPOSE(D)#labpos(*,i)
    ENDFOR
    
    index=WHERE(labpos(2,*) GE r/3., count)   ; only draw labels at a greater distance 
                                              ; from the edge of the sun
    IF (count GT 0) THEN BEGIN
        FOR i=0,count-1 DO BEGIN
            XYOUTS,labpos(0,index(i))+center(0)+r/60., $
              labpos(1,index(i))+center(1)+r/60., $
              STRTRIM(STRING(latlab(index(i))),2), $
              /DATA,ORIENTATION=!RADEG*P,CHARSIZE=charsize,CHARTHICK=charsize, COLOR=color
        ENDFOR
    ENDIF
    
ENDIF
IF (N_ELEMENTS(grid) GT 0) THEN BEGIN
    grid=TVRD()
    SET_PLOT,olddev
ENDIF


END
