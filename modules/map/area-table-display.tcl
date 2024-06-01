## -*- tcl -*-
# # ## ### ##### ######## ############# ######################
## (c) 2022 Andreas Kupries
##
## Originally developed within the AKIS project (c) Andreas Kupries

# @@ Meta Begin
# Package map::area::table-table-display 0.1
# Meta author      {Andreas Kupries}
# Meta location    https://core.tcl.tk/tklib
# Meta platform    tcl
# Meta summary	   Widget to display a table of area definitions
# Meta description Widget to display the information of many area definitions
# Meta description in a table
# Meta subject     {area display, tabular}
# Meta subject     {tabular, area display}
# Meta require     {Tcl 8.6-}
# Meta require     {Tk  8.6-}
# Meta require     debug
# Meta require     debug::caller
# Meta require     {map::slippy 0.8}
# Meta require     scrollutil
# Meta require     snit
# Meta require     tablelist
# @@ Meta End

package provide map::area::table-display 0.1

# # ## ### ##### ######## ############# ######################
## API
#
##  <class> OBJ store ...
#
##  OBJ focus ID
#
##  -on-selection	Command prefix to report selection changes
#
# # ## ### ##### ######## ############# ######################
## Requirements

package require Tcl 8.6-
package require Tk  8.6-
#                                       ;# Tcllib
package require debug                   ;# - Narrative Tracing
package require debug::caller           ;#
package require map::slippy 0.8         ;# - Map utilities
package require snit                    ;# - OO system
#                                       ;# Tklib
package require scrollutil              ;# - Scroll framework
package require tablelist               ;# - Tabular table-display

# # ## ### ##### ######## ############# ######################
## Ensemble setup.

namespace eval map       { namespace export area          ; namespace ensemble create }
namespace eval map::area { namespace export table-display ; namespace ensemble create }

debug level  tklib/map/area/table-display
debug prefix tklib/map/area/table-display {<[pid]> [debug caller] | }

# # ## ### ##### ######## ############# ######################

snit::widget ::map::area::table-display {
    # . . .. ... ..... ........ ............. .....................
    ## User configuration

    option -on-selection -default {}

    # . . .. ... ..... ........ ............. .....................
    ## State
    #
    # - List of shown area definitions
    #   (per row: id, name, center (lat/lon separate), parts, diameter, perimeter)
    #   => 7 columns
    #   id identifies the row, and is mapped back to the AREA id.
    #
    # - Backward map from row ids to AREA ids
    #   NOTE: multiple row ids can map to the same area (multiple names!)
    #
    # - Forward map from area id to the set of rows showing that area
    #   (set because multiple names)
    #
    # - Command to access backing store.

    variable myspec  {} ;# Table data derived from the area specifications
    variable myrows  {} ;# dict (row-id -> area-id)
    variable myareas {} ;# dict (area-id -> row-id -> ".")
    variable mystore {} ;# Store backing the display
    # FUTURE: event: add/remove/change

    # . . .. ... ..... ........ ............. .....................
    ## Lifecycle

    constructor {store args} {
	debug.tklib/map/area/table-display {}

	$self configurelist $args

	set mystore $store

	scrollutil::scrollarea $win.sa
	tablelist::tablelist   $win.sa.table -width 90 \
	    -columntitles {\# Name Lat Lon Parts Diameter Perimeter}
	$win.sa setwidget     $win.sa.table

	pack $win.sa -in $win -fill both -expand 1

	$win.sa.table configure \
	    -listvariable [myvar myspec] \
	    -labelcommand  tablelist::sortByColumn \
	    -labelcommand2 tablelist::addToSortColumns

	bind $win.sa.table <<TablelistSelect>> [mymethod SelectionChanged]

	#DO watch [mymethod StoreChanged] ;# FUTURE: react to edits and
	after 100 [mymethod StoreChanged] ;# resulting store changes
	return
    }

    destructor {
	debug.tklib/map/area/table-display {}

	#DO unwatch [mymethod StoreChanged]
	return
    }

    # . . .. ... ..... ........ ............. .....................
    ## API

    method focus {areaid} {
	debug.tklib/map/area/table-display {}

	set rowids [dict keys [dict get $myareas $areaid]]

	# Locate the rows in the table bearing the rowids for the area
	# Search is required because the table may not be sorted in order

	set rows [lsort -integer [lmap rowid $rowids {
	    set pos [lsearch -exact -index 0 $myspec $rowid]
	    if {$pos < 0} continue
	    set pos
	}]]

	# Select all rows, show the highest (by dint of sorting above)
	$win.sa.table selection clear 0 end
	foreach row $rows {
	    $win.sa.table selection set $row
	    $win.sa.table see           $row
	}

	return
    }

    # . . .. ... ..... ........ ............. .....................
    ## Internals

    proc DO {args} {
	debug.tklib/map/area/table-display {}

	upvar 1 mystore mystore
	return [uplevel #0 [list {*}$mystore {*}$args]]
    }

    method StoreChanged {args} {
	debug.tklib/map/area/table-display {}

	# Local storage to assemble the display information in.
	set specs {}
	set map   {}
	set areas {}

	# Note: Areas with multiple names generate multiple entries in the table, one per name.
	# Each such row maps to the same area, and the area will know about all its rows.

	foreach areaid [DO ids] {
	    set spec [DO get $areaid]
	    # names, geo, center, diameter, perimeter, parts
	    dict with spec {}
	    #puts |$areaid|$spec|

	    # Formatting for display - Ignores geo

	    set diameter  [map slippy pretty-distance $diameter]
	    set perimeter [map slippy pretty-distance $perimeter]
	    lassign [map slippy geo limit $center] lat lon

	    if {![llength $names]} {
		# No names, single row with empty name column.

		lappend row	[incr rowid]
		lappend row	{}
		lappend row	$lat
		lappend row	$lon
		lappend row	$parts
		lappend row	$diameter
		lappend row	$perimeter

		lappend specs $row
		unset row

		dict set map   $rowid $areaid
		dict set areas $areaid $rowid .
	    } else {
		# One or more names, one row per name

		foreach name $names {
		    lappend row	[incr rowid]
		    lappend row	$name
		    lappend row	$lat
		    lappend row	$lon
		    lappend row	$parts
		    lappend row	$diameter
		    lappend row	$perimeter

		    lappend specs $row
		    unset row

		    dict set map   $rowid $areaid
		    dict set areas $areaid $rowid .
		}
	    }
	}

	# ... and commit
	set myrows  $map
	set myareas $areas
	set myspec  $specs

	return
    }

    method SelectionChanged {} {
	debug.tklib/map/area/table-display {}

	after idle [mymethod ReportSelectionChange]
	return
    }

    method ReportSelectionChange {} {
	debug.tklib/map/area/table-display {}

	if {![llength $options(-on-selection)]} return

	# row    - index of entry in table, influenced by sorting
	# rowid  - internal row id as pulled out of entry
	# areaid - area id associated to the row id

	set row [$win.sa.table curselection]
	if {$row eq {}} return

	#puts row//[lindex $myspec $row]//

	set rowid  [lindex $myspec $row 0]
	set areaid [dict get $myrows $rowid]

	uplevel #0 [list {*}$options(-on-selection) $areaid]
	return
    }

    # . . .. ... ..... ........ ............. .....................
}

# # ## ### ##### ######## ############# ######################
return
