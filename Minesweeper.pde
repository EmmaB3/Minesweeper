

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined
int rows, columns,bombsNum;
void setup ()
{
    rows = 16;
    columns = 16;
    bombsNum = 50;
    size(400, 400);
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
    setBombs();
}
public void setBombs()
{
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
    //your code here
    return false;
}
public void displayLosingMessage()
{
  println("die");
    //your code here
}
public void displayWinningMessage()
{
    //your code here
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
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
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void leftMousePressed(){
      clicked = true;
          if(bombs.contains(buttons[r][c])){
            displayLosingMessage();
          }else if(countBombs(r,c) != 0){
            setLabel("" + countBombs(r,c));
          }else{
            if(isValid(r - 1, c - 1)) buttons[r - 1][c - 1].leftMousePressed();
            if(isValid(r - 1, c)) buttons[r - 1][c].leftMousePressed();
            if(isValid(r - 1, c + 1)) buttons[r - 1][c + 1].leftMousePressed();
            if(isValid(r, c - 1)) buttons[r ][c - 1].leftMousePressed();
            if(isValid(r, c + 1)) buttons[r ][c + 1].leftMousePressed();
            if(isValid(r + 1, c - 1)) buttons[r + 1][c - 1].leftMousePressed();
            if(isValid(r + 1, c)) buttons[r + 1][c].leftMousePressed();
            if(isValid(r + 1, c + 1)) buttons[r + 1][c + 1].leftMousePressed();
            /*for(int a = -1; a <= 1; a++){
              for(int b = -1; b <= 1; b++){
                if(!(a==0 && b == 0) && isValid(r + a, c + b)){
                  println(a + " " + b);
                  buttons[r + a][c + b].leftMousePressed();
                }
              }
            }*/
          }
    }
    
    public void mousePressed () 
    {
        if(mouseButton == LEFT){
         /* clicked = true;
          if(bombs.contains(buttons[r][c])){
            displayLosingMessage();
          }else if(countBombs(r,c) != 0){
            setLabel("" + countBombs(r,c));
          }else{
            for(int a = -1; a <= 1; a++){
              for(int b = -1; b <= 1; b++){
                if(!(a==0 && b == 0) && isValid(r + a, c + b) && countBombs(r + a, c + b) == 0){
                  buttons[r + a][c + b].mousePressed();
                }
              }
            }
          }*/
          leftMousePressed();
        }else if(mouseButton == RIGHT){
          marked = true;
        }
        
        //your code here
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
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
            if(!(a==0 && b == 0)){
              numBombs += bombs.contains(buttons[row + a][col + b])? 1 : 0;
            }
          }
        }
        return numBombs;
    }
}
