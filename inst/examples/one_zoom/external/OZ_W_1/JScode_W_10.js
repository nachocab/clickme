    // this is the logic that draws the leaves and could be edited or added to with additional functions
var popuptext = null;
var popuptext2 = null;
var justopened = true;
var zoominnum;
var zoomoutnum;
var shapechanged = false;
var drawreminder = false;

    function drawleaf1(x,y,r)
    {
        context.beginPath();
        context.arc(x,y,r*(1-partl2*1.5),0,Math.PI*2,true);
        context.lineWidth = r*(partl2*3);
        context.stroke();
        context.fill();
    }

    function drawleaf2(x,y,r,angle)
    {
        var tempsinpre = Math.sin(angle);
        var tempcospre = Math.cos(angle);
        var tempsin90pre = Math.sin(angle + Math.PI/2.0);
        var tempcos90pre = Math.cos(angle + Math.PI/2.0);

        var startx = x-r*(1-partl2*1)*tempcospre;
        var endx = x+r*(1-partl2*1)*tempcospre;
        var starty = y-r*(1-partl2*1)*tempsinpre;
        var endy = y+r*(1-partl2*1)*tempsinpre;
        var midy = (endy-starty)/3;
        var midx = (endx-startx)/3;

        context.beginPath();
        context.moveTo(startx,starty);
        context.bezierCurveTo(startx+midx+2*r/2.4*tempcos90pre,starty+midy+2*r/2.4*tempsin90pre,startx+2*midx+2*r/2.4*tempcos90pre,starty+2*midy+2*r/2.4*tempsin90pre,endx,endy);
        context.bezierCurveTo(startx+2*midx-2*r/2.4*tempcos90pre,starty+2*midy-2*r/2.4*tempsin90pre,startx+midx-2*r/2.4*tempcos90pre,starty+midy-2*r/2.4*tempsin90pre,startx,starty);
        context.lineWidth = r*(partl2*3);
        context.stroke();
        context.fill();
    }

    // SECTION 2: GLOBAL VARIABLE DECLARIATION

    // display size variables - there are defaults but these values are automatically changed later
    var widthres = 1000;
    var heightres = 600;
    var xmin = 0;
    var xmax = widthres;
    var ymin = 0;
    var ymax = heightres;

    var widthofcontrols = 920;
    var widthofcontrols2 = 560;
    var widthofinfobar = 620;

    var buttonoptions = 0;
    // data and graphics variables
    var context; // the graphics element
    var myCanvas; // the canvas
    var fulltree; // the full tree
    var datahastraits = false; // if data has traits

    // zoom and pan position variables
    var ws = 1; // current zoom
    var xp = widthres/2; // current x position
    var yp = heightres;  // current y position
    var wsinit; // used for comparison with ws to obtain zoom level
    var calculating = false; // if in the process of calculating for zoom

    // variables for mouse use
    var mousehold = false;
    var buttonhold = false;
    var popupboxlicense = false;
    var popupboxabout = false;
    var tutorialmode = false;
    var mouseX;
    var mouseY;
    var oldyp; // old y position for moving
    var oldxp; // old x position for moving

    // growth functions
    var timelim = -1; // used as a global variable by the growth function to store the current time limit
    var timeinc; // used as a global variable by the growth function to store the time scaling factor
    var t2; // second timing object for growth function
    var growing = false; // if in the process of growth
    var growingpause = false;

    // flight functons
    var flying = false; // if in the process of flying
    var countdownB = 0;
    var t; // timing object for flying

    // search functions
    var numhits;
    var searchinparts = [];
    var searchinfull = null;
    var fullsearch = null;
    var highlight_search = false;
    var latin_search = false;
    var common_search = true;
    var trait_search = true;

    // variables indicating current preferences
    var infotype = 0; // for the info bar


    var mywindow;

    // INITIALISERS

    // this initialises the whole IFIG
    function init()
    {
        shapechanged = false;
        zoominnum = 7;
        zoomoutnum = 7;
        myCanvas = document.getElementById("myCanvas");
        clearbuttons();
        buttonoptions = 0;

        document.getElementById("JSnotsupported").style.display = 'none';

        context= myCanvas.getContext('2d'); // sort out the canvas element
        if (!(context))
        {
                 document.getElementById("Canvasnotsupported").style.display = '';
        }
        else
        {
                 document.getElementById("Canvasnotsupported").style.display = 'none';
        }
        Resize_only();
        draw_loading();
        setTimeout('init2()',10);
    }

    function init2()
    {
        // sort out event listeners for zoom and pan
        myCanvas.onmousedown = holdon;
        myCanvas.onmouseup = holdoff;
        myCanvas.onmouseout = holdoff;
        myCanvas.onmousemove = movemouse;
        if (myCanvas.addEventListener)
        {
            myCanvas.addEventListener ("mousewheel", mousewheel, false);
            myCanvas.addEventListener ("DOMMouseScroll", mousewheel, false);
        }
        else
        {
            if (myCanvas.attachEvent)
            {
                myCanvas.attachEvent ("onmousewheel", mousewheel);
            }
        }

        readintree(); // read in the tree and do all the necessary precalculations
        Reset(); // set the canvas size and draw the IFIG initial view
        setTimeout('cancelfirstuse()',5000);
        setTimeout('remindshape()',90000);
    }

    // read in the tree data
    function readintree()
    {
        datahastraits = true;
        // read in information from text input
        var stringin = document.forms["myform"]["datain"].value;
        fulltree = null;
        if (stringin)
        {
            // if there is data inputed use this as the tree
            fulltree = new midnode(stringin);
        }
        else
        {
            // otherwise use embedded data set at top of file
            userdata();
        }
        if (!datahastraits)
        {
            colourtype = 2;
        }
        // calculate species richness at all nodes
        fulltree.richness_calc();
        if (datahastraits)
        {
        fulltree.concalc();
        }
        if (auto_interior_node_labels)
        {

        // check all names and find monophyletic genera groups
            fulltree.name_calc();
        }
        // calculate ages
        fulltree.phylogeneticdiv_calc();
        fulltree.age_calc();
        // calculate labels
        if (auto_interior_node_labels)
        {
            fulltree.inlabel_calc(null);
        }
        // update fractal form and do all precalculations
        update_form();
        // resize canvas to fit
        Resize();
        // centre view on IFIG
        fulltree.setxyr3r(40,widthres-40,40,heightres-40);
        // store initial zoom level
        wsinit = ws;
    }

    // resize the canvas to fit the space
    function Resize_only()
    {
        widthres = 1024; // default
        heightres = 660; // default
        if (document.body && document.body.offsetWidth) {
            widthres = document.body.offsetWidth;
            winH = document.body.offsetHeight;
        }
        if (document.compatMode=='CSS1Compat' &&
            document.documentElement &&
            document.documentElement.offsetWidth ) {
            widthres = document.documentElement.offsetWidth;
            heightres = document.documentElement.offsetHeight;
        }
        if (window.innerWidth && window.innerHeight) {
            widthres = window.innerWidth;
            heightres = window.innerHeight;
        }
        // need to allow for space for buttons and border etc.
        document.getElementById("headerspace").width = widthres-658;
        heightres = heightres - 60;
        widthres = widthres - 30;
         document.getElementById("headerspace2").style.display = 'none';
        if (buttonoptions != 0)
        {
            document.getElementById("headerspace2").style.display = '';
            heightres = heightres - 40;
            if (widthres < widthofcontrols)
            {
                heightres = heightres - 27; // add space for two rows of buttons
                if (widthres < widthofcontrols/2)
                {
                    heightres = heightres - 27; // add space for three rows of buttons
                    if (widthres < widthofcontrols/3)
                    {
                        heightres = heightres - 27; // add space for four rows of buttons
                    }
                }
            }
        }
        if (((infotype != 0 || growing || growingpause) && (buttonoptions ==0) ))
        {
            heightres -= 42 // add space for infobar if needed
            if (widthres < widthofinfobar)
            {
                heightres -= 42
            }
        }


        if (widthres < widthofcontrols2)
            {
                heightres = heightres - 27; // add space for two rows of buttons
                if (widthres < widthofcontrols2/2)
                {
                    heightres = heightres - 27; // add space for three rows of buttons
                    if (widthres < widthofcontrols2/3)
                    {
                        heightres = heightres - 27; // add space for four rows of buttons
                    }
                }
            }
        // change size of canvas
        var myCanvas = document.getElementById("myCanvas");
        myCanvas.width = widthres;
        myCanvas.height = heightres;
        // redraw canvas
    }

    function Resize()
    {
        Resize_only();
        draw2();
    }

function cancelfirstuse()
{
    justopened = false;
    draw2();
}

function remindshape()
{
    if (!shapechanged)
    {
        drawreminder = true;
        draw2();
        setTimeout('remindshape_done()',20000);
    }
}

function remindshape_done()
{
    drawreminder = false;
    draw2();
}

function usersearchclear()
{
    document.getElementById("searchtf").value="";
    justopened = false;
    clearTimeout(t);
    flying = false;
    performclear();
    fulltree.clearsearch();
    fulltree.clearlinks();
    fulltree.clearonroute();
    document.getElementById("numhittxt").innerHTML= ('no hits');

}

function userReset()
{
    justopened = false;
    Reset();
}

    // reset the search and view to its start position
    function Reset()
    {
        growthtimetot = 30;
        threshold =2;
        if ((growing)||(growingpause))
        {
            clearTimeout(t2);
            draw2();
            timelim = -1;
            Resize();
            growing = false;
            growingpause = false;
            Resize();
        }
        tutorialmode = false;
        popupboxabout = false;
        popupboxlicense = false;
        document.getElementById("numhittxt").innerHTML= ('no hits');
        calculating = false;
        clearTimeout(t);
        flying = false;
        clearTimeout(t2);
        performclear();
        timelim = -1;
        fulltree.deanchor();
        fulltree.graphref = true;
        fulltree.clearsearch();
        fulltree.clearlinks();
        fulltree.clearonroute();
        fulltree.setxyr3r(40,widthres-40,40,heightres-40);
        wsinit = ws;
        Resize();
    }

    // MOUSE CONTROL, PAN AND ZOOM
var clicking;

    // if holding down left mouse button - prepare to pan
    function holdon(event)
    {
        justopened = false;
        popupboxabout = false;
        popupboxlicense = false;
        clearTimeout(t);
        flying = false;
        mouseY = event.clientY-myCanvas.offsetTop;
        mouseX = event.clientX-myCanvas.offsetLeft;
        fulltree.clearlinks();
        fulltree.links2();
        if (fulltree.linkclick)
        {
            mousehold = false;
            buttonhold = true;
            calculating = true;
            draw2();
            calculating = false;
        }
        else
        {
            mousehold = true;
            clicking = true;
            oldyp = yp;
            oldxp = xp;
            setTimeout('clicktoolate()',200);

        }
    }

    function clicktoolate()
    {
        clicking = false;
    }


    // if releasing left mouse button
    function holdoff()
    {
        if (fulltree.linkclick)
        {
            // link out
            fulltree.wikilink();
        }
        if(clicking)
        {
            click2zoomnum = 4;
            click2zoom();
        }
        fulltree.clearlinks();
        if ((!popupboxabout)&&(!popupboxlicense))
        {
            draw2();
        }
        buttonhold = false;
        mousehold = false;
        calculating = false;
    }

    // mouse move, so if left button held redraw
    function movemouse(event)
    {

        if (mousehold)
        {
            yp = oldyp + (-mouseY+event.clientY -myCanvas.offsetTop);
            xp = oldxp + (-mouseX+event.clientX -myCanvas.offsetLeft);
            if ((yp-oldyp)^2>9)
            {
                clicking = false;
            }
            if ((xp-oldxp)^2>9)
            {
                clicking = false;
            }
            draw2();
        }
        else
        {
            if ((!popupboxabout)&&(!popupboxlicense))
            {
                mouseY = event.clientY -myCanvas.offsetTop;
                mouseX = event.clientX -myCanvas.offsetLeft;
                calculating = true;
                fulltree.clearlinks();
                fulltree.links2();
                draw2();
                calculating = false;
            }
        }

    }

    // need to zoom in or out
    function mousewheel(event)
    {
        justopened = false;
        popupboxabout = false;
        popupboxlicense = false;
        if (!calculating)
        {
            clearTimeout(t);
            flying = false;
            if (!mousehold)
            {
                var delta = 0;
                if ('wheelDelta' in event)
                {
                    delta = event.wheelDelta;
                }
                else
                {
                    delta = -event.detail / 2;
                }

                if ((parseFloat(delta)) > 0.0)
                {
                    calculating = true;
                    zoomin(event)
                }
                else
                {
                    calculating = true;
                    zoomout(event)
                }
            }
            setTimeout('calcfalse()',1);
            // there is a tiny delay here to force redraw in all browsers when zooming a lot
        }
    }

    // handles the calculating flag
    function calcfalse()
    {
        calculating = false;
    }

    // zoom in function
    function zoomin(event)
    {
        clearTimeout(t);
        mouseY = event.clientY -myCanvas.offsetTop;
        mouseX = event.clientX -myCanvas.offsetLeft;
        flying = false;
        ws = ws/sensitivity;
        xp = mouseX + (xp-mouseX)/sensitivity;
        yp = mouseY + (yp-mouseY)/sensitivity;
        context.clearRect(0,0, widthres,heightres);
        draw2();
    }

    // zoom out function
    function zoomout(event)
    {
        mouseY = event.clientY -myCanvas.offsetTop;
        mouseX = event.clientX -myCanvas.offsetLeft;
        clearTimeout(t);
        flying = false;

        if((((fulltree).rvar*(fulltree.hxmax-fulltree.hxmin))>(widthres*0.7))||(((fulltree).rvar*(fulltree.hymax-fulltree.hymin))>(heightres*0.7)))
        {
            ws = ws*sensitivity;
            xp = mouseX + (xp-mouseX)*sensitivity;
            yp = mouseY + (yp-mouseY)*sensitivity;
            context.clearRect(0,0, widthres,heightres);
            draw2();

        }
    }

var click2zoomnum;

function click2zoom()
{

    clearTimeout(t);
    flying = false;
    ws = ws/sensitivity3;
    xp = mouseX + (xp-mouseX)/sensitivity3;
    yp = mouseY + (yp-mouseY)/sensitivity3;
    context.clearRect(0,0, widthres,heightres);
    draw2();
    click2zoomnum --;
    if (click2zoomnum >= 0)
    {
         t = setTimeout('click2zoom()',33);
    }
}

// zoom in function
function CZoomin()
{
    if (zoominnum > 0)
    {
        zoominnum --;
    }
    click2zoomnum = 4;
    CZoomin2();
}

// zoom out function
function CZoomout()
{
    if (zoomoutnum > 0)
    {
        zoomoutnum --;
    }
    click2zoomnum = 4;
    CZoomout2();
}

// zoom in function
function CZoomin2()
{
    clearTimeout(t);
    flying = false;
    ws = ws/sensitivity2;
    xp = widthres/2 + (xp-widthres/2)/sensitivity2;
    yp = heightres/2 + (yp-heightres/2)/sensitivity2;
    context.clearRect(0,0, widthres,heightres);
    draw2();
    click2zoomnum --;
    if (click2zoomnum >= 0)
    {
        t = setTimeout('CZoomin2()',33);
    }
}

// zoom out function
function CZoomout2()
{
    clearTimeout(t);
    flying = false;

    if((((fulltree).rvar*(fulltree.hxmax-fulltree.hxmin))>(widthres*0.7))||(((fulltree).rvar*(fulltree.hymax-fulltree.hymin))>(heightres*0.7)))
    {
        ws = ws*sensitivity2;
        xp = widthres/2 + (xp-widthres/2)*sensitivity2;
        yp = heightres/2 + (yp-heightres/2)*sensitivity2;
        context.clearRect(0,0, widthres,heightres);
        draw2();

    }
    click2zoomnum --;
    if (click2zoomnum >= 0)
    {
        t = setTimeout('CZoomout2()',33);
    }
}



    // BUTTON CONTROL

    function clearbuttons()
    {

        document.getElementById("growtxt").style.display = 'none';
        document.getElementById("viewtxt").style.display = 'none';
        document.getElementById("viewtxt2").style.display = 'none';
        document.getElementById("searchtxt").style.display = 'none';
        document.getElementById("moretxt").style.display = 'none';


        document.getElementById("detailincbutton").style.display = 'none';
        document.getElementById("detaildecbutton").style.display = 'none';
        document.getElementById("tdetailincbutton").style.display = 'none';
        document.getElementById("tdetaildecbutton").style.display = 'none';
        document.getElementById("info button").style.display = 'none';
        document.getElementById("formbutton").style.display = 'none';
        document.getElementById("colourbutton").style.display = 'none';
        document.getElementById("spbutton").style.display = 'none';
        document.getElementById("namebutton").style.display = 'none';
        document.getElementById("polybutton").style.display = 'none';

        document.getElementById("growtitle").style.display = 'none';
        document.getElementById("revgbutton").style.display = 'none';
        document.getElementById("pausegbutton").style.display = 'none';
        document.getElementById("fastergbutton").style.display = 'none';
        document.getElementById("slowergbutton").style.display = 'none';
        document.getElementById("playgbutton").style.display = 'none';
        document.getElementById("startgbutton").style.display = 'none';
        document.getElementById("endgbutton").style.display = 'none';

        document.getElementById("searchtf").style.display = 'none';
        document.getElementById("searchbutton").style.display = 'none';
        document.getElementById("searchbutton2").style.display = 'none';
        document.getElementById("leapbutton").style.display = 'none';
        document.getElementById("flybutton").style.display = 'none';
        document.getElementById("latincheckbox").style.display = 'none';
        document.getElementById("latintxt").style.display = 'none';
        document.getElementById("commoncheckbox").style.display = 'none';
        document.getElementById("commontxt").style.display = 'none';
        document.getElementById("traitcheckbox").style.display = 'none';
        document.getElementById("traittxt").style.display = 'none';
        document.getElementById("flightcheckbox").style.display = 'none';
        document.getElementById("flighttxt").style.display = 'none';
        document.getElementById("markingscheckbox").style.display = 'none';
        document.getElementById("markingstxt").style.display = 'none';
        document.getElementById("numhittxt").style.display = 'none';
        document.getElementById("searchclearbutton").style.display = 'none';

        document.getElementById("datatxt").style.display = 'none';
        document.getElementById("datatxtin").style.display = 'none';
        document.getElementById("databutton").style.display = 'none';

        document.getElementById("closebutton").style.display = 'none';
    }

function reopenbuttons()
{
    if (((growing)||(growingpause))&&(buttonoptions == 0))
    {
        document.getElementById("endgbutton").style.display = '';
    }
    else
    {
        if (( buttonoptions == 0)&&(infotype != 0))
        {
            document.getElementById("closebutton").style.display = '';
        }
    }
}

    function Closebar()
    {
        if (( buttonoptions == 0)&&(infotype != 0))
        {
            infotype = 0
            document.getElementById("viewtxt2").style.display = 'none';
            widthofcontrols -= 100;
        }
        clearbuttons();
        buttonoptions = 0;
        reopenbuttons();
        Resize();
    }

    function searchoptions()
    {
        justopened = false;
        clearbuttons();
        if (buttonoptions == 1)
        {
            buttonoptions = 0;
            popuptext = "Open search bar";
            reopenbuttons();
        }
        else
        {
            buttonoptions = 1;
            document.getElementById("closebutton").style.display = '';
            document.getElementById("searchtxt").style.display = '';
            document.getElementById("searchtf").style.display = '';
            document.getElementById("searchbutton").style.display = '';
            //document.getElementById("searchbutton2").style.display = '';
            //document.getElementById("leapbutton").style.display = '';
            //document.getElementById("flybutton").style.display = '';
            document.getElementById("flightcheckbox").style.display = '';
            document.getElementById("flighttxt").style.display = '';
            document.getElementById("markingscheckbox").style.display = '';
            document.getElementById("markingstxt").style.display = '';
            document.getElementById("numhittxt").style.display = '';
            document.getElementById("latincheckbox").style.display = '';
            document.getElementById("latintxt").style.display = '';
            document.getElementById("searchclearbutton").style.display = '';
            if (datahastraits)
            {
                document.getElementById("commoncheckbox").style.display = '';
                document.getElementById("commontxt").style.display = '';
                document.getElementById("traitcheckbox").style.display = '';
            document.getElementById("traittxt").style.display = '';
            }
            popuptext = "Close search bar";
        }
        Resize();
    }

    function growoptions()
    {
        justopened = false;
        clearbuttons();
        if (buttonoptions == 2)
        {
            buttonoptions = 0;
            popuptext = "Open growth animation bar";
            reopenbuttons();
        }
        else
        {
            buttonoptions = 2;
             document.getElementById("closebutton").style.display = '';
            document.getElementById("growtitle").style.display = '';
            document.getElementById("growtxt").style.display = '';
            document.getElementById("revgbutton").style.display = '';
            document.getElementById("pausegbutton").style.display = '';
            //document.getElementById("fastergbutton").style.display = '';
            //document.getElementById("slowergbutton").style.display = '';
            document.getElementById("playgbutton").style.display = '';
            //document.getElementById("startgbutton").style.display = '';
            document.getElementById("endgbutton").style.display = '';
            if ((!growingpause) && (!growing))
            {
                growplay();
            }
            popuptext = "Close growth animation bar";
        }
        Resize();
    }

    function viewoptions()
    {
        justopened = false;
        clearbuttons();
        if (buttonoptions == 3)
        {
            buttonoptions = 0;
            popuptext = "Open view options bar";
            reopenbuttons();
        }
        else
        {
            buttonoptions = 3;
            document.getElementById("viewtxt").style.display = '';

             document.getElementById("closebutton").style.display = '';


            //document.getElementById("tdetailincbutton").style.display = '';
            //document.getElementById("tdetaildecbutton").style.display = '';
            //document.getElementById("info button").style.display = '';
            document.getElementById("formbutton").style.display = '';
            document.getElementById("colourbutton").style.display = '';

            document.getElementById("spbutton").style.display = '';
            document.getElementById("namebutton").style.display = '';


            popuptext = "Close view options bar";
        }
        Resize();
    }

    function moreoptions()
    {
        justopened = false;
        clearbuttons();
        if (buttonoptions == 5)
        {
            buttonoptions = 0;
            popuptext = "Open more options bar";
            reopenbuttons();
        }
        else
        {
            buttonoptions = 5;
            document.getElementById("moretxt").style.display = '';
             document.getElementById("closebutton").style.display = '';
            document.getElementById("info button").style.display = '';
            document.getElementById("detailincbutton").style.display = '';
            document.getElementById("detaildecbutton").style.display = '';
            document.getElementById("polybutton").style.display = '';
            if (infotype != 0)
            {
                document.getElementById("viewtxt2").style.display = '';
            }
             popuptext = "Close more options bar";
        }
        Resize();
    }

    function dataoptions()
    {
        justopened = false;
        clearbuttons();
        if (buttonoptions == 4)
        {
            buttonoptions = 0;
            reopenbuttons();
        }
        else
        {
             document.getElementById("closebutton").style.display = '';
            document.getElementById("datatxt").style.display = '';
            document.getElementById("datatxtin").style.display = '';
            document.getElementById("databutton").style.display = '';
            buttonoptions = 4;
        }
        Resize();
    }

    // change use of info display
    function toggledisplay()
    {

        if (infotype == 0)
        {
            widthofcontrols += 100;
            infotype = 3
            document.getElementById("viewtxt2").style.display = '';
        }
        else
        {
            if (infotype == 3)
            {
                infotype = 4
                document.getElementById("viewtxt2").style.display = '';
            }
            else
            {
                infotype = 0
                document.getElementById("viewtxt2").style.display = 'none';
                widthofcontrols -= 100;
            }
        }
        Resize();
    }

    // change level of detail in display
    function detailup()
    {
        if (threshold > 0.6)
        {
            threshold = threshold / 2.0;
        }
        draw2();
    }

    function detaildown()
    {
        if (threshold < 3.9)
        {
            threshold = threshold*2.0;
        }
        draw2();
    }

function tdetailup()
{
    if (thresholdtxt> 0.2)
    {
        thresholdtxt = thresholdtxt / 1.5;
    }
    draw2();
}

function tdetaildown()
{
    if (thresholdtxt < 10.0)
    {
        thresholdtxt = thresholdtxt*1.5;
    }
    draw2();
}

    // change fractal form of display
    function form_change()
    {
        shapechanged = true;
        clearTimeout(t);
        flying = false;
        if (viewtype == 1)
        {
            viewtype = 2;
        }
        else
        {
            if (viewtype == 2)
            {
                viewtype = 3;
            }
            else
            {
                if (viewtype == 3)
                {
                    viewtype = 4;
                }
                else
                {
                    viewtype = 1;
                }
            }
        }
        draw_loading();
        setTimeout('form_change2()',1);
    }

    function form_change2()
    {
        update_form();
        Resize();
    }

    // change the way polytomies are displayed
    function polyt_change()
    {
        if (polytype == 3)
        {
            polytype = 1;
        }
        else
        {
            if (polytype == 1)
            {
                polytype = 2;
            }
            else
            {
                polytype = 3;

            }
        }
        draw2();
    }

    // change colour scheme
    function colour_change()
    {
        if (colourtype == 1)
        {
            colourtype = 2;
        }
        else
        {
            if (colourtype == 2)
            {
                if (datahastraits)
                {
                    colourtype = 3;
                }
                else
                {
                    colourtype = 1;
                }
            }
            else
            {
                colourtype = 1;
            }
        }
        draw2();
    }

    function name_change()
    {
        if (commonlabels == true)
        {
            commonlabels = false;
        }
        else
        {
            commonlabels = true;
        }
        draw2();
    }

function signpost_change()
{
    if (drawsignposts == true)
    {
        drawsignposts = false;
        thresholdtxt =1.5;
    }
    else
    {
        drawsignposts = true;
        thresholdtxt =2;
    }

    draw2();
}


    // TEXT DRAWING TOOLS

    // text tool
    function autotext(initalic,texttodisp,textx,texty,textw,defpt)
    {
        var drawntext = false;
        if (defpt > mintextsize)
        {
            // draws text within a bounding width but only if possible with font size > 1
            // if possible uses the defpt font size and centres the text in the box
            // otherwise fills the box
            context.textBaseline = 'middle';
            context.textAlign = 'left';
            if (initalic)
            {
                context.font = 'italic ' + (defpt).toString() + 'px '+fonttype;
            }
            else
            {
                context.font = (defpt).toString() + 'px '+ fonttype;
            }
            var testw = context.measureText(texttodisp).width;
            if (testw > textw)
            {
                if ((defpt*textw/testw) > mintextsize)
                {
                    if (initalic)
                    {
                        context.font = 'italic ' + (defpt*textw/testw).toString() + 'px '+fonttype;
                    }
                    else
                    {
                        context.font = (defpt*textw/testw).toString() + 'px '+fonttype;
                    }
                    context.fillText  (texttodisp , textx - textw/2.0,texty);
                    drawntext = true;
                }
            }
            else
            {
                context.fillText  (texttodisp , textx - (testw)/2.0,texty);
                drawntext = true;
            }
        }
        return drawntext;
    }

    function autotext2(initalic,texttodisp,textx,texty,textw,defpt)
    {
        var drawntext = false;
        // x and y are the centres
        if (defpt >mintextsize)
        {

            // draws text within a bounding width but only if possible with font size > 1
            // if possible uses the defpt font size and centres the text in the box
            // otherwise fills the box
            context.textBaseline = 'middle';
            context.textAlign = 'center';
            if (initalic)
            {
                context.font = 'italic ' + (defpt).toString() + 'px '+fonttype;
            }
            else
            {
                context.font = (defpt).toString() + 'px '+ fonttype;
            }

            var centerpoint = (texttodisp.length)/3;
            var splitstr = texttodisp.split(" ");
            var print1 = " ";
            var print2 = " ";

            if (splitstr.length == 1)
            {
                drawntext = autotext(initalic,texttodisp,textx,texty,textw,defpt);
            }
            else
            {
                if (splitstr.length == 2)
                {
                    print1  = (splitstr[0]);
                    print2  = (splitstr[1]);
                }
                else
                {
                    for (i = (splitstr.length -1) ; i >= 0 ; i--)
                    {
                        if ((print2.length)>centerpoint)
                        {
                            print1  = (" " + splitstr[i] + print1);
                        }
                        else
                        {
                            print2 = (" " + splitstr[i] + print2);
                        }
                    }
                }
                var testw = context.measureText(print2).width;
                if (testw < (context.measureText(print1).width))
                {
                    testw = context.measureText(print1).width
                }
                if (testw > textw)
                {
                    if ((defpt*textw/testw) > mintextsize)
                    {

                        if (initalic)
                        {
                            context.font = 'italic ' + (defpt*textw/testw).toString() + 'px '+fonttype;
                        }
                        else
                        {
                            context.font = (defpt*textw/testw).toString() + 'px '+fonttype;
                        }

                        context.fillText  (print1 , textx ,texty-defpt*textw/testw/1.7);
                        context.fillText  (print2 , textx ,texty+defpt*textw/testw/1.7);
                        drawntext = true;
                    }
                }
                else
                {
                    context.fillText  (print1 , textx ,texty-defpt/1.7);
                    context.fillText  (print2 , textx ,texty+defpt/1.7);
                    drawntext = true;
                }
            }

        }
        return drawntext;
    }


function autotext3(initalic,texttodisp,textx,texty,textw,defpt)
{
    var drawntext = false;
    // x and y are the centres
    if (defpt >mintextsize)
    {

        // draws text within a bounding width but only if possible with font size > 1
        // if possible uses the defpt font size and centres the text in the box
        // otherwise fills the box
        context.textBaseline = 'middle';
        context.textAlign = 'center';
        if (initalic)
        {
            context.font = 'italic ' + (defpt).toString() + 'px '+fonttype;
        }
        else
        {
            context.font = (defpt).toString() + 'px '+ fonttype;
        }

        var centerpoint = (texttodisp.length)/4;
        var splitstr = texttodisp.split(" ");
        var print1 = " ";
        var print2 = " ";
        var print3 = " ";

        if (splitstr.length == 1)
        {
            drawntext = autotext(initalic,texttodisp,textx,texty,textw,defpt);
        }
        else
        {
            if (splitstr.length == 2)
            {
                drawntext = autotext2(initalic,texttodisp,textx,texty,textw,defpt);
            }
            else
            {
                if (splitstr.length == 3)
                {
                    print1  = (splitstr[0]);
                    print2  = (splitstr[1]);
                    print3  = (splitstr[2]);
                }
                else
                {
                    for (i = (splitstr.length -1) ; i >= 0 ; i--)
                    {
                        if ((print3.length)>=centerpoint)
                        {
                            if ((print2.length)>=centerpoint)
                            {
                                print1  = (" " + splitstr[i] + print1);
                            }
                            else
                            {
                                print2 = (" " + splitstr[i] + print2);
                            }
                        }
                        else
                        {
                            print3 = (" " + splitstr[i] + print3);
                        }
                    }
                }
            }

            if ((print3.length >= (print1.length+print2.length))||(print1.length >= (print3.length+print2.length)))
            {
                drawntext = autotext2(initalic,texttodisp,textx,texty,textw,defpt);
            }
            else
            {

                var testw = context.measureText(print2).width;
                if (testw < (context.measureText(print1).width))
                {
                    testw = context.measureText(print1).width
                }
                if (testw < (context.measureText(print3).width))
                {
                    testw = context.measureText(print3).width
                }
                if (testw > textw)
                {
                    if ((defpt*textw/testw) > mintextsize)
                    {

                        if (initalic)
                        {
                            context.font = 'italic ' + (defpt*textw/testw).toString() + 'px '+fonttype;
                        }
                        else
                        {
                            context.font = (defpt*textw/testw).toString() + 'px '+fonttype;
                        }

                        context.fillText  (print1 , textx ,texty-defpt*textw/testw*1.2);
                        context.fillText  (print2 , textx ,texty);
                        context.fillText  (print3 , textx ,texty+defpt*textw/testw*1.2);
                        drawntext = true;
                    }
                }
                else
                {
                    context.fillText  (print1 , textx ,texty-defpt*1.2);
                    context.fillText  (print2 , textx ,texty);
                    context.fillText  (print3 , textx ,texty+defpt*1.2);
                    drawntext = true;
                }
            }
        }

    }
    return drawntext;
}



    function tutorialstart()
    {
        justopened = false;
        mywindow = window.open("http://www.onezoom.org/tutorial2.htm");
        popup_out();
    }

    // DRAWING ROUTINES

    function infobar()
    {
        document.getElementById("textout").innerHTML = '';
        if (growing || growingpause || (infotype != 0)|| buttonoptions != 0)
        {
            document.getElementById("textout").style.display = '';
        }
        else
        {
            document.getElementById("textout").style.display = 'none';
        }

        var toalter = "textout";
        if (buttonoptions ==5)
        {
            toalter = "viewtxt2";
        }


        if (buttonoptions == 5 || buttonoptions == 0)
        {
        if (infotype == 3)
        {
            var multret = ws/wsinit/fulltree.mult();
            //multret = Math.log(multret)/Math.log(10);

            if (multret<2500)
            {
                document.getElementById(toalter).innerHTML= ('<FONT COLOR="FFFFFF" >Current zoom level is ' + (Math.round(multret*10.0)/10.0).toString() + ' times magnification </FONT> ');
            }
            else
            {
                if (multret<1500000)
                {
                    document.getElementById(toalter).innerHTML= ('<FONT COLOR="FFFFFF" >Current zoom level is ' + (Math.round(multret/1000.0)).toString() + ' thousand times magnification </FONT> ');
                }
                else
                {
                    document.getElementById(toalter).innerHTML= ('<FONT COLOR="FFFFFF" >Current zoom level is ' + (Math.round(multret/100000.0)/10.0).toString() + ' million times magnification </FONT> ');
                }

            }

        }
        else
        {
            if (infotype == 4)
            {
                var multret = ws/wsinit/fulltree.mult();
                var mret = multret*widthres/8661.4;
                if (mret<1.5)
                {
                    document.getElementById(toalter).innerHTML= ('<FONT COLOR="FFFFFF" >The complete image now measures at least ' + (Math.round(mret*1000.0)/10.0).toString() + ' Centimeters across </FONT>');
                }
                else
                {
                    if (mret>1500)
                    {
                        document.getElementById(toalter).innerHTML= ('<FONT COLOR="FFFFFF" >The complete image now measures at least ' + (Math.round(mret/100)/10.0).toString() + ' Kilometers across </FONT>');
                    }
                    else
                    {
                        document.getElementById(toalter).innerHTML= ('<FONT COLOR="FFFFFF" >The complete image now measures at least ' + (Math.round(mret*10.0))/10.0.toString() + ' Meters across </FONT>');
                    }

                }

            }
            else
            {

                document.getElementById("viewtxt2").style.display = 'none';
            }
        }
        }

            toalter = "growtxt";
        if (buttonoptions != 2)
        {
            toalter = "textout";
        }

        if (buttonoptions == 2 || buttonoptions == 0)
        {
            if ((growingpause || growing))
            {
            if (timelim >= 0 )
            {
                if (timelim >10)
                {
                    document.getElementById(toalter).innerHTML = '<FONT COLOR="FFFFFF" >' + (Math.round(timelim*10)/10.0).toString() + ' Million years ago - ' + gpmapper(timelim) + ' Period </FONT>';
                }
                else
                {
                    if (timelim >1)
                    {
                        document.getElementById(toalter).innerHTML =  '<FONT COLOR="FFFFFF" >' + (Math.round(timelim*100)/100.0).toString() + ' Million years ago - ' + gpmapper(timelim) + ' Period </FONT>';
                    }
                    else
                    {
                        document.getElementById(toalter).innerHTML =  '<FONT COLOR="FFFFFF" >' + (Math.round(timelim*10000)/10.0).toString() + ' Thousand years ago - ' + gpmapper(timelim) + ' Period </FONT>';
                    }
                }
                if (growingpause)
                {
                    document.getElementById(toalter).innerHTML += '<FONT COLOR="FFFFFF" >  (paused) </FONT>';
                }

            }
            }
            else
            {
                if (buttonoptions == 2 )
                {
                    document.getElementById("growtxt").innerHTML = '<FONT COLOR="FFFFFF" > Present day </FONT>';
                }
            }
        }
    }


function drawremind()
{
    context.beginPath();
    context.lineWidth = 1;
    context.lineTo( myCanvas.width -392 , 40 );
    context.lineTo( myCanvas.width -392, 10);
    context.lineTo( myCanvas.width -21, 10 );
    context.lineTo( myCanvas.width -21, 40 );
    context.fillStyle = 'rgba(0,0,0,0.85)';
    context.fill();
    context.fillStyle = 'rgb(255,255,255)';
    autotext(false, "Click here to change tree shape" , myCanvas.width -192, 25 , 250 , 14);
    context.beginPath();
    context.fillStyle = 'rgba(0,0,0,0.85)';
    context.lineTo( myCanvas.width -231 , 10 );
    context.lineTo( myCanvas.width -211, 10);
    context.lineTo( myCanvas.width -221, 0 );
    context.fill();

}



    function drawopen()
    {
        context.beginPath();
        context.lineWidth = 1;
        context.lineTo( myCanvas.width -164 , 40 );
        context.lineTo( myCanvas.width -164, 10);
        context.lineTo( myCanvas.width -21, 10 );
        context.lineTo( myCanvas.width -21, 40 );
        context.fillStyle = 'rgba(0,0,0,0.85)';
        context.fill();
        context.fillStyle = 'rgb(255,255,255)';
        autotext(false, "Click for a tutorial" , myCanvas.width -92, 25 , 250 , 14);
        //autotext2(false, "This message will disappear when you begin using OneZoom." , myCanvas.width -207, 130 , 280 , 25);
        context.beginPath();
        context.fillStyle = 'rgba(0,0,0,0.85)';
        context.lineTo( myCanvas.width -138 , 10 );
        context.lineTo( myCanvas.width -118, 10);
        context.lineTo( myCanvas.width -128, 0 );
        context.fill();

        var offsetx = 28;
        context.beginPath();
        context.lineWidth = 1;
        context.lineTo( myCanvas.width -372 -18, 40 );
        context.lineTo( myCanvas.width -372-18, 10);
        context.lineTo( myCanvas.width -180-18, 10 );
        context.lineTo( myCanvas.width -180-18, 40 );
        context.fillStyle = 'rgba(0,0,0,0.85)';
        context.fill();
        context.fillStyle = 'rgb(255,255,255)';
        autotext(false, "Click or scroll to zoom" , myCanvas.width -276-18, 25 , 250 , 14);
        //autotext2(false, "This message will disappear when you begin using OneZoom." , myCanvas.width -207, 130 , 280 , 25);
        context.beginPath();
        context.fillStyle = 'rgba(0,0,0,0.85)';
        context.lineTo( myCanvas.width -330 -offsetx, 10 );
        context.lineTo( myCanvas.width -310-offsetx, 10);
        context.lineTo( myCanvas.width -320-offsetx, 0 );
        context.fill();
        context.beginPath();
        context.fillStyle = 'rgba(0,0,0,0.85)';
        context.lineTo( myCanvas.width -362-offsetx , 10 );
        context.lineTo( myCanvas.width -342-offsetx, 10);
        context.lineTo( myCanvas.width -352-offsetx, 0 );
        context.fill();

        context.beginPath();
        context.lineWidth = 1;
        context.lineTo( 21 , 40 );
        context.lineTo( 21, 10);
        context.lineTo( 233, 10 );
        context.lineTo( 233, 40 );
        context.fillStyle = 'rgba(0,0,0,0.85)';
        context.fill();
        context.beginPath();
        context.fillStyle = 'rgba(0,0,0,0.85)';
        context.lineTo( 137, 10 );
        context.lineTo( 117, 10);
        context.lineTo( 127, 0 );
        context.fill();

        context.fillStyle = 'rgb(255,255,255)';
        autotext(false, "See more trees on OneZoom" , 130, 25 , 250 , 14);

    }

    function draw2()
    {
        fulltree.drawreg(xp,yp,220*ws);
        if ((((ws > 100)||(ws < 0.01))&&(!mousehold))) // possibly change these values
        {
            fulltree.reanchor();
            fulltree.drawreg(xp,yp,220*ws);
        }
        if (backgroundcolor)
        {
            context.fillStyle = backgroundcolor;
            context.fillRect(0,0,widthres,heightres);
        }
        else
        {
            context.clearRect(0,0,widthres,heightres);
        }
        fulltree.draw();
        fulltree.draw_sp_back();
        fulltree.draw_sp_txt();
        context.beginPath();
        context.lineWidth = 1;
        context.strokeStyle = outlineboxcolor;
        context.moveTo( 0 , 0 );
        var myCanvas = document.getElementById("myCanvas");
        context.lineTo( myCanvas.width , 0 );
        context.lineTo( myCanvas.width , myCanvas.height );
        context.lineTo( 0 , myCanvas.height );
        context.lineTo( 0 , 0 );
        context.stroke();
        infobar();
        if (tutorialmode)
        {
            context.beginPath();
            context.lineWidth = 1;
            context.lineTo( myCanvas.width /6 , myCanvas.height *4/5 );
            context.lineTo( myCanvas.width /6, myCanvas.height /5);
            context.lineTo( myCanvas.width *5/6, myCanvas.height /5 );
            context.lineTo( myCanvas.width *5/6 , myCanvas.height *4/5 );
            context.fillStyle = 'rgba(0,0,0,0.85)';
            context.fill();
            context.fillStyle = 'rgb(255,255,255)';
            autotext(false,"OneZoom Tutorial" , myCanvas.width /2 , myCanvas.height *0.25 , myCanvas.width *0.6 , 22);
            autotext(false,"To exit the tutorial mode, press the 'Tutorial' button again" , myCanvas.width /2 , myCanvas.height *0.35 , myCanvas.width *0.5 , 15);
            autotext(false,"To zoom in scroll up, to zoom out scroll down" , myCanvas.width /2 , myCanvas.height *0.39 , myCanvas.width *0.5 , 15);
            autotext(false,"To move, press and hold the left mouse button, then move the mouse" , myCanvas.width /2 , myCanvas.height *0.43 , myCanvas.width *0.5 , 15);
            autotext(false,"Click on the logo on the top left to see the rest of the site including a video" , myCanvas.width /2 , myCanvas.height *0.47 , myCanvas.width *0.5 , 15);
            autotext(false,"Hover the mouse over the icons on the top right to access extra functions" , myCanvas.width /2 , myCanvas.height *0.51 , myCanvas.width *0.5 , 15);
            autotext(false,"Most icons will reveal buttons at the bottom of the page" , myCanvas.width /2 , myCanvas.height *0.55 , myCanvas.width *0.5 , 15);
            autotext(false,"The 'View options bar' allows you to change the look and colors of the tree" , myCanvas.width /2 , myCanvas.height *0.59 , myCanvas.width *0.5 , 15);
            autotext(false,"The 'Search bar' allows searching of the tree" , myCanvas.width /2 , myCanvas.height *0.63 , myCanvas.width *0.6 , 15);
            autotext(false,"The 'Growth animation bar' allows you to see animations of the tree growing" , myCanvas.width /2 , myCanvas.height *0.67 , myCanvas.width *0.5 , 15);
            autotext(false,"The 'More options bar' includes more advanced settings" , myCanvas.width /2 , myCanvas.height *0.71 , myCanvas.width *0.6 , 15);
        }

        if (justopened)
        {
            drawopen();
        }
        if (drawreminder)
        {
            drawremind();
        }

        if (popuptext)
        {
            context.beginPath();
            context.lineWidth = 1;
            context.lineTo( myCanvas.width -392 , 40 );
            context.lineTo( myCanvas.width -392, 10);
            context.lineTo( myCanvas.width -21, 10 );
            context.lineTo( myCanvas.width -21, 40 );
            context.fillStyle = 'rgba(0,0,0,0.85)';
            context.fill();
            context.fillStyle = 'rgb(255,255,255)';
            autotext(false, popuptext , myCanvas.width -192, 25 , 250 , 14);
        }


        if (popuptext2)
        {
            context.beginPath();
            context.lineWidth = 1;
            context.lineTo( 21 , 40 );
            context.lineTo( 21, 10);
            context.lineTo( 233, 10 );
            context.lineTo( 233, 40 );
            context.fillStyle = 'rgba(0,0,0,0.85)';
            context.fill();
            context.fillStyle = 'rgb(255,255,255)';
            autotext(false, popuptext2 , 130, 25 , 250 , 14);
        }


    }

    function Link2OZ()
    {
        justopened = false;
         window.location.href = "http://www.onezoom.org";
    }

    function Link2Facebook()
    {
        justopened = false;
        mywindow = window.open("http://www.facebook.com/OneZoomTree");

    }

    function Link2Twitter()
    {
        justopened = false;
        mywindow = window.open("https://twitter.com/OneZoomTree");
    }

    function draw_loading()
    {

        infobar();
        Resize_only();
        if (backgroundcolor)
        {
            context.fillStyle = backgroundcolor;
            context.fillRect(0,0,widthres,heightres);
        }
        else
        {
            context.clearRect(0,0,widthres,heightres);
        }
        context.beginPath();
        context.lineWidth = 1;
        context.strokeStyle = outlineboxcolor;
        context.moveTo( 0 , 0 );
        var myCanvas = document.getElementById("myCanvas");
        context.lineTo( myCanvas.width , 0 );
        context.lineTo( myCanvas.width , myCanvas.height );
        context.lineTo( 0 , myCanvas.height );
        context.lineTo( 0 , 0 );
        context.stroke();

        context.beginPath();
        context.textBaseline = 'middle';
        context.textAlign = 'left';

        context.fillStyle = 'rgb(0,0,50)';
        context.font = '50px sans-serif';
        context.textAlign = 'center';
        context.fillText  ('Loading', widthres/2,heightres/2, widthres/2);

        return true;

    }


    // FRACTAL FORM ALGORITHMS AND PRECALCULATIONS

    // variables that were used for all fractal forms
    var partc = 0.4;
    var partcint = 0.165;
    var partl1 = 0.55; // size of line
    var partl2 = 0.1;
    var ratio1 = 0.77; // size of larger branch
    var ratio2 = 0.47; // size of smaller branch
    var Tsize = 1.1;
    var Twidth = 1;
    var Psize = 0.70
    var leafmult = 3.2;
    var posmult = leafmult -2;

    midnode.prototype.precalc = function(x,y,r,angle)
    {
        this.arca = angle;
        var tempsinpre = Math.sin(angle);
        var tempcospre = Math.cos(angle);
        var tempsin90pre = Math.sin(angle + Math.PI/2.0);
        var tempcos90pre = Math.cos(angle + Math.PI/2.0);
        var atanpre;
        var atanpowpre;

        if (this.child1)
        {
            atanpre = Math.atan2((this.child1).richness_val,(this.child2).richness_val);
            atanpowpre = Math.atan2(Math.pow((this.child1).richness_val,0.5),Math.pow(((this.child2).richness_val),0.5));
        }

        var thisangleleft = 0.46;
        var thisangleright = 0.22;
        var thisratio1 = 1/1.3;;
        var thisratio2 = 1/2.25;

        var tempsin2 = Math.sin(angle + Math.PI*thisangleright);
        var tempcos2 = Math.cos(angle + Math.PI*thisangleright);
        var tempsin3 = Math.sin(angle - Math.PI*thisangleleft);
        var tempcos3 = Math.cos(angle - Math.PI*thisangleleft);

        if (this.child1)
        {

            if ((this.child1.richness_val) >= (this.child2.richness_val))
            {

                this.nextr1 = thisratio1; // r (scale) reference for child 1
                this.nextr2 = thisratio2; // r (scale) reference for child 2

                (this.child1).bezsx = -(0.3)*(tempcospre)/thisratio1;
                (this.child1).bezsy = -(0.3)*(tempsinpre)/thisratio1;
                (this.child1).bezex = tempcos2;
                (this.child1).bezey = tempsin2;
                (this.child1).bezc1x = -0.3*(tempcospre)/thisratio1;
                (this.child1).bezc1y = -0.3*(tempsinpre)/thisratio1;
                (this.child1).bezc2x = 0.15*(tempcospre)/thisratio1;
                (this.child1).bezc2y = 0.15*(tempsinpre)/thisratio1;
                (this.child1).bezr = partl1;

                (this.child2).bezsx = -(0.3)*(tempcospre)/thisratio2;
                (this.child2).bezsy = -(0.3)*(tempsinpre)/thisratio2;
                (this.child2).bezex = tempcos3;
                (this.child2).bezey = tempsin3;
                (this.child2).bezc1x = 0.1*(tempcospre)/thisratio2;
                (this.child2).bezc1y = 0.1*(tempsinpre)/thisratio2;
                (this.child2).bezc2x = 0.9*tempcos3;
                (this.child2).bezc2y = 0.9*tempsin3;
                (this.child2).bezr = partl1;

                this.nextx1 = (1.3*Math.cos(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty1 = (1.3*Math.sin(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempsin90pre; // y reference point for both children
                this.nextx2 = (1.3*Math.cos(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty2 = (1.3*Math.sin(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempsin90pre; // y reference point for both children
            }
            else
            {
                this.nextr2 = thisratio1; // r (scale) reference for child 1
                this.nextr1 = thisratio2; // r (scale) reference for child 2

                (this.child2).bezsx = -(0.3)*(tempcospre)/thisratio1;
                (this.child2).bezsy = -(0.3)*(tempsinpre)/thisratio1;
                (this.child2).bezex = tempcos2;
                (this.child2).bezey = tempsin2;
                (this.child2).bezc1x = -0.2*(tempcospre)/thisratio1;
                (this.child2).bezc1y = -0.2*(tempsinpre)/thisratio1;
                (this.child2).bezc2x = 0.15*(tempcospre)/thisratio1;
                (this.child2).bezc2y = 0.15*(tempsinpre)/thisratio1;
                (this.child2).bezr = partl1;

                (this.child1).bezsx = -(0.3)*(tempcospre)/thisratio2;
                (this.child1).bezsy = -(0.3)*(tempsinpre)/thisratio2;
                (this.child1).bezex = tempcos3;
                (this.child1).bezey = tempsin3;
                (this.child1).bezc1x = 0.1*(tempcospre)/thisratio2;
                (this.child1).bezc1y = 0.1*(tempsinpre)/thisratio2;
                (this.child1).bezc2x = 0.9*tempcos3;
                (this.child1).bezc2y = 0.9*tempsin3;
                (this.child1).bezr = partl1;

                this.nextx2 = (1.3*Math.cos(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty2 = (1.3*Math.sin(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempsin90pre; // y reference point for both children
                this.nextx1 = (1.3*Math.cos(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty1 = (1.3*Math.sin(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempsin90pre; // y reference point for both children
            }

            this.arcx = this.bezex;
            this.arcy = this.bezey;
            this.arcr = (this.bezr)/2;

            if (this.child1)
            {
                if ((this.child1.richness_val) >= (this.child2.richness_val))
                {
                    this.child1.precalc (x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*thisratio1,angle + Math.PI*thisangleright);
                    this.child2.precalc (x+((r)*(this.nextx2)),y+(r)*(this.nexty2),r*thisratio2,angle - Math.PI*thisangleleft);
                }
                else
                {
                    this.child2.precalc (x+((r)*(this.nextx2)),y+(r)*(this.nexty2),r*thisratio1,angle + Math.PI*thisangleright);
                    this.child1.precalc (x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*thisratio2,angle - Math.PI*thisangleleft);
                }
            }
        }
        else
        {
            this.arcx = this.bezex+posmult*(tempcospre);
            this.arcy = this.bezey+posmult*(tempsinpre);
            this.arcr = leafmult*partc;
        }

    }


    midnode.prototype.precalc2 = function(x,y,r,angle)
    {
        this.arca = angle;
        var tempsinpre = Math.sin(angle);
        var tempcospre = Math.cos(angle);
        var tempsin90pre = Math.sin(angle + Math.PI/2.0);
        var tempcos90pre = Math.cos(angle + Math.PI/2.0);
        var atanpre;
        var atanpowpre;

        if (this.child1)
        {
            atanpre = Math.atan2((this.child1).richness_val,(this.child2).richness_val);
            atanpowpre = Math.atan2(Math.pow((this.child1).richness_val,0.5),Math.pow(((this.child2).richness_val),0.5));
        }

        var thisangleleft = 0.5;
        var thisangleright = 0.2;
        var thisratio1 = ratio1;
        var thisratio2 = ratio2;
        var thislinewidth1;
        var thislinewidth2;
        if ((this.richness_val > 1)&&((this.child1)&&(this.child2)))
        {
            if ((this.child1.richness_val) >= (this.child2.richness_val))
            {
                thisangleright = 0.45-(atanpre)/Math.PI/0.5*0.449;
                thisangleleft = 0.45-(0.5-(atanpre)/Math.PI)/0.5*0.449;
                thisratio1 = 0.3+(atanpowpre)/Math.PI/0.5*0.5;
                thisratio2 = 0.3+(0.5-(atanpowpre)/Math.PI)/0.5*0.5;
            }
            else
            {
                thisangleleft = 0.45-(atanpre)/Math.PI/0.5*0.449;
                thisangleright = 0.45-(0.5-(atanpre)/Math.PI)/0.5*0.449;
                thisratio2 = 0.3+(atanpowpre)/Math.PI/0.5*0.5;
                thisratio1 = 0.3+(0.5-(atanpowpre)/Math.PI)/0.5*0.5;
            }
        }

        if (this.child1)
        {
            thislinewidth1 = (this.child1.richness_val)/((this.child1.richness_val)+(this.child2.richness_val));
            thislinewidth2 = (this.child2.richness_val)/((this.child1.richness_val)+(this.child2.richness_val));
        }

        var tempsin2 = Math.sin(angle + Math.PI*thisangleright);
        var tempcos2 = Math.cos(angle + Math.PI*thisangleright);
        var tempsin3 = Math.sin(angle - Math.PI*thisangleleft);
        var tempcos3 = Math.cos(angle - Math.PI*thisangleleft);

        if (this.child1)
        {
            if ((this.child1.richness_val) >= (this.child2.richness_val))
            {
                this.nextr1 = thisratio1; // r (scale) reference for child 1
                this.nextr2 = thisratio2; // r (scale) reference for child 2

                (this.child1).bezsx = -(0.3)*(tempcospre)/thisratio1;
                (this.child1).bezsy = -(0.3)*(tempsinpre)/thisratio1;
                (this.child1).bezex = tempcos2;
                (this.child1).bezey = tempsin2;
                (this.child1).bezc1x = 0;
                (this.child1).bezc1y = 0;
                (this.child1).bezc2x = 0.9*tempcos2;
                (this.child1).bezc2y = 0.9*tempsin2;
                (this.child1).bezr = partl1;

                (this.child2).bezsx = -(0.3)*(tempcospre)/thisratio2;
                (this.child2).bezsy = -(0.3)*(tempsinpre)/thisratio2;
                (this.child2).bezex = tempcos3;
                (this.child2).bezey = tempsin3;
                (this.child2).bezc1x = 0;
                (this.child2).bezc1y = 0;
                (this.child2).bezc2x = 0.3*tempcos3;
                (this.child2).bezc2y = 0.3*tempsin3;
                (this.child2).bezr = partl1;

                this.nextx1 = (1.3*Math.cos(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty1 = (1.3*Math.sin(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempsin90pre; // y reference point for both children
                this.nextx2 = (1.3*Math.cos(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty2 = (1.3*Math.sin(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempsin90pre; // y reference point for both children
            }
            else
            {
                this.nextr2 = thisratio1; // r (scale) reference for child 1
                this.nextr1 = thisratio2; // r (scale) reference for child 2

                (this.child2).bezsx = -(0.3)*(tempcospre)/thisratio1;
                (this.child2).bezsy = -(0.3)*(tempsinpre)/thisratio1;
                (this.child2).bezex = tempcos2;
                (this.child2).bezey = tempsin2;
                (this.child2).bezc1x = 0;
                (this.child2).bezc1y = 0;
                (this.child2).bezc2x = 0.9*tempcos2;
                (this.child2).bezc2y = 0.9*tempsin2;
                (this.child2).bezr = partl1;

                (this.child1).bezsx = -(0.3)*(tempcospre)/thisratio2;
                (this.child1).bezsy = -(0.3)*(tempsinpre)/thisratio2;
                (this.child1).bezex = tempcos3;
                (this.child1).bezey = tempsin3;
                (this.child1).bezc1x = 0;
                (this.child1).bezc1y = 0;
                (this.child1).bezc2x = 0.9*tempcos3;
                (this.child1).bezc2y = 0.9*tempsin3;
                (this.child1).bezr = partl1;

                this.nextx2 = (1.3*Math.cos(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty2 = (1.3*Math.sin(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempsin90pre; // y reference point for both children
                this.nextx1 = (1.3*Math.cos(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty1 = (1.3*Math.sin(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempsin90pre; // y reference point for both children
            }

            this.arcx = this.bezex;
            this.arcy = this.bezey;
            this.arcr = (this.bezr)/2;

            if (this.child1)
            {
                if ((this.child1.richness_val) >= (this.child2.richness_val))
                {
                    this.child1.precalc2 (x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*thisratio1,angle + Math.PI*thisangleright);
                    this.child2.precalc2 (x+((r)*(this.nextx2)),y+(r)*(this.nexty2),r*thisratio2,angle - Math.PI*thisangleleft);
                }
                else
                {
                    this.child2.precalc2 (x+((r)*(this.nextx2)),y+(r)*(this.nexty2),r*thisratio1,angle + Math.PI*thisangleright);
                    this.child1.precalc2 (x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*thisratio2,angle - Math.PI*thisangleleft);
                }
            }
        }
        else
        {
            this.arcx = this.bezex+posmult*(tempcospre);
            this.arcy = this.bezey+posmult*(tempsinpre);
            this.arcr = leafmult*partc;
        }

    }

midnode.prototype.precalc4 = function(x,y,r,angle)
{
    this.arca = angle;
    var tempsinpre = Math.sin(angle);
    var tempcospre = Math.cos(angle);
    var tempsin90pre = Math.sin(angle + Math.PI/2.0);
    var tempcos90pre = Math.cos(angle + Math.PI/2.0);
    var atanpre;
    var atanpowpre;

    if (this.child1)
    {
        atanpre = Math.atan2((this.child1).richness_val,(this.child2).richness_val);
        atanpowpre = Math.atan2(Math.pow((this.child1).richness_val,0.5),Math.pow(((this.child2).richness_val),0.5));
    }

    var thisangleleft = 0.33;
    var thisangleright = 0.33;
    var thisratio1 = 0.61;
    var thisratio2 = 0.61;

    var tempsin2 = Math.sin(angle + Math.PI*thisangleright);
    var tempcos2 = Math.cos(angle + Math.PI*thisangleright);
    var tempsin3 = Math.sin(angle - Math.PI*thisangleleft);
    var tempcos3 = Math.cos(angle - Math.PI*thisangleleft);

    if (this.child1)
    {

        if ((this.child1.richness_val) >= (this.child2.richness_val))
        {

            this.nextr1 = thisratio1; // r (scale) reference for child 1
            this.nextr2 = thisratio2; // r (scale) reference for child 2

            (this.child1).bezsx = -(0.3)*(tempcospre)/thisratio1;
            (this.child1).bezsy = -(0.3)*(tempsinpre)/thisratio1;
            (this.child1).bezex = tempcos2;
            (this.child1).bezey = tempsin2;
            (this.child1).bezc1x = -0.3*(tempcospre)/thisratio1;
            (this.child1).bezc1y = -0.3*(tempsinpre)/thisratio1;
            (this.child1).bezc2x = 0.15*(tempcospre)/thisratio1;
            (this.child1).bezc2y = 0.15*(tempsinpre)/thisratio1;
            (this.child1).bezr = partl1;

            (this.child2).bezsx = -(0.3)*(tempcospre)/thisratio2;
            (this.child2).bezsy = -(0.3)*(tempsinpre)/thisratio2;
            (this.child2).bezex = tempcos3;
            (this.child2).bezey = tempsin3;
            (this.child2).bezc1x = 0.1*(tempcospre)/thisratio2;
            (this.child2).bezc1y = 0.1*(tempsinpre)/thisratio2;
            (this.child2).bezc2x = 0.9*tempcos3;
            (this.child2).bezc2y = 0.9*tempsin3;
            (this.child2).bezr = partl1;

            this.nextx1 = (1.3*Math.cos(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempcos90pre; // x refernece point for both children
            this.nexty1 = (1.3*Math.sin(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempsin90pre; // y reference point for both children
            this.nextx2 = (1.3*Math.cos(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempcos90pre; // x refernece point for both children
            this.nexty2 = (1.3*Math.sin(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempsin90pre; // y reference point for both children
        }
        else
        {
            this.nextr2 = thisratio1; // r (scale) reference for child 1
            this.nextr1 = thisratio2; // r (scale) reference for child 2

            (this.child2).bezsx = -(0.3)*(tempcospre)/thisratio1;
            (this.child2).bezsy = -(0.3)*(tempsinpre)/thisratio1;
            (this.child2).bezex = tempcos2;
            (this.child2).bezey = tempsin2;
            (this.child2).bezc1x = -0.2*(tempcospre)/thisratio1;
            (this.child2).bezc1y = -0.2*(tempsinpre)/thisratio1;
            (this.child2).bezc2x = 0.15*(tempcospre)/thisratio1;
            (this.child2).bezc2y = 0.15*(tempsinpre)/thisratio1;
            (this.child2).bezr = partl1;

            (this.child1).bezsx = -(0.3)*(tempcospre)/thisratio2;
            (this.child1).bezsy = -(0.3)*(tempsinpre)/thisratio2;
            (this.child1).bezex = tempcos3;
            (this.child1).bezey = tempsin3;
            (this.child1).bezc1x = 0.1*(tempcospre)/thisratio2;
            (this.child1).bezc1y = 0.1*(tempsinpre)/thisratio2;
            (this.child1).bezc2x = 0.9*tempcos3;
            (this.child1).bezc2y = 0.9*tempsin3;
            (this.child1).bezr = partl1;

            this.nextx2 = (1.3*Math.cos(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempcos90pre; // x refernece point for both children
            this.nexty2 = (1.3*Math.sin(angle))+(((this.bezr)-(partl1*thisratio1))/2.0)*tempsin90pre; // y reference point for both children
            this.nextx1 = (1.3*Math.cos(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempcos90pre; // x refernece point for both children
            this.nexty1 = (1.3*Math.sin(angle))-(((this.bezr)-(partl1*thisratio2))/2.0)*tempsin90pre; // y reference point for both children
        }

        this.arcx = this.bezex;
        this.arcy = this.bezey;
        this.arcr = (this.bezr)/2;

        if (this.child1)
        {
            if ((this.child1.richness_val) >= (this.child2.richness_val))
            {
                this.child1.precalc4 (x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*thisratio1,angle + Math.PI*thisangleright);
                this.child2.precalc4 (x+((r)*(this.nextx2)),y+(r)*(this.nexty2),r*thisratio2,angle - Math.PI*thisangleleft);
            }
            else
            {
                this.child2.precalc4 (x+((r)*(this.nextx2)),y+(r)*(this.nexty2),r*thisratio1,angle + Math.PI*thisangleright);
                this.child1.precalc4 (x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*thisratio2,angle - Math.PI*thisangleleft);
            }
        }
    }
    else
    {
        this.arcx = this.bezex+posmult*(tempcospre);
        this.arcy = this.bezey+posmult*(tempsinpre);
        this.arcr = leafmult*partc;
    }

}



    midnode.prototype.precalc3 = function(x,y,r,angle,dir)
    {
        this.arca = angle;
        var tempsinpre = Math.sin(angle);
        var tempcospre = Math.cos(angle);
        var tempsin90pre = Math.sin(angle + Math.PI/2.0);
        var tempcos90pre = Math.cos(angle + Math.PI/2.0);
        var atanpre;
        var atanpowpre;

        var thisangleleft = 0.2;
        var thisangleright = 0.1;
        var thisratio1 = 0.85;
        var thisratio2 = 0.42;
        var child1right = false;

        if (!dir)
        {
            var thisangleleft = 0.1;
            var thisangleright = 0.2;
            var thisratio1 = 0.42;
            var thisratio2 = 0.85;
            if (this.child1)
            {
                if ((this.child1.richness_val) < (this.child2.richness_val))
                {
                    child1right = true;
                }
            }
        }
        else
        {
            if (this.child1)
            {
                if ((this.child1.richness_val) >= (this.child2.richness_val))
                {
                    child1right = true;
                }
            }
        }

        var partl1a = partl1;
        var partl1b = partl1;
        var tempsin2 = Math.sin(angle + Math.PI*thisangleright);
        var tempcos2 = Math.cos(angle + Math.PI*thisangleright);
        var tempsin3 = Math.sin(angle - Math.PI*thisangleleft);
        var tempcos3 = Math.cos(angle - Math.PI*thisangleleft);

        if (this.child1)
        {

            if (child1right)
            {

                this.nextr1 = thisratio1; // r (scale) reference for child 1
                this.nextr2 = thisratio2; // r (scale) reference for child 2

                (this.child1).bezsx = -(0.3)*(tempcospre)/thisratio1;
                (this.child1).bezsy = -(0.3)*(tempsinpre)/thisratio1;
                (this.child1).bezex = tempcos2;
                (this.child1).bezey = tempsin2;
                (this.child1).bezc1x = -0.3*(tempcospre)/thisratio1;
                (this.child1).bezc1y = -0.3*(tempsinpre)/thisratio1;
                (this.child1).bezc2x = 0.15*(tempcospre)/thisratio1;
                (this.child1).bezc2y = 0.15*(tempsinpre)/thisratio1;
                (this.child1).bezr = partl1;

                (this.child2).bezsx = -(0.3)*(tempcospre)/thisratio2;
                (this.child2).bezsy = -(0.3)*(tempsinpre)/thisratio2;
                (this.child2).bezex = tempcos3;
                (this.child2).bezey = tempsin3;
                (this.child2).bezc1x = 0.1*(tempcospre)/thisratio2;
                (this.child2).bezc1y = 0.1*(tempsinpre)/thisratio2;
                (this.child2).bezc2x = 0.9*tempcos3;
                (this.child2).bezc2y = 0.9*tempsin3;
                (this.child2).bezr = partl1;

                this.nextx1 = (1.3*Math.cos(angle))+(((this.bezr)-(partl1a*thisratio1))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty1 = (1.3*Math.sin(angle))+(((this.bezr)-(partl1a*thisratio1))/2.0)*tempsin90pre; // y reference point for both children
                this.nextx2 = (1.3*Math.cos(angle))-(((this.bezr)-(partl1b*thisratio2))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty2 = (1.3*Math.sin(angle))-(((this.bezr)-(partl1b*thisratio2))/2.0)*tempsin90pre; // y reference point for both children
            }
            else
            {
                this.nextr2 = thisratio1; // r (scale) reference for child 1
                this.nextr1 = thisratio2; // r (scale) reference for child 2

                (this.child2).bezsx = -(0.3)*(tempcospre)/thisratio1;
                (this.child2).bezsy = -(0.3)*(tempsinpre)/thisratio1;
                (this.child2).bezex = tempcos2;
                (this.child2).bezey = tempsin2;
                (this.child2).bezc1x = -0.2*(tempcospre)/thisratio1;
                (this.child2).bezc1y = -0.2*(tempsinpre)/thisratio1;
                (this.child2).bezc2x = 0.15*(tempcospre)/thisratio1;
                (this.child2).bezc2y = 0.15*(tempsinpre)/thisratio1;
                (this.child2).bezr = partl1;

                (this.child1).bezsx = -(0.3)*(tempcospre)/thisratio2;
                (this.child1).bezsy = -(0.3)*(tempsinpre)/thisratio2;
                (this.child1).bezex = tempcos3;
                (this.child1).bezey = tempsin3;
                (this.child1).bezc1x = 0.1*(tempcospre)/thisratio2;
                (this.child1).bezc1y = 0.1*(tempsinpre)/thisratio2;
                (this.child1).bezc2x = 0.9*tempcos3;
                (this.child1).bezc2y = 0.9*tempsin3;
                (this.child1).bezr = partl1;

                this.nextx2 = (1.3*Math.cos(angle))+(((this.bezr)-(partl1a*thisratio1))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty2 = (1.3*Math.sin(angle))+(((this.bezr)-(partl1a*thisratio1))/2.0)*tempsin90pre; // y reference point for both children
                this.nextx1 = (1.3*Math.cos(angle))-(((this.bezr)-(partl1b*thisratio2))/2.0)*tempcos90pre; // x refernece point for both children
                this.nexty1 = (1.3*Math.sin(angle))-(((this.bezr)-(partl1b*thisratio2))/2.0)*tempsin90pre; // y reference point for both children
            }

            this.arcx = this.bezex;
            this.arcy = this.bezey;
            this.arcr = (this.bezr)/2;

            if (this.child1)
            {
                if (child1right)
                {
                    this.child1.precalc3 (x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*thisratio1,angle + Math.PI*thisangleright,!dir);
                    this.child2.precalc3 (x+((r)*(this.nextx2)),y+(r)*(this.nexty2),r*thisratio2,angle - Math.PI*thisangleleft,!dir);
                }
                else
                {
                    this.child2.precalc3 (x+((r)*(this.nextx2)),y+(r)*(this.nexty2),r*thisratio1,angle + Math.PI*thisangleright,!dir);
                    this.child1.precalc3 (x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*thisratio2,angle - Math.PI*thisangleleft,!dir);
                }
            }
        }
        else
        {
            this.arcx = this.bezex+posmult*0.9*(tempcospre);
            this.arcy = this.bezey+posmult*0.9*(tempsinpre);
            this.arcr = leafmult*partc*0.9;
        }
    }



    function update_form()
    {
        // updates the view and all variables to match the current viewtype
        //fulltree.clearroute();
        fulltree.drawreg(xp,yp,220*ws);
        fulltree.move2();

        fulltree.bezsx = 0; // start x position
        fulltree.bezsy = 0; // start y position
        fulltree.bezex = 0; // end x position
        fulltree.bezey = -1; // end y position
        fulltree.bezc1x = 0; // control point 1 x position
        fulltree.bezc1y = -0.05; // control point 2 y position
        fulltree.bezc2x = 0; // control point 2 x position
        fulltree.bezc2y = -0.95; // control point 2 y position
        fulltree.bezr = partl1; // line width

        if (viewtype == 2)
        {
            fulltree.precalc2(xp,yp,220*ws,Math.PI*3/2);
        }
        else
        {
            if (viewtype == 3)
            {
                fulltree.bezsx = -Math.sin(Math.PI*0.05); // start x position
                fulltree.bezsy = 0; // start y position
                fulltree.bezex = -Math.sin(Math.PI*0.05); // end x position
                fulltree.bezey = -Math.cos(Math.PI*0.05); // end y position
                fulltree.bezc1x = -Math.sin(Math.PI*0.05); // control point 1 x position
                fulltree.bezc1y = -0.05; // control point 2 y position
                fulltree.bezc2x = -Math.sin(Math.PI*0.05); // control point 2 x position
                fulltree.bezc2y = -0.95; // control point 2 y position
                fulltree.bezr = partl1; // line width
                fulltree.precalc3(xp,yp,220*ws,Math.PI*(3/2-0.05),true,true);
            }
            else
            {
                if (viewtype == 4)
                {
                    fulltree.precalc4(xp,yp,220*ws,Math.PI*3/2);
                }
                else
                {
                    fulltree.precalc(xp,yp,220*ws,Math.PI*3/2);

                }
            }
        }
        fulltree.calchorizon();
        fulltree.graphref = true;
        fulltree.reref();
        //fulltree.clearsearch();
        Resize_only();
        fulltree.deanchor();
        fulltree.reref();
        fulltree.move3(40,widthres-40,40,heightres-40);
        draw2();
    }

    // NODE OBJECT BASIC CALCULATIONS

    midnode.prototype.richness_calc = function()
    {
        if (this.child1)
        {
            this.richness_val =  (((this.child1).richness_calc())+((this.child2).richness_calc()));
        }
        else
        {
            if (this.richness_val <= 0)
            {
                this.richness_val = 1;
            }
        }
        return (this.richness_val);
    }

    midnode.prototype.concalc = function()
    {
        this.num_EX = 0;
        this.num_EW = 0;
        this.num_CR = 0;
        this.num_EN = 0;
        this.num_VU = 0;
        this.num_NT = 0;
        this.num_LC = 0;
        this.num_DD = 0;
        this.num_NE = 0;

        this.num_I = 0;
        this.num_D = 0;
        this.num_S = 0;
        this.num_U = 0;

        if (this.child1)
        {
            (this.child1).concalc();
            (this.child2).concalc();


            this.num_EX = ((this.child1).num_EX) + ((this.child2).num_EX);
            this.num_EW = ((this.child1).num_EW) + ((this.child2).num_EW);
            this.num_CR = ((this.child1).num_CR) + ((this.child2).num_CR);
            this.num_EN = ((this.child1).num_EN) + ((this.child2).num_EN);
            this.num_VU = ((this.child1).num_VU) + ((this.child2).num_VU);
            this.num_NT = ((this.child1).num_NT) + ((this.child2).num_NT);
            this.num_LC = ((this.child1).num_LC) + ((this.child2).num_LC);
            this.num_DD = ((this.child1).num_DD) + ((this.child2).num_DD);
            this.num_NE = ((this.child1).num_NE) + ((this.child2).num_NE);

            this.num_I = ((this.child1).num_I) + ((this.child2).num_I);
            this.num_D = ((this.child1).num_D) + ((this.child2).num_D);
            this.num_S = ((this.child1).num_S) + ((this.child2).num_S);
            this.num_U = ((this.child1).num_U) + ((this.child2).num_U);

        }
        else
        {
            this.num_EX = 0;
            this.num_EW = 0;
            this.num_CR = 0;
            this.num_EN = 0;
            this.num_VU = 0;
            this.num_NT = 0;
            this.num_LC = 0;
            this.num_DD = 0;
            this.num_NE = 0;

            this.num_I = 0;
            this.num_D = 0;
            this.num_S = 0;
            this.num_U = 0;

            if (this.redlist)
            {
                switch(this.redlist)
                {
                    case "EX":
                    {
                        this.num_EX = 1;
                        break;
                    }
                    case "EW":
                    {
                        this.num_EW = 1;
                        break;
                    }
                    case "CR":
                    {
                        this.num_CR = 1;
                        break;
                    }
                    case "EN":
                    {
                        this.num_EN = 1;
                        break;
                    }
                    case "VU":
                    {
                        this.num_VU = 1;
                        break;
                    }
                    case "NT":
                    {
                        this.num_NT = 1;
                        break;
                    }
                    case "LC":
                    {
                        this.num_LC = 1;
                        break;
                    }
                    case "DD":
                    {
                        this.num_DD = 1;
                        break;
                    }
                    case "NE":
                    {
                        this.num_NE = 1;
                        break;
                    }
                    default:
                    {
                        this.num_NE = 1;
                        break;
                    }
                }
            }
            else
            {
                this.num_NE = 1;
            }

            if (this.popstab)
            {
                switch(this.popstab)
                {
                    case "I":
                    {
                        this.num_I = 1;
                        break;
                    }
                    case "S":
                    {
                        this.num_S = 1;
                        break;
                    }
                    case "D":
                    {
                        this.num_D = 1;
                        break;
                    }
                    case "U":
                    {
                        this.num_U = 1;
                        break;
                    }
                    default:
                    {
                        this.num_U = 1;
                        break;
                    }
                }
            }
            else
            {
                this.num_U = 1;
            }

        }
    }

    midnode.prototype.name_calc = function()
    {
        if (this.child1)
        {
            if (((this.child1).name_calc())==((this.child2).name_calc()))
            {
                this.name2 = ((this.child1).name2);
            }
        }
        return (this.name2);
    }

    midnode.prototype.phylogeneticdiv_calc = function()
    {
        this.phylogenetic_diversity = 0;
        if (this.child1)
        {
            this.phylogenetic_diversity += (this.child2).phylogeneticdiv_calc();
            this.phylogenetic_diversity += (this.child1).phylogeneticdiv_calc();
        }
        return (this.phylogenetic_diversity + this.lengthbr);
    }

    midnode.prototype.age_calc = function()
    {
        if ((this.lengthbr == 0)&&(this.child1))
        {
            this.npolyt = false;
        }
        else
        {
            this.npolyt = true;
        }
        var length_temp;
        length_temp = (this.lengthbr);
        if (this.child1)
        {
            (this.lengthbr) = (this.child2).age_calc();
            (this.lengthbr) = (this.child1).age_calc();
            return ((length_temp)+(this.lengthbr));
        }
        else
        {
            (this.lengthbr) = 0;
            return (length_temp);
        }
    }

midnode.prototype.inlabel_calc = function(testname)
{

    if (this.child1)
    {
        if ((this.name2)&&(this.name2 != testname))
        {
            this.name1 = this.name2;
            this.child1.inlabel_calc(this.name1);
            this.child2.inlabel_calc(this.name1);
        }
        else
        {
            this.name2 = null;
            this.child1.inlabel_calc(testname);
            this.child2.inlabel_calc(testname);
        }

    }


}


    // DEEP ZOOM REREFERENCING METHODS (COMPLEX)

    // returns the product of all scaling factors so as to find out the total scaling difference
    midnode.prototype.mult = function ()
    {
        var multreturn;
        if (this.child1)
        {
            if (this.child1.graphref)
            {
                multreturn = (this.nextr1)*(this.child1.mult());
            }
            else
            {
                if (this.child2.graphref)
                {
                    multreturn = (this.nextr2)*(this.child2.mult());
                }
                else
                {
                    multreturn = 1;
                }
            }
        }
        else
        {
            multreturn = 1;
        }
        return multreturn;
    }

    midnode.prototype.reref = function()
    {
        if (this.onroute)
        {
            this.graphref = true;
            if (this.child1)
            {
                if (this.child1.onroute)
                {
                    this.child1.reref();
                }
                else
                {
                    this.child1.graphref = false;
                }
                if (this.child2.onroute)
                {
                    this.child2.reref();
                }
                else
                {
                    this.child2.graphref = false;
                }
            }
        }
    }

    midnode.prototype.calchorizon = function()
    {
        // find the bounding box for the bezier curve
        this.hxmax = this.bezsx;
        this.hxmin = this.bezsx;
        this.hymax = this.bezsy;
        this.hymin = this.bezsy;
        if (this.hxmax < this.bezc1x) { this.hxmax = this.bezc1x; }
        if (this.hxmin > this.bezc1x) { this.hxmin = this.bezc1x; }
        if (this.hymax < this.bezc1y) { this.hymax = this.bezc1y; }
        if (this.hymin > this.bezc1y) { this.hymin = this.bezc1y; }
        if (this.hxmax < this.bezc2x) { this.hxmax = this.bezc2x; }
        if (this.hxmin > this.bezc2x) { this.hxmin = this.bezc2x; }
        if (this.hymax < this.bezc2y) { this.hymax = this.bezc2y; }
        if (this.hymin > this.bezc2y) { this.hymin = this.bezc2y; }
        if (this.hxmax < this.bezex) { this.hxmax = this.bezex; }
        if (this.hxmin > this.bezex) { this.hxmin = this.bezex; }
        if (this.hymax < this.bezey) { this.hymax = this.bezey; }
        if (this.hymin > this.bezey) { this.hymin = this.bezey; }
        this.hxmax += this.bezr/2;
        this.hxmin -= this.bezr/2;
        this.hymax += this.bezr/2;
        this.hymin -= this.bezr/2;

        //expand the bounding box to include the arc if necessary
        if (this.hxmax < (this.arcx+this.arcr)) { this.hxmax = (this.arcx+this.arcr); }
        if (this.hxmin > (this.arcx-this.arcr)) { this.hxmin = (this.arcx-this.arcr); }
        if (this.hymax < (this.arcy+this.arcr)) { this.hymax = (this.arcy+this.arcr); }
        if (this.hymin > (this.arcy-this.arcr)) { this.hymin = (this.arcy-this.arcr); }
        // set the graphics bounding box before the horizon is expanded for children
        this.gxmax = this.hxmax;
        this.gxmin = this.hxmin;
        this.gymax = this.hymax;
        this.gymin = this.hymin;

        // check for children
        if(this.child1)
        {
            // if children calculate their horizons
            this.child1.calchorizon ();
            this.child2.calchorizon ();
            // and expand the bounding box if necessary
            if (this.hxmax < (this.nextx1+this.nextr1*this.child1.hxmax)) { this.hxmax = (this.nextx1+this.nextr1*this.child1.hxmax); }
            if (this.hxmin > (this.nextx1+this.nextr1*this.child1.hxmin)) { this.hxmin = (this.nextx1+this.nextr1*this.child1.hxmin); }
            if (this.hymax < (this.nexty1+this.nextr1*this.child1.hymax)) { this.hymax = (this.nexty1+this.nextr1*this.child1.hymax); }
            if (this.hymin > (this.nexty1+this.nextr1*this.child1.hymin)) { this.hymin = (this.nexty1+this.nextr1*this.child1.hymin); }
            if (this.hxmax < (this.nextx2+this.nextr2*this.child2.hxmax)) { this.hxmax = (this.nextx2+this.nextr2*this.child2.hxmax); }
            if (this.hxmin > (this.nextx2+this.nextr2*this.child2.hxmin)) { this.hxmin = (this.nextx2+this.nextr2*this.child2.hxmin); }
            if (this.hymax < (this.nexty2+this.nextr2*this.child2.hymax)) { this.hymax = (this.nexty2+this.nextr2*this.child2.hymax); }
            if (this.hymin > (this.nexty2+this.nextr2*this.child2.hymin)) { this.hymin = (this.nexty2+this.nextr2*this.child2.hymin); }
        }
    }

    midnode.prototype.reanchor = function ()
    {
        if (this.dvar)
        {
            this.graphref = true;
            if (((this.gvar)||(!(this.child1)))||((this.rvar/220>0.01)&&(this.rvar/220<100)))
            {
                // reanchor here
                xp = this.xvar;
                yp = this.yvar;
                ws = this.rvar/220;
                if (this.child1)
                {
                    this.child2.deanchor();
                    this.child1.deanchor();
                }
            }
            else
            {
                // reanchor somewhere down the line
                if (this.child1.dvar)
                {
                    this.child1.reanchor();
                    this.child2.deanchor();

                }
                else
                {
                    this.child2.reanchor();
                    this.child1.deanchor();
                }
            }
        }
        // else not possible to reanchor
    }

    midnode.prototype.deanchor = function ()
    {
        if (this.graphref)
        {
            if (this.child1)
            {
                this.child1.deanchor();
                this.child2.deanchor();
            }
            this.graphref = false;
        }
    }

    midnode.prototype.drawreg = function(x,y,r)
    {
        // we assume that only those for whom graphref is true will call this routine
        if (this.child1)
        {
            // we are not a leaf and we are referencing - check children
            if (this.child1.graphref)
            {
                // child 1 leads to (or is) the referencing node
                this.child1.drawreg(x,y,r);
                this.rvar = this.child1.rvar/this.nextr1;
                this.xvar = this.child1.xvar-this.rvar*this.nextx1;
                this.yvar = this.child1.yvar-this.rvar*this.nexty1;
                this.dvar = false;
                this.child2.gvar = false;
                this.child2.dvar = false;

                if(((!((((this.xvar+(this.rvar*this.hxmax))<0)||((this.xvar+(this.rvar*this.hxmin))>widthres))||(((this.yvar+(this.rvar*this.hymax))<0)||((this.yvar+(this.rvar*this.hymin))>heightres))))))
                {
                    if (this.rvar > threshold)
                    {

                        this.child2.drawreg2 (this.xvar+((this.rvar)*(this.nextx2)),this.yvar+(this.rvar)*(this.nexty2),this.rvar*this.nextr2);
                    }

                    if(((((this.xvar+(this.rvar*this.gxmax))<0)||((this.xvar+(this.rvar*this.gxmin))>widthres))||(((this.yvar+(this.rvar*this.gymax))<0)||((this.yvar+(this.rvar*this.gymin))>heightres))))
                    {
                        this.gvar = false;
                    }
                    else
                    {
                        this.gvar = true;
                        this.dvar = true;
                    }
                    if (this.rvar <= threshold)
                    {
                        this.child1.gvar = false;
                        this.child2.gvar = false;
                        this.child1.dvar = false;
                        this.child2.dvar = false;
                    }
                }
                else
                {
                    this.gvar = false;
                }

                if ((this.child1.dvar)||(this.child2.dvar))
                {
                    this.dvar = true;
                }

            }
            else
            {
                if (this.child2.graphref)
                {
                    // child 2 leads to (or is) the referencing node
                    this.child2.drawreg(x,y,r);
                    this.rvar = this.child2.rvar/this.nextr2;
                    this.xvar = this.child2.xvar-this.rvar*this.nextx2;
                    this.yvar = this.child2.yvar-this.rvar*this.nexty2;
                    this.dvar = false;
                    this.child1.gvar = false;
                    this.child1.dvar = false;

                    if(((!((((this.xvar+(this.rvar*this.hxmax))<0)||((this.xvar+(this.rvar*this.hxmin))>widthres))||(((this.yvar+(this.rvar*this.hymax))<0)||((this.yvar+(this.rvar*this.hymin))>heightres))))))
                    {
                        if (this.rvar > threshold)
                        {
                            this.child1.drawreg2 (this.xvar+((this.rvar)*(this.nextx1)),this.yvar+(this.rvar)*(this.nexty1),this.rvar*this.nextr1);
                        }

                        if(((((this.xvar+(this.rvar*this.gxmax))<0)||((this.xvar+(this.rvar*this.gxmin))>widthres))||(((this.yvar+(this.rvar*this.gymax))<0)||((this.yvar+(this.rvar*this.gymin))>heightres))))
                        {
                            this.gvar = false;
                        }
                        else
                        {
                            this.gvar = true;

                            this.dvar = true;
                        }

                        if (this.rvar <= threshold)
                        {
                            this.child1.gvar = false;
                            this.child2.gvar = false;
                            this.child1.dvar = false;
                            this.child2.dvar = false;
                        }
                    }
                    else
                    {
                        this.gvar = false;
                    }

                    if ((this.child1.dvar)||(this.child2.dvar))
                    {
                        this.dvar = true;
                    }
                }
                else
                {
                    // we are the referencing node so call drawreg2
                    this.drawreg2(x,y,r);
                }
            }
        }
        else
        {
            // we are a leaf and we are referencing - we are the referencing node so record x,y,r
            this.drawreg2(x,y,r); //does all we need and will automatically skip any child commands
        }
    }

    midnode.prototype.drawreg2 = function(x,y,r)
    {
        this.xvar = x;
        this.yvar = y;
        this.rvar = r;
        this.dvar = false;
        if(((!((((x+(r*this.hxmax))<0)||((x+(r*this.hxmin))>widthres))||(((y+(r*this.hymax))<0)||((y+(r*this.hymin))>heightres))))))
        {
            if (this.child1)
            {
                if (r > threshold)
                {
                    this.child1.drawreg2 (x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*this.nextr1);
                    this.child2.drawreg2 (x+((r)*(this.nextx2)),y+(r)*(this.nexty2),r*this.nextr2);
                }
                else
                {
                    this.child1.gvar = false;
                    this.child1.dvar = false;
                    this.child2.gavr = false;
                    this.child2.dvar = false;
                }

                if ((this.child1.dvar)||(this.child2.dvar))
                {
                    this.dvar = true;
                }
            }
            if(((((x+(r*this.gxmax))<0)||((x+(r*this.gxmin))>widthres))||(((y+(r*this.gymax))<0)||((y+(r*this.gymin))>heightres))))
            {
                this.gvar = false;
            }
            else
            {
                this.gvar = true;
                this.dvar = true;

            }
        }
        else
        {
            this.gvar = false;
        }
    }

    // SEARCH UTILITIES

    midnode.prototype.search = function()
    {

        // initialize the search variables to the default (wipe previous searches)
        this.startscore = 0;
        this.targeted = false;
        this.searchinpast = 0;
        this.flysofarA = false;
        this.flysofarB = false;
        var temphitsa = 0;

        if (this.child1)
        {
            temphitsa += (this.child1).search();
            temphitsa += (this.child2).search();
        }
        if (temphitsa == 0)
        {

            var thishit = true;
            for (i = 0 ; i < searchinparts.length ; i ++)
            {
                if (!(this.searchone(searchinparts[i],false)))
                {
                    thishit = false;
                }
            }
            if (thishit)
            {
                temphitsa += this.richness_val;
            }
        }


        this.searchin = temphitsa;
        return temphitsa;
    }


    midnode.prototype.searchtarget = function()
    {
        // go down richerside and then use density as decider
        // keep going until density reaches threshold
        var searchresult = -1;
        if ((this.searchin-this.searchinpast)>0)
        {
            if (((this.searchin-this.searchinpast) / (this.richness_val))>0.7)
            {
                this.targeted = true;
                if ((this.child1)&&(((this.child1).searchin > 0)||((this.child2).searchin > 0)))
                {
                    if ((((this.child1).searchin)-((this.child1).searchinpast)) <= 0)
                    {
                        var returned = (this.child2).searchtarget();

                        searchresult = returned;
                    }
                    else
                    {
                        if ((((this.child2).searchin)-((this.child2).searchinpast)) <= 0)
                        {
                            var returned = (this.child1).searchtarget();

                            searchresult = returned;
                        }
                        else
                        {
                            searchresult = this.searchin;
                        }
                    }
                }
                else
                {
                    searchresult = this.searchin;
                }
            }
            else
            {
                if (this.child1)
                {
                    var searchresult1 = this.child1.searchtarget();
                    var searchresult2 = this.child2.searchtarget();
                }
                if (searchresult1 > searchresult2)
                {
                    this.child1.targeted = true;
                    this.child2.targeted = false;
                    searchresult = searchresult1;
                }
                else
                {
                    this.child2.targeted = true;
                    this.child1.targeted = false;
                    searchresult = searchresult2;
                }
            }
        }
        return (searchresult);
    }

    midnode.prototype.searchtargetmark = function()
    {
        var searchresult = -1;
        if (this.targeted)
        {
            searchresult = this.searchin;
            if (this.child1)
            {
                if (this.child1.targeted)
                {
                    searchresult = this.child1.searchtargetmark();
                }
                else
                {
                    if (this.child2.targeted)
                    {
                        searchresult = this.child2.searchtargetmark();
                    }
                }
            }
            this.searchinpast += searchresult;
        }
        return (searchresult);
    }

    midnode.prototype.clearsearch = function ()
    {
        (this.searchin) = 0;
        this.targeted = false;
        this.searchinpast = 0;
        this.flysofarA = false;
        this.flysofarB = false;
        if (this.child1)
        {
            (this.child1).clearsearch();
            (this.child2).clearsearch();
        }
    }

    midnode.prototype.clearroute = function ()
    {
        this.onroute = false;
        if (this.child1)
        {
            (this.child1).clearroute();
            (this.child2).clearroute();
        }
    }

    midnode.prototype.semiclearsearch = function ()
    {
        this.targeted = false;
        this.flysofarA = false;
        this.flysofarB = false;
        if (this.child1)
        {
            (this.child1).semiclearsearch();
            (this.child2).semiclearsearch();
        }
    }

    midnode.prototype.setxyr = function(x,y,r,xtargmin,xtargmax,ytargmin,ytargmax,movement,propmove)
    {
        var vxmax;
        var vxmin;
        var vymax;
        var vymin;
        if (this.child1)
        {
            if (movement != 2)
            {
                vxmax = x+r*this.nextx1 + r*this.nextr1*this.child1.hxmax;

                vxmin = x+r*this.nextx1 + r*this.nextr1*this.child1.hxmin;

                vymax = y+r*this.nexty1 + r*this.nextr1*this.child1.hymax;

                vymin = y+r*this.nexty1 + r*this.nextr1*this.child1.hymin;
                if (movement != 1)
                {

                    if (vxmax < (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmax))
                    {
                        vxmax = (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmax);
                    }
                    if (vxmin > (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmin))
                    {
                        vxmin = (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmin);
                    }
                    if (vymax < (y+r*this.nexty2 + r*this.nextr2*this.child2.hymax))
                    {
                        vymax = (y+r*this.nexty2 + r*this.nextr2*this.child2.hymax);
                    }
                    if (vymin > (y+r*this.nexty2 + r*this.nextr2*this.child2.hymin))
                    {
                        vymin = (y+r*this.nexty2 + r*this.nextr2*this.child2.hymin);
                    }
                }
            }
            else
            {
                vxmax = x+r*this.nextx2 + r*this.nextr2*this.child2.hxmax;
                vxmin = x+r*this.nextx2 + r*this.nextr2*this.child2.hxmin;
                vymax = y+r*this.nexty2 + r*this.nextr2*this.child2.hymax;
                vymin = y+r*this.nexty2 + r*this.nextr2*this.child2.hymin;
            }
        }
        else
        {
            vxmax = (x+r*(this.arcx+this.arcr));
            vxmin = (x+r*(this.arcx-this.arcr));
            vymax = (y+r*(this.arcy+this.arcr));
            vymin = (y+r*(this.arcy-this.arcr));
        }

        if (vxmax < (x+r*(this.bezsx+this.bezex)/2)) { vxmax = (x+r*(this.bezsx+this.bezex)/2); }
        if (vxmin > (x+r*(this.bezsx+this.bezex)/2)) { vxmin = (x+r*(this.bezsx+this.bezex)/2); }
        if (vymax < (y+r*(this.bezsy+this.bezey)/2)) { vymax = (y+r*(this.bezsy+this.bezey)/2); }
        if (vymin > (y+r*(this.bezsy+this.bezey)/2)) { vymin = (y+r*(this.bezsy+this.bezey)/2); }

        var ywsmult = ((ytargmax-ytargmin)/(vymax-vymin));//propmove;
        // the number we need to multply ws by to get the right size for a vertical fit
        var xwsmult = ((xtargmax-xtargmin)/(vxmax-vxmin));//propmove;
        // the number we need to multply ws by to get the right size for a horizontal fit
        var wsmult;
        if (ywsmult > xwsmult)
        {
            // we use xwsmult - the smaller
            wsmult = xwsmult;
        }
        else
        {
            // we use ywsmult - the smaller
            wsmult = ywsmult;
        }
        xp += (((xtargmax+xtargmin)/2.0)-((vxmax+vxmin)/2.0));
        yp += (((ytargmax+ytargmin)/2.0)-((vymax+vymin)/2.0));
        ws = ws*wsmult;
        xp = widthres/2 + (xp-widthres/2)*wsmult;
        yp = heightres/2 + (yp-heightres/2)*wsmult;
    }

    midnode.prototype.setxyr3r = function(xtargmin,xtargmax,ytargmin,ytargmax)
    {

        ws = 1;
        xp = widthres/2;
        yp = heightres;
        var x = xp;
        var y = yp;
        var r = 220*ws;

        var vxmax;
        var vxmin;
        var vymax;
        var vymin;

        if (this.child1)
        {
            vxmax = x+r*this.nextx1 + r*this.nextr1*this.child1.hxmax;
            vxmin = x+r*this.nextx1 + r*this.nextr1*this.child1.hxmin;
            vymax = y+r*this.nexty1 + r*this.nextr1*this.child1.hymax;
            vymin = y+r*this.nexty1 + r*this.nextr1*this.child1.hymin;
            if (vxmax < (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmax))
            {
                vxmax = (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmax);
            }
            if (vxmin > (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmin))
            {
                vxmin = (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmin);
            }
            if (vymax < (y+r*this.nexty2 + r*this.nextr2*this.child2.hymax))
            {
                vymax = (y+r*this.nexty2 + r*this.nextr2*this.child2.hymax);
            }
            if (vymin > (y+r*this.nexty2 + r*this.nextr2*this.child2.hymin))
            {
                vymin = (y+r*this.nexty2 + r*this.nextr2*this.child2.hymin);
            }
        }
        else
        {
            vxmax = (x+r*(this.arcx+this.arcr));
            vxmin = (x+r*(this.arcx-this.arcr));
            vymax = (y+r*(this.arcy+this.arcr));
            vymin = (y+r*(this.arcy-this.arcr));
        }
        if (vxmax < (x+r*(this.bezsx+this.bezex)/2)) { vxmax = (x+r*(this.bezsx+this.bezex)/2); }
        if (vxmin > (x+r*(this.bezsx+this.bezex)/2)) { vxmin = (x+r*(this.bezsx+this.bezex)/2); }
        if (vymax < (y+r*(this.bezsy+this.bezey)/2)) { vymax = (y+r*(this.bezsy+this.bezey)/2); }
        if (vymin > (y+r*(this.bezsy+this.bezey)/2)) { vymin = (y+r*(this.bezsy+this.bezey)/2); }

        var ywsmult = ((ytargmax-ytargmin)/(vymax-vymin));//propmove;
        // the number we need to multply ws by to get the right size for a vertical fit
        var xwsmult = ((xtargmax-xtargmin)/(vxmax-vxmin));//propmove;
        // the number we need to multply ws by to get the right size for a horizontal fit
        var wsmult;
        if (ywsmult > xwsmult)
        {
            // we use xwsmult - the smaller
            wsmult = xwsmult;
        }
        else
        {
            // we use ywsmult - the smaller
            wsmult = ywsmult;
        }

        xp += (((xtargmax+xtargmin)/2.0)-((vxmax+vxmin)/2.0));//*((1-(1/wsmult))/(1-(Math.pow((1/wsmult),propmove))));
        yp += (((ytargmax+ytargmin)/2.0)-((vymax+vymin)/2.0));//*((1-(1/wsmult))/(1-(Math.pow((1/wsmult),propmove))));

        ws = ws*wsmult;
        xp = widthres/2 + (xp-widthres/2)*wsmult;
        yp = heightres/2 + (yp-heightres/2)*wsmult;
    }

    midnode.prototype.setxyr2 = function(x,y,r,xtargmin,xtargmax,ytargmin,ytargmax,movement,propmove,flynum)
    {
        var vxmax;
        var vxmin;
        var vymax;
        var vymin;
        if (movement != 3)
        {
            vxmax = (x+r*(this.fxmax));//(x+r*(this.arcx+this.arcr));
            vxmin = (x+r*(this.fxmin));
            vymax = (y+r*(this.fymax));
            vymin = (y+r*(this.fymin));
        }
        else
        {
            if (this.child1)
            {
                vxmax = x+r*this.nextx1 + r*this.nextr1*this.child1.hxmax;
                vxmin = x+r*this.nextx1 + r*this.nextr1*this.child1.hxmin;
                vymax = y+r*this.nexty1 + r*this.nextr1*this.child1.hymax;
                vymin = y+r*this.nexty1 + r*this.nextr1*this.child1.hymin;
                if (vxmax < (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmax))
                {
                    vxmax = (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmax);
                }
                if (vxmin > (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmin))
                {
                    vxmin = (x+r*this.nextx2 + r*this.nextr2*this.child2.hxmin);
                }
                if (vymax < (y+r*this.nexty2 + r*this.nextr2*this.child2.hymax))
                {
                    vymax = (y+r*this.nexty2 + r*this.nextr2*this.child2.hymax);
                }
                if (vymin > (y+r*this.nexty2 + r*this.nextr2*this.child2.hymin))
                {
                    vymin = (y+r*this.nexty2 + r*this.nextr2*this.child2.hymin);
                }
            }
            else
            {
                vxmax = (x+r*(this.arcx+this.arcr));
                vxmin = (x+r*(this.arcx-this.arcr));
                vymax = (y+r*(this.arcy+this.arcr));
                vymin = (y+r*(this.arcy-this.arcr));
            }
            if (vxmax < (x+r*(this.bezsx+this.bezex)/2)) { vxmax = (x+r*(this.bezsx+this.bezex)/2); }
            if (vxmin > (x+r*(this.bezsx+this.bezex)/2)) { vxmin = (x+r*(this.bezsx+this.bezex)/2); }
            if (vymax < (y+r*(this.bezsy+this.bezey)/2)) { vymax = (y+r*(this.bezsy+this.bezey)/2); }
            if (vymin > (y+r*(this.bezsy+this.bezey)/2)) { vymin = (y+r*(this.bezsy+this.bezey)/2); }
        }

        var ywsmult = ((ytargmax-ytargmin)/(vymax-vymin));//propmove;
        // the number we need to multply ws by to get the right size for a vertical fit
        var xwsmult = ((xtargmax-xtargmin)/(vxmax-vxmin));//propmove;
        // the number we need to multply ws by to get the right size for a horizontal fit
        var wsmult;
        if (ywsmult > xwsmult)
        {
            // we use xwsmult - the smaller
            wsmult = xwsmult;
        }
        else
        {
            // we use ywsmult - the smaller
            wsmult = ywsmult;
        }

        wsmult =Math.pow(wsmult,(1.0/propmove));
        var xpadd;
        var ypadd;

        if (Math.abs(wsmult-1) < 0.000001)
        {
            xpadd = (((xtargmax+xtargmin)/2.0)-((vxmax+vxmin)/2.0));//*((1-(1/wsmult))/(1-(Math.pow((1/wsmult),propmove))));
            ypadd = (((ytargmax+ytargmin)/2.0)-((vymax+vymin)/2.0));//*((1-(1/wsmult))/(1-(Math.pow((1/wsmult),propmove))));
        }
        else
        {
            xpadd = (((xtargmax+xtargmin)/2.0)-((vxmax+vxmin)/2.0))*((1-(1/wsmult))/(1-(Math.pow((1/wsmult),propmove))));
            ypadd = (((ytargmax+ytargmin)/2.0)-((vymax+vymin)/2.0))*((1-(1/wsmult))/(1-(Math.pow((1/wsmult),propmove))));
        }
        xp+= xpadd;
        yp+= ypadd;
        ws = ws*wsmult;
        xp = widthres/2 + (xp-widthres/2)*wsmult;
        yp = heightres/2 + (yp-heightres/2)*wsmult;
    }

    midnode.prototype.move = function(xtargmin,xtargmax,ytargmin,ytargmax)
    {
        if (this.targeted)
        {
            this.graphref = true;
            if (this.child1)
            {
                if (this.child1.targeted)
                {
                    this.child1.move(xtargmin,xtargmax,ytargmin,ytargmax);
                }
                else
                {
                    if (this.child2.targeted)
                    {
                        this.child2.move(xtargmin,xtargmax,ytargmin,ytargmax);
                    }
                    else
                    {
                        this.setxyr3r(40,widthres-40,40,heightres-40);
                        this.setxyr3r(40,widthres-40,40,heightres-40);
                    }
                }
            }
            else
            {
                this.setxyr3r(40,widthres-40,40,heightres-40);
                this.setxyr3r(40,widthres-40,40,heightres-40);
            }
        }
    }

    midnode.prototype.move3 = function(xtargmin,xtargmax,ytargmin,ytargmax)
    {
        if (this.onroute)
        {
            if (this.child1)
            {
                if (this.child1.onroute)
                {
                    this.child1.move3(xtargmin,xtargmax,ytargmin,ytargmax);
                }
                else
                {
                    if (this.child2.onroute)
                    {
                        this.child2.move3(xtargmin,xtargmax,ytargmin,ytargmax);
                    }
                    else
                    {
                        this.setxyr3r(40,widthres-40,40,heightres-40);
                        this.setxyr3r(40,widthres-40,40,heightres-40);
                    }
                }
            }
            else
            {
                this.setxyr3r(40,widthres-40,40,heightres-40);
                this.setxyr3r(40,widthres-40,40,heightres-40);
            }
        }
    }

    midnode.prototype.move2 = function()
    {
        if (this.dvar)
        {
            this.onroute = true;
            if ((!(this.gvar))&&(this.child1))
            {
                if (!((this.child1.dvar)&&(this.child2.dvar)))
                {
                    if (this.child1.dvar)
                    {
                        this.child1.move2();
                    }
                    else
                    {
                        if (this.child2.dvar)
                        {
                            this.child2.move2();
                        }
                    }
                }
            }
        }
    }

    midnode.prototype.clearonroute = function()
    {
        this.onroute = false;
        if (this.child1)
        {
            (this.child1).clearonroute();
            (this.child2).clearonroute();
        }
    }

    midnode.prototype.flyFB = function(xtargmin,xtargmax,ytargmin,ytargmax)
    {
        var x = this.xvar;
        var y = this.yvar;
        var r = this.rvar;
        if (this.targeted)
        {
            if (this.flysofarB)
            {
                if (this.child1)
                {
                    if (this.child1.targeted)
                    {
                        this.child1.flyFB(xtargmin,xtargmax,ytargmin,ytargmax);
                    }
                    else
                    {
                        if (this.child2.targeted)
                        {
                            this.child2.flyFB(xtargmin,xtargmax,ytargmin,ytargmax);
                        }
                        else
                        {
                            if (this.flysofarB )
                            {
                                if (flying)
                                {
                                    clearTimeout(t);
                                    fulltree.searchtargetmark();
                                    flying = false;
                                }
                            }
                            else
                            {
                                this.setxyr2(x,y,r,xtargmin,xtargmax,ytargmin,ytargmax,3,countdownB,2);
                                if (countdownB <= 1)
                                {
                                    this.flysofarB = true;

                                    countdownB = 6;

                                }
                                else
                                {
                                    countdownB --;
                                }
                            }
                        }
                    }
                }
                else
                {
                    if (this.flysofarB )
                    {
                        if (flying)
                        {
                            clearTimeout(t);
                            fulltree.searchtargetmark();
                            flying = false;
                        }
                    }
                    else
                    {
                        this.setxyr2(x,y,r,xtargmin,xtargmax,ytargmin,ytargmax,3,countdownB,2);
                        if (countdownB <= 1)
                        {
                            this.flysofarB = true;

                            countdownB = 6;

                        }
                        else
                        {
                            countdownB --;
                        }
                    }
                }
            }
            else
            {
                if (this.child1)
                {
                    if (this.child1.targeted)
                    {
                        this.setxyr2(x,y,r,xtargmin,xtargmax,ytargmin,ytargmax,1,countdownB,2);
                        if (countdownB <= 1)
                        {
                            this.flysofarB = true;
                            countdownB = 6;

                        }
                        else
                        {
                            countdownB --;
                        }
                    }
                    else
                    {
                        if (this.child2.targeted)
                        {
                            this.setxyr2(x,y,r,xtargmin,xtargmax,ytargmin,ytargmax,2,countdownB,2);
                            if (countdownB <= 1)
                            {
                                this.flysofarB = true;

                                countdownB = 6;

                            }
                            else
                            {
                                countdownB --;
                            }
                        }
                        else
                        {

                            if (this.flysofarB )
                            {
                                if (flying)
                                {
                                    clearTimeout(t);
                                    fulltree.searchtargetmark();
                                    flying = false;
                                }
                            }
                            else
                            {
                                this.setxyr2(x,y,r,xtargmin,xtargmax,ytargmin,ytargmax,3,countdownB,2);
                                if (countdownB <= 1)
                                {
                                    this.flysofarB = true;

                                    countdownB = 6;

                                }
                                else
                                {
                                    countdownB --;
                                }
                            }
                        }
                    }
                }
                else
                {
                    if (this.flysofarB )
                    {
                        if (flying)
                        {
                            clearTimeout(t);
                            fulltree.searchtargetmark();
                            flying = false;
                        }
                    }
                    else
                    {
                        this.setxyr2(x,y,r,xtargmin,xtargmax,ytargmin,ytargmax,3,countdownB,2);
                        if (countdownB <= 1)
                        {
                            this.flysofarB = true;

                            countdownB = 6;

                        }
                        else
                        {
                            countdownB --;
                        }
                    }
                }
            }
        }
    }

    midnode.prototype.prepfly = function(x,y,r)
    {
        if (this.targeted)
        {
            this.fxmax = this.gxmax;
            this.fxmin = this.gxmin;
            this.fymax = this.gymax;
            this.fymin = this.gymin;

            // nothing to do otherwise
            if (this.child1)
            {
                if (this.child1.targeted)
                {
                    this.child1.prepfly(x+r*this.nextx1,y+r*this.nexty1,r*this.nextr1);
                    if (this.fxmax < (this.nextx1+this.nextr1*this.child1.fxmax)) { this.fxmax = (this.nextx1+this.nextr1*this.child1.fxmax) }
                    if (this.fxmin > (this.nextx1+this.nextr1*this.child1.fxmin)) { this.fxmin = (this.nextx1+this.nextr1*this.child1.fxmin) }
                    if (this.fymax < (this.nexty1+this.nextr1*this.child1.fymax)) { this.fymax = (this.nexty1+this.nextr1*this.child1.fymax) }
                    if (this.fymin > (this.nexty1+this.nextr1*this.child1.fymin)) { this.fymin = (this.nexty1+this.nextr1*this.child1.fymin) }

                }
                else
                {
                    if (this.child2.targeted)
                    {
                        this.child2.prepfly(x+r*this.nextx2,y+r*this.nexty2,r*this.nextr2);
                        if (this.fxmax < (this.nextx2+this.nextr2*this.child2.fxmax)) { this.fxmax = (this.nextx2+this.nextr2*this.child2.fxmax) }
                        if (this.fxmin > (this.nextx2+this.nextr2*this.child2.fxmin)) { this.fxmin = (this.nextx2+this.nextr2*this.child2.fxmin) }
                        if (this.fymax < (this.nexty2+this.nextr2*this.child2.fymax)) { this.fymax = (this.nexty2+this.nextr2*this.child2.fymax) }
                        if (this.fymin > (this.nexty2+this.nextr2*this.child2.fymin)) { this.fymin = (this.nexty2+this.nextr2*this.child2.fymin) }

                    }
                    else
                    {
                        this.fxmax = this.hxmax;
                        this.fxmin = this.hxmin;
                        this.fymax = this.hymax;
                        this.fymin = this.hymin;
                    }
                }
            }
            else
            {
                this.fxmax = this.hxmax;
                this.fxmin = this.hxmin;
                this.fymax = this.hymax;
                this.fymin = this.hymin;
            }
        }
    }

    function marksearch()
    {
        if ((! flying) && (document.getElementById("searchtf").value!=""))
        {
        performsearch2(false);
            highlight_search = (document.forms["myform"]["domarksearch"].checked);
            if(fulltree.searchin == 1)
            {
                document.getElementById("numhittxt").innerHTML= ('1 hit');
            }
            else
            {
                if(fulltree.searchin <= 0)
                {
                    document.getElementById("numhittxt").innerHTML= ('no hits');
                }
                else
                {
                    document.getElementById("numhittxt").innerHTML= ((fulltree.searchin).toString() + ' hits');
                }
            }
            document.getElementById("numhittxt").style.display = '';
            if ((document.forms["myform"]["flightsearch"].checked))
            {
                performfly();
        }
        else
        {
            performleap();
        }
        draw2();
        }
    }

function marksearchchange()
{
    highlight_search = (document.forms["myform"]["domarksearch"].checked);
    draw2();
}

    function unmarksearch()
{
    if (highlight_search)
    {
        highlight_search = false;
    }
    else
    {
        highlight_search = true;
    }
    draw2();
}

    function performclear()
    {
        highlight_search = false;
        searchinparts = [];
        context.clearRect(0,0, widthres,heightres);
        draw2();
    }

    function performfly()
    {
        if (!flying)
        {
            fulltree.deanchor();
            fulltree.graphref = true;
            fulltree.setxyr(xp,yp,220*ws,20,widthres-2,20,heightres,0,1);
            fulltree.setxyr(xp,yp,220*ws,20,widthres-2,20,heightres,0,1);
            wsinit = ws;
            draw2();
            fulltree.semiclearsearch();

            flying = true;


            performsearch2(false);

            if (fulltree.searchtarget() == -1)
            {
                searchinparts = [];
                performsearch2(false);
                fulltree.searchtarget()
            }
            fulltree.targeted = true;
            //fulltree.searchtargetmark();
            countdownB = 12;
            fulltree.flysofarB = true;
            if (fulltree.child1)
            {
                if (fulltree.child1.targeted)
                {
                    if (((fulltree.child1).child1)&&((fulltree.child1).child1.targeted||(fulltree.child1).child2.targeted))
                    {
                        fulltree.child1.flysofarB = true;
                    }
                }
                if (fulltree.child2.targeted)
                {
                    if (((fulltree.child2).child1)&&((fulltree.child2).child1.targeted||(fulltree.child2).child2.targeted))
                    {
                        fulltree.child2.flysofarB = true;
                    }
                }
            }
            fulltree.prepfly(xp,yp,220*ws,5);
            performfly2();
        }
    }

    function performfly2()
    {
        fulltree.drawreg(xp,yp,220*ws);
        fulltree.flyFB(40,widthres-40,40,heightres-40);
        draw2();
        if (flying)
        {
            t = setTimeout('performfly2()',100);
        }
    }

    function performleap()
    {
        clearTimeout(t);
        flying = false;
        performsearch2(false);
        if (fulltree.searchtarget() == -1)
        {
            searchinparts = [];
            performsearch2(true);
            fulltree.searchtarget()
        }
        fulltree.targeted = true;
        fulltree.searchtargetmark();
        fulltree.deanchor();
        fulltree.move(40,widthres-40,40,heightres-40);
        draw2();
    }

    // GROW OPTIONS

    midnode.prototype.oldest = function()
    {
        var oldestreturn = 0.0;
        if(this.dvar)
        {
            if(this.gvar)
            {
                if (this.lengthbr)
                {
                    if ( this.lengthbr > oldestreturn )
                    {
                        oldestreturn = this.lengthbr;
                    }
                }
            }
            if (this.child1)
            {
                var oldestc1 = this.child1.oldest ();
                var oldestc2 = this.child2.oldest ();
                if (oldestc1 > oldestreturn)
                {
                    oldestreturn = oldestc1;
                }
                if (oldestc2 > oldestreturn)
                {
                    oldestreturn = oldestc2;
                }
            }
        }
        return oldestreturn;
    }

    function growstart()
    {
        timelim = fulltree.oldest();
        clearTimeout(t2);
        growingpause = true;
        growing = false;
        Resize();
    }

    function growrev()
    {
        if (timelim >= fulltree.oldest())
        {
            timelim = -0.001;
        }
        clearTimeout(t2);
        growingpause = false;
        growing = true;
        Resize();
        timeinc = fulltree.lengthbr/(growthtimetot*10);
        grow3();
    }

    function growpause()
    {
        clearTimeout(t2);
        growingpause = true;
        growing = false;
        Resize();
    }

    function growplay()
    {
        if (timelim <= 0)
        {
            timelim = fulltree.oldest();
        }
        clearTimeout(t2);
        growingpause = false;
        growing = true;
        Resize();
        timeinc = fulltree.oldest()/(growthtimetot*10);
        grow2();
    }

    function growend()
    {
        clearTimeout(t2);
        timelim = -1;
        clearTimeout(t2);
        growingpause = false;
        growing = false;
        if (buttonoptions != 2)
        {
            clearbuttons();
            reopenbuttons();
        }
        Resize();
    }

    function growfaster()
    {

        growthtimetot = growthtimetot/1.25;
        timeinc = fulltree.oldest()/(growthtimetot*10);
    }

    function growslower()
    {
        growthtimetot = growthtimetot*1.25;
        timeinc = fulltree.oldest()/(growthtimetot*10);
    }

    function grow2()
    {
        if (timelim >= 0)
        {
            timelim -= timeinc;
            draw2();
            t2 = setTimeout('grow2()',100);
        }
        else
        {
            clearTimeout(t2);
            draw2();
            t2 = setTimeout('Resize()',500);
            growing = false;
            growingpause = false;
        }
    }

    function grow3()
    {

        if (timelim <= fulltree.lengthbr)
        {
            timelim += timeinc;
            draw2();
            t2 = setTimeout('grow3()',100);
        }
        else
        {
            clearTimeout(t2);
            draw2();
            t2 = setTimeout('Resize()',500);
            growing = false;
            growingpause = true;
        }
    }

    function popup_search()
    {
        justopened = false;
         drawreminder = false;
        if (buttonoptions == 1)
        {
            popuptext = "Close search bar";
        }
        else
        {
            popuptext = "Open search bar";
        }
        draw2();
    }

    function popup_grow()
    {
        justopened = false;
         drawreminder = false;
        if (buttonoptions == 2)
        {
            popuptext = "Close growth animation bar";
        }
        else
        {
            popuptext = "Open growth animation bar";
        }

        draw2();
    }

    function popup_view()
    {
        justopened = false;
         drawreminder = false;
        if (buttonoptions == 3)
        {
            popuptext = "Close view options bar";
        }
        else
        {
            popuptext = "Open view options bar";
        }

        draw2();
    }

    function popup_reset()
    {
        justopened = false;
         drawreminder = false;
        popuptext = "Reset view";
        draw2();
    }

    function popup_tutorial()
    {
        justopened = false;
         drawreminder = false;
        popuptext = "Open tutorial window";
        draw2();
    }

    function popup_more()
    {
        justopened = false;
         drawreminder = false;
        if (buttonoptions == 5)
        {
            popuptext = "Close more options bar";
        }
        else
        {
            popuptext = "Open more options bar";
        }
        draw2();
    }

    function popup_twitter()
    {
        justopened = false;
         drawreminder = false;
        popuptext = "Follow us on Twitter";
        draw2();
    }

function popup_shape()
{
    justopened = false;
     drawreminder = false;
    popuptext = "Change fractal shape";
    draw2();
}


    function popup_facebook()
    {
        justopened = false;
         drawreminder = false;
        popuptext = "Like us on Facebook";
        draw2();
    }

function popup_OZsite()
{
    justopened = false;
    drawreminder = false;
    popuptext2 = "See more trees on OneZoom";
    draw2();
}

function popup_Zoomin()
{
    justopened = false;
     drawreminder = false;
    if (zoominnum >0)
    {
        popuptext = "Click or scroll up to zoom in";
        draw2();
    }

}

function popup_Zoomout()
{
    justopened = false;
     drawreminder = false;
    if(zoomoutnum >0)
    {
        popuptext = "Click or scroll down to zoom out";
        draw2();
    }

}

function popup_home()
{
    justopened = false;
    drawreminder = false;
    popuptext = "Goto OneZoom, see more trees";
    draw2();
}

function popup_out()
    {
        justopened = false;
         drawreminder = false;
        popuptext = null;
        popuptext2 = null;
        draw2();
    }
