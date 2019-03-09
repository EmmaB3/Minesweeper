

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
int rows, columns,bombsNum,markedBombs,currentPage,bombsMarkerY;
/*enum Page{
  START, GAME
}
enum BombAmt{
  SMALL, MED, LARGE
}
Page currentPage;
BombAmt bombAmt;*/
float bombsPercent;
boolean isLost;
void setup ()
{
  isLost = false;
  bombsMarkerY = 155;
    currentPage = 0;
    bombsPercent = 0.1;
    rows = 20;
    columns = 20;
    bombsNum = 50;
    markedBombs = 0;
    size(400, 420);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[rows][columns];
    for(int a = 0; a < rows; a++){
        for(int b= 0; b < columns; b++){
            buttons[a][b] = new MSButton(a,b);
        }
    }
    bombs = new ArrayList<MSButton>();
}
public void setBombs()
{
  bombsNum = (int)(bombsPercent * 400);
    while(bombs.size() < bombsNum){
        int row = (int)(Math.random()*rows);
        int column = (int)(Math.random()*columns);
        if(!bombs.contains(buttons[row][column])){
            bombs.add(buttons[row][column]);
        }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    for(MSButton[] arr : buttons){
      for(MSButton button : arr){
        if(!bombs.contains(button) && !(button.isClicked())){
          return false;
        }
      }
    }
    return true;
}

public void displayLosingMessage()
{
    isLost= true;
    buttons[12][8].setShowingMessage(true);
    buttons[12][9].setShowingMessage(true);
    buttons[12][10].setShowingMessage(true);
    buttons[12][11].setShowingMessage(true);
    buttons[13][7].setShowingMessage(true);
    buttons[13][12].setShowingMessage(true);
    buttons[14][13].setShowingMessage(true);
    buttons[14][6].setShowingMessage(true);
    buttons[8][7].setShowingMessage(true);
    buttons[8][6].setShowingMessage(true);
    buttons[8][12].setShowingMessage(true);
    buttons[8][13].setShowingMessage(true);
    buttons[9][14].setShowingMessage(true);
    buttons[9][5].setShowingMessage(true);
    //your code here
}
public void displayWinningMessage()
{
    buttons[14][8].setShowingMessage(true);
    buttons[14][9].setShowingMessage(true);
    buttons[14][10].setShowingMessage(true);
    buttons[14][11].setShowingMessage(true);
    buttons[13][7].setShowingMessage(true);
    buttons[13][12].setShowingMessage(true);
    buttons[12][13].setShowingMessage(true);
    buttons[12][6].setShowingMessage(true);
    buttons[9][7].setShowingMessage(true);
    buttons[9][6].setShowingMessage(true);
    buttons[9][12].setShowingMessage(true);
    buttons[9][13].setShowingMessage(true);
    buttons[8][14].setShowingMessage(true);
    buttons[8][5].setShowingMessage(true);
    //your code here
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked, showingMessage;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/columns;
        height = 400/rows;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public void setShowingMessage(boolean b){
      showingMessage = b;
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        switch(currentPage){
          case 0:
            if(mouseX >= 100 && mouseX <= 300 && mouseY >= 250 && mouseY <= 350){
              setBombs();
              currentPage = 1;
            }else if(mouseY > 120 && mouseY < 140){
              bombsMarkerY = 125;
              bombsPercent = 0.05;
            }else if(mouseY > 140 && mouseY < 170){
                  bombsMarkerY = 155;
                  bombsPercent = .1;
            }else if(mouseY > 170 && mouseY < 200){
              bombsMarkerY = 185;
             bombsPercent = .15;
            }
          break;
          case 1:
          if(!isLost){
          if(mouseButton == RIGHT){
            if(!isMarked() && !isClicked()){
              marked = true;
              markedBombs ++;
            }else{
              marked = false;
              markedBombs--;
            }
        }else{
          clicked = true;
          if(bombs.contains(buttons[r][c])){
            displayLosingMessage();
          }else if(countBombs(r,c) != 0){
            setLabel("" + countBombs(r,c));
          }else{
            for(int a = -1; a < 2; a++){
              for(int b = -1; b < 2; b++){
                if(isValid(r + a, c + b) && !buttons[r+a][c+b].isClicked()){
                  buttons[r + a][c + b].mousePressed();
                }
              }
            }
          }
        }
          }
          break;
        }
        //your code here
    }

    public void draw () 
    {    
      switch(currentPage){
        case 0:
          fill(255);
          textAlign(CENTER);
          textSize(20);
          text("Mode", 200,100);
          textSize(15);
          text("Easy", 200, 130);
          text("Medium", 200, 160);
          text("Hard", 200, 190);
          ellipse(150, bombsMarkerY, 10,10);
          rectMode(CENTER);
          rect(200, 300, 200, 50);
          fill(0);
          textSize(45);
          text("Start",200,315);
         break;
        case 1:
          if (showingMessage)
            fill(255, 246, 89);
          else if (marked)
              fill(0);
          else if( (clicked || isLost) && bombs.contains(this) ) 
               fill(255,0,0);
          else if(clicked)
              fill( 200 );
          else 
              fill( 100 );
          textAlign(CENTER,CENTER);
          rectMode(CORNER);
          textSize(15);
          rect(x, y, width, height);
          fill(0);
          text(label,x+width/2,y+height/2);
          fill(255);
          textSize(10);
          text("Bombs Left: " + (bombsNum - markedBombs), 100, 410);
          break;
      }
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        return r < rows && r >= 0 && c < columns && c >= 0;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        for(int a = -1; a <= 1; a++){
          for(int b = -1; b <= 1; b++){
            if(!(a==0 && b == 0) && isValid(row + a, col + b)){
              numBombs += bombs.contains(buttons[row + a][col + b])? 1 : 0;
            }
          }
        }
        return numBombs;
    }
}
