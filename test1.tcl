# Define options #
set val(chan)       Channel/WirelessChannel  ;# channel type
set val(prop)       Propagation/TwoRayGround ;# radio-propagation model
set val(ant)        Antenna/OmniAntenna      ;# Antenna type
set val(ll)         LL                       ;# Link layer type
set val(ifq)        Queue/DropTail/PriQueue  ;# Interface queue type
set val(ifqlen)     50                       ;# max packet in ifq
set val(netif)      Phy/WirelessPhy          ;# network interface type
set val(mac)        Mac/802_11               ;# MAC type
set val(rp)         DSDV                     ;# ad-hoc routing protocol
set val(nn)         6                        ;# number of mobilenodes
set val(x)	    600
set val(y)	    600

set ns_ [new Simulator] 

set tracefd [open simple.tr w]
$ns_ trace-all $tracefd

set namtrace [open out_nam.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)
# Configure nodes 
$ns_ node-config -adhocRouting $val(rp) \
-llType $val(ll) \
-macType $val(mac) \
-ifqType $val(ifq) \
-ifqLen $val(ifqlen) \
-antType $val(ant) \
-propType $val(prop) \
-phyType $val(netif) \
-topoInstance $topo \
-channelType $val(chan) \
-agentTrace ON \
-routerTrace ON \
-macTrace ON \
-movementTrace ON

for {set i 0} {$i < $val(nn) } {incr i} {
     set node_($i) [$ns_ node ]
     $node_($i) random-motion 0 ;# disable random motion
}

for {set i 0} {$i < $val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 40
}

# Provide initial (X,Y, for now Z=0) co-ordinates
$node_(0) set X_ 200.0
$node_(0) set Y_ 300.0

$node_(1) set X_ 400.0
$node_(1) set Y_ 300.0

$node_(2) set X_ 100.0
$node_(2) set Y_ 400.0

$node_(3) set X_ 500.0
$node_(3) set Y_ 400.0

$node_(4) set X_ 100.0
$node_(4) set Y_ 200.0

$node_(5) set X_ 500.0
$node_(5) set Y_ 200.0

$ns_ at 0.0 "$node_(0) add-mark m1 green circle"
$ns_ at 0.0 "$node_(1) add-mark m1 red circle"
$ns_ at 0.0 "$node_(2) add-mark m1 yellow circle"
$ns_ at 0.0 "$node_(3) add-mark m1 blue circle"
$ns_ at 0.0 "$node_(4) add-mark m1 purple circle"
$ns_ at 0.0 "$node_(5) add-mark m1 pink circle"

$ns_ at 0.0 "$node_(0) setdest 200.0 300.0 100.0"
$ns_ at 0.0 "$node_(1) setdest 400.0 300.0 100.0"
$ns_ at 0.0 "$node_(2) setdest 100.0 400.0 100.0"
$ns_ at 0.0 "$node_(3) setdest 500.0 400.0 100.0"
$ns_ at 0.0 "$node_(4) setdest 100.0 200.0 100.0"
$ns_ at 0.0 "$node_(5) setdest 500.0 200.0 100.0"

#round 1 node position change
$ns_ at 10.0 "$node_(2) setdest 150.0 450.0 15.0"
$ns_ at 25.0 "$node_(3) setdest 450.0 450.0 15.0"
$ns_ at 40.0 "$node_(4) setdest 150.0 150.0 15.0"
$ns_ at 55.0 "$node_(5) setdest 450.0 150.0 15.0"

#round 2 node position change
$ns_ at 25.0 "$node_(2) setdest 250.0 450.0 15.0"
$ns_ at 40.0 "$node_(3) setdest 350.0 500.0 15.0"
$ns_ at 55.0 "$node_(4) setdest 250.0 200.0 15.0"
$ns_ at 70.0 "$node_(5) setdest 350.0 100.0 15.0"

#round 3 node position change
$ns_ at 40.0 "$node_(2) setdest 300.0 300.0 15.0"
$ns_ at 55.0 "$node_(3) setdest 300.0 400.0 15.0"
$ns_ at 70.0 "$node_(4) setdest 250.0 100.0 15.0"
$ns_ at 85.0 "$node_(5) setdest 400.0 200.0 15.0"

#round 4 node position change
$ns_ at 70 "$node_(2) setdest 100.0 400.0 15.0"
$ns_ at 85 "$node_(3) setdest 500.0 400.0 15.0"
$ns_ at 90 "$node_(4) setdest 50.0 50.0 15.0"
$ns_ at 95 "$node_(5) setdest 500.0 200.0 15.0"

# .##### TCP connections between node_(0) and other. ########
set tcp(0) [new Agent/TCP]
$ns_ attach-agent $node_(0) $tcp(0)
set ftp(0) [new Application/FTP]
$ftp(0) attach-agent $tcp(0)

set sink(0) [new Agent/TCPSink]
$ns_ attach-agent $node_(5) $sink(0)
$ns_ connect $tcp(0) $sink(0)
$ns_ at 10.0 "$ftp(0) start"
$ns_ at 15.0 "$ftp(0) stop"
# .##### TCP connections between node_(0) and other. ########

# .##### TCP connections between node_(0) and other. ########
set tcp(1) [new Agent/TCP]
$ns_ attach-agent $node_(0) $tcp(1)
set ftp(1) [new Application/FTP]
$ftp(1) attach-agent $tcp(1)

set sink(1) [new Agent/TCPSink]
$ns_ attach-agent $node_(4) $sink(1)
$ns_ connect $tcp(1) $sink(1)
$ns_ at 20.0 "$ftp(1) start"
$ns_ at 25.0 "$ftp(1) stop"
# .##### TCP connections between node_(0) and other. ########

# .##### TCP connections between node_(0) and other. ########
set tcp(2) [new Agent/TCP]
$ns_ attach-agent $node_(0) $tcp(2)
set ftp(2) [new Application/FTP]
$ftp(2) attach-agent $tcp(2)

set sink(2) [new Agent/TCPSink]
$ns_ attach-agent $node_(3) $sink(2)
$ns_ connect $tcp(2) $sink(2)
$ns_ at 30.0 "$ftp(2) start"
$ns_ at 35.0 "$ftp(2) stop"
# .##### TCP connections between node_(0) and other. ########

# .##### TCP connections between node_(0) and other. ########
set tcp(3) [new Agent/TCP]
$ns_ attach-agent $node_(0) $tcp(3)
set ftp(3) [new Application/FTP]
$ftp(3) attach-agent $tcp(3)

set sink(3) [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $sink(3)
$ns_ connect $tcp(3) $sink(3)
$ns_ at 40.0 "$ftp(3) start"
$ns_ at 45.0 "$ftp(3) stop"
# .##### TCP connections between node_(0) and other. ########

# .##### TCP connections between node_(1) and other. ########
set tcp(4) [new Agent/TCP]
$ns_ attach-agent $node_(1) $tcp(4)
set ftp(4) [new Application/FTP]
$ftp(4) attach-agent $tcp(4)

set sink(4) [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $sink(4)
$ns_ connect $tcp(4) $sink(4)
$ns_ at 60.0 "$ftp(4) start"
$ns_ at 65.0 "$ftp(4) stop"
# .##### TCP connections between node_(1) and other. ########

# .##### TCP connections between node_(1) and other. ########
set tcp(5) [new Agent/TCP]
$ns_ attach-agent $node_(1) $tcp(5)
set ftp(5) [new Application/FTP]
$ftp(5) attach-agent $tcp(5)

set sink(5) [new Agent/TCPSink]
$ns_ attach-agent $node_(3) $sink(5)
$ns_ connect $tcp(5) $sink(5)
$ns_ at 70.0 "$ftp(5) start"
$ns_ at 75.0 "$ftp(5) stop"
# .##### TCP connections between node_(0) and other. ########

# .##### TCP connections between node_(0) and other. ########
set tcp(6) [new Agent/TCP]
$ns_ attach-agent $node_(1) $tcp(6)
set ftp(6) [new Application/FTP]
$ftp(6) attach-agent $tcp(6)

set sink(6) [new Agent/TCPSink]
$ns_ attach-agent $node_(4) $sink(6)
$ns_ connect $tcp(6) $sink(6)
$ns_ at 80.0 "$ftp(6) start"
$ns_ at 85.0 "$ftp(6) stop"
# .##### TCP connections between node_(0) and other. ########

# .##### TCP connections between node_(0) and other. ########
set tcp(7) [new Agent/TCP]
$ns_ attach-agent $node_(1) $tcp(7)
set ftp(7) [new Application/FTP]
$ftp(7) attach-agent $tcp(7)

set sink(7) [new Agent/TCPSink]
$ns_ attach-agent $node_(5) $sink(7)
$ns_ connect $tcp(7) $sink(7)
$ns_ at 90.0 "$ftp(7) start"
$ns_ at 95.0 "$ftp(7) stop"
# .##### TCP connections between node_(1) and other. ########

# .##### TCP connections between node_(1) and other. ########
set tcp(9) [new Agent/TCP]
$ns_ attach-agent $node_(1) $tcp(9)
set ftp(9) [new Application/FTP]
$ftp(9) attach-agent $tcp(9)

set sink(9) [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $sink(9)
$ns_ connect $tcp(9) $sink(9)
$ns_ at 60.0 "$ftp(4) start"
$ns_ at 70.0 "$ftp(4) stop"
# .##### TCP connections between node_(1) and other. ########

# .##### TCP connections between node_(1) and other. ########
set tcp(8) [new Agent/TCP]
$ns_ attach-agent $node_(1) $tcp(8)
set ftp(8) [new Application/FTP]
$ftp(8) attach-agent $tcp(8)

set sink(8) [new Agent/TCPSink]
$ns_ attach-agent $node_(4) $sink(8)
$ns_ connect $tcp(8) $sink(8)
$ns_ at 70.0 "$ftp(8) start"
$ns_ at 95.0 "$ftp(8) stop"
# .##### TCP connections between node_(1) and other. ########

# Tell nodes when the simulation ends
for {set i 0} {$i < $val(nn) } {incr i} {
     $ns_ at 100.0 "$node_($i) reset";
}
$ns_ at 100.0001 "stop"
$ns_ at 100.0002 "puts \"NS EXITING...\" $ns_ halt"


# graph procedure..
$ns_ at 6.0 "Graph"
set g [open graph.tr w]
#set g1 [open graph1.tr w]

proc Graph {} {
global ns_ g 
set time 1.0
set now [$ns_ now]
puts $g "[expr rand()*4] [expr rand()*2]"
#puts $g1 "[expr rand()*8] [expr rand()*6]"
$ns_ at [expr $now+$time] "Graph"
}

proc stop {} {
     global ns_ tracefd namtrace
     $ns_ flush-trace
     close $tracefd
     close $namtrace

exec xgraph -M -bb -geometry 500X500 graph.tr &
# exec xgraph -brb -geometry 600X500 graph.tr &
exec xgraph -bg skyblue -t Packet_Delivery_Ratio_vs_Time -x TIME -y PDR(%) simple.tr &
     #exec $namtrace 
     exit 0
}

puts "Starting Simulation..."
$ns_ run
