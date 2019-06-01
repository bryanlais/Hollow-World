import java.util.*;

Screen scr;
Player p;
Slime s, s2;
Baby d, d2;
Minotaur min, min2;
Boar b, b2;
Spirit sp, sp2;
Griffin g, g2;
Dragon dr, dr2;
HUD h;
boolean running = true;
ArrayList<OverworldObject> roomObjects = new ArrayList<OverworldObject>();
ArrayList<OverworldObject> collideableRoomObjects = new ArrayList<OverworldObject>();
String[] objects, spriteNames, hudNames, assetNames, playerNames, screenNames;
ArrayList<Monster> m = new ArrayList<Monster>();
ArrayList<PImage> sprite = new ArrayList<PImage>();
ArrayList<PImage> assets = new ArrayList<PImage>();
ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
ArrayList<PImage> hud = new ArrayList<PImage>();
ArrayList<PImage> screenImages = new ArrayList<PImage>();
ArrayList<Screen> screens = new ArrayList<Screen>();
int iT = 60;

void setup() {
  size(1440,810);
  spriteNames = loadStrings("data/SpriteNames.txt");
  for (String str : spriteNames) {
     sprite.add(loadImage("data/sprites/" + str + ".png"));
  }
  hudNames = loadStrings("data/hudNames.txt");
  for (String str : hudNames) {
     hud.add(loadImage("data/hud/" + str + ".png"));
  }
  screenNames = loadStrings("data/screenNames.txt");
  for (String str : screenNames) {
     screenImages.add(loadImage("data/screens/" + str + ".png"));
  }
  scr = new Screen(width/2 - 190, height - 115, width/2, 75, 75, "title");
  screens.add(scr);
  s = new Slime(width/2, height/2, 50, 50, 1, 200.0, 4, 4, 120, iT, .5, false);
  s2 = new Slime(200, 600, 50, 50, 1, 200.0, 1, 4, 120, iT, .5, true);
  d = new Baby(500, 800, 90, 90, 1.5, 300.0, 3, 10, 120, iT, 1, false);
  d2 = new Baby(500, 200, 90, 90, 1.5, 300.0, 3, 10, 120, iT, 1, true);
  min = new Minotaur(300, 600, 150, 150, 1.5, 400.0, 5, 4, 120, iT, .5, false, 150);
  min2 = new Minotaur(300, 600, 150, 150, 1.5, 400.0, 5, 4, 120, iT, .5, true, 150);
  b = new Boar(200, 600, 50, 50, 2, 300.0, 1, 8, 120, iT, .5, false);
  b2 = new Boar(200, 600, 50, 50, 2, 300.0, 1, 8, 120, iT, .5, true);
  sp = new Spirit(600, 200, 100, 100, 1.5, 300.0, 3, 10, 120, iT, 1, false);
  sp2 = new Spirit(600, 200, 100, 100, 1.5, 300.0, 3, 10, 120, iT, 1, true);
  g = new Griffin(300, 600, 150, 150, 1.5, 400.0, 5, 10, 120, iT, .5, false, 150);
  g2 = new Griffin(300, 600, 150, 150, 1.5, 400.0, 5, 10, 120, iT, .5, true, 150);
  dr = new Dragon(500, 200, 100, 100, 1.5, 300.0, 3, 10, 120, iT, 1, false);
  dr2 = new Dragon(500, 200, 100, 100, 1.5, 300.0, 3, 10, 120, iT, 1, true);
  m.add(s);
  m.add(s2);
  m.add(d);
  m.add(d2);
  m.add(min);
  m.add(min2);
  m.add(b);
  m.add(b2);
  m.add(sp);
  m.add(sp2);
  m.add(g);
  m.add(g2);
  m.add(dr);
  m.add(dr2);

  //Player assets:
  playerNames = loadStrings("data/player_sprites.txt");
  for (String s : playerNames) {
    assets.add(loadImage("data/room_player_assets/" + s + ".png"));
  }
  //4 stands for # of sprites for each PHASE. Not the number of sprites in total. The value changes in differnet cases.
  p = new Player(50,50,width/2 + 100,height/2 + 100,iT,4,assets);
  
  //Room assets:
  objects = loadStrings("data/rooms.txt");
  for(int i = 0; i < objects.length; i++) {
    //If the line/string does not contain Room...
    if(!objects[i].contains("Room")) {
      String[] params = objects[i].split(" ");
      //print(Arrays.toString(params)) Using these parameters, add to room sprites.
      for(int copies = 0; copies < Float.valueOf(params[5]); copies++) {
        for(int yCopies = 0; yCopies < Float.valueOf(params[6]); yCopies++) {
          roomObjects.add(new OverworldObject(Float.valueOf(params[1]) + copies * Float.valueOf(params[3]), Float.valueOf(params[2]) + yCopies * Float.valueOf(params[4]) , Float.valueOf(params[3]), Float.valueOf(params[4]), loadImage("data/room_player_assets/" + params[0] + ".png"), Boolean.valueOf(params[7])));
          if(Boolean.valueOf(params[7])) {
            collideableRoomObjects.add(new OverworldObject(Float.valueOf(params[1]) + copies * Float.valueOf(params[3]), Float.valueOf(params[2]) + yCopies * Float.valueOf(params[4]) , Float.valueOf(params[3]), Float.valueOf(params[4]), loadImage("data/room_player_assets/" + params[0] + ".png"), Boolean.valueOf(params[7])));
          }
        }
      }
    }
  }
}


void draw() {
    h = new HUD(p.m_health, 20, 20, 50);
    //Room assets:
    if (screens.size() > 0) screens.get(0).display();
    else if(running){
      background(51);
      fill(0, 102, 153);
      for (OverworldObject o : roomObjects) {
        o.display();
      }
      for (int mons = m.size() - 1; mons >= 0; mons--) {
        m.get(mons).update(p);
        m.get(mons).move(m.get(mons).currentDirection);
        m.get(mons).display();
        for (int i = m.size() - 1; i >= 0; i--) {
          if (m.get(i).cHealth <= 0 && m.get(i).getDeathTimer() == 0) m.remove(i);
        }
      }
      for (int i = projectiles.size() - 1; i >= 0; i--) {
        projectiles.get(i).move();
        projectiles.get(i).display();
        projectiles.get(i).update(p);
      }
      p.update(h);
      p.move();
      p.display();
      h.update(p.c_health);
      h.display();
    }
    else {
      clear();
    }
}

//Clears everything on the screen when reaching gameOver.
void clear() {
  if(p.c_health <= 0) screens.add(new Screen(width/2, height/2, width/2, 50, 50, "gameover"));
}

void keyPressed() {
  if (screens.size() > 0) screens.get(0).select();
  else if(running) p.setMove(keyCode, true, m);
}

void keyReleased() {
  p.setMove(keyCode, false, m);
}
