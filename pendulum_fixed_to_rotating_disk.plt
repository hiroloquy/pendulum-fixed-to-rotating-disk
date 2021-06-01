reset

#=================== Parameter ====================
g = 9.81        # Gravitational acceleration [m/s2]
m = 10.0        # Mass of the pendulum [kg]
l = 10.0        # Length of the pendulum [m]
r = 5.0         # Radius of the disk [m]
w = 2.0         # Angular velocity of the disk [rad/s]

psOrigin = 1    # ps = point size
psJoint = 1.5
psPendulum = 2
lwDisk = 1      # lw = line width
lwLink = 2
lwTrajectory = 1

# Initial Value
t = 0.0         # [s]
alpha = 0.0     # [rad]
theta = 0.0     # [rad]
dtheta = 5.0    # [rad/s]

dt = 0.001      # [s]
dh = dt/6.0     # Coefficient of Runge Kutta 4th
tmax = 30.0     # [s]         
numLoop = 2000  # Number of the frame
numSkip = int((tmax/dt)/numLoop)   # Number of the skipping frame

# Select terminal type
qtMode = 1     # ==1: qt (simulator) / !=1: png (output images for making video)
print sprintf("[MODE] %s", (qtMode==1 ? 'Simulate in Qt window' :'Output PNG images'))

#=================== Function ====================
# Position of the fixed point
calcJointX(alpha) = r*cos(alpha)
calcJointY(alpha) = r*sin(alpha)

# Position of the pendulum
calcPendulumX(alpha, theta) = r*cos(alpha) + l*sin(theta)
calcPendulumY(alpha, theta) = r*sin(alpha) - l*cos(theta)

# Equations of motion
C1 = r/l*w**2       # The first coefficient of eom
C2 = g/l            # The second coefficient of eom

f1(theta, dtheta, t) = dtheta                           # dθ/dt
f2(theta, dtheta, t) = C1*cos(theta-w*t)-C2*sin(theta)  # d2θ/dt2

# Runge-Kutta 4th (Define rk_i(theta, dtheta, t))
do for[i=1:2]{
    rki = "rk"
    fi  = "f".sprintf("%d", i)
    rki = rki.sprintf("%d(theta, dtheta, t) = (\
        k1 = %s(theta, dtheta, t),\
        k2 = %s(theta + dt*k1/2., dtheta + dt*k1/2., t + dt/2.),\
        k3 = %s(theta + dt*k2/2., dtheta + dt*k2/2., t + dt/2.),\
        k4 = %s(theta + dt*k3, dtheta + dt*k3, t + dt),\
        dh * (k1 + 2*k2 + 2*k3 + k4))", i, fi, fi, fi, fi)
    eval rki
}

# Fade the trajectory of the pendulum
fadeTrajectory(i) = (fadeN=100, (i>fadeN ? i-fadeN : 0))

# Show the value of time t
showTime(t) = sprintf("{/:Italic t} = %3.2f s", t)

#=================== Setting ====================
if(qtMode==1){
    set term qt size 720, 720 font 'Times'
} else {
    set term pngcairo size 720, 720 font 'Times'
    folderName = 'png'
    system sprintf('mkdir %s', folderName)
}

unset key
set grid
set size ratio -1
set xlabel '{/:Italic x}' font ', 20'
set ylabel '{/:Italic y}' font ', 20'
set tics font ', 18'

#=================== Calculation ====================
# Output 1: "position_3joints.txt" is need for plotting two lines.
dataJointsPos = "position_3joints.txt"
print sprintf('Start outputting %s ...', dataJointsPos)
set print dataJointsPos

# Write terms and initial values into txt file
print sprintf("# %s", dataJointsPos)
print "# Time: t"
print "# Origin: x / y"
print "# Joint: x / y"
print "# Pendulum: x / y"
print sprintf("%.3f", t)    # time (only 1 column)
print 0, 0  # origin
print sprintf("%.3f %.3f", calcJointX(alpha), calcJointY(alpha))
print sprintf("%.3f %.3f", calcPendulumX(alpha, theta), calcPendulumY(alpha, theta))
print ""

do for [i=1:numLoop*numSkip:1] {
    t  = t  + dt
    alpha = alpha  + w * dt
    incTheta = rk1(theta, dtheta, t)
    incDtheta = rk2(theta, dtheta, t)
    theta = theta + incTheta
    dtheta = dtheta + incDtheta

    if(i%numSkip==0) {
        # print sprintf("# t = %.3f", t)
        print sprintf("%.3f", t)    # time (only 1 column)
        print 0, 0  # origin
        print sprintf("%.3f %.3f", calcJointX(alpha), calcJointY(alpha))
        print sprintf("%.3f %.3f", calcPendulumX(alpha, theta), calcPendulumY(alpha, theta))
        print ""
    }
}
unset print 
print sprintf('Finish!')

# Output 2: "pendulum_trajectory.txt" is need for plotting the trajectoy of the pendulum.
dataPendulumTrajectory = 'pendulum_trajectory.txt'
print sprintf('Start outputting %s ...', dataPendulumTrajectory)
set print dataPendulumTrajectory

print sprintf("# %s", dataPendulumTrajectory)
print '# t / x / y'
set yrange [*:*]    # This command enables to remove restrictions on the range of the stats command.
do for [i=0:numLoop:1]{
    stats dataJointsPos using 1 every ::0:i:0:i nooutput
    pend_t = STATS_max
    stats dataJointsPos using 1 every ::3:i:3:i nooutput
    pend_x = STATS_max
    stats dataJointsPos using 2 every ::3:i:3:i nooutput
    pend_y = STATS_max
    print pend_t, pend_x, pend_y
}
unset print 
print sprintf('Finish!')

#=================== Plot ====================
if(qtMode == 1) {
    print "Start simulation"
} else {
    print sprintf('Start outputting %d images ...', numLoop)
}
rangePlotArea = (r+l)*1.3

do for [i=0:numLoop:1]{
    if(qtMode != 1) { set output sprintf("%s/img_%04d.png", folderName, i) }

    # Get the value of time from either of txt files
    set yrange [*:*]    # This command enables to remove restrictions on the range of the stats command.
    stats dataJointsPos using 1 every ::0:i:0:i nooutput
    time = STATS_max
    set title showTime(time) left offset screen -0.07, -0.01 font ', 20'
 
    # Draw the rotating disk
    set object 1 circle at 0, 0 size r fc rgb 'gray' fs solid border lc rgb 'black' lw lwDisk behind

    plot[floor(-rangePlotArea):ceil(rangePlotArea)][floor(-rangePlotArea):ceil(rangePlotArea)] \
        dataJointsPos using 1:2 every ::1:i:2:i with linespoints pt 7 ps psOrigin lw lwDisk lc -1, \
        dataJointsPos using 1:2 every ::2:i:3:i with linespoints pt 7 ps psJoint lw lwLink lc -1, \
        dataJointsPos using 1:2 every ::3:i:3:i with points pt 7 ps psPendulum lc 7, \
        dataPendulumTrajectory using 2:3 every ::fadeTrajectory(i)::i with line lw lwTrajectory lc 7

    if(qtMode == 1) {    
        if(i==0) {pause 2}
    } else {
        set out # terminal pngcairo
    }
}
    
if(qtMode == 1){ pause 2 }   # Wait a few seconds

# Output the trajectory of the pendulum
set term pngcairo size 720, 720 font 'Times'
set output "trajectory_plot.png"
plot[floor(-rangePlotArea):ceil(rangePlotArea)][floor(-rangePlotArea):ceil(rangePlotArea)] \
    dataPendulumTrajectory using 2:3 every ::0::numLoop with line lw lwTrajectory lc 7
set out
print sprintf('Finish this program')
