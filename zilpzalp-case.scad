WallThickness = 1.5;
BottomWallThickness = WallThickness;
TopWallThickness = BottomWallThickness;
BottomFloorHeight = 1.7;
PCBHeight = 2;
HalfHolesHeight = 1.1;
BottomHeight = BottomFloorHeight + PCBHeight;

// TopFloorHeight = 5.65;
TopFloorHeight = 1.2;
TopFloorHeightBigger = 0.75;
TopTotalHeight = BottomHeight + TopFloorHeight + TopFloorHeightBigger;
TightFit = .2;
// HolesOffset = .2;

TotalHeight = 12.5;

module pcb_outline()
{
    import("zilp-case.svg", id="pcb");
}

// module frame_inner() offset(FramePCBOffset) import("outline-rounded.svg",center=false);
// module frame_inner() offset(FramePCBOffset) import("outline-edgy-rounded.svg",center=false);
module frame_inner() import("zilp-case.svg", id="frame-inner");
module frame_outer() import("zilp-case.svg", id="frame-outer");
// module frame_inner() offset(FramePCBOffset) import("pcb.svg",center=false);

module holes_sockets() translate([0,0,-1]) linear_extrude(convexity=50) import("zilp-case.svg",id="holes-sockets");
module holes_switches_diodes() linear_extrude(convexity=50) import("zilp-case.svg", id="holes-switches-diodes");

// hotswap height 5.7
// hotswap width 13.93
// switch big hole radius 1.95
// switch small hole radius .95

// wall thickness 1.5


// total height 12.5

module bottom_case() {
    module frame_inner_smaller() offset(-TightFit) frame_inner();
    difference() {
        linear_extrude(BottomFloorHeight) frame_inner_smaller();
        holes_sockets();
        translate([0,0,BottomFloorHeight - HalfHolesHeight]) holes_switches_diodes();
    }
}

module top() import("zilp-case.svg", id="cover-outer");
module top_cutout() import("zilp-case.svg", id="cover-cutout");
module top_holes_switches() import("zilp-case.svg", id="top-holes-switches");
module top_holes_switches_bigger() import("zilp-case.svg", id="top-holes-switches-bigger");
module frame_inner_top() import("zilp-case.svg", id="frame-inner-top");

module top_case() {
    difference() {
        translate([0,0,BottomHeight+TopFloorHeightBigger]) linear_extrude(TotalHeight-BottomHeight) top();
        linear_extrude() offset(-TopWallThickness) top();
        linear_extrude() top_cutout();
    }

    translate([0,0,TotalHeight-WallThickness+TopFloorHeightBigger]) linear_extrude(WallThickness) top();

    difference() {
        translate([0,0,BottomHeight+TopFloorHeightBigger]) linear_extrude(TopFloorHeight,convexity=50) frame_inner_top();
        linear_extrude(convexity=50) top_holes_switches();
        translate([0,0,BottomHeight+TopFloorHeightBigger-1]) linear_extrude(TopFloorHeightBigger+1,convexity=50) top_holes_switches_bigger();
    
        linear_extrude() top();
    }

    
    linear_extrude(TopTotalHeight)
    {
        difference()
        {
            offset(WallThickness) frame_inner_top();
            frame_inner_top();
        }
    }
}

// }

// linear_extrude(5) difference() {
// frame_inner() top_holes_switches();

// }




translate([-200,-150,0])
{
color("#bfff77") top_case();
// color([0,.3,0]) translate([0,0,BottomFloorHeight]) pcb_outline();
// color("#80CEE1") bottom_case();
}

