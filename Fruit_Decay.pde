int n; 
color[][] cellsNow, cellsNext;
int[][] turnDarkBrown; int[][] turnBlack; int[][] turnTeal;
int pad = 5; 
color yellow, brown, darkBrown, lightBrown, black, white, orange, teal, green;

//Changeable Variables
String fruit = "Banana"; //"Banana" or "Orange"
String temp = "Room"; //"Refrigerator" or "Room" temperature
boolean createDecay = false; //For orange only, type true if you want to be able to create new decay wherever you click

void setup(){
  size(1000,1000);
  
  yellow = color(255,255,0); white = color(255); lightBrown = color(160, 82, 45); brown = color(139,69,19); darkBrown = color(70,36,10); black = color(0); orange = color(255,128,0); teal = color(0,190,175); green = color(152,255,51);
 
  n = width/pad;
  
  cellsNow = new color [n][n];
  cellsNext = new color [n][n];
  
  turnBlack = new int [n][n];
  turnTeal = new int [n][n];
  turnDarkBrown = new int [n][n];
  
  //Checking weather to draw a Banana or Orange for first generation
  if ( fruit == "Banana" )
    makeBanana();
  else if ( fruit == "Orange" )
    makeOrange();
    
  frameRate( 1 );
  
  //Setting values for all cells to 0, so the second a cell turns dark brown (for Banana) or white (for orange), it counts the amount of generations it's been since the cell changed colour and if should turn darker brown/black (for banana) or teal (for orange) 
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      turnBlack[i][j] = 0;
  
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      turnTeal[i][j] = 0; 
  
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      turnDarkBrown[i][j] = 0;
}

void draw(){
  background(0);
  noStroke();
  
  for (int i = 0; i < n; i++){
    for (int j = 0; j < n; j++){
      
//Drawing and updating the banana       
      if ( fruit == "Banana" ){                                            
        if ( cellsNow[i][j] == yellow )
          fill(yellow);
        else if ( cellsNow[i][j] == brown ){
          if ( temp == "Refrigerator" ){
            if ( turnDarkBrown[i][j] >= 2 ){
              cellsNow[i][j] = darkBrown;
              fill(darkBrown);}
            else{
              fill(brown);
            }
       }
          if ( temp == "Room" ){
            if ( turnDarkBrown[i][j] >= 3 ){
              cellsNow[i][j] = darkBrown;
              fill(darkBrown);}
            else{
              fill(brown);}
       }  
          turnDarkBrown[i][j]++;
       }
         else if ( cellsNow[i][j] == darkBrown ){
          if ( temp == "Refrigerator" ){
            if ( turnBlack[i][j] >= 2 )
              fill(black);
            else{
              fill(darkBrown);
            }
       }
          if ( temp == "Room" ){
            if ( turnBlack[i][j] >= 3 )
              fill(black);
            else{
              fill(darkBrown);}
       }  
          turnBlack[i][j]+=1;
       }
        else if ( cellsNow[i][j] == lightBrown )
          fill(lightBrown);
        else{
          fill(white);}
     }
     
//Drawing and updating the ORANGE      
     else if ( fruit == "Orange" ){  
       if ( cellsNow[i][j] == orange )
         fill(orange);  
       else if ( cellsNow[i][j] == white ){
         if ( temp == "Refrigerator" ){
           if ( turnTeal[i][j] >= 3 )
             fill(teal);
           else{
             fill(white);}
         }
         else if ( temp == "Room" ){
           if ( turnTeal[i][j] >= 1 )
             fill(teal);
           else{
             fill(white);}
         }
         turnTeal[i][j] += 1;
       }
     else{
         fill(green);}
    }
   rect(i*pad, j*pad, pad, pad);
  }
  }
  setNextGen();
  copyCurrentGen();
}
  

void setNextGen(){
  int rottingNeighbours;
  
  for (int i = 0; i < n; i++){
    for (int j = 0; j < n; j++){
      
//BANANA
      if ( fruit == "Banana" ){
        if ( cellsNow[i][j] == yellow ){
          if ( temp == "Refrigerator" ){ //For refrigerator tempreture
            rottingNeighbours = countRottingNeighbours(i , j);
          if ( rottingNeighbours >= 2 )
            cellsNext[i][j] = brown;
          else if ( round(random(100)) < 2 ) //Can change the probability of a yellow cell randomly turning brown
            cellsNext[i][j] = brown;
          else{
            cellsNext[i][j] = yellow;
          }
         }
          if ( temp == "Room" ){ //For room tempreture
            rottingNeighbours = countRottingNeighbours(i , j);
          if ( rottingNeighbours >= 3 )
            cellsNext[i][j] = brown;
          else if ( round(random(100)) < 1 ) //Can change the probability of a yellow cell randomly turning brown
            cellsNext[i][j] = brown;
          else{
            cellsNext[i][j] = yellow;
          }
        }
      }

      else if ( cellsNow[i][j] == brown )
        cellsNext[i][j] = brown;
      else if ( cellsNow[i][j] == darkBrown )
        cellsNext[i][j] = darkBrown;
      else if ( cellsNow[i][j] == lightBrown )
        cellsNext[i][j] = lightBrown;
      else{
        cellsNext[i][j] = white;
      }
     }
     
//ORANGE     
    else if ( fruit == "Orange" ){
      if ( cellsNow[i][j] == orange ){
        rottingNeighbours = countRottingNeighbours( i , j );
        if ( rottingNeighbours >= 1 ){
          cellsNext[i][j] = white;
        }
        else{
          cellsNext[i][j] = orange;
        }
      }
      else if ( cellsNow[i][j] == white ){
        cellsNext[i][j] = white;
      }
      else if ( cellsNow[i][j] == green ){
        cellsNext[i][j] = green;
      }
     }
  }
  }
}


void copyCurrentGen() {
    for(int i=0; i<n; i++)
      for(int j=0; j<n; j++)
        cellsNow[i][j] = cellsNext[i][j];
}

int countRottingNeighbours(int i, int j){
    int count = 0;
    for(int a = -1; a <= 1; a++) { 
      for(int b = -1; b <= 1; b++){
        if ( fruit == "Banana" ){
          try {if (cellsNow[i+a][j+b] == brown || cellsNow[i+a][j+b] == darkBrown && !(a==0 && b==0))
            count++; }
          catch( IndexOutOfBoundsException e ) {}
      }
        else if ( fruit == "Orange" ){
          try {if (cellsNow[i+a][j+b] == white && !(a==0 && b==0))
            count++; }
          catch( IndexOutOfBoundsException e ) {}
          }
   }
   }
  return count;
}

void makeBanana(){
  
  for (int i = 0; i < n; i++){
    for (int j = 0; j < n; j++){
      if ( 40 < i && i < 160 ){
        if ( 60 < j && j < 100 ){
          if ( temp == "Refrigerator" ){
           if ( round(random(100)) < 2 )
            cellsNow[i][j] = brown;
           else{
            cellsNow[i][j] = yellow; 
            }
          }
          else if ( temp == "Room" ){
           if ( round(random(100)) < 1 )
            cellsNow[i][j] = brown;
           else{
            cellsNow[i][j] = yellow; 
            }
          }
        }
      }            
         
     else if ( 159 < i && i < 170 )
       if ( 75 < j && j < 85 )
         cellsNow[i][j] = lightBrown;
     
      else{
        cellsNow[i][j] = white;
        }
  }
  }
}

void makeOrange(){
   int x = round(random(65,135));
   int y = round(random(45,115));
   
   for (int i = 0; i < n; i++){
    for (int j = 0; j < n; j++){
      if ( 60 < i && i < 140 ){
        if ( 40 < j && j < 120 ){
          cellsNow[i][j] = orange;
          cellsNow[x][y] = white;
          cellsNow[x+1][y] = white;
          cellsNow[x][y+1] = white;
          cellsNow[x+1][y+1] = white; 
      }
     }
      else{
        cellsNow[i][j] = green;
        }
    }
   }
}

void mouseClicked(){
  int col, row;
  col = int(mouseX/pad);
  row = int(mouseY/pad);
  
  if ( fruit == "Orange" && createDecay == true){
    if ( cellsNow[col][row] == orange ){
          cellsNow[col][row] = white;
          cellsNow[col+1][row] = white;
          cellsNow[col][row+1] = white;
          cellsNow[col+1][row+1] = white;
          redraw();
        }
      }
  else{ }
}

//By: Huzaifah Muhammad
          
    
    
  
 

 
