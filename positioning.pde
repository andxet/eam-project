// SPACES AND POSITIONING 

// update all relative spaces, related to plan layers
void update_spaces () { 
  if (mute_clusters.size() != 0) {
    plans_height = (track_header_height/10)*6 - mutes_height;  // plans are 6/10 of visualization - the space for mutes (in this case);
    plans_bottom_y = plans_top_y + plans_height;     
  } else {
    plans_height = (track_header_height/10)*6;  // plans are 6/10 of visualization - no space for mutes;
    plans_bottom_y = plans_top_y + plans_height;         
  }
}


// create the timeline nodes, on which all other alignments rely 
void create_sequence_nodes() {
  println("\n \n----------- CREATE SEQUENCE NODES -----------\n"); 
  Sequence_element se_aux = (Sequence_element) sequence.get(0); // get the first incident (index 0) of the sequence (or timeline)
  if (!(se_aux.nt.equals("NULL"))) { // if the scene that contains it is not NULL, 
    for (int i = 0; i < sequence.size(); i++) { // for each sequence (terminal) element 
      Sequence_element se = (Sequence_element) sequence.get(i);
      TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, se.id, se.nt, "TS"));
      color fill_color = assign_fill_color ("T", "SEQUENCE", t.type, "NULL"); 
      color text_color = assign_text_color ("T", "SEQUENCE", t.type, "NULL");
      t.d_t = new DrawingObj_v(0, 0, fill_color, text_color, t.id, t.print, false);  // DEBUG t.id; DELIVERY t.print
    } // END for 
    float pair_size = display_width / sequence.size();
    incident_side = pair_size / (1 + side_hdistance_ratio); // actual side of a story incident
    incident_hdistance = pair_size - incident_side; // actual distance of a story incident
    println("\n\n display_width = " + display_width + "; pair_size = " + pair_size + "; sequence.size() = " + sequence.size());
    println("side_hdistance_ratio = " + side_hdistance_ratio + "; incident_side = " + incident_side + "; incident_hdistance = " + incident_hdistance);
    if (incident_side < min_side) {println("\nDRAWING IS NOT POSSIBLE: MIN SIZES ARE NOT RESPECTED! \n"); exit();}
    for (int i = 0; i < sequence.size(); i++) { // for each sequence (terminal) element 
      Sequence_element se = (Sequence_element) sequence.get(i);
      TerminalInSequence t = (TerminalInSequence) terminals_in_sequence.get(searchALindex_item_set (terminals_in_sequence, se.id, se.nt, "TS"));
      t.d_t.x_coord = (i*incident_side) + (i*incident_hdistance) + display_left_x + (incident_hdistance/2) + (incident_side/2); 
      t.d_t.y_coord = timeline_top_y + ((timeline_bottom_y - timeline_top_y)/2);
      t.d_t.x_width = incident_side; t.d_t.y_height = timeline_height-timeline_margin*2;
    } // END for 
  } else {
    for (int i = 0; i < sequence.size(); i++) { // for each sequence (terminal) element 
      Sequence_element se = (Sequence_element) sequence.get(i);
      NonTerminalInSequence nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, se.id, "NTS"));
      color fill_color = assign_fill_color ("T", "SEQUENCE", nt.type, "NULL"); 
      color text_color = assign_text_color ("T", "SEQUENCE", nt.type, "NULL");
      // int x = size_x/sequence.size()*i;
      nt.d_unit = new DrawingObj_v(0, 0, fill_color, text_color, nt.id, nt.print, false);  // DEBUG t.id; DELIVERY t.print
    } // END for 
    float pair_size = display_width / sequence.size();
    incident_side = pair_size / (1 + side_hdistance_ratio); // actual side of a story incident
    incident_hdistance = pair_size - incident_side; // actual distance of a story incident
    println("\n\n display_width = " + display_width + "; pair_size = " + pair_size + "; sequence.size() = " + sequence.size());
    println("side_hdistance_ratio = " + side_hdistance_ratio + "; incident_side = " + incident_side + "; incident_hdistance = " + incident_hdistance);
    if (incident_side < min_side) {println("\nDRAWING IS NOT POSSIBLE: MIN SIZES ARE NOT RESPECTED! \n"); exit();}
    for (int i = 0; i < sequence.size(); i++) { // for each sequence (terminal) element 
      Sequence_element se = (Sequence_element) sequence.get(i);
      NonTerminalInSequence nt = (NonTerminalInSequence) nonterminals_in_sequence.get(searchALindex_item (nonterminals_in_sequence, se.id, "NTS"));
      nt.d_unit.x_coord = (i*incident_side) + (i*incident_hdistance) + display_left_x + (incident_hdistance/2) + (incident_side/2); 
      nt.d_unit.y_coord = timeline_top_y + ((timeline_bottom_y - timeline_top_y)/2);
      nt.d_unit.x_width = incident_side; nt.d_unit.y_height = timeline_height-timeline_margin*2;
    } // END for 
  } // END IF

  println("\n ----------- END CREATE SEQUENCE NODES -----------\n \n"); 
} 