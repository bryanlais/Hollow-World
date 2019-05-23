import java.util.*;

Player p;
Slime s, s2;
Piranha_Plant d;
String[] spriteNames;
String[] playerNames;
ArrayList<OverworldObject> roomSprites = new ArrayList<OverworldObject>();
ArrayList<Monster> m = new ArrayList<Monster>();
ArrayList<PImage> sprite = new ArrayList<PImage>();
ArrayList<PImage> assets = new ArrayList<PImage>();
ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
int iT = 60;
void setup() {
  size(1000,1000);
  spriteNames = loadStrings("data/SpriteNames.txt");
  for (String str : spriteNames) {
     sprite.add(loadImage("data/sprites/" + str + ".png"));
  }
  d = new Piranha_Plant(500, 800, 100, 100, 1.5, 300.0, 3, 10, 120, iT, 1, false);
  s = new Slime(width/2, height/2, 50, 50, 1, 200.0, 1, 4, 120, iT, .5, false);
  s2 = new Slime(200, 600, 50, 50, 1, 200.0, 1, 4, 120, iT, .5, false);
  m.add(s);
  s.cHealth = 3;
  m.add(s2);
  m.add(d);
  //m.add(s2);
  
  //Player assets:
  playerNames = loadStrings("player_assets/player_sprites.txt");
  for (String s : playerNames) {
    assets.add(loadImage("player_assets/" + s + ".png"));
  }
  //4 stands for # of sprites for each PHASE. Not the number of sprites in total. The value changes in differnet cases.
  p = new Player(40,40,300,300,iT,4,assets);
  
  //Room assets:
}

void draw() {
  background(255);
  textSize(32);
  text(p.x_pos + " " + p.y_pos, 50, 50);
  text(p.c_health + "", 50, 50);
  text(projectiles.toString(), 100, 100);
  fill(0, 102, 153);
  for (Monster mons : m) {
    mons.update(p);
    mons.move(mons.currentDirection);
    mons.display();
    text("Monster health: " + mons.cHealth, 500, 50);
  }
  for (int i = projectiles.size() - 1; i >= 0; i--) {
    projectiles.get(i).move();
    projectiles.get(i).display();
    projectiles.get(i).update();
  }
  //if(p.isTouching(s)) System.out.print("hi");
  //System.out.print(p.x_pos + ",");
  //System.out.print(p.y_pos);
  //System.out.print(" " + s.x_pos + ",");
  //System.out.print(s.y_pos);
  p.update();
  p.display();
  p.move();
}

void keyPressed() {
  p.setMove(keyCode, true, m);
}

void keyReleased() {
  p.setMove(keyCode, false, m);
}
