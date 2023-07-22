## -*- tcl -*-
# # ## ### ##### ######## ############# ######################
## (c) 2022 Andreas Kupries
##
## Filesystem based storage of geo/area information - Independent of AKIS
## Tklib geo/area file format
##
## - Line based
## - Ignores leading and trailing whitespace in lines
## - Ignores empty lines
## - Ignore lines starting with `//` - C++ line comments
## - Ignore lines starting with `#`  - Shell et al line comments
## - Magic word in first line identifying the file: "tklib/geo/area"
## - Zero to more non-numeric lines specifying area names
## - Exactly 2 or more numeric lines specifying coordinates, even number
## - Coordinates are validated as lat/lon

# @@ Meta Begin
# Package map::area::file 0.1
# Meta author      {Andreas Kupries}
# Meta location    https://core.tcl.tk/tklib
# Meta platform    tcl
# Meta summary	   Reading/writing tklib geo/area files
# Meta description Reading/writing tklib geo/area files
# Meta subject	   map
# Meta subject	   {file, geo/area}
# Meta subject	   {geo/area, file}
# Meta require     {Tcl 8.6-}
# Meta require     debug
# Meta require     debug::caller
# Meta require     {map::slippy 0.8}
# Meta require     snit
# @@ Meta End

package provide map::area::file 0.1

# # ## ### ##### ######## ############# ######################
## API
#
##  read  PATH		-> INFO :: dict (names, geo)
##  write PATH INFO	-> VOID
#
# # ## ### ##### ######## ############# ######################
## Requirements

package require Tcl 8.6
#                               ;# Tcllib
package require debug		;# - Narrative Tracing
package require debug::caller   ;#
package require map::slippy 0.8	;# - Map utilities
package require snit            ;# - OO system

# # ## ### ##### ######## ############# ######################
## Ensemble setup.

namespace eval map             { namespace export area       ; namespace ensemble create }
namespace eval map::area       { namespace export file       ; namespace ensemble create }
namespace eval map::area::file { namespace export read write ; namespace ensemble create }

debug level  tklib/map/area/file
debug prefix tklib/map/area/file {<[pid]> [debug caller] | }

# # ## ### ##### ######## ############# ######################
## API

proc ::map::area::file::read {path} {
    debug.tklib/map/area/file {}

    if {[catch {
	set c [open $path r]
    }]} return

    set d [::read $c]
    close $c

    set names {}
    set coordinates [lmap line [split $d \n] {
	set line [string trim $line]
	if {$line eq {}} continue
	if {[string match //*  $line]} continue
	if {[string match "#*" $line]} continue
	if {![string is double -strict $line]} {
	    lappend names $line
	    continue
	}
	set line
    }]

    #puts $path\t//$names//$coordinates//
    set names [lassign $names magic]

    if {$magic ne "tklib/geo/area"} {
	#puts "$path\t/no magic"
	return
    }
    if {[llength $coordinates] < 2} {
	#puts "$path\t/bad coordinate count [llength $coordinates]"
	return
    }
    if {[llength $coordinates] % 2 == 1} {
	#puts "$path\t/bad coordinate count [llength $coordinates]"
	return
    }

    set geos [lmap {lat lon} $coordinates { list $lat $lon }]

    if {![map slippy geo valid-list $geos]} return

    # Default name derived from file name, iff no name specified
    if {![llength $names]} { lappend names [file rootname [file tail $path]] }

    dict set g names $names
    dict set g geo   $geos

    return $g
}

proc ::map::area::file::write {path gdata} {
    debug.tklib/map/area/file {}

    set c [open $path w]

    puts $c tklib/geo/area

    foreach name [lsort -dict -unique [dict get $gdata names]] {
	puts $c $name
    }

    foreach geo [dict get $gdata geo] {
	lassign $geo lat lon
	puts $c $lat
	puts $c $lon
    }

    close $c
    return
}

# # ## ### ##### ######## ############# ######################
return
