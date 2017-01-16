
// ************* HIGH-LEVEL DRAWING FUNCTIONS ****************

// draw a large header
void draw_header_L(int x, int y, int x_w, int y_h, color f, color t, String txt) {
  noStroke();
  fill (f); // stroke(0); strokeWeight(3); 
  rectMode(CORNER); rect (x, y, x_w, y_h);
  stroke(200); strokeWeight(3);
  line(x, y+y_h, x+x_w, y+y_h);
  fill(t);
  PFont sansserif_h = createFont("SansSerif", y_h*0.75, true); 
  textFont(sansserif_h); textAlign(CENTER, CENTER); 
  text(txt, x+(x_w/2), y+(y_h/2));
  }

// draw the track headers, on the left
void draw_track_headers() { 
  PFont sansserif_12 = loadFont("SansSerif-12.vlw");
  textFont(sansserif_12); textAlign(CENTER, CENTER); 
  strokeWeight(1); stroke(200);
  // from bottom to top: scenes, acts, play headers
  line(track_header_left_x, scenes_bottom_y, track_header_right_x, scenes_bottom_y);
  text("scenes", (track_header_right_x - track_header_left_x)/2, scenes_bottom_y-(scenes_layer_height/2));
  line(track_header_left_x, scenes_bottom_y-scenes_layer_height, track_header_right_x, scenes_bottom_y-scenes_layer_height);
  text("acts", (track_header_right_x-track_header_left_x)/2, scenes_bottom_y-scenes_layer_height-(acts_layer_height/2));
  line(track_header_left_x, scenes_bottom_y-scenes_layer_height-acts_layer_height, track_header_right_x, scenes_bottom_y-scenes_layer_height-acts_layer_height);
  text("play", (track_header_right_x-track_header_left_x)/2, scenes_bottom_y-scenes_layer_height-acts_layer_height-play_layer_height/2);
  strokeWeight(1); stroke(200);
  //line(track_header_left_x, track_header_top_y+play_layer_height, track_header_right_x, track_header_top_y+play_layer_height);
  // timeline header
  text("timeline", (track_header_right_x-track_header_left_x)/2, timeline_top_y+(timeline_height/2));
  line(track_header_left_x, timeline_bottom_y, track_header_right_x, timeline_bottom_y);
  // plans headers
  float plans_layer_height = plans_height / hierarchy_clusters_in_display.size(); // one track per character  
  for (int j=0; j<mute_boxes.size(); j++) {mute_boxes.remove(j);} 
  for (int i=0; i < hierarchy_clusters_in_display.size(); i++) {
    strokeWeight(1); stroke(200);
    line(track_header_left_x, plans_top_y+(plans_layer_height*i), track_header_right_x, plans_top_y+(plans_layer_height*i));
    HCluster hc = (HCluster) hierarchy_clusters_in_display.get(i);
    float radius;
    if (plans_layer_height < track_header_width) {radius = plans_layer_height*0.9;} else {radius = track_header_width*0.9;}
    DrawingObj_r d_o = new DrawingObj_r (track_header_left_x+(track_header_width/2), // track_header_left_x+2*(track_header_width/3),
                                         plans_top_y + (i*plans_layer_height) + (plans_layer_height/2), 
                                         radius, radius, radius, 
                                         hc.c, #000000, hc.id);
    d_o.draw_r_obj (0, 0);  
    strokeWeight(1); stroke(127); fill(230);
    rectMode(CENTER);
    rect(track_header_left_x+8, plans_top_y+(plans_layer_height*i)+8, 10, 10); 
    // mute toggle
    PFont sansserif_8 = loadFont("SansSerif-8.vlw"); textFont(sansserif_8);
    textAlign(CENTER, CENTER); fill(0);
    text("M", track_header_left_x+8, plans_top_y+(plans_layer_height*i)+8, 10, 10);
    // Mute_box(String i, String a, float xc, float yc, float xw, float yh)
    Mute_box mb = new Mute_box("mb_"+hc.id, hc.id, track_header_left_x+8, plans_top_y+(plans_layer_height*i)+8, 10, 10); 
    mute_boxes.add(mb);
    strokeWeight(1); stroke(200);
    line(track_header_left_x, plans_top_y+(plans_layer_height*i), track_header_right_x, plans_top_y+(plans_layer_height*i));
  }
  strokeWeight(1); stroke(200);
  line(track_header_left_x, plans_top_y+(plans_layer_height*hierarchy_clusters_in_display.size()), track_header_right_x, plans_top_y+(plans_layer_height*hierarchy_clusters_in_display.size()));
  if (mute_clusters.size() > 0) {
    textFont(sansserif_12);
    text("mutes", (track_header_right_x-track_header_left_x)/2, mutes_top_y+(mutes_height/2));
  } 
  line(track_header_right_x, track_header_top_y, track_header_right_x, track_header_bottom_y);
}

void draw_sequence() { 
  // println("\n---------------- DRAWING SEQUENCE ----------------\n"); 
  strokeWeight(1); stroke(127); 
  line(timeline_left_x, timeline_top_y, timeline_right_x, timeline_top_y);
  strokeWeight(0);
  Sequence_element se_aux = (Sequence_element) sequence.get(0); 
  if (!(se_aux.nt.equals("NULL"))) {
    for (int i = 0; i < sequence.size(); i++) { // for each sequence (terminal) element 
      Sequence_element se = (Sequence_element) sequence.get(i);
      TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, se.id, se.nt, "TS"));
      // println(i + " Drawing terminal " + t.id + " at x=" + t.d_t.x_coord + " and y=" + t.d_t.y_coord);
      t.d_t.draw_v_obj (0 , 0); 
    } // END for 
  } else {
    for (int i = 0; i < sequence.size(); i++) { // for each sequence (terminal) element 
      Sequence_element se = (Sequence_element) sequence.get(i);
      NonTerminalInSequence nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, se.id, "NTS"));
      // println(i + " Drawing Nonterminal " + nt.id + " at x=" + nt.d_unit.x_coord + " and y=" + nt.d_unit.y_coord);
      nt.d_unit.draw_v_obj (0 , 0); 
    } // END for 
  }
  strokeWeight(1); stroke(127);
  line(timeline_left_x, timeline_bottom_y, timeline_right_x, timeline_bottom_y);
}


void draw_plans() { 
  // given the number of agents, compute the vertical height of each layer
  float layer_height = plans_height / hierarchy_clusters_in_display.size();
  // println("\n\n plans_top_y = " + plans_top_y + "; hierarchy_clusters_in_display.size() = " + hierarchy_clusters_in_display.size() + "; layer_height = " + layer_height);
  int i=0;
  // for each agent, sort the plans through increasing recursive level and compute the max rec levels
  int max_rec_levels = -1;
  for (i=0; i < hierarchy_clusters_in_display.size(); i++) {
    HCluster hc = (HCluster) hierarchy_clusters_in_display.get(i);  
    hc.sort_plans_increasing_rec_sublayers (); 
    if (max_rec_levels < hc.rec_levels) {max_rec_levels = hc.rec_levels;}
  }
  // set the increment for each plan  
  float plan_height = layer_height / (max_rec_levels + 1); // because also the representation is curve
  // println("--- layer_height = " + layer_height + "; max_rec_levels = " + max_rec_levels + "; plan_height = " + plan_height);
  // for each agent, draw the plans
  for (i=0; i < hierarchy_clusters_in_display.size(); i++) {
    strokeWeight(1); stroke(200);
    line(plans_left_x, plans_top_y+(layer_height*i), plans_right_x, plans_top_y+(layer_height*i));
    // println("--- y = " + (plans_top_y+layer_height*i));
    HCluster hc = (HCluster) hierarchy_clusters_in_display.get(i);  
    // for each plan, assign a sublayer
    for (int k=0; k < hc.plans.size(); k++) {
      Hierel p = (Hierel) hc.plans.get(k);
      // assign x positions to each daughter and compute the span of the hierel from left to right 
      float[] lm_rm = {-1, -1};
      lm_rm = p.x_positioning (lm_rm[0], lm_rm[1]); // assign x positions to daughters and returns the extreme positions
      color f_color = assign_fill_color ("NT", "HIERARCHY", "T", p.hcluster);
      color t_color = assign_text_color ("NT", "HIERARCHY", "T", p.hcluster); 
      // DrawingObj_h (float x, float y, float h_w, float h_h, float ld, float rd, color f, color t, String txt, boolean b)
      if (lm_rm[0]!=-1 && lm_rm[1]!=-1) { // left and right ok
        p.hierel_mt.d_nt = new DrawingObj_h(lm_rm[0], 0, lm_rm[1]-lm_rm[0], 0.0, 0, PI, f_color, t_color, p.print, false); 
      } else if (lm_rm[0]!=-1 && lm_rm[1]==-1 ) { // only left ok, put end at mapping_init end and it is barred
        NonTerminalInSequence nts = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item(nonterminals_in_sequence, p.mapping_init, "NTS"));
        p.hierel_mt.d_nt = new DrawingObj_h(lm_rm[0], 0, (incident_side + incident_hdistance)*2, 0.0, PI/2, PI, f_color, t_color, p.print, true); 
      } 
      // draw the plan
      strokeWeight(1);
      // println("\n--- *** DRAWING HIEREL " + p.id + " *** ---");
      // println("\n---- Leftmost and rightmost position of the hierel: <" + lm_rm[0] + ", " + lm_rm[1] + ">");
      if (lm_rm[0] != -1) { // if everything ok (leftmost extreme found) 
        NonTerminalInHierarchies nt_h = (NonTerminalInHierarchies) 
                                         nonterminals_in_hierarchies.get(searchALindex_item(nonterminals_in_hierarchies, p.id, "NTH"));
        int rec_level_n = Integer.parseInt(p.rec_level); 
        // println("--- max_rec_levels = " + max_rec_levels + "; plan_height = " + plan_height + "; rec_level_n = " + rec_level_n);
        nt_h.d_nt.x_coord = lm_rm[0]; nt_h.d_nt.y_coord = plans_top_y+layer_height*i; 
        nt_h.d_nt.h_height = plan_height * (rec_level_n + 1) * 0.75; 
        if (lm_rm[1]!=-1) {nt_h.d_nt.h_width = lm_rm[1] - lm_rm[0];}
        // println("--- Drawing plan " + p.id + " of agent " + p.hcluster + " at x interval = <" + lm_rm[0] + ", " + lm_rm[1] + "> and y interval = <" + nt_h.d_nt.y_coord + ", " + (nt_h.d_nt.y_coord+nt_h.d_nt.h_height) + ">");
        nt_h.d_nt.draw_h_obj("down", true, 2, p.barred);
      } 
    } // END FOR EACH PLAN
  } // END for each character
  strokeWeight(1); stroke(200);
  line(plans_left_x, plans_top_y+(layer_height*hierarchy_clusters_in_display.size()), plans_right_x, plans_top_y+(layer_height*hierarchy_clusters_in_display.size()));
}


void draw_scenes() { 
  for (int i=0; i < scenes.size(); i++) {
    Scene s = (Scene) scenes.get(i);
    // compute the span of the scene from left to right 
    float[] lm_rm = {-1, -1};
    NonTerminalInSequence nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, s.mapping_init, "NTS"));
    if (searchALindex_item (terminals_in_sequence, nt.daughters_init, "TS") != -1) {
      TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, nt.daughters_init, nt.id, "TS"));
      lm_rm[0] = t.d_t.x_coord - incident_side/2 - incident_hdistance/2; 
    } else {
      lm_rm[0] = nt.d_unit.x_coord - incident_side/2 - incident_hdistance/2; 
    }
    // println("--- Drawing scene " + s.id + " from init " + nt.daughters_init);
    nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, s.mapping_end, "NTS"));
    if (searchALindex_item (terminals_in_sequence, nt.daughters_end, "TS") != -1) {
      TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, nt.daughters_init, nt.id, "TS"));
      lm_rm[1] = t.d_t.x_coord + incident_side/2 + incident_hdistance/2; 
    } else {
      lm_rm[1] = nt.d_unit.x_coord + incident_side/2 + incident_hdistance/2; 
    }
    // draw the scene
    strokeWeight(1);
    if (lm_rm[0] != -1) { // if everything ok (leftmost extreme found) 
      NonTerminalInSequence nt_s = (NonTerminalInSequence) 
                                         nonterminals_in_sequence.get(searchALindex_item(nonterminals_in_sequence, s.id, "NTS"));
      // DrawingObj_h (float x, float y, float h_w, float h_h, float ld, float rd, color f, color t, String txt, boolean b)
      nt_s.d_nt = new DrawingObj_h (lm_rm[0], scenes_bottom_y, lm_rm[1] - lm_rm[0], (int) (scenes_layer_height * 0.6), 0, PI, 128, 128, s.id, false); 
      // println("--- Drawing scene " + s.id + " at x interval = <" + lm_rm[0] + ", " + lm_rm[1] + "> and y interval = <" + nt_s.d_nt.y_coord + ", " + (nt_h.d_nt.y_coord-nt_h.d_nt.h_height) + ">");
      nt_s.d_nt.draw_h_obj("up", true, 2, false);
    }  
  }
}

void draw_acts() { 
  for (int i=0; i < acts.size(); i++) {
    Act a = (Act) acts.get(i);
      // println("--- Drawing act " + a.id + " from init " + a.mapping_init + " to end " + a.mapping_end);
    // compute the span of the scene from left to right 
    float[] lm_rm = {-1, -1};
      NonTerminalInSequence nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, a.mapping_init, "NTS"));
      if (searchALindex_item (terminals_in_sequence, nt.daughters_init, "TS") != -1) {
        TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, nt.daughters_init, nt.id, "TS"));
        lm_rm[0] = t.d_t.x_coord - incident_side/2 - incident_hdistance/2; 
      } else {
        lm_rm[0] = nt.d_unit.x_coord - incident_side/2 - incident_hdistance/2; 
      }
      nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, a.mapping_end, "NTS"));
      if (searchALindex_item (terminals_in_sequence, nt.daughters_end, "TS") != -1) {
        TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, nt.daughters_end, nt.id, "TS"));
        lm_rm[1] = t.d_t.x_coord + incident_side/2 + incident_hdistance/2; 
    } else {
      lm_rm[1] = nt.d_unit.x_coord + incident_side/2 + incident_hdistance/2; 
    }
    // println("--- Drawing act " + a.id + " from init " + nt.daughters_init + " to end " + nt.daughters_end);
    // draw the act
    strokeWeight(1);
    if (lm_rm[0] != -1) { // if everything ok (leftmost extreme found) 
      NonTerminalInSequence nt_s = (NonTerminalInSequence) 
                                         nonterminals_in_sequence.get(searchALindex_item(nonterminals_in_sequence, a.id, "NTS"));
      // DrawingObj_h (float x, float y, float h_w, float h_h, float ld, float rd, color f, color t, String txt, boolean b)
      nt_s.d_nt = new DrawingObj_h (lm_rm[0], scenes_bottom_y, lm_rm[1] - lm_rm[0], (int) (scenes_layer_height + acts_layer_height * 0.6), 0, PI, 128, 128, a.id, false); 
      // println("--- Drawing scene " + s.id + " at x interval = <" + lm_rm[0] + ", " + lm_rm[1] + "> and y interval = <" + nt_s.d_nt.y_coord + ", " + (nt_h.d_nt.y_coord-nt_h.d_nt.h_height) + ">");
      nt_s.d_nt.draw_h_obj("up", true, 2, false);
    }  
  }
}

void draw_play() { 
  for (int i=0; i < plays.size(); i++) {
    Play p = (Play) plays.get(i);
    // println("--- Drawing play " + p.id + " from unit " + p.mapping_init + " to unit " + p.mapping_end);
    // compute the span of the scene from left to right 
    float[] lm_rm = {-1, -1};
    NonTerminalInSequence nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, p.mapping_init, "NTS"));
    if (searchALindex_item (terminals_in_sequence, nt.daughters_init, "TS") != -1) {
      TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, nt.daughters_init, nt.id, "TS"));
      lm_rm[0] = t.d_t.x_coord - incident_side/2 - incident_hdistance/2; 
    } else {
      lm_rm[0] = nt.d_unit.x_coord - incident_side/2 - incident_hdistance/2; 
    }
    nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, p.mapping_end, "NTS"));
    if (searchALindex_item (terminals_in_sequence, nt.daughters_end, "TS") != -1) {
      TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, nt.daughters_end, nt.id, "TS"));
      lm_rm[1] = t.d_t.x_coord + incident_side/2 + incident_hdistance/2; 
    } else {
      lm_rm[1] = nt.d_unit.x_coord + incident_side/2 + incident_hdistance/2; 
    }
    // println("--- Drawing play " + p.id + " from init " + nt.daughters_init + " to end " + nt.daughters_end);
    // draw the act
    strokeWeight(1);
    if (lm_rm[0] != -1) { // if everything ok (leftmost extreme found) 
      NonTerminalInSequence nt_s = (NonTerminalInSequence) 
                                         nonterminals_in_sequence.get(searchALindex_item(nonterminals_in_sequence, p.id, "NTS"));
      // DrawingObj_h (float x, float y, float h_w, float h_h, float ld, float rd, color f, color t, String txt, boolean b) 
      nt_s.d_nt = new DrawingObj_h (lm_rm[0], scenes_bottom_y, lm_rm[1] - lm_rm[0], (int) (scenes_layer_height + acts_layer_height + play_layer_height * 0.95), 0 , PI, 128, 128, p.id, false); 
      // println("--- Drawing scene " + s.id + " at x interval = <" + lm_rm[0] + ", " + lm_rm[1] + "> and y interval = <" + nt_s.d_nt.y_coord + ", " + (nt_h.d_nt.y_coord-nt_h.d_nt.h_height) + ">");
      nt_s.d_nt.draw_h_obj("up", true, 2, false);
    }  
  }
}


void draw_agents_in_scenes() { 
  // float min_degree = PI/10; 
  for (int i=0; i < scenes.size(); i++) {
    Scene s = (Scene) scenes.get(i);
    NonTerminalInSequence nt_s = s.scene_mt;
    if (s.agents.size() > 0) {
      float degree = (PI/2)/s.agents.size();
      // println("--- Drawing agents in scene: number " + s.agents.size() + " and degree " + degree);
      for (int j=0; j < s.agents.size(); j++) {
        String a = (String) s.agents.get(j);
        HCluster hc = (HCluster) hierarchy_clusters.get(searchALindex_item (hierarchy_clusters, a, "HCL"));
        // DrawingObj_h (float x, float y, float h_w, float h_h, float ld, float rd, color f, color t, String txt, boolean b)
        nt_s.d_nt_a = new DrawingObj_h (nt_s.d_nt.x_coord, scenes_bottom_y, nt_s.d_nt.h_width-inner_radius, nt_s.d_nt.h_height-inner_radius, j*degree+offset_angle, (j+1)*degree+offset_angle, hc.c, hc.c, s.id, false); 
        // println("--- Drawing scene " + s.id + " at x interval = <" + lm_rm[0] + ", " + lm_rm[1] + "> and y interval = <" + nt_s.d_nt.y_coord + ", " + (nt_h.d_nt.y_coord-nt_h.d_nt.h_height) + ">");
        nt_s.d_nt_a.draw_h_obj("up", false, 5, false);
      }
    } // END IF AGENTS > 0
  } // END FOR EACH SCENE
  for (int i=0; i < acts.size(); i++) {
    Act a = (Act) acts.get(i);
    NonTerminalInSequence nt_s = a.act_mt;
    if (a.agents.size() > 0) {
      float degree = (PI/2)/a.agents.size();
      // println("--- Drawing agents in act: number " + a.agents.size() + " and degree " + degree);
      for (int j=0; j < a.agents.size(); j++) {
        String agt = (String) a.agents.get(j);
        HCluster hc = (HCluster) hierarchy_clusters.get(searchALindex_item (hierarchy_clusters, agt, "HCL"));
        // DrawingObj_h (float x, float y, float h_w, float h_h, float ld, float rd, color f, color t, String txt, boolean b)
        nt_s.d_nt_a = new DrawingObj_h (nt_s.d_nt.x_coord, scenes_bottom_y, nt_s.d_nt.h_width-inner_radius, nt_s.d_nt.h_height-inner_radius, j*degree+offset_angle, (j+1)*degree+offset_angle, hc.c, hc.c, a.id, false); 
        // println("--- Drawing scene " + s.id + " at x interval = <" + lm_rm[0] + ", " + lm_rm[1] + "> and y interval = <" + nt_s.d_nt.y_coord + ", " + (nt_h.d_nt.y_coord-nt_h.d_nt.h_height) + ">");
        nt_s.d_nt_a.draw_h_obj("up", false, 5, false);
      }
    } // END IF AGENTS > 0
  } // END FOR EACH ACT
  for (int i=0; i < plays.size(); i++) {
    Play p = (Play) plays.get(i);
    NonTerminalInSequence nt_s = p.play_mt;
    if (p.agents.size() > 0) {
      float degree = (PI/2)/p.agents.size();
      // println("--- Drawing agents in play: number " + p.agents.size() + " and degree " + degree);
      for (int j=0; j < p.agents.size(); j++) {
        String agt = (String) p.agents.get(j);
        HCluster hc = (HCluster) hierarchy_clusters.get(searchALindex_item (hierarchy_clusters, agt, "HCL"));
        // DrawingObj_h (float x, float y, float h_w, float h_h, float ld, float rd, color f, color t, String txt, boolean b)
        nt_s.d_nt_a = new DrawingObj_h (nt_s.d_nt.x_coord, scenes_bottom_y, nt_s.d_nt.h_width-inner_radius, nt_s.d_nt.h_height-inner_radius, j*degree+offset_angle, (j+1)*degree+offset_angle, hc.c, hc.c, p.id, false); 
        // nt_s.d_nt.h_height = (int) (scenes_layer_height * 0.6); 
        // println("--- Drawing scene " + s.id + " at x interval = <" + lm_rm[0] + ", " + lm_rm[1] + "> and y interval = <" + nt_s.d_nt.y_coord + ", " + (nt_h.d_nt.y_coord-nt_h.d_nt.h_height) + ">");
        nt_s.d_nt_a.draw_h_obj("up", false, 5, false);
      }
    } // END IF AGENTS > 0
  } // END FOR THE PLAY
}

void drawGrid() {
  Sequence_element se_aux = (Sequence_element) sequence.get(0); 
  // if the first element in sequence (so, all elements) is a terminal (because it belongs to some non terminal)
  if (!(se_aux.nt.equals("NULL"))) { // print terminals
    for (int i=0; i < sequence.size() - 1; i++) {
      Sequence_element se = (Sequence_element) sequence.get(i);
      TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, se.id, se.nt, "TS"));
      float x1 = t.d_t.x_coord + (t.d_t.x_width/2) + (incident_hdistance/2); // float y1 = t.d_t.y_coord + t.d_t.y_height + incident_hdistance;
      // float x2 = t.d_t.x_coord + t.d_t.x_width + (incident_hdistance/2); // float y2 = height;
      fill(127);
      float dots = sqrt(sq(x1 - track_header_right_x) + sq(plans_bottom_y - scenes_top_y)) / 5;
      dottedLine(x1, scenes_top_y, x1, plans_bottom_y, dots);
    } // END for
  } else { // else, print non terminals (units)
    for (int i=0; i < sequence.size() - 1; i++) { 
      Sequence_element se = (Sequence_element) sequence.get(i);
      NonTerminalInSequence nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, se.id, "NTS"));
      float x1 = nt.d_unit.x_coord + (nt.d_unit.x_width/2) + (incident_hdistance/2); // float y1 = t.d_t.y_coord + t.d_t.y_height + incident_hdistance;
      // float x2 = t.d_t.x_coord + t.d_t.x_width + (incident_hdistance/2); // float y2 = height;
      fill(127);
      float dots = sqrt(sq(x1 - track_header_right_x) + sq(plans_bottom_y - scenes_top_y)) / 5;
      dottedLine(x1, scenes_top_y, x1, plans_bottom_y, dots);
    } // END for
  }
}


void draw_mute_clusters() {
  // println (" Drawing mute clusters ");
  for (int j=0; j < unmute_boxes.size(); j++) {unmute_boxes.remove(j);}
  for (int i=0; i < mute_clusters.size(); i++) {
    HCluster hc = (HCluster) mute_clusters.get(i);
    float radius;
    if (mutes_height < mutes_width) {radius = mutes_height/3;} else {radius = mutes_width/3;}
    DrawingObj_r d_o = new DrawingObj_r (mutes_left_x+(i+1)*radius+(i+1)*(radius/2), 
                                         mutes_top_y + (mutes_height/3), 
                                         radius, radius, radius, 
                                         hc.c, #000000, hc.id);
    d_o.draw_r_obj (0, 0);  
    Mute_box mb = new Mute_box("mb_"+hc.id, hc.id, mutes_left_x+(i+1)*radius+(i+1)*(radius/2),  mutes_top_y+(2*(mutes_height/3)), 10, 10); 
    strokeWeight(1); stroke(127); fill(230);
    rectMode(CENTER);
    rect(mb.x_coord, mb.y_coord, 10, 10); 
    // mute toggle
    PFont sansserif_8 = loadFont("SansSerif-8.vlw"); textFont(sansserif_8);
    textAlign(CENTER, CENTER); fill(0);
    text("U", mb.x_coord, mb.y_coord, 10, 10);
    // Mute_box(String i, String a, float xc, float yc, float xw, float yh)
    unmute_boxes.add(mb);  
  }
}


// by Cedric 15-01-28
void dottedLine(float x1, float y1, float x2, float y2, float steps){
 for(int i=0; i<=steps; i++) {
   float x = lerp(x1, x2, i/steps);
   float y = lerp(y1, y2, i/steps);
   noStroke();
   ellipse(x,y,1,1);
 }
}