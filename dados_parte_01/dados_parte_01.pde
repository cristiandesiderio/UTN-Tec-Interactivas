// El terreno está armado en base a este tutorial:  Code for: https://youtu.be/IKB1hWWedMk (Daniel Shiffman)
// Los OBJ son de Turbosquid

// SE DEBE IMPLEMENTAR EL CÓDIGO DONDE SE INDICA // *** COMPLETAR ACÁ *** 

PImage img;
PShape model;

// velocidadRotacion indicará cuántos grados queremos rotar el cubo 
// cada vez que presionamos una tecla (la tecla determinará el eje y sentido de rotación
float velocidadRotacion = PI/18;

// se usan para mantener los ángulos de rotación
float rotaX, rotaY, rotaZ = 0;

// estas definiciones son para el terreno
int cols, rows;
int scl = 20;
int w = 1600;
int h = 800;
float flying = 0;
float[][] terrain;
// 

// permitirá activar o desactivar la grilla
boolean grillaOn = true;

// para uso de la cámara - activación/desactivación y ángulo de rotación
boolean cameraOn = false;
float anguloCamera = 0;


// Nuevas variables para la segunda cámara
PVector camaraPosicion;
PVector camaraObjetivo;
PVector camaraArriba;
float camaraVelocidad = 0.1;

void setup(){
  size(800, 600, P3D);
  frameRate(30);
  
  // necesita el archivo ojo.mtl (biblioteca de materiales)
  model = loadShape("dice.obj");
  // este modo establece como ejes locales el centro del objeto (modelo) importado
  shapeMode(CORNERS);
  
  // definiciones para el terreno 3D
  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];
  //
  
  
}

// Este procedimiento crea una grilla plana en la vista 
// se deben dibujar líneas verticales y líneas horizontales
void dibujarGrilla(int espacio){
  stroke(96,96,0);
  
 // Dibuja líneas verticales
  for (float x = 0; x <= w; x += espacio) {
    line(x, 0, x, h);

  }
  
  // Dibuja líneas horizontales
  for (float y = 0; y <= h; y += espacio) {
    line(0, y, w, y);

  }

}

void terreno3D(){
 
  flying -= 0.1;

  float yoff = flying;
  for (int y = 0; y < rows; y++) {
    float xoff = 0;
    for (int x = 0; x < cols; x++) {
      // la función noise retorna secuencias al asar https://processing.org/reference/noise_.html
      // la función map MAPEA esos random a coordenadas de nuestra escena
      terrain[x][y] = map(noise(xoff, yoff), 0, 1, -100, 50);
      xoff += 0.2;
    }
    yoff += 0.2;
  }

  stroke(255);
  noFill();
  translate(width/2, height/2);
  rotateX(PI/3);
  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      // probar comentar los VERTEX anteriores y descomentar esto
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
  translate(w/2, h/2);
  rotateX(-PI/3);

  
}

void draw(){
  background(0);
  
  
  if (mousePressed) {
   beginCamera();
   camera();
   rotateY(radians(anguloCamera));
   endCamera();
  } 
  
    
  if (grillaOn) {
    translate(0, -50,150);
    dibujarGrilla(20);
    translate(0,50,-150);
  }

  // dibuja el terreno
  terreno3D();
  
  
  lights();
  
  // posiciona el CUBO
  translate(0,-50,150);
  
if (keyPressed) {
    if (key == 'W' || key == 'w') {
      rotaX += velocidadRotacion;
    }
    if (key == 'S' || key == 's') {
        rotaX -= velocidadRotacion;
     }
    if (key == 'A' || key == 'a') {
        rotaY += velocidadRotacion;
     }
     if (key == 'D' || key == 'd') {
         rotaY -= velocidadRotacion;
     }
     if (key == 'Q' || key == 'q') {
        rotaZ += velocidadRotacion;
     }
     if (key == 'E' || key == 'e') {
        rotaZ += velocidadRotacion;
     }
  }
  
  // *** COMPLETAR ACÁ ***
  rotateX(rotaX);
  rotateY(rotaY);
  rotateZ(rotaZ);
  // *** FIN ***s
 
  
  stroke(0,255,0);
  // dibuja una línea guía
  line(0, -100, 0, 0, 100, 0);
  
  scale(10);
  shape(model);
  
}

void keyReleased(){
  if (key == 'G' || key == 'g') {
      grillaOn =  !(grillaOn);
    }
   
}

// Detección de acciones de MOUSE
// se mantengo presionado y muevo mouse debería cambiar el 
// ángulo de la cámara 
void mouseDragged() {
// Controla la segunda cámara con el mouse
  anguloCamera += (mouseX-pmouseX) * velocidadRotacion; // Ajusta la velocidad de rotación según tus preferencias
}

// al soltar el mouse RESTEO la cámara
void mouseReleased() {
  cameraOn = false;
  anguloCamera = 0; 

}
