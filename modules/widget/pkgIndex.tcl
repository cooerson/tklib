if {![package vsatisfies [package provide Tcl] 8.4-]} {return}
package ifneeded widget                 3.1   [list source [file join $dir widget.tcl]]
package ifneeded widget::arrowbutton    1.0   [list source [file join $dir arrowb.tcl]]
package ifneeded widget::calendar       1.0.1 [list source [file join $dir calendar.tcl]]
package ifneeded widget::dateentry      0.97  [list source [file join $dir dateentry.tcl]]
package ifneeded widget::dialog         1.3.1 [list source [file join $dir dialog.tcl]]
package ifneeded widget::menuentry      1.0.1 [list source [file join $dir mentry.tcl]]
package ifneeded widget::panelframe     1.1   [list source [file join $dir panelframe.tcl]]
package ifneeded widget::ruler          1.1   [list source [file join $dir ruler.tcl]]
package ifneeded widget::screenruler    1.2   [list source [file join $dir ruler.tcl]]
package ifneeded widget::scrolledtext   1.0   [list source [file join $dir stext.tcl]]
package ifneeded widget::scrolledwindow 1.2.1 [list source [file join $dir scrollw.tcl]]
package ifneeded widget::statusbar      1.2.1 [list source [file join $dir statusbar.tcl]]
package ifneeded widget::superframe     1.0.1 [list source [file join $dir superframe.tcl]]
package ifneeded widget::toolbar        1.2.1 [list source [file join $dir toolbar.tcl]]
