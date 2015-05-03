#ifndef NEKO_CAM_H
#define NEKO_CAM_H

#include "Vect.h"

#include "Ray.h"

struct Cam
{
  Vect pos;
  Vect dir;
  
  //we are going to arrange the view-rays to go from one point through a plane
  //the plane has the size of plx*ply and is pld away from pos in dir direction
  Vect right;
  Vect down;
  
  dot aspec;
  
  //screen size
  int2 resolution;
  
  Cam()
  {
    setRes(1,1);
  }
  
  void setRes(int w, int h);
  
  void setPos(Vect t_pos);
  
  void lookAt(Vect t_at);
  
  Ray getRay(int x, int y);
  
  
};

#endif