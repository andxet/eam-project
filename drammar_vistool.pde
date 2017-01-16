// DRAWING CHARACTERS' INTENTIONS IN A STORY: THE ACTION MAP

// Interactive visualization tool for storyflow visualization in terms of characters' intentions in a story flow: 
// 1. fixed screen size to 1024 x 576
// 2. represent characters' intentions with colored arcs
// 3. characters' participation to story motivations aligned with story incidents and scenes

import processing.video.*;

Movie inc02; // STUDENT


// ZOOM DATA
float xo;
float yo;
float zoom = 1;
float angle = 0;

// GENERAL VISUALIZATION DATA
int size_x=1024; // size of the drawing screen 
int size_y=576; 
int header_width_L = size_x; // main header width 
int header_height_L = 30; // main header height
int header_width_S = size_x; // secondary header width 
int header_height_S = 16; // secondary header height
int stroke_header = 3;

int min_track_headers_width = 30; // width of track header 
int min_track_headers_height = 5; // height of track header 
int min_track_headers_radius = 3; // radius of track header 

float track_header_left_x = 0; float track_header_right_x = size_x/20; 
float track_header_top_y = header_height_L; float track_header_bottom_y = size_y; 
float track_header_width = track_header_right_x - track_header_left_x; 
float track_header_height = track_header_bottom_y - track_header_top_y;

float display_left_x = track_header_right_x; float display_right_x = size_x;
float display_top_y = header_height_L; float display_bottom_y = size_y; 
float display_width = display_right_x - display_left_x; 
float display_height = display_bottom_y - display_top_y;

float scenes_left_x = track_header_right_x; float scenes_right_x = size_x; 
float scenes_width = scenes_right_x - scenes_left_x; 
float scenes_height = (track_header_height/10)*3;  // scenes are 3/10 of visualization;
float scenes_top_y = track_header_top_y; float scenes_bottom_y = scenes_top_y + scenes_height;  
float scenes_layer_height = scenes_height / 8; // play, act, scenes
float acts_layer_height = scenes_height / 4; // play, act, scenes
float play_layer_height = scenes_height / 2; // play, act, scenes

float timeline_left_x = track_header_right_x; float timeline_right_x = size_x; 
float timeline_width = timeline_right_x - timeline_left_x; 
float timeline_height = track_header_height/10;  // timeline is 1/10 of visualization;
float timeline_top_y = scenes_bottom_y; float timeline_bottom_y = timeline_top_y + timeline_height; 
float timeline_margin = 3; 

float plans_left_x = track_header_right_x; float plans_right_x = size_x; 
float plans_width = plans_right_x - plans_left_x; 
float plans_height = (track_header_height/10)*6;  // plans are 6/10 of visualization;
float plans_top_y = timeline_bottom_y; float plans_bottom_y = plans_top_y + plans_height; 

float mutes_left_x = track_header_right_x; float mutes_right_x = size_x; 
float mutes_width = mutes_right_x - mutes_left_x; 
float mutes_height = track_header_height/20;  // plans are 6/10 of visualization;
float mutes_bottom_y = size_y; float mutes_top_y = mutes_bottom_y-mutes_height; 

// CONSTANTS
// ELEMENTS OF VISUALIZATION 
float min_side = 8.0; // 6 pixels is the min linear side of a story incident (square of some side)
float min_hdistance = 4.0; // 3 pixels is the min horizontal distance between adjacent story incidents
float side_hdistance_ratio = min_hdistance/min_side; 
float incident_side; // actual side of a story incident
float incident_hdistance; // actual distance of a story incident

int v_height = 20; // height of a story incident
int v_width = 20; // height of a story incident
// int h_height = 20; // height of a story incident

int min_plans_height = 20; // min height of char layer; actual height to be determined
int min_incr_plan_height = 10; // for each plan layer in a hierarchy
int min_scene_layer_height = 30; // height of scene layer

int inner_radius = 5;
float offset_angle = PI/4;

int max_text_length = 0;
float tooltipbox_width_factor = 0.4;

/*
int sequence_size_x = 0;  int sequence_size_y = 0; // initialize x and y sizes of the sequence (to be computed)
int hierarchies_size_x = 0; int hierarchies_size_y = 0; // initialize x and y sizes of the hierarchies (to be computed)
*/

// DATA ELEMENTS
ArrayList hierarchy_clusters; // set of hierarchy clusters
ArrayList hierarchy_clusters_in_display; // set of hierarchy clusters that are currently displayed
ArrayList mute_clusters; // clusters (agents) that are mute

ArrayList sequence; // sequence of terminals (SEQEL)
ArrayList terminals_in_sequence; // set of terminal elements in sequence
ArrayList hierels; // set of hierarchy elements (plans)
ArrayList scenes; // set of scenes 
ArrayList acts; // set of scenes 
ArrayList plays; // set of scenes 

ArrayList terminals_in_hierarchies; // set of terminal elements in hierarchies
ArrayList nonterminal_daughters; // set of daughters, which are NON terminals
ArrayList nonterminals_in_sequence; // set of NON terminal elements in sequence
ArrayList nonterminals_in_hierarchies; // set of NON terminal elements in sequence

ArrayList tooltip_boxes; // all the boxes that have tooltips
ArrayList mute_boxes; // all the mute boxes in the track headers
ArrayList unmute_boxes; // all the mute boxes in the mute clusters, to be unmuted

// AUXILIARY CONSTANTS AND VARIABLES
int max_rec_level = 100;



void setup() {  
    inc02 = new Movie(this, "inc02.mp4"); // STUDENT


  // frameRate(25);
  smooth();
  noStroke();

  // preparatory instructions, initializations
  sequence = new ArrayList(); 
  terminals_in_sequence = new ArrayList();  
  hierarchy_clusters = new ArrayList();
  hierarchy_clusters_in_display = new ArrayList();
  mute_clusters = new ArrayList(); // clusters (agents) that are mute

  hierels = new ArrayList();
  scenes = new ArrayList();
  acts = new ArrayList();
  plays = new ArrayList();
  terminals_in_hierarchies = new ArrayList();  
  nonterminal_daughters = new ArrayList();
  nonterminals_in_sequence = new ArrayList(); 
  nonterminals_in_hierarchies = new ArrayList(); 

  tooltip_boxes = new ArrayList();
  mute_boxes = new ArrayList();
  unmute_boxes = new ArrayList();
  // LOADING 
  XML xml_repository = loadXML("drama_test.xml"); // load the XML file    
  loading_drama_repository1(xml_repository); // loading repository elements from XML file
  XML xml_drama = loadXML("drama_test.xml"); // load the XML file    
  println("Drama file LOADED ... \n");
  loading_drama(xml_drama); // loading plans, timelines, and mapping from XML file
  // what agents are in display on the tracks
  for (int i=0; i < hierarchy_clusters.size(); i++) {
    HCluster hc = (HCluster) hierarchy_clusters.get(i);
    println(i + " Agent " + hc.id + " of " + hierarchy_clusters.size() + " agents "); 
    hierarchy_clusters_in_display.add(hc); // display agent's track
    // if (hc.plans.size() != 0) {hierarchy_clusters_in_display.add(hc);} // if this agent has plans, then display its track
  }; 
  println(" Display for " + hierarchy_clusters_in_display.size() + " agents "); 
  // SETTING COLORS OF AGENTS
  colorMode(HSB, 360, 100, 100);   
  float next_hue = 0;
  if (hierarchy_clusters.size() > 0) {
    for (int i=0; i < hierarchy_clusters.size(); i++) {
      HCluster hc = (HCluster) hierarchy_clusters.get(i);
      if (hc.plans.size() > 0) {
        // hc.c = color((i*23)%360, 40, 100); 
        hc.c = color(next_hue, 100, 75);  
        next_hue = (next_hue+(360/hierarchy_clusters.size())+19)%360;
      }
    }
  }; 
  // compute the positions of each element in the sequence 
  create_sequence_nodes();

  size(1024, 576); 
  background(#FFFFFF);

  Play p = (Play) plays.get(0); // retrieve the play
  draw_header_L(0, 0, header_width_L, header_height_L,  color(0,0,100), color(0,0,0), p.print + ": Action map");

  draw_track_headers(); 
  
  draw_sequence();

  drawGrid();

  draw_plans();

  draw_scenes();
  
  draw_acts();

  draw_play();
  
  assign_agents_to_scenes(); 
  
  draw_agents_in_scenes();
  
  save("Drammar_test_visual.png");

}

// ********************************** END SETUP **** START DRAW **************************************

void draw() {
  System.gc();

  inc02.read(); // STUDENT 
  
  scale (zoom);
  translate (xo, yo);

  background(#FFFFFF); // set background to white
  
  update_spaces(); 
  
  Play p = (Play) plays.get(0); // retrieve the play
  draw_header_L(0, 0, header_width_L, header_height_L,  color(0,0,100), color(0,0,0), p.print + ": Action map");

  draw_track_headers(); 
  
  draw_sequence();

  drawGrid();

  draw_plans();

  draw_scenes();
  
  draw_acts();

  draw_play();
  
  draw_mute_clusters();
  
  assign_agents_to_scenes(); 
  
  draw_agents_in_scenes();

  layover();

} // END DRAW function


// ********************************** ******************************* **************************************
// ********************************** END DRAW **** START SUBROUTINES **************************************
// ********************************** ******************************* **************************************


// ********************************** AUXILIARY FUNCTIONS **************************************



// collect the agents who are active in the scenes 
void assign_agents_to_scenes() {
  // for each scene, search the plans within the same span and assign the corresponding agents
  for (int i=0; i < scenes.size(); i++) {
    Scene s = (Scene) scenes.get(i); // retrieve a scene
    for (int j=0; j < hierels.size(); j++) {
      Hierel he = (Hierel) hierels.get(j); // search the plans 
      if (he.hierel_mt.d_nt!=null) {
        if (contains(he.hierel_mt.d_nt.x_coord, he.hierel_mt.d_nt.x_coord + he.hierel_mt.d_nt.h_width, s.scene_mt.d_nt.x_coord, s.scene_mt.d_nt.x_coord+s.scene_mt.d_nt.h_width) || 
            contained(he.hierel_mt.d_nt.x_coord, he.hierel_mt.d_nt.x_coord + he.hierel_mt.d_nt.h_width, s.scene_mt.d_nt.x_coord, s.scene_mt.d_nt.x_coord+s.scene_mt.d_nt.h_width) ||
            overlap(he.hierel_mt.d_nt.x_coord, he.hierel_mt.d_nt.x_coord + he.hierel_mt.d_nt.h_width, s.scene_mt.d_nt.x_coord, s.scene_mt.d_nt.x_coord+s.scene_mt.d_nt.h_width)) {
          if (searchALindex_item (s.agents, he.hcluster, "STR")==-1) {
            s.agents.add(he.hcluster); // in case the coordinates are coincident, include the agent in the scene
          }}} // END 3 IF's
    } // END FOR EACH PLAN
  } // END FOR EACH SCENE
  for (int i=0; i < acts.size(); i++) {
    Act a = (Act) acts.get(i); // retrieve an act
    for (int j=0; j < hierels.size(); j++) {
      Hierel he = (Hierel) hierels.get(j); // search the plans 
      if (he.hierel_mt.d_nt!=null) {
        if (contains(he.hierel_mt.d_nt.x_coord, he.hierel_mt.d_nt.x_coord + he.hierel_mt.d_nt.h_width, a.act_mt.d_nt.x_coord, a.act_mt.d_nt.x_coord+a.act_mt.d_nt.h_width) || 
            contained(he.hierel_mt.d_nt.x_coord, he.hierel_mt.d_nt.x_coord + he.hierel_mt.d_nt.h_width, a.act_mt.d_nt.x_coord, a.act_mt.d_nt.x_coord+a.act_mt.d_nt.h_width) ||
            overlap(he.hierel_mt.d_nt.x_coord, he.hierel_mt.d_nt.x_coord + he.hierel_mt.d_nt.h_width, a.act_mt.d_nt.x_coord, a.act_mt.d_nt.x_coord+a.act_mt.d_nt.h_width)) {
          if (searchALindex_item (a.agents, he.hcluster, "STR")==-1) {
            a.agents.add(he.hcluster); // in case the coordinates are coincident, include the agent in the scene
          }}} // END 3 IF's
    } // END FOR EACH PLAN
  } // END FOR EACH ACT
  for (int i=0; i < plays.size(); i++) {
    Play p = (Play) plays.get(i); // retrieve the play
    for (int j=0; j < hierels.size(); j++) {
      Hierel he = (Hierel) hierels.get(j); // search the plans 
      if (he.hierel_mt.d_nt!=null) {
        if (contains(he.hierel_mt.d_nt.x_coord, he.hierel_mt.d_nt.x_coord + he.hierel_mt.d_nt.h_width, p.play_mt.d_nt.x_coord, p.play_mt.d_nt.x_coord+p.play_mt.d_nt.h_width) || 
            contained(he.hierel_mt.d_nt.x_coord, he.hierel_mt.d_nt.x_coord + he.hierel_mt.d_nt.h_width, p.play_mt.d_nt.x_coord, p.play_mt.d_nt.x_coord+p.play_mt.d_nt.h_width) ||
            overlap(he.hierel_mt.d_nt.x_coord, he.hierel_mt.d_nt.x_coord + he.hierel_mt.d_nt.h_width, p.play_mt.d_nt.x_coord, p.play_mt.d_nt.x_coord+p.play_mt.d_nt.h_width)) {
          if (searchALindex_item (p.agents, he.hcluster, "STR")==-1) {
            p.agents.add(he.hcluster); // in case the coordinates are coincident, include the agent in the scene
          }}} // END 3 IF's
    } // END FOR EACH PLAN
  } // END FOR THE PLAY
}


// ********************************** INTERACTIONS **************************************

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {yo += 30;} else 
    if (keyCode == DOWN) {yo -= 30;} else 
    if (keyCode == RIGHT) {xo -= 10;} else 
    if (keyCode == LEFT) {xo += 10;}
  }
  if (key == 105) {zoom += .5;}  
  if (key == 111) {zoom -= .5;}  
  if (key == 32) {
    angle = 0;
    zoom = 1;
    xo = 0; // width/2;
    yo = 0; // height/2;
  }
}
 
void mouseDragged() {
  xo = xo + (mouseX - pmouseX);
  yo = yo + (mouseY - pmouseY);
}

void mouseClicked() {
  PFont sans_serif_10 = loadFont("SansSerif-10.vlw"); 
  textFont(sans_serif_10); 
  for (int i=0; i<tooltip_boxes.size(); i++) {
    Tooltip_box tb = (Tooltip_box) tooltip_boxes.get(i);
    if (mouseX < tb.x_coord+tb.x_width/2 && mouseX > tb.x_coord-tb.x_width/2) {
      if (mouseY < tb.y_coord+tb.y_height/2 && mouseY > tb.y_coord-tb.y_height/2) {
        // float tw = textWidth(tb.tooltip);
        float tw = 200;
        float th = textWidth(tb.tooltip)/tw;
        fill(0, 0, 255);
        noStroke();
        rectMode(CENTER);
        rect(mouseX, mouseY-10, tw + 15, th + 30);
        fill(0);
        text(tb.tooltip, mouseX, mouseY-10, tw + 15, th + 30);
      }
    }
  } // END FOR tooltip_boxes
  for (int i=0; i<mute_boxes.size(); i++) {
    Mute_box mb = (Mute_box) mute_boxes.get(i);
    if (mouseX < mb.x_coord + mb.x_width/2 && mouseX > mb.x_coord - mb.x_width/2) {
      if (mouseY < mb.y_coord + mb.y_height/2 && mouseY > mb.y_coord - mb.y_height/2) {
        HCluster hc = (HCluster) hierarchy_clusters.get(searchALindex_item(hierarchy_clusters, mb.hc, "HCL"));
        hierarchy_clusters_in_display.remove(searchALindex_item(hierarchy_clusters_in_display, hc.id, "HCL"));
        mute_clusters.add(hc);
        println (" Removed agent " + hc.id + " from display"); 
        mouseX = size_x + 1; mouseY = size_y + 1;
      }
    }
  } // END FOR mute_boxes
  for (int i=0; i<unmute_boxes.size(); i++) {
    Mute_box mb = (Mute_box) unmute_boxes.get(i);
    if (mouseX < mb.x_coord + mb.x_width/2 && mouseX > mb.x_coord - mb.x_width/2) {
      if (mouseY < mb.y_coord + mb.y_height/2 && mouseY > mb.y_coord - mb.y_height/2) {
        HCluster hc = (HCluster) hierarchy_clusters.get(searchALindex_item(hierarchy_clusters, mb.hc, "HCL"));
        mute_clusters.remove(searchALindex_item(mute_clusters, hc.id, "HCL"));
        hierarchy_clusters_in_display.add(hc);
        // println (" Added agent " + hc.id + " to display"); 
        mouseX = size_x + 1; mouseY = size_y + 1;
      }
    }
  } // END FOR mute_boxes
}

void layover() {
  // println("max_text_length = " + max_text_length);
  float tooltip_box_side = max_text_length * tooltipbox_width_factor; // max_text_length == 0, tooltipbox_width_factor == 0.4
  // PFont sans_serif_12 = loadFont("SansSerif-12.vlw"); 
  // textFont(sans_serif_12); 
  float x = mouseX; float y = mouseY;
  // println(theTooltipString);
  // println("search tooltip list of " + tooltip_boxes.size() + " boxes");
  for (int i=0; i<tooltip_boxes.size(); i++) { // for each box that includes a tooltip 
    Tooltip_box tb = (Tooltip_box) tooltip_boxes.get(i);
    if (mouseX < tb.x_coord+tb.x_width/2 && mouseX > tb.x_coord-tb.x_width/2) { // if the mouse is over such box
      if (mouseY < tb.y_coord+tb.y_height/2 && mouseY > tb.y_coord-tb.y_height/2) {
        // float tw = textWidth(tb.tooltip);
        // fill(0, 0, 255); 
        stroke(0); strokeWeight(1); 
        if (mouseX - tooltip_box_side/2 < 0) {x = tooltip_box_side/2;} 
        if (mouseX + tooltip_box_side/2 > size_x) {x = size_x - tooltip_box_side/2;} 
        if (mouseY - tooltip_box_side/2 < 0) {y = tooltip_box_side/2;} 
        if (mouseY + tooltip_box_side/2 > size_y) {y = size_y - tooltip_box_side/2;}         
        // String tipText = "Alpha: "+tooltipAlpha+"\nR: "+tooltipR+"  G: "+tooltipG+"  B: "+tooltipB+"\nmouseX= "+x+" mouseY= "+y;  
        ToolTip toolTip = new ToolTip((int) x, (int) y, tb.tooltip);
        colorMode(HSB, 360, 100, 100, 100);
        color c = color(0, 0, 80, 10); // color(0, 80, 255, 30);
        toolTip.setBackground(c); // color(0,80,255,30));
        // toolTip.setBackground(color(tooltipR,tooltipG,tooltipB,tooltipAlpha));
        // toolTip.clip=false;
        toolTip.display();
        // if (i != prec_txt_i) {println("i = " + i + " != prec_txt_i = " + prec_txt_i);
          // color c = color(0, 80, 255, 30); fill(c); rect(x, y, tooltip_box_side, tooltip_box_side); prec_txt_i = i; 
          // }
        // fill(0);
        // text(tb.tooltip, x, y, tooltip_box_side, tooltip_box_side);
      }
    }
  } // END FOR tooltip_boxes
}