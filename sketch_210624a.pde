String[][] tablero = {
  {"", "", ""},
  {"", "", ""},
  {"", "", ""}
};

String[] jugadores = {"X", "O"};
int turno;
int jugadorActual;
ArrayList<PVector> disponible = new ArrayList<PVector>();  
//inicia
void setup() {    
  size(400, 400);
  frameRate(30);  
  jugadorActual = floor(random(2));
  turno=0;
  for (int j = 0; j < 3; j++) {
    for (int i = 0; i < 3; i++) {
      disponible.add(new PVector(i, j));
    }
  }  
}  
  
//funcion para revisar tres strings iguales
boolean equals3(String a, String b, String c) {
  return (a == b && b == c && a != "");
}

//funcion que revisa si hay un ganador
String revisarGanador(String[][]tablero) {
  String ganador = null;

  // horizontal
  for (int i = 0; i < 3; i++) {
    if (equals3(tablero[i][0], tablero[i][1], tablero[i][2])) {
      ganador = tablero[i][0];
    }
  }

  // Vertical
  for (int i = 0; i < 3; i++) {
    if (equals3(tablero[0][i], tablero[1][i], tablero[2][i])) {
      ganador = tablero[0][i];
    }
  }

  // Diagonal
  if (equals3(tablero[0][0], tablero[1][1], tablero[2][2])) {
    ganador = tablero[0][0];
  }
  if (equals3(tablero[2][0], tablero[1][1], tablero[0][2])) {
    ganador = tablero[2][0];
  }
  
   int espaciosVacios = 0;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (tablero[i][j] == "") {
          espaciosVacios++;
        }
      }
    }
  if (ganador == null && espaciosVacios == 0) {
    return "empate";
  } else {
    return ganador;
  }
}

//funcion para detectar el mouse en un rectangulo
boolean pointRect(float px, float py, float rx, float ry, float rw, float rh) {

  // esta el punto del rectangulo
  if (px >= rx &&        // right of the left edge AND
    px <= rx + rw &&   // a la izquierda de la parte derecha ytablero
    py >= ry &&        // debajo de la parte mas alta y
    py <= ry + rh) {   // por encima de la parte baja
    return true;
  }
  return false;
}

//funcion para detectar el mejor movimiento a traves del minimax
void MejorMovimiento() {
  // juega la ia
  int mejorPuntuacion = Integer.MIN_VALUE;
  int movimientoi=0;
  int movimientoj=0;
  String[][] tablero2 = tablero;
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      // esta dfisponible?
      if (tablero2[i][j] == "") {
        tablero2[i][j] = jugadores[0];
        int puntuacion = minimax( tablero2,0, false);
        tablero2[i][j] = "";
        if (puntuacion > mejorPuntuacion) {
          mejorPuntuacion = puntuacion;
          movimientoi=i;
          movimientoj=j;
        }
      }
    }
  }
  
  //jugamos
  for(int i=0;i<disponible.size();i++){
        PVector punto = disponible.get(i);
        if((int) punto.x==movimientoi && (int) punto.y==movimientoj){
          juega(i);
          siguienteTurno();
        }
      }

}



//funcion minimax recursiva
int minimax(String [][]tablero2, int profundidad, boolean estaMaximizando) {
  String resultado = revisarGanador(tablero2);
  if (resultado != null) {
    if(resultado=="X"){
      return 1;
    }else if(resultado=="O"){
      return -1;
    }else if(resultado=="empate"){
      return 0;
    }
  }
//maximiza
  if (estaMaximizando) {
    int mejorPuntuacion = Integer.MIN_VALUE;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        // esta disponible?
        if (tablero2[i][j] == "") {
          tablero2[i][j] = jugadores[0];
          int puntuacion = minimax( tablero2,profundidad + 1, false);
          tablero2[i][j] = "";
          mejorPuntuacion = max(puntuacion, mejorPuntuacion);
        }
      }
    }
    return mejorPuntuacion;
  } else {//minimiza
    int mejorPuntuacion = Integer.MAX_VALUE;
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        // esta disponible?
        if (tablero2[i][j] == "") {
          tablero2[i][j] = jugadores[1];
          int puntuacion = minimax(tablero2,profundidad + 1, true);
          tablero2[i][j] = "";
          mejorPuntuacion = min(puntuacion, mejorPuntuacion);
        }
      }
    }
    return mejorPuntuacion;
  }
}

//funcion para jugar en el tablero
void juega(int index){
    PVector punto = disponible.get(index);
    disponible.remove(index);
    int i = (int) punto.x;
    int j = (int) punto.y;
    tablero[i][j] = jugadores[jugadorActual];
}
//funcion para pasar al siguiente turno
void siguienteTurno() {
  jugadorActual = (jugadorActual + 1) % jugadores.length;
  
}


void mousePressed() {
  if(turno==0){
    if(jugadorActual==0){
      println("inicia la ia da clic para que ella inicie");
      turno++;
    }else{
      println("inicias tu da clic en una casilla para iniciar");
      turno++;
    }
  }else{
    if(jugadorActual==1){
      
      int px=mouseX;
      int py=mouseY;
      float w = width / 3;
      float h = height / 3;
      boolean estaesqizq= pointRect(px, py, 0, 0, w, h);
      boolean estaarribamedio=pointRect(px, py, h, 0, w, h);
      boolean estaarribaderecha=pointRect(px, py, h*2, 0, w, h);
      boolean estamedioizq = pointRect(px, py, 0, h, w, h);
      boolean estamedio = pointRect(px, py, w, h, w, h);
      boolean estamedioderecha = pointRect(px, py, w*2, h, w, h);
      boolean estaabajoizq = pointRect(px, py, 0, h*2, w, h);
      boolean estaabajoderecha = pointRect(px, py, w*2, h*2, w, h);
      boolean estaabajomedia = pointRect(px, py, w, h*2, w, h);
     
      if(estaesqizq){
        
        boolean yaJugado=true;
        
        for(int i=0;i<disponible.size();i++){
          PVector punto = disponible.get(i);
          if((int) punto.x==0 && (int) punto.y==0){
            juega(i);
            siguienteTurno();
            yaJugado=false;
            println("ya jugaste da clic para que juegue la ia");
          }
        }
        if(yaJugado){
          println("ya jugado");
        }
      }else if(estaarribamedio){
        boolean yaJugado=true;
        
        for(int i=0;i<disponible.size();i++){
          PVector punto = disponible.get(i);
          if((int) punto.x==1 && (int) punto.y==0){
            juega(i);
            siguienteTurno();
            yaJugado=false;
            println("ya jugaste da clic para que juegue la ia");
          }
        }
        if(yaJugado){
          println("ya jugado");
        }
      }else if(estaarribaderecha){
        boolean yaJugado=true;
        
        for(int i=0;i<disponible.size();i++){
          PVector punto = disponible.get(i);
          if((int) punto.x==2 && (int) punto.y==0){
            juega(i);
            siguienteTurno();
            yaJugado=false;
            println("ya jugaste da clic para que juegue la ia");
          }
        }
        if(yaJugado){
          println("ya jugado");
        }
      }else if(estamedioizq){
        
        boolean yaJugado=true;
        for(int i=0;i<disponible.size();i++){
          PVector punto = disponible.get(i);
          if((int) punto.x==0 && (int) punto.y==1){
            juega(i);
            siguienteTurno();
            yaJugado=false;
            println("ya jugaste da clic para que juegue la ia");
          }
        }
        if(yaJugado){
          println("ya jugado");
        }
      }else if(estamedio){
        boolean yaJugado=true;
        
        for(int i=0;i<disponible.size();i++){
          PVector punto = disponible.get(i);
          if((int) punto.x==1 && (int) punto.y==1){
            juega(i);
            siguienteTurno();
            yaJugado=false;
            println("ya jugaste da clic para que juegue la ia");
          }
        }
        if(yaJugado){
          println("ya jugado");
        }
      }else if(estamedioderecha){
        boolean yaJugado=true;
        
        for(int i=0;i<disponible.size();i++){
          PVector punto = disponible.get(i);
          if((int) punto.x==2 && (int) punto.y==1){
            juega(i);
            siguienteTurno();
            yaJugado=false;
            println("ya jugaste da clic para que juegue la ia");
          }
        }
        if(yaJugado){
          println("ya jugado");
        }
      }else if(estaabajoizq){
        boolean yaJugado=true;
        
        for(int i=0;i<disponible.size();i++){
          PVector punto = disponible.get(i);
          if((int) punto.x==0 && (int) punto.y==2){
            juega(i);
            siguienteTurno();
            yaJugado=false;
            println("ya jugaste da clic para que juegue la ia");
          }
        }
        if(yaJugado){
          println("ya jugado");
        }
      }else if(estaabajoderecha){
        boolean yaJugado=true;
        
        for(int i=0;i<disponible.size();i++){
          PVector punto = disponible.get(i);
          if((int) punto.x==2 && (int) punto.y==2){
            juega(i);
            siguienteTurno();
            yaJugado=false;
            println("ya jugaste da clic para que juegue la ia");
          }
        }
        if(yaJugado){
          println("ya jugado");
        }
      }else if(estaabajomedia){
        boolean yaJugado=true;
        
        for(int i=0;i<disponible.size();i++){
          PVector punto = disponible.get(i);
          if((int) punto.x==1 && (int) punto.y==2){
            juega(i);
            siguienteTurno();
            yaJugado=false;
            println("ya jugaste da clic para que juegue la ia");
          }
        }
        if(yaJugado){
          println("ya jugado");
        }
      }
      
    }else{
      
      if(jugadorActual==0){
        MejorMovimiento();
      }
      println("la ia jugó, tu turno");
    }
  }
}

void draw() {
  background(255);
  float w = width / 3;
  float h = height / 3;
  strokeWeight(4);

  line(w, 0, w, height);
  line(w * 2, 0, w * 2, height);
  line(0, h, width, h);
  line(0, h * 2, width, h * 2);
  
  for (int j = 0; j < 3; j++) {
    for (int i = 0; i < 3; i++) {
      float x = w * i + w / 2;
      float y = h * j + h / 2;
      String punto = tablero[i][j];
      textSize(32);
      if (punto == jugadores[1]) {
        noFill();
        ellipse(x, y, w / 2, w / 2);
      } else if (punto == jugadores[0]) {
        float xr = w / 4;
        line(x - xr, y - xr, x + xr, y + xr);
        line(x + xr, y - xr, x - xr, y + xr);
      }
    }
  }

  String resultado = revisarGanador(tablero);
  if (resultado != null) {
    noLoop();
    if (resultado == "empate") {
      println("empate!");
    } else {
      println(resultado + " gana!");
    }
  } else {
    
  }
}
