// default viewing options (can be changed with buttons when running)
var polytype = 3; // the way polytomies are expressed (should be 0,1,2 or 3)
var viewtype = 1; // the default viewtype (should be 1,2,3,4 or 5)
var colourtype = 3; // the default colour mode - note: if doing further editing of colour palette's below this may become irrelevant
// colourtype = 3 is only suited for redlist data
var leaftype = 2; // leaf shape circular or natural - this cannpt be changed with buttons it is recommended you leave it

var fonttype = 'Helvetica'; // change the text font to match the rest of your article and journal style // 'sans-serif' // is good too
var intnodetextcolor = 'rgb(255,255,255)' // for interior node text colour where there is a name to be put
// note there are more advanced options later to change th interior node text
var backgroundcolor = 'rgb(255,255,200)' //background color 'null' if no background is wanted
var outlineboxcolor = 'rgb(0,0,0)' // outline box colour
var auto_interior_node_labels = false; // monophyletic groups of genera are to be automatically labelled in interior nodes.

var innode_label_help = false; // supresses the cutting out of 'namingtodo' labels in the interior nodes of the tree
var commonlabels = true; // makes common names the primary info if false then latin names become the primary focus
var intcircdraw = true; // display interior circles or not?
var mintextsize = 4; // the smallest size text you want to have displayed

var sensitivity = 0.84; // for mouse sensitivity
var sensitivity3 = 0.9;
var sensitivity2 = 0.88; // for mouse sensitivity
var threshold =2; // for the detail threshold
var thresholdtxt =2; // for the detail threshold

var drawsignposts = true;
var searchinteriornodes = false;

var growthtimetot = 30;
