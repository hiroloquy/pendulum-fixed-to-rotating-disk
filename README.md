# pendulum-fixed-to-rotating-disk
"fixed-pendulum_rotating-disk" is a **mechanical simulator** with gnuplot.
This simulator is involved with the pendulum fixed to the edge of a rotating disk.
 
# DEMO
- teminal: **`qt`**  
 ![simulator_in_qt](demo_qt.gif)

- teminal: **`pngcairo`**  
  Note: To create a video from PNG images, you use ffmpeg.  
![video_in_pngcairo](demo_pngcairo.gif)

# Modeling
 ![model](model.png)
## Position of the point P
<img src="https://latex.codecogs.com/png.latex?\dpi{200}&space;\boldsymbol{p}=\begin{bmatrix}&space;r\cos\omega&space;t&plus;l\sin\theta&space;\\&space;r\sin\omega&space;t-l\cos\theta&space;\end{matrix}" title="\boldsymbol{p}=\begin{bmatrix} r\cos\omega t+l\sin\theta \\ r\sin\omega t-l\cos\theta \end{matrix}" />

## Lgrange's equation
<img src="https://latex.codecogs.com/png.latex?\dpi{200}&space;\frac{d}{dt}\left(\frac{\partial&space;L}{\partial&space;\dot{\theta}}\right)-\frac{\partial&space;L}{\partial\theta}=0" title="\frac{d}{dt}\left(\frac{\partial L}{\partial \dot{\theta}}\right)-\frac{\partial L}{\partial\theta}=0" />

## Equation of motion
<img src="https://latex.codecogs.com/png.latex?\dpi{200}&space;\ddot{\theta}-\frac{r}{l}\omega^2\cos\left(\theta-\omega&space;t\right)&plus;\frac{g}{l}\sin\theta=0" title="\ddot{\theta}-\frac{r}{l}\omega^2\cos\left(\theta-\omega t\right)+\frac{g}{l}\sin\theta=0" />

# Features
You enable to switch terminal type `qt` or `pngcairo` by using **`qtMode`**.
- If you select `qt` terminal (`qtMode==1`), gnuplot opens qt window and you can run this simulator.

- On the other hand, in `pngcairo` terminal (`qtMode!=1`), you can get a lot of PNG images of the simulation.
By using the outputted images, you can make a video or an animated GIF.

# Operating environment
<!-- # Requirement -->
- macOS Big Sur 11.3.1 / Macbook Air (M1, 2020) 16GB
- gnuplot version 5.4 patchlevel 1

<!-- # Installation -->
 
# Usage
```
git clone https://github.com/hiroloquy/mechanics.git
cd pendulum-fixed-to-rotating-disk
gnuplot
load 'pendulum_fixed_to_rotating_disk.plt'
```
Please check the value of `qtMode` before running.
# Note
- When changing the initial value or parameter value, you don not forget to write a decimal point in the number (**float**). If the value does not have a decimal point, gnuplot regards the value as **int**, and the calculation accuracy will be poor!

- I made a MP4 file (png2movie.mp4) and an animated GIF file (movie2anime.gif) by using **ffmpeg**.

```
cd pendulum-fixed-to-rotating-disk
ffmpeg -framerate 60 -i png/img_%04d.png -vcodec libx264 -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -r 60 png2video.mp4
```
 
# Author
* Hiro
* Twitter: https://twitter.com/Sm_pgmf
 
# License
"pendulum-fixed-to-rotating-disk" is under [Hiroloquy](https://hiroloquy.com/).
 
