
// ********************************** LOADING LIBRARIES *********************************

// get all the terminal elements: agents, incidents, actions, states
void loading_drama_repository1(XML xml) {
  println("Loading repository ... \n");

  // get the repository elements (currently, agents only, stored in hierarchy_clusters ArrayList as HCluster objects)
  XML x_repository = xml.getChild("repository");
  XML[] x_rep_elem = x_repository.getChildren("rep_elem");
  for (int i=0; i < x_rep_elem.length; i++) { // for each element in the repository
    String rep_elem_type = x_rep_elem[i].getString("type");
    println("Loading rep elem " + x_rep_elem[i].getString("id")); 
    // build the agent (hierarchy cluster) elements
    if (rep_elem_type.equals("AGT")) {  // Agent(String i, String t, String p)
      println(x_rep_elem[i].getString("id") + " in hierarchy_clusters, of size " + hierarchy_clusters.size()); 
      // Agent rep_elem = new Agent(x_rep_elem[i].getString("id"), x_rep_elem[i].getString("type"), x_rep_elem[i].getString("print")); 
      HCluster rep_elem = new HCluster(x_rep_elem[i].getString("id"), "HCL", x_rep_elem[i].getString("print"));       
      hierarchy_clusters.add(rep_elem); 
    }
  }
  // get the timelines terminal elements (the incidents, stored in terminals_in_sequence ArrayList as TerminalInSequence objects)  
  XML x_timelines = xml.getChild("timelines");
  XML[] x_timeline = x_timelines.getChildren("timeline");
  for (int k=0; k < x_timeline.length; k++) { // for each timeline 
    if (x_timeline[k].getString("id").equals("Timeline_total")) { // if timeline total
      XML[] x_te = x_timeline[k].getChildren("te");
      for (int i=0; i < x_te.length; i++) { // for each timeline element
        if (x_te[i].getString("type").equals("UNI")) { // if a UNIT
          println("\n " + i + "-UNIT " + x_te[i].getString("id")); 
          XML[] x_incidents = x_te[i].getChildren("incident"); // get the list of incidents 
          String[] inc_list = new String[x_incidents.length]; // create array of incidents
          for (int j = 0; j < x_incidents.length; j++) { // for each incident
            if (x_incidents[j].getString("type").equals("ACT") || x_incidents[j].getString("type").equals("UNI")) { 
              // TerminalInSequence(String i, String n, String t, String p) 
              TerminalInSequence rep_elemS = new TerminalInSequence (x_incidents[j].getString("id"), 
                                                               x_incidents[j].getString("set"), 
                                                               x_incidents[j].getString("type"), 
                                                               x_incidents[j].getString("print"),
                                                               x_incidents[j].getString("rec_level"));
              rep_elemS.type = "T";                                         
              terminals_in_sequence.add(rep_elemS);
              println(rep_elemS.id + " in terminals_in_sequence, of size " + terminals_in_sequence.size()); 
            } // END IF 
          } // END for
        } else { // if x_te[i].getString("type").equals("UST") --- in case of a unit state set
          println("\n " + i + "-UNITSTATE " + x_te[i].getString("id")); 
          XML[] x_states = x_te[i].getChildren("state"); // get the list of states 
          for (int j = 0; j < x_states.length; j++) { // for each state 
            if (x_states[j].getString("type").equals("SOA") || x_states[j].getString("type").equals("BEL") ||
                x_states[j].getString("type").equals("VAS") || x_states[j].getString("type").equals("EMO") ||
                x_states[j].getString("type").equals("ACC")) { 
              // TerminalInSequence(String i, String n, String t, String p) 
              TerminalInSequence rep_elemS = new TerminalInSequence (x_states[j].getString("id"), 
                                                                     x_states[j].getString("set"), 
                                                                     x_states[j].getString("type"), 
                                                                     x_states[j].getString("print"),
                                                                     x_states[j].getString("rec_level"));
              rep_elemS.type = "XT";                                         
              terminals_in_sequence.add(rep_elemS);
              println(rep_elemS.id + " in terminals_in_sequence, of size " + terminals_in_sequence.size()); 
            } // END if (x_states[j].getString("type").equals("SOA") || ...)
          } // end for each state in unitstate
        } // end "else" (UNITSTATE)
      } // END for each timeline element
    } // END if timeline total
  } // END FOR each timeline
  
  // ... AND NOW TERMINALS FROM PLANS (HIERARHIES) 
  // get the plans terminal elements (actions and states, stored in terminals_in_hierarchies ArrayList as TerminalInHierarchies objects)  
  XML x_plans = xml.getChild("plans"); // plans' subtree 
  XML[] x_plan = x_plans.getChildren("plan"); // list of plans  
  for (int i = 0; i < x_plan.length; i++) { // for each plan
    XML[] x_pel = x_plan[i].getChildren("pe"); // get the list of plan daughters 
    if (x_pel.length!=0) {
      for (int j = 0; j < x_pel.length; j++) { // for each plan element (plan state or action/subplan)
        if (x_pel[j].getString("type").equals("CSS")) { 
          XML[] x_state = x_pel[j].getChildren("state"); // get the list of states in the plan state 
          for (int k = 0; k < x_state.length; k++) { // for each state, retrieve its terminal node
            // TerminalInHierarchies(String i, String h, String t, String p, String a, String rl) 
            TerminalInHierarchies rep_elemH = new TerminalInHierarchies (x_state[k].getString("id"), 
                                                                         x_state[k].getString("set"), 
                                                                         "NULL", // hierel still unknown
                                                                         x_state[k].getString("type"), 
                                                                         x_state[k].getString("print"),
                                                                         x_state[k].getString("mapping"), x_state[k].getString("mapping_set"),
                                                                         x_state[k].getString("rec_level"));
            rep_elemH.type = "XT";  
            println(rep_elemH.id + " " + rep_elemH.set + " " + " in terminals_in_hierarchies, of size " + terminals_in_hierarchies.size()); 
            terminals_in_hierarchies.add(rep_elemH); 
          } // END for each state 
        } else if (x_pel[j].getString("type").equals("ACT")) { // if this pe is an action ("ACT") 
          // TerminalInHierarchies(String i, String h, String t, String p, String a, String rl) 
          TerminalInHierarchies rep_elemH = new TerminalInHierarchies (x_pel[j].getString("id"), 
                                                                       x_pel[j].getString("set"), 
                                                                       "NULL", // hierel still unknown
                                                                       x_pel[j].getString("type"), 
                                                                       x_pel[j].getString("print"),
                                                                       x_pel[j].getString("mapping"), x_pel[j].getString("mapping_set"),
                                                                       x_pel[j].getString("rec_level"));
          rep_elemH.type = "T";                                         
          println(rep_elemH.id + " " + rep_elemH.set + " " + " in terminals_in_hierarchies, of size " + terminals_in_hierarchies.size()); 
          terminals_in_hierarchies.add(rep_elemH); 
        } // END if this pe is an action ("ACT")
      } // END for each plan element (plan state or action/subplan)
    } // END if (x_pel.length!=0) 
  } // END for each plan

} 


// get all the non terminal elements and builds structures of non terminals and terminals
void loading_drama (XML xml) {
  println("Loading drama ... \n");

  // load the timeline and build the timeline, the units, the story states, the incidents, the single states
  println("\n Loading timeline total ... \n");
  // initialize all the structures that host the elements
  XML x_timelines = xml.getChild("timelines");
  XML[] x_timeline = x_timelines.getChildren("timeline");
  for (int i=0; i < x_timeline.length; i++) { // for each timeline 
    if (x_timeline[i].getString("id").equals("Timeline_total")) { // if timeline total
      println("\n Here is timeline total ... \n");
      XML[] x_te = x_timeline[i].getChildren("te");
      load_timeline (x_te);
    }
  }
  println("\n \n Timeline size = " + sequence.size());    
  println("Loading timeline ... completed!\n");

  // load the plans into the plan objects, with their state-action lists
  println("\n Loading plans ... \n");
  XML x_plans = xml.getChild("plans"); // plans' subtree 
  XML[] x_plan = x_plans.getChildren("plan"); // list of plans  
  load_plans(x_plans, x_plan); 
  println("\n Hierels size " + hierels.size() + "\nHierels: ");
  for (int i=0; i < hierels.size(); i++) {Hierel he = (Hierel) hierels.get(i); println(he.id + ", with " + he.daughter_list.size() + " daughters");}
  // println("\n Nonterminal daughters size " + nonterminal_daughters.size() + "\nNonterminal daughters: ");
  // for (int i=0; i < nonterminal_daughters.size(); i++) {print(((NonTerminalDaughter) nonterminal_daughters.get(i)).id + ", ");}
  println("\n Loading plans ... completed!\n");

  // load the scenes into scene objects
  println("\n Loading scenes ... \n");
  XML x_scenes = xml.getChild("scenes"); // scenes' subtree 
  XML[] x_scene = x_scenes.getChildren("scene"); // list of scenes  
  load_scenes(x_scenes, x_scene); 
  println("\n Scenes size " + scenes.size() + "\nScenes: ");
  for (int i=0; i < scenes.size(); i++) {Scene s = (Scene) scenes.get(i); println(s.id);}
  println("\n Loading scenes ... completed!\n");

  // load the acts into the act objects
  println("\n Loading acts ... \n");
  XML x_acts = xml.getChild("acts"); // acts' subtree 
  XML[] x_act = x_acts.getChildren("act"); // list of acts  
  load_acts(x_acts, x_act); 
  println("\n Acts size " + acts.size() + "\nActs: ");
  for (int i=0; i < acts.size(); i++) {Act a = (Act) acts.get(i); println(a.id);}
  println("\n Loading acts ... completed!\n");

  // load the play into the play objects (actually one)
  println("\n Loading play ... \n");
  XML x_plays = xml.getChild("plays"); // plans' subtree 
  XML[] x_play = x_plays.getChildren("play"); // list of plays  
  load_play(x_plays, x_play); 
  println("\n Plays size " + plays.size() + "\nPlays: ");
  for (int i=0; i < plays.size(); i++) {Play p = (Play) plays.get(i); println(p.id);}
  println("\n Loading play ... completed!\n");


  println("\n Loading ... completed!");
}


// load the plans into the plan objects, with their plan elements 
void load_plans(XML x_plans, XML[] x_plan) {
  for (int i = 0; i < x_plan.length; i++) { // for each plan
    // LOAD THE HIEREL HEADER ... create the plan and add to the plans arraylist 
    Hierel p = new Hierel(x_plan[i].getString("id"), x_plan[i].getString("agent"), x_plan[i].getString("plantype"), x_plan[i].getString("print"), x_plan[i].getString("rec_level"));
    p.mapping_init = x_plan[i].getString("mapping_init"); p.mapping_end = x_plan[i].getString("mapping_end");
    if (x_plan[i].getString("accomplished").equals("F") || x_plan[i].getString("accomplished").equals("NULL")) {p.barred = true;} else {p.barred = false;}
    hierels.add(p); 
    HCluster hc = (HCluster) hierarchy_clusters.get(searchALindex_item(hierarchy_clusters, x_plan[i].getString("agent"), "HCL"));
    hc.plans.add(p);
    println("\n  Loading plan " + p.id); 
    // NonTerminalInHierarchies(String i, String h, String p, String d_i, String d_e)
    NonTerminalInHierarchies mt = new NonTerminalInHierarchies(p.id, p.id, p.print, p.mapping_init, p.mapping_end); 
    nonterminals_in_hierarchies.add(mt);
    p.hierel_mt = mt;
    // ... AND THE DAUGHTERS    
    XML[] x_pel = x_plan[i].getChildren("pe"); // get the list of plan daughters 
    println("\n  ... with daughters "); 
    if (x_pel.length==0) {print(" ... NO!!! "); p.only_empty_terminal_daughters = true;} 
    else {
      p.only_empty_terminal_daughters = false;
      for (int j = 0; j < x_pel.length; j++) { // for each plan element (plan state or action/subplan)
        // if this pe is a plan state, for each state contained create a daughter   
        if (x_pel[j].getString("type").equals("CSS")) { 
          // println("\n  Loading planstate " + x_pel[j].getString("id") + " of the plan " + p.id); // PlanState(String i, String p_o_e, String p, State[] s_l)
          XML[] x_state = x_pel[j].getChildren("state"); // get the list of states in the plan state 
          XML[] x_states_copy = x_pel[j].getChildren("state"); // get the list of states in the plan state 
          // loop on all the daughters with a sequence position
          int daughter_index = first_state_in_sequence_index (x_states_copy); // initialize the daughter position 
          while (daughter_index!=-1) {  
            println("  ??? " + x_states_copy[daughter_index].getString("id") + " " + x_states_copy[daughter_index].getString("set") + " " + p.id); 
            p.create_daughter(daughter_index, x_states_copy[daughter_index].getString("id"), x_states_copy[daughter_index].getString("set"), p.id); 
            if (!x_state[daughter_index].getString("mapping").equals("NULL")) { // update only if the daughter IS PROJECTED -- REDUNDANT TEST, BUT OK!!! 
              if (p.leftmost_projected_daughter==-1) {p.leftmost_projected_daughter = p.daughter_list.size()-1;};
              p.rightmost_projected_daughter = p.daughter_list.size()-1; 
            };
            for (int k = daughter_index; k < x_states_copy.length - 1; k++) {x_states_copy[k] = x_states_copy[k+1];}; x_states_copy[x_states_copy.length-1]=null; 
            // for (int k = 0; k < x_states_copy.length; k++) {println(" x_states_copy[k] " + x_state[k].getString("id"));};
            daughter_index = first_state_in_sequence_index (x_states_copy);
          }; // END WHILE DAUGHTERS IN SEQUENCE
          // loop on all the daughters WITHOUT a sequence position
          int k = 0; 
          while (k < x_states_copy.length) { 
            println("  State " + x_states_copy[k].getString("id") + " " + x_states_copy[k].getString("set") + " " + p.id);
            if (x_states_copy[k] != null) {p.create_daughter(k, x_states_copy[k].getString("id"), x_states_copy[k].getString("set"), p.id);};
            k++;
          }
        } else if (x_pel[j].getString("type").equals("ACT")) { // if this pe is an action ("ACT") 
          TerminalInHierarchies a  = (TerminalInHierarchies) 
                                       terminals_in_hierarchies.get(
                                         searchALindex_item_set (terminals_in_hierarchies, 
                                                                 x_pel[j].getString("id"), 
                                                                 x_pel[j].getString("set"), 
                                                                 "TH")); // println("  Loading action " + a.id);
          a.he=p.id; // hierel as a set           
          Daughter d = new Daughter(a.id, a.set, p.id, "TD"); // create the daughter 
          println("  ... " + d.id); 
          // update leftmost and rightmost daughters 
          p.daughter_list.add(d);
          if (!a.projectionT.equals("NULL")) { // update only if the daughter IS PROJECTED
            if (p.leftmost_projected_daughter==-1) {p.leftmost_projected_daughter = p.daughter_list.size()-1;};
            p.rightmost_projected_daughter = p.daughter_list.size()-1; 
          };
        } else { // if it is a subplan, i.e. one of type "SPL" 
          // NonTerminalDaughter(String i, String s_o_h, String p, String t_m)
          String tm; if (x_pel[j].getString("mapping_end").equals("NULL")) {tm = "F";} else {tm = "T";};
          NonTerminalDaughter sp = new NonTerminalDaughter(x_pel[j].getString("id"), 
                                                           p.id, 
                                                           "HIERARCHY", 
                                                           x_pel[j].getString("agent"), 
                                                           x_pel[j].getString("print"), 
                                                           tm);
          nonterminal_daughters.add(sp);  
          Daughter d = new Daughter(sp.id, sp.set, p.id, "NTD"); // create the daughter 
          println("  ... " + d.id); 
          p.daughter_list.add(d);
          if (tm.equals("T")) { // update only if the daughter IS ALIGNED
            if (p.leftmost_projected_daughter==-1) {p.leftmost_projected_daughter = p.daughter_list.size()-1;};
            p.rightmost_projected_daughter = p.daughter_list.size()-1; 
          };
        } // end "if"
      } // end "for"    
      println("  ...... and leftmost p. daughter " + p.leftmost_projected_daughter + " and rightmost p. daughter " + p.rightmost_projected_daughter); 
  } // end "if"
  } // end "for each plan"
}


// load the scenes into the scene objects, with their scene elements 
void load_scenes(XML x_scenes, XML[] x_scene) {
  for (int i = 0; i < x_scene.length; i++) { // for each plan
    // LOAD THE SCENE HEADER ... create the scene and add to the scenes arraylist 
    Scene s = new Scene(x_scene[i].getString("id"), x_scene[i].getString("type"), x_scene[i].getString("print"));
    s.mapping_init = x_scene[i].getString("mapping_init"); s.mapping_end = x_scene[i].getString("mapping_end");
    scenes.add(s); 
    println("\n  Loading scene " + s.id); 
    NonTerminalInSequence mt = new NonTerminalInSequence(s.id, s.print, s.mapping_init, s.mapping_end); 
    nonterminals_in_sequence.add(mt);
    s.scene_mt = mt;
  } // end "for each scene"
}

// load the acts into the acts objects, with their act elements 
void load_acts(XML x_acts, XML[] x_act) {
  for (int i = 0; i < x_act.length; i++) { // for each plan
    // LOAD THE ACT HEADER ... create the act and add to the acts arraylist 
    Act a = new Act(x_act[i].getString("id"), x_act[i].getString("type"), x_act[i].getString("print"));
    a.mapping_init = x_act[i].getString("mapping_init"); a.mapping_end = x_act[i].getString("mapping_end");
    acts.add(a); 
    println("\n  Loading act " + a.id); 
    NonTerminalInSequence mt = new NonTerminalInSequence(a.id, a.print, a.mapping_init, a.mapping_end); 
    nonterminals_in_sequence.add(mt);
    a.act_mt = mt;
  } // end "for each act"
}

// load the play into the play objects, with their play elements 
void load_play(XML x_plays, XML[] x_play) {
  for (int i = 0; i < x_play.length; i++) { // for each plan
    // LOAD THE SCENE HEADER ... create the scene and add to the scenes arraylist 
    Play p = new Play(x_play[i].getString("id"), x_play[i].getString("type"), x_play[i].getString("print"));
    p.mapping_init = x_play[i].getString("mapping_init"); p.mapping_end = x_play[i].getString("mapping_end");
    plays.add(p); 
    println("\n  Loading play " + p.id); 
    NonTerminalInSequence mt = new NonTerminalInSequence(p.id, p.print, p.mapping_init, p.mapping_end); 
    nonterminals_in_sequence.add(mt);
    p.play_mt = mt;
  } // end "for each act"
}


// load the timeline and build the timeline, the units, the unit states, the incidents, the single states
void load_timeline (XML[] x_te) {
  println("TIMELINE"); 
  for (int i=0; i < x_te.length; i++) { // for each timeline element
    String init = "NULL"; String end = "NULL";
    if (x_te[i].getString("type").equals("UNI")) { // if a UNIT
      println("\n " + i + "-UNIT " + x_te[i].getString("id")); 
      XML[] x_incidents = x_te[i].getChildren("incident"); // get the list of incidents 
      String[] inc_list = new String[x_incidents.length]; // create array of incidents 
      if (x_incidents.length>0) { init = x_incidents[0].getString("id"); end = x_incidents[x_incidents.length-1].getString("id"); }; 
      // NonTerminalInSequence(String id, String print, String daughters_init, String daughters_end) --- Create the unit and add to nonterminals_in_sequence
      NonTerminalInSequence u =  new NonTerminalInSequence (x_te[i].getString("id"), x_te[i].getString("print"), init, end); 
      nonterminals_in_sequence.add(u); 
      println("\n ADDED UNIT " + x_te[i].getString("id") + " TO nonterminals_in_sequence"); 
      if (x_incidents.length>0) {
        for (int j = 0; j < x_incidents.length; j++) { // for each incident
          inc_list[j] = x_incidents[j].getString("id"); // create a TerminalInSequence and add to sequence
          TerminalInSequence a = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set(terminals_in_sequence, inc_list[j], u.id, "TS"));
          println("---Incident " + a.id + " of the unit " + u.id);         
          sequence.add(new Sequence_element(a.id, u.id));
        } // end for each incident
      } else { // only non terminals (UNIT) in sequence
        sequence.add(new Sequence_element(u.id, "NULL"));
      }
    } // end "if unit"
    else { // if x_te[i].getString("type").equals("UST") --- in case of a unit state set 
      println("\n " + i + "-UNITSTATE " + x_te[i].getString("id")); 
      XML[] x_states = x_te[i].getChildren("state"); // get the list of states 
      XML[] x_states_copy = x_te[i].getChildren("state"); // get a copy the list of states to compute the rec level of each state
      if (x_states.length>0) {init = x_states[0].getString("id"); end = x_states[x_states.length-1].getString("id"); }; 
      // NonTerminalInSequence(String i, String p, String d_i, String d_e)       Create the unitstate and add to nonterminals_in_sequence
      NonTerminalInSequence us =  new NonTerminalInSequence (x_te[i].getString("id"), x_te[i].getString("print"), init, end); 
      nonterminals_in_sequence.add(us); 
      String rec_level_s = "+" + 0; // initialize the rec level to +0
      for (int j = 0; j < x_states.length; j++) { // for each state 
        int index = next_rec_level_state_in_unit_state (x_states_copy, rec_level_s);
        print("\n   Loading state of rec level " + index);                
        TerminalInSequence s = (TerminalInSequence) // create a terminal in sequence 
                                 terminals_in_sequence.get(
                                   searchALindex_item_set (terminals_in_sequence, 
                                                           x_states[index].getString("id"), 
                                                           x_states[index].getString("set"), 
                                                           "TS"));
        rec_level_s = x_states[index].getString("rec_level"); 
        println("---State " + s.id + " of rec level " + rec_level_s + " of the unit state " + x_te[i].getString("id"));         
        // sequence.add(new Sequence_element(s.id, x_states[index].getString("set")));
        sequence.add(new Sequence_element(s.id, s.nt));
      } // end for
    } // end "else"
  } // end "for each timeline element"
}


// ------------- AUXILIARY ------------


// find the next state in the rec level order 
int next_rec_level_state_in_unit_state (XML[] x_states, String last_rec_level_s) {
  int return_index = -1; // index in x_states that will be returned
  println("\n Enter nrlsius: last rec level is " + last_rec_level_s);
  int last_rec_level = Integer.parseInt(last_rec_level_s.substring(1)); // number without the sign
  // if last_rec_level is positive look for the next equal or higher 
  if (last_rec_level_s.substring(0,1).equals("+")) {
    int return_rec_level = max_rec_level; // set to maximum rec level
    for (int i=0; i < x_states.length; i++) { // loops on all the states 
      if (x_states[i] != null && x_states[i].getString("rec_level").substring(0,1).equals("+")) { // if we are in the same, positive sign
        int cur_rec_level = Integer.parseInt(x_states[i].getString("rec_level").substring(1)); // extract the current rec level
        // if the cur rec level is greater or equal than the last found and is lesser than the rec level found until now, set the new return index
        if (cur_rec_level >= last_rec_level && cur_rec_level <= return_rec_level) { return_rec_level = cur_rec_level; return_index = i; }
      }
    }
    if (return_index != -1) {x_states[return_index] = null; return return_index; } // if found (return_index different than -1), return the index
    // if no more positive to check, look for the minimum negative (return rec level still set to the max rec level)
    return_rec_level = 0;
    // println("--- nrlsius: look for first negative; return rec level is " + return_rec_level); 
    for (int j=0; j < x_states.length; j++) { // loop on all the states 
      if (x_states[j] != null && x_states[j].getString("rec_level").substring(0,1).equals("-")) { // if we are in the same, negative sign
        int cur_rec_level = Integer.parseInt(x_states[j].getString("rec_level").substring(1)); // extract the cur rec level
        // println("--- --- nrlsius: loop for negative; cur rec level is " + cur_rec_level);
        // if the cur rec level is greater or equal than 0 the last found and is lesser than the rec level found until now, set the new return index
        if (cur_rec_level <= max_rec_level && cur_rec_level >= return_rec_level) { 
          // println("--- --- nrlsius: found good negative; cur rec level is " + cur_rec_level); 
          return_rec_level = cur_rec_level; return_index = j; 
        }
      }
    }
    if (return_index != -1) {x_states[return_index] = null; return return_index; }
  } else { // else if last_rec_level is negative look for the next equal or higher -- if (last_rec_level_s.substring(0,0).equals("-")) {
    // println("--- nrlsius: look for NEXT negative; last rec level is " + last_rec_level);
    int return_rec_level = 0;
    for (int k=0; k < x_states.length; k++) { 
      if (x_states[k] != null && x_states[k].getString("rec_level").substring(0,1).equals("-")) {
        int cur_rec_level = Integer.parseInt(x_states[k].getString("rec_level").substring(1));
        if (cur_rec_level <= last_rec_level && cur_rec_level >= return_rec_level) { return_rec_level = cur_rec_level; return_index = k; }
      }
    }
    if (return_index != -1) {x_states[return_index] = null; return return_index; }
  }
  return -1;
}  


// returns the first daughter given the projection on the sequence linear order 
int first_state_in_sequence_index (XML[] x_states) {
  // println("\n Enter next_state_in_sequence: curr sequence_index is " + sequence_index);
  int min_sequence_index = sequence.size(); 
  int daughter_index = -1; // index in x_states that will be returned
  int curr_sequence_index = -1;
  // for each state 
  int i = 0; 
  while (i < x_states.length && x_states[i]!=null) {
    // find the sequence index projected 
    if (!(x_states[i].getString("mapping")).equals("NULL")) { // if mapping of this state is non null 
      curr_sequence_index = searchALindex_item_set (sequence, x_states[i].getString("mapping"), x_states[i].getString("mapping_set"), "SE"); 
      // if this index is lesser than the current return_index, then set the return_index
      if (curr_sequence_index < min_sequence_index) {min_sequence_index = curr_sequence_index; daughter_index = i;} 
    }
    i++;
  }
  return daughter_index; 
}