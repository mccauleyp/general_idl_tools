# General IDL Tools

This repository contains a collection of general-purpose IDL routines along with codes 
that are specific to Solar Physics applications but are not related to a specific 
instrument. 

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

## Contents and Usage

Each file includes a header with usage documentation. The following is a simple list 
of the subdirectories with brief descriptions of what each program does:

### Arrays and Images

### Mapping

### Physics and Math

### Plotting

### File IO

### Strings


## Dependencies

Many of the programs include references to files in the 
[SolarSoft IDL](https://sohowww.nascom.nasa.gov/solarsoft/) libraries and a few contain 
references to the 
[Coyote IDL](http://www.idlcoyote.com/documents/programs.php) library. 
Dependencies to external libraries are noted in the "CALLS" section of the program 
headers. 

## Authors and acknowledgment

These codes were largely written by me (Patrick McCauley) with a few instances of 
routines that I modified to add new features. Most of the modified versions are denoted 
by an "mc" appended to the original filename. See headers for authorship details. 

## License
[MIT](https://choosealicense.com/licenses/mit/)