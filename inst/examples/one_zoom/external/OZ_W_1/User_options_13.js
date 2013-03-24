

// this will indicate pop up text

// colour codes for redlist
function redlistcolor(codein)
{
    switch(codein)
    {
        case "EX":
            return ('rgb(0,0,180)');
        case "EW":
            return ('rgb(60,50,135)');
        case "CR":
            return ('rgb(210,0,10)');
        case "EN":
            return ('rgb(125,50,00)');
        case "VU":
            return ('rgb(85,85,30)');
        case "NT":
            return ('rgb(65,120,0)');
        case "LC":
            return ('rgb(0,180,20)');
        case "DD":
            return ('rgb(80,80,80)');
        case "NE":
            return ('rgb(0,0,0)');
        default:
            return ('rgb(0,0,0)');
    }
}

// definition of geological periods
function gpmapper(datein)
{
    if (datein > 253.8)
    {
        return("pre Triassic");
    }
    else
    {
        if (datein > 203.6)
        {
            return("Triassic");
        }
        else
        {
            if (datein > 150.8)
            {
                return("Jurassic");
            }
            else
            {
                if (datein > 70.6)
                {
                    return("Cretaceous");
                }
                else
                {
                    if (datein > 28.4)
                    {
                        return("Paleogene");
                    }
                    else
                    {
                        if (datein > 3.6)
                        {
                            return("Neogene");
                        }
                        else
                        {
                            return("Quaternary");
                        }
                    }
                }
            }
        }
    }

}

midnode.prototype.leafcolor1 = function()
{
    // for the leaf fill
    if ((this.redlist)&&(colourtype == 3))
    {
        return(redlistcolor(this.redlist));
    }
    else
    {
        if (colourtype == 3)
        {
            return (this.branchcolor());
        }
        else
        {
            return ('rgb(0,100,0)');
        }
    }
}


midnode.prototype.leafcolor2 = function()
{
    // for the leaf outline
    if ((this.redlist)&&(colourtype == 3))
    {
        return(redlistcolor(this.redlist));
    }
    else
    {
        if (colourtype == 3)
        {
            return (this.branchcolor());
        }
        else
        {
            return ('rgb(0,150,30)');
        }
    }
}

midnode.prototype.leafcolor3 = function()
{
    return ('rgb(255,255,255)'); // for the leaf text
}

midnode.prototype.hitstextcolor = function()
{
    // for text showing number of hits in each interior node (for search function)
    if ((this.npolyt)||(polytype == 3))
    {
        return ('rgb(255,255,255)');
    }
    else
    {
        return this.branchcolor();
    }
}

midnode.prototype.branchcolor = function() // branch colour logic
{
    // this script sets the colours of the branches
    var colortoreturn = 'rgb(100,75,50)';
    if (colourtype == 2) // there are two different color schemes in this version described by the colourtype variable
    {
        // this.lengthbr is the date of the node
        // timelim is the cut of date beyond which the tree is not drawn (when using growth animation functions
        if ((this.lengthbr<150.8)&&(timelim<150.8))
        {
            colortoreturn =  'rgb(180,50,25)';
        }
        if ((this.lengthbr<70.6)&&(timelim<70.6))
        {
            colortoreturn =  'rgb(50,25,50)';
        }
    }
    else
    {

        var conservation = (4*(this.num_CR) + 3*(this.num_EN) + 2*(this.num_VU) + this.num_NT);
        var num_surveyed = (this.num_CR + this.num_EN + this.num_VU + this.num_NT + this.num_LC);
        if (colourtype == 3)
        {
            if (num_surveyed == 0)
            {
                if (((this.num_NE >= this.num_DD)&&(this.num_NE >= this.num_EW))&&(this.num_NE >= this.num_EX))
                {
                    colortoreturn = redlistcolor("NE");
                }
                else
                {
                    if ((this.num_DD >= this.num_EX)&&(this.num_DD >= this.num_EW))
                    {
                        colortoreturn = redlistcolor("DD");
                    }
                    else
                    {
                        if (this.num_EW >= this.num_EX)
                        {
                            colortoreturn = redlistcolor("EW");
                        }
                        else
                        {
                            colortoreturn = redlistcolor("EX");
                        }
                    }
                }
            }
            else
            {
                if ((conservation/num_surveyed)>3.5)
                {
                    colortoreturn = redlistcolor("CR");
                }
                else
                {
                    if ((conservation/num_surveyed)>2.5)
                    {
                        colortoreturn = redlistcolor("EN");
                    }
                    else
                    {
                        if ((conservation/num_surveyed)>1.5)
                        {
                            colortoreturn = redlistcolor("VU");
                        }
                        else
                        {
                            if ((conservation/num_surveyed)>0.5)
                            {
                                colortoreturn = redlistcolor("NT");
                            }
                            else
                            {
                                colortoreturn = redlistcolor("LC");
                            }
                        }
                    }
                }
            }
        }
    }
    // the current logic uses different colorschemes for pre, post and during the Cretaceous period, if color type = 2
    // otherwise it uses a fixed brown color for the branches
    // when the tree is growing it only allows branches to be coloured for a certain period if the tree has already growed up to that period.
    return colortoreturn;
}

midnode.prototype.barccolor = function() // branch outline colour logic
{
    // this script sets the color for the outline of the branches
    var colortoreturn = 'rgba(50,37,25,0.3)';
    if (colourtype == 2)
    {
        if((this.lengthbr<70.6)&&(timelim<70.6))
        {
            colortoreturn = 'rgba(200,200,200,0.3)';
        }
    }
    if (colourtype == 3)
    {
        colortoreturn = 'rgba(0,0,0,0.3)';
    }
    return colortoreturn;
}

midnode.prototype.highlightcolor = function() // highlight colour logic
{
    return 'rgba(255,255,255,0.5)';
    /*
    // this logic defines the stripe colors that indicate search results, but could be edited to indicate other features such as traits
    return 'rgba('+(Math.round(255-254*this.searchin/numhits)).toString()+','+(Math.round(255-254*this.searchin/numhits)).toString()+','+(Math.round(255-254*this.searchin/numhits)).toString()+',0.6)';
    //*/
}

midnode.prototype.datetextcolor = function() // date text colour logic
{
    var colortoreturn = 'rgb(255,255,255)';
    if (colourtype == 2)
    {
        if ((this.lengthbr<150.8)&&(this.lengthbr>70.6))
        {
            colortoreturn = 'rgb(255,255,255)';
        }
    }
    if (colourtype == 3)
    {
        colortoreturn = 'rgb(255,255,255)';
    }
    return colortoreturn;
}

midnode.prototype.richnesstextcolor = function() // richness text colour logic
{
    var colortoreturn = 'rgb(255,255,255)';
    if (colourtype == 2)
    {
        if ((this.lengthbr<150.8)&&(this.lengthbr>70.6))
        {
            colortoreturn = 'rgb(255,255,250)';
        }
    }
    if (colourtype == 3)
    {
        colortoreturn = 'rgb(255,255,255)';
    }
    return colortoreturn;
}

// it is not advisable to edit below this point unless you are trying to sort out the display of custom trait data

// *** there are three types of leaves that are drawn by the code
// *** 1.) Fake leaf: where the tree continues but is smaller than the size threshold it is sometimes
// *** asthetically pleasing to draw a leaf there, especially if the threshold is a few pixels wide.  If the threshold is much smaller it does not matter if the facke leaf is drawn or not.
// *** 2.) Growth leaf: where growing animations are taking place there should be leaves on the tips of the branches
// *** 3.) Tip leaf: these are the classic leaves in which species names are put - these are the tips of the complete tree.
// *** all leaf classes can be defined with custom logic in the three scripts below

midnode.prototype.fakeleaflogic = function(x,y,r,angle)
{
    context.strokeStyle = this.leafcolor2();
    context.fillStyle = this.leafcolor1();
    if (leaftype == 1)
    {
        drawleaf1(x,y,r);
    }
    else
    {
        drawleaf2(x,y,r,angle);
    }
}

midnode.prototype.growthleaflogic = function(x,y,r,angle)
{
    context.strokeStyle = this.leafcolor2();
    context.fillStyle = this.leafcolor1();
    if (leaftype == 1)
    {
        drawleaf1(x,y,r);
    }
    else
    {
        drawleaf2(x,y,r,angle);
    }
}

midnode.prototype.tipleaflogic = function(x,y,r,angle)
{
    context.strokeStyle = this.leafcolor2();
    context.fillStyle = this.leafcolor1();
    if (leaftype == 1)
    {
        drawleaf1(x,y,r);
    }
    else
    {
        drawleaf2(x,y,r,angle);
    }
}




midnode.prototype.datepart = function()
{
    if (this.lengthbr >10)
    {
        return (Math.round((this.lengthbr)*10)/10.0).toString() + " Mya";
    }
    else
    {
        if (this.lengthbr >1)
        {
            return (Math.round((this.lengthbr)*100)/100.0).toString()  + " Mya";
        }
        else
        {
            return (Math.round((this.lengthbr)*10000)/10.0).toString()  + " Kya";
        }
    }
}


midnode.prototype.datemed = function()
{
    if (this.lengthbr >10)
    {
        return (Math.round((this.lengthbr)*10)/10.0).toString() + " Million years ago";
    }
    else
    {
        if (this.lengthbr >1)
        {
            return (Math.round((this.lengthbr)*100)/100.0).toString()  + " Million years ago";
        }
        else
        {
            return (Math.round((this.lengthbr)*10000)/10.0).toString()  + " Thousand years ago";
        }
    }
}

midnode.prototype.datefull = function()
{
    if (this.lengthbr >10)
    {
        return (Math.round((this.lengthbr)*10)/10.0).toString() + " Million years ago (" + gpmapper(this.lengthbr) + ")";
    }
    else
    {
        if (this.lengthbr >1)
        {
            return (Math.round((this.lengthbr)*100)/100.0).toString()  + " Million years ago (" + gpmapper(this.lengthbr) + ")";
        }
        else
        {
            return (Math.round((this.lengthbr)*10000)/10.0).toString()  + " Thousand years ago (" + gpmapper(this.lengthbr) + ")";
        }
    }
}

midnode.prototype.specnumfull = function()
{
    var num_threatened = (this.num_CR + this.num_EN + this.num_VU);
    if (num_threatened > 0)
    {
        return (this.richness_val).toString() + " species ( " + (num_threatened).toString() +" threatened - " + (Math.round((num_threatened)/(this.richness_val)*1000.0)/10.0).toString() + "% )";
    }
    else
    {
        return (this.richness_val).toString() + " species, none threatened";
    }
}

midnode.prototype.iprimaryname = function()
{
    if (commonlabels)
    {
        return(this.cname);
    }
    else
    {
        if (this.child1)
        {
            return(this.name1);
        }
        else
        {
            return(this.name2 + " " + this.name1);
        }

    }
}

midnode.prototype.isecondaryname = function()
{
    if (commonlabels)
    {
        if (this.child1)
        {
            return(this.name1);
        }
        else
        {
            return(this.name2 + " " + this.name1);
        }
    }
    else
    {
        if (this.cname)
        {
            if ((this.name2)&&(!auto_interior_node_labels))
            {
                return(this.cname + " (" + this.name2 + ")");
            }
            else
            {
                return(this.cname);
            }
        }
        else
        {
            return null;
        }
    }
}


midnode.prototype.draw_sp_back = function()
{
    // draw sign posts
    var signdrawn = false;
    var x ;
    var y ;
    var r ;
    if(this.dvar)
    {
        if (this.rvar)
        {
            x = this.xvar;
            y = this.yvar;
            r = this.rvar;
        }
        if (this.richness_val > 1)
        {

            if (drawsignposts)
            {
                if (this.child1)
                {

                    if (((thresholdtxt*35 < r*(this.hxmax-this.hxmin))&&(r <=thresholdtxt*50))||(this.lengthbr <= timelim))
                    {
                        if (this.name1&&(!commonlabels)) // white signposts
                        {

                            context.fillStyle = 'rgba(255,255,255,0.5)';
                            context.beginPath();
                            context.arc(x+r*(this.hxmax+this.hxmin)/2,y+r*(this.hymax+this.hymin)/2,r*((this.hxmax-this.hxmin)*0.35),0,Math.PI*2,true);
                            context.fill();
                            signdrawn = true;

                        }
                        if (this.cname&&(commonlabels)) // white signposts
                        {

                            context.fillStyle = 'rgba(255,255,255,0.5)';
                            context.beginPath();
                            context.arc(x+r*(this.hxmax+this.hxmin)/2,y+r*(this.hymax+this.hymin)/2,r*((this.hxmax-this.hxmin)*0.35),0,Math.PI*2,true);
                            context.fill();
                            signdrawn = true;

                        }
                    }
                    if (!signdrawn)
                    {
                        if (this.lengthbr > timelim)
                        {

                            this.child1.draw_sp_back ()
                            this.child2.draw_sp_back ()
                        }
                    }
                }

            }
        }
    }
}

midnode.prototype.draw_sp_txt = function()
{
    // draw sign posts
    var signdrawn = false;
    var x ;
    var y ;
    var r ;
    if(this.dvar)
    {
        if (this.rvar)
        {
            x = this.xvar;
            y = this.yvar;
            r = this.rvar;
        }
        if (this.richness_val > 1)
        {

            if (drawsignposts)
            {
                if (this.child1)
                {


                    if (((thresholdtxt*35 < r*(this.hxmax-this.hxmin))&&(r <=thresholdtxt*50))||(this.lengthbr <= timelim))
                    {
                        if (this.name1&&(!commonlabels)) // white signposts
                        {

                            context.fillStyle = 'rgb(0,0,0)';
                            autotext3(true,this.name1 ,x+r*(this.hxmax+this.hxmin)/2,y+r*(this.hymax+this.hymin)/2,r*(this.hxmax-this.hxmin)*0.65,r*((this.hxmax-this.hxmin)/5));
                            signdrawn = true;

                        }
                        if (this.cname&&(commonlabels)) // white signposts
                        {

                            context.fillStyle = 'rgb(0,0,0)';
                            autotext3(true,this.cname ,x+r*(this.hxmax+this.hxmin)/2,y+r*(this.hymax+this.hymin)/2,r*(this.hxmax-this.hxmin)*0.65,r*((this.hxmax-this.hxmin)/5));
                            signdrawn = true;

                        }
                    }
                    if (!signdrawn)
                    {
                        if (this.lengthbr > timelim)
                        {
                            this.child1.draw_sp_txt ()
                            this.child2.draw_sp_txt ()
                        }
                    }
                }

            }
        }
    }
}



// drawing the tree
midnode.prototype.draw = function()
{
    var signdone = false;
    var x ;
    var y ;
    var r ;
    if(this.dvar)
    {
        if (this.rvar)
        {
            x = this.xvar;
            y = this.yvar;
            r = this.rvar;
        }
        if ((this.child1)&&(this.lengthbr > timelim))
        {
            if ((this.child1.richness_val) >= (this.child2.richness_val))
            {
                signdone = this.child1.draw () || signdone;
                signdone = this.child2.draw () || signdone;
            }
            else
            {
                signdone = this.child2.draw () || signdone;
                signdone = this.child1.draw () || signdone;
            }
        }
        var ing = false; // if we are in the region where graphics need to be drawn
        if((this.gvar)&&((polytype!=2)||(this.npolyt)))
        {

            ing = true;
            context.lineCap = "round";
            context.lineWidth = r*(this.bezr);
            context.beginPath();
            context.moveTo(x+r*(this.bezsx),y+r*this.bezsy);
            context.bezierCurveTo(x+r*(this.bezc1x),y+r*(this.bezc1y),x+r*(this.bezc2x),y+r*(this.bezc2y),x+r*(this.bezex),y+r*(this.bezey));
            context.strokeStyle = this.branchcolor();
            context.stroke();
            if ((highlight_search)&&(this.searchin > 0))
            {
                /*
                 context.lineWidth = r*(this.bezr)/3;
                 context.strokeStyle = 'rgb(255,255,255)';
                 context.beginPath();
                 context.moveTo(x+r*(this.bezsx),y+r*this.bezsy);
                 context.bezierCurveTo(x+r*(this.bezc1x),y+r*(this.bezc1y),x+r*(this.bezc2x),y+r*(this.bezc2y),x+r*(this.bezex),y+r*(this.bezey));
                 context.stroke();
                 */
                context.strokeStyle = this.highlightcolor();
                context.lineWidth = r*(this.bezr)/5.0;
                context.beginPath();
                context.moveTo(x+r*(this.bezsx),y+r*this.bezsy);
                context.bezierCurveTo(x+r*(this.bezc1x),y+r*(this.bezc1y),x+r*(this.bezc2x),y+r*(this.bezc2y),x+r*(this.bezex),y+r*(this.bezey));
                context.stroke();
            }
        }
        if (this.lengthbr > timelim)
        {
            if (((this.richness_val > 1)&&(r<=threshold))&&(timelim <= 0))
            {
                // we are drawing a fake leaf - ing is irrelevant as this is instead of drawing the children
                this.fakeleaflogic(x+((r)*(this.nextx1)),y+(r)*(this.nexty1),r*leafmult*0.75*partc,this.arca);
            }
            else
            {
                if (ing)
                {
                    if (this.richness_val > 1)
                    {


                        // START INT NODE DETAILS
                        //autotest(texttodisp,textw,defpt) // use this

                        if (this.lengthbr > timelim)
                        {
                            // interior node drawing starts here
                            // first set up the variables that decide text size
                            var temp_twidth = (r*partc-r*partl2)*Twidth;
                            var temp_theight = (r*partc-r*partl2)*Tsize/2.0;
                            var temp_theight_2 = (r*partc-r*partl2)*Tsize/3.0;
                            // this piece of logic draws the arc background if needed (no text)
                            if ((highlight_search)&&(this.searchin > 0))
                            {
                                context.beginPath();
                                context.arc(x+r*(this.arcx),y+r*this.arcy,r*this.arcr,0,Math.PI*2,true);
                                context.fillStyle = this.branchcolor();
                                context.fill();
                                if (!((this.npolyt)||(polytype == 3)))
                                {
                                    context.beginPath();
                                    context.arc(x+r*(this.arcx),y+r*this.arcy,r*this.arcr*0.5,0,Math.PI*2,true);
                                    context.fillStyle = this.highlightcolor();
                                    context.fill();
                                }

                            }
                            if (((this.npolyt)||((highlight_search)&&(this.searchin > 0)))||(polytype == 3))
                            {
                                // we are drawing an internal circle
                                if(((r > thresholdtxt*50)))
                                {
                                    if (intcircdraw)
                                    {
                                        context.beginPath();
                                        context.arc(x+r*(this.arcx),y+r*this.arcy,r*this.arcr*(1-partl2/2.0),0,Math.PI*2,true);
                                        context.lineWidth = r*this.arcr*partl2;
                                        if ((highlight_search)&&(this.searchin > 0))
                                        {
                                            context.strokeStyle = this.highlightcolor();
                                        }
                                        else
                                        {
                                            context.strokeStyle = this.barccolor();
                                        }
                                        context.stroke();
                                    }
                                }
                                else
                                {
                                    if (intcircdraw)
                                    {
                                        if (((highlight_search)&&(this.searchin > 0))&&((r*this.arcr*partl2*2)>0.3))
                                        {
                                            context.beginPath();
                                            context.arc(x+r*(this.arcx),y+r*this.arcy,r*this.arcr*0.5,0,Math.PI*2,true);
                                            context.fillStyle = this.highlightcolor();
                                            context.fill();
                                        }
                                    }


                                }
                            }
                            // internal text drawing starts here *****
                            if ((this.npolyt)||(polytype == 3))
                            {
                                if (datahastraits)
                                {
                                    var drawndetails = false;


                                    if(((!drawndetails)&&(r > thresholdtxt*280)))
                                    {

                                        // drawing internal text

                                        // DRAW PIECHARTS

                                        if (r > threshold*45)
                                        {

                                            context.fillStyle = 'rgb(255,255,255)';

                                            context.beginPath();
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/3.3,0,Math.PI*2,true);
                                            context.fill();

                                            if (r > threshold*250)
                                            {

                                                for (i = 0 ; i < 9 ; i ++)
                                                {
                                                    context.beginPath();
                                                    context.arc(x+r*this.arcx+temp_theight*i*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.05,0,Math.PI*2,true);
                                                    context.fill();
                                                }
                                                context.fillStyle = redlistcolor("EX");
                                                context.beginPath();
                                                context.arc(x+r*this.arcx+temp_theight*0*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,0,Math.PI*2,true);
                                                context.fill();
                                                context.fillStyle = redlistcolor("EW");
                                                context.beginPath();
                                                context.arc(x+r*this.arcx+temp_theight*1*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,0,Math.PI*2,true);
                                                context.fill();
                                                context.fillStyle = redlistcolor("CR");
                                                context.beginPath();
                                                context.arc(x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,0,Math.PI*2,true);
                                                context.fill();
                                                context.fillStyle = redlistcolor("EN");
                                                context.beginPath();
                                                context.arc(x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,0,Math.PI*2,true);
                                                context.fill();
                                                context.fillStyle = redlistcolor("VU");
                                                context.beginPath();
                                                context.arc(x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,0,Math.PI*2,true);
                                                context.fill();
                                                context.fillStyle = redlistcolor("NT");
                                                context.beginPath();
                                                context.arc(x+r*this.arcx+temp_theight*5*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,0,Math.PI*2,true);
                                                context.fill();
                                                context.fillStyle = redlistcolor("LC");
                                                context.beginPath();
                                                context.arc(x+r*this.arcx+temp_theight*6*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,0,Math.PI*2,true);
                                                context.fill();
                                                context.fillStyle = redlistcolor("DD");
                                                context.beginPath();
                                                context.arc(x+r*this.arcx+temp_theight*7*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,0,Math.PI*2,true);
                                                context.fill();
                                                context.fillStyle = redlistcolor("NE");
                                                context.beginPath();
                                                context.arc(x+r*this.arcx+temp_theight*8*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,0,Math.PI*2,true);
                                                context.fill();
                                                context.fillStyle = this.leafcolor3();
                                                autotext(false,"EX", x+r*this.arcx+temp_theight*0*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,temp_theight*0.04);
                                                autotext(false,"EW", x+r*this.arcx+temp_theight*1*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,temp_theight*0.04);
                                                autotext(false,"CR", x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,temp_theight*0.04);
                                                autotext(false,"EN", x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,temp_theight*0.04);
                                                autotext(false,"VU", x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,temp_theight*0.04);
                                                autotext(false,"NT", x+r*this.arcx+temp_theight*5*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,temp_theight*0.04);
                                                autotext(false,"LC", x+r*this.arcx+temp_theight*6*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,temp_theight*0.04);
                                                autotext(false,"DD", x+r*this.arcx+temp_theight*7*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,temp_theight*0.04);
                                                autotext(false,"NE", x+r*this.arcx+temp_theight*8*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.09,temp_theight*0.04,temp_theight*0.04);
                                                autotext(false,conconvert("EX"), x+r*this.arcx+temp_theight*0*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.12,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,conconvert("EW"), x+r*this.arcx+temp_theight*1*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.12,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,conconvert("CR"), x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.12,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,conconvert("EN"), x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.12,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,conconvert("VU"), x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.12,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,conconvert("NT"), x+r*this.arcx+temp_theight*5*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.12,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,conconvert("LC"), x+r*this.arcx+temp_theight*6*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.12,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,conconvert("DD"), x+r*this.arcx+temp_theight*7*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.12,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,conconvert("NE"), x+r*this.arcx+temp_theight*8*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.12,temp_theight*0.04,temp_theight*0.005);

                                                autotext(false,(Math.round(10000.0*(this.num_EX/this.richness_val))/100.0).toString() + " %", x+r*this.arcx+temp_theight*0*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.045,temp_theight*0.04,temp_theight*0.008);
                                                autotext(false,(Math.round(10000.0*(this.num_EW/this.richness_val))/100.0).toString() + " %", x+r*this.arcx+temp_theight*1*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.045,temp_theight*0.04,temp_theight*0.008);
                                                autotext(false,(Math.round(10000.0*(this.num_CR/this.richness_val))/100.0).toString() + " %", x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.045,temp_theight*0.04,temp_theight*0.008);
                                                autotext(false,(Math.round(10000.0*(this.num_EN/this.richness_val))/100.0).toString() + " %", x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.045,temp_theight*0.04,temp_theight*0.008);
                                                autotext(false,(Math.round(10000.0*(this.num_VU/this.richness_val))/100.0).toString() + " %", x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.045,temp_theight*0.04,temp_theight*0.008);
                                                autotext(false,(Math.round(10000.0*(this.num_NT/this.richness_val))/100.0).toString() + " %", x+r*this.arcx+temp_theight*5*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.045,temp_theight*0.04,temp_theight*0.008);
                                                autotext(false,(Math.round(10000.0*(this.num_LC/this.richness_val))/100.0).toString() + " %", x+r*this.arcx+temp_theight*6*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.045,temp_theight*0.04,temp_theight*0.008);
                                                autotext(false,(Math.round(10000.0*(this.num_DD/this.richness_val))/100.0).toString() + " %", x+r*this.arcx+temp_theight*7*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.045,temp_theight*0.04,temp_theight*0.008);
                                                autotext(false,(Math.round(10000.0*(this.num_NE/this.richness_val))/100.0).toString() + " %", x+r*this.arcx+temp_theight*8*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.045,temp_theight*0.04,temp_theight*0.008);

                                                autotext(false,(this.num_EX).toString() + " species", x+r*this.arcx+temp_theight*0*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.06,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,(this.num_EW).toString() + " species", x+r*this.arcx+temp_theight*1*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.06,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,(this.num_CR).toString() + " species", x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.06,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,(this.num_EN).toString() + " species", x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.06,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,(this.num_VU).toString() + " species", x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.06,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,(this.num_NT).toString() + " species", x+r*this.arcx+temp_theight*5*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.06,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,(this.num_LC).toString() + " species", x+r*this.arcx+temp_theight*6*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.06,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,(this.num_DD).toString() + " species", x+r*this.arcx+temp_theight*7*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.06,temp_theight*0.04,temp_theight*0.005);
                                                autotext(false,(this.num_NE).toString() + " species", x+r*this.arcx+temp_theight*8*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.06,temp_theight*0.04,temp_theight*0.005);

                                                autotext(true,"Threatened", x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.132,temp_theight_2*0.04,temp_theight*0.005);
                                                autotext(true,"Threatened", x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.132,temp_theight_2*0.04,temp_theight*0.005);
                                                autotext(true,"Threatened", x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight_2*1.132,temp_theight_2*0.04,temp_theight*0.005);
                                            }

                                            var pieangle = 0;
                                            var newpieangle = pieangle+(this.num_LC/this.richness_val)*Math.PI*2 +0.1;
                                            if (newpieangle > Math.PI*2)
                                            {
                                                newpieangle = Math.PI*2;
                                            }
                                            context.fillStyle = redlistcolor("LC")
                                            context.beginPath();
                                            context.moveTo(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7);
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/4,pieangle-0.1,newpieangle,false);
                                            pieangle +=(this.num_LC/this.richness_val)*Math.PI*2;
                                            context.fill();

                                            newpieangle = pieangle+(this.num_NT/this.richness_val)*Math.PI*2 +0.1;
                                            if (newpieangle > Math.PI*2)
                                            {
                                                newpieangle = Math.PI*2;
                                            }
                                            context.fillStyle = redlistcolor("NT")
                                            context.beginPath();
                                            context.moveTo(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7);
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/4,pieangle,newpieangle,false);
                                            pieangle +=(this.num_NT/this.richness_val)*Math.PI*2;
                                            context.fill();

                                            newpieangle = pieangle+(this.num_VU/this.richness_val)*Math.PI*2 +0.1;
                                            if (newpieangle > Math.PI*2)
                                            {
                                                newpieangle = Math.PI*2;
                                            }

                                            context.fillStyle = redlistcolor("VU")
                                            context.beginPath();
                                            context.moveTo(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7);
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/4,pieangle,newpieangle,false);
                                            pieangle +=(this.num_VU/this.richness_val)*Math.PI*2;
                                            context.fill();
                                            newpieangle = pieangle+(this.num_EN/this.richness_val)*Math.PI*2 +0.1;
                                            if (newpieangle > Math.PI*2)
                                            {
                                                newpieangle = Math.PI*2;
                                            }

                                            context.fillStyle = redlistcolor("EN")
                                            context.beginPath();
                                            context.moveTo(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7);
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/4,pieangle,newpieangle,false);
                                            pieangle +=(this.num_EN/this.richness_val)*Math.PI*2;
                                            context.fill();
                                            newpieangle = pieangle+(this.num_CR/this.richness_val)*Math.PI*2 +0.1;
                                            if (newpieangle > Math.PI*2)
                                            {
                                                newpieangle = Math.PI*2;
                                            }

                                            context.fillStyle = redlistcolor("CR")
                                            context.beginPath();
                                            context.moveTo(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7);
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/4,pieangle,newpieangle,false);
                                            pieangle +=(this.num_CR/this.richness_val)*Math.PI*2;
                                            context.fill();
                                            newpieangle = pieangle+(this.num_EW/this.richness_val)*Math.PI*2 +0.1;
                                            if (newpieangle > Math.PI*2)
                                            {
                                                newpieangle = Math.PI*2;
                                            }

                                            context.fillStyle = redlistcolor("EW")
                                            context.beginPath();
                                            context.moveTo(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7);
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/4,pieangle,newpieangle,false);
                                            pieangle +=(this.num_EW/this.richness_val)*Math.PI*2;
                                            context.fill();
                                            newpieangle = pieangle+(this.num_EX/this.richness_val)*Math.PI*2 +0.1;
                                            if (newpieangle > Math.PI*2)
                                            {
                                                newpieangle = Math.PI*2;
                                            }

                                            context.fillStyle = redlistcolor("EX")
                                            context.beginPath();
                                            context.moveTo(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7);
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/4,pieangle,newpieangle,false);
                                            pieangle +=(this.num_EX/this.richness_val)*Math.PI*2;
                                            context.fill();
                                            newpieangle = pieangle+(this.num_DD/this.richness_val)*Math.PI*2 +0.1;
                                            if (newpieangle > Math.PI*2)
                                            {
                                                newpieangle = Math.PI*2;
                                            }

                                            context.fillStyle = redlistcolor("DD")
                                            context.beginPath();
                                            context.moveTo(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7);
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/4,pieangle,newpieangle,false);
                                            pieangle +=(this.num_DD/this.richness_val)*Math.PI*2;
                                            context.fill();
                                            newpieangle = pieangle+(this.num_NE/this.richness_val)*Math.PI*2;
                                            if (newpieangle > Math.PI*2)
                                            {
                                                newpieangle = Math.PI*2;
                                            }

                                            context.fillStyle = redlistcolor("NE")
                                            context.beginPath();
                                            context.moveTo(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7);
                                            context.arc(x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,temp_theight/4,pieangle,newpieangle,false);
                                            pieangle +=(this.num_NE/this.richness_val)*Math.PI*2;
                                            context.fill();

                                            context.fillStyle = intnodetextcolor;
                                            autotext(false,"conservation status pie chart" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.85,temp_twidth*0.75,temp_theight_2/7.0);


                                        }

                                        // DO THE TEXT

                                        if ((this.child1)&&(this.lengthbr))
                                        {
                                            context.fillStyle = this.datetextcolor();
                                            if (this.lengthbr >10)
                                            {
                                                autotext(false,(Math.round((this.lengthbr)*10)/10.0).toString() + " Million years ago", x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.15,temp_twidth,temp_theight_2/1.5);
                                                autotext(false,gpmapper(this.lengthbr) + " Period", x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.55,temp_twidth,temp_theight_2/5);
                                            }
                                            else
                                            {
                                                if (this.lengthbr >1)
                                                {
                                                    autotext(false,(Math.round((this.lengthbr)*100)/100.0).toString()  + " Million years ago", x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.15,temp_twidth,temp_theight_2/1.5);
                                                    autotext(false,gpmapper(this.lengthbr) + " Period", x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.55,temp_twidth,temp_theight_2/5);
                                                }
                                                else
                                                {
                                                    autotext(false,(Math.round((this.lengthbr)*10000)/10.0).toString()  + " Thousand years ago", x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.15,temp_twidth,temp_theight_2/1.5);
                                                    autotext(false,gpmapper(this.lengthbr) + " Period", x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.55,temp_twidth,temp_theight_2/5);
                                                }
                                            }
                                        }

                                        var num_threatened = (this.num_CR + this.num_EN + this.num_VU);

                                        if ((this.iprimaryname())||(this.isecondaryname()))
                                        {
                                            context.fillStyle = intnodetextcolor;
                                            if (!this.isecondaryname())
                                            {
                                                autotext(true,this.iprimaryname() , x+r*this.arcx,y+r*this.arcy-temp_theight_2*0.25,temp_twidth*1.35,temp_theight_2/1.5);
                                            }
                                            else
                                            {
                                                if (this.iprimaryname())
                                                {
                                                    autotext(true,this.iprimaryname() , x+r*this.arcx,y+r*this.arcy-temp_theight_2*0,temp_twidth*1.35,temp_theight_2*0.5);
                                                    autotext(true,this.isecondaryname() , x+r*this.arcx,y+r*this.arcy-temp_theight_2*0.6,temp_twidth*1.35,temp_theight_2*0.4);
                                                }
                                                else
                                                {
                                                    autotext(true,this.isecondaryname() , x+r*this.arcx,y+r*this.arcy-temp_theight_2*0.25,temp_twidth*1.35,temp_theight_2/1.5);
                                                }
                                            }

                                            context.fillStyle = this.richnesstextcolor();
                                            //*
                                            if (num_threatened > 0)
                                            {
                                                autotext(false,(this.richness_val).toString() + " species , " + (num_threatened).toString() + " threatened ( " + (Math.round((num_threatened)/(this.richness_val)*1000.0)/10.0).toString() + "% )" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.45,temp_twidth*1.2,temp_theight_2/7.0);
                                            }
                                            else
                                            {
                                                autotext(false,(this.richness_val).toString() + " species, none threatened" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.45,temp_twidth,temp_theight_2/7.0);
                                            }
                                            if(this.phylogenetic_diversity>1000.0)
                                            {
                                                autotext(false,(Math.round(this.phylogenetic_diversity/100)/10.0).toString() + " billion years total phylogenetic diversity" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.65,temp_twidth,temp_theight_2/7.0);
                                            }
                                            else
                                            {
                                                autotext(false,(Math.round(this.phylogenetic_diversity)).toString() + " million years total phylogenetic diversity" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.65,temp_twidth,temp_theight_2/7.0);
                                            }

                                            var linkpos = 0;

                                            if ((this.npolyt)||(polytype != 2))
                                            {
                                                if ((highlight_search)&&(this.searchin > 0))
                                                {
                                                    context.fillStyle = this.hitstextcolor();
                                                    if (this.searchin > 1)
                                                    {
                                                        autotext(false,(this.searchin).toString() + " hits" ,  x+r*this.arcx-temp_theight_2*0.3,y+r*this.arcy-temp_theight_2*1.95,temp_twidth*0.5,temp_theight_2*0.2);
                                                    }
                                                    else
                                                    {
                                                        autotext(false,"1 hit" ,  x+r*this.arcx-temp_theight_2*0.3,y+r*this.arcy-temp_theight_2*1.95,temp_theight_2*0.6,temp_theight_2*0.2);
                                                    }
                                                    linkpos = temp_theight_2*0.45;
                                                }
                                            }
                                            if (this.name1)
                                            {
                                                if ( r > threshold*200)
                                                {
                                                if ((this.linkclick)&&((!this.child1.linkclick)&&(!this.child2.linkclick)))
                                                {
                                                    context.fillStyle = 'rgb(0,0,0)';
                                                    context.beginPath();
                                                    context.arc(x+r*this.arcx+linkpos,y+r*this.arcy-temp_theight_2*1.95,temp_theight*0.12,0,Math.PI*2,true);
                                                    context.fill();
                                                    context.fillStyle = 'rgb(255,255,255)';
                                                    context.beginPath();
                                                    context.arc(x+r*this.arcx+linkpos,y+r*this.arcy-temp_theight_2*1.95,temp_theight*0.1,0,Math.PI*2,true);
                                                    context.fill();
                                                    context.fillStyle = intnodetextcolor;
                                                    context.fillStyle = 'rgb(0,0,0)';

                                                    autotext(true,"Wiki", x+r*this.arcx+linkpos,y+r*this.arcy-temp_theight_2*1.95,temp_theight*0.17,temp_theight_2/10.0);
                                                }
                                                else
                                                {
                                                    context.fillStyle = 'rgb(255,255,255)';
                                                    context.beginPath();
                                                    context.arc(x+r*this.arcx+linkpos,y+r*this.arcy-temp_theight_2*1.95,temp_theight*0.12,0,Math.PI*2,true);
                                                    context.fill();
                                                    context.fillStyle = this.branchcolor();
                                                    context.beginPath();
                                                    context.arc(x+r*this.arcx+linkpos,y+r*this.arcy-temp_theight_2*1.95,temp_theight*0.1,0,Math.PI*2,true);
                                                    context.fill();
                                                    context.fillStyle = intnodetextcolor;
                                                    context.fillStyle = 'rgb(255,255,255)';

                                                    autotext(true,"Wiki", x+r*this.arcx+linkpos,y+r*this.arcy-temp_theight_2*1.95,temp_theight*0.17,temp_theight_2/10.0);
                                                }
                                                }
                                            }
                                        }
                                        else
                                        {

                                            context.fillStyle = this.richnesstextcolor();
                                            autotext(false,(this.richness_val).toString() + " species",  x+r*this.arcx,y+r*this.arcy+temp_theight_2*-0.17,temp_twidth*1.35,temp_theight_2/1.5);

                                            if (num_threatened > 0)
                                            {
                                                if (num_threatened > 1)
                                                {
                                                    autotext(false,(num_threatened).toString() + " of " + (this.richness_val).toString() + " species are threatened ( " + (Math.round((num_threatened)/(this.richness_val)*1000.0)/10.0).toString() + "% )" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.45,temp_twidth,temp_theight_2/5.0);
                                                }
                                                else
                                                {
                                                    autotext(false,(num_threatened).toString() + " of " + (this.richness_val).toString() + " species is threatened ( " + (Math.round((num_threatened)/(this.richness_val)*1000.0)/10.0).toString() + "% )" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.45,temp_twidth,temp_theight_2/5.0);
                                                }
                                            }
                                            else
                                            {
                                                autotext(false,"no threatened species" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.45,temp_twidth*0.75,temp_theight_2/5.0);
                                            }
                                            if(this.phylogenetic_diversity>1000.0)
                                            {
                                                autotext(false,(Math.round(this.phylogenetic_diversity/100)/10.0).toString() + " billion years total phylogenetic diversity" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.65,temp_twidth,temp_theight_2/5.0);
                                            }
                                            else
                                            {
                                                autotext(false,(Math.round(this.phylogenetic_diversity)).toString() + " million years total phylogenetic diversity" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.65,temp_twidth,temp_theight_2/5.0);
                                            }

                                            if ((this.npolyt)||(polytype != 2))
                                            {
                                                if ((highlight_search)&&(this.searchin > 0))
                                                {
                                                    context.fillStyle = this.hitstextcolor();
                                                    if (this.searchin > 1)
                                                    {
                                                        autotext(false,(this.searchin).toString() + " hits" ,  x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.85,temp_twidth*0.5,temp_theight_2*0.2);
                                                    }
                                                    else
                                                    {
                                                        autotext(false,"1 hit" ,  x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.85,temp_twidth*0.5,temp_theight_2*0.2);
                                                    }

                                                }
                                            }

                                        }

                                        drawndetails = true;
                                    }


                                    /*
                                     if ((!drawndetails)&&(r > thresholdtxt*130))
                                     {
                                     var num_threatened = (this.num_CR + this.num_EN + this.num_VU);
                                     if (this.iprimaryname())
                                     {
                                     context.fillStyle = intnodetextcolor;
                                     autotext2(false,this.datemed(), x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.5,r*this.arcr*(1-partl2/2.0),temp_theight_2*0.3);
                                     autotext3(true,this.iprimaryname() , x+r*this.arcx,y+r*this.arcy,1.4*r*this.arcr*(1-partl2/2.0),temp_theight_2*0.6);
                                     autotext(false,(this.richness_val).toString() + " species",  x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.3,r*this.arcr*(1-partl2/2.0),temp_theight_2*0.3);
                                     if (num_threatened > 0)
                                     {
                                     autotext(false,"(" +(num_threatened).toString() +" threatened)",  x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.7,r*this.arcr*(1-partl2/2.0),temp_theight_2*0.3);
                                     }
                                     }
                                     else
                                     {
                                     context.fillStyle = intnodetextcolor;
                                     autotext2(false,this.datemed(), x+r*this.arcx,y+r*this.arcy-temp_theight_2*0.6,1.4*r*this.arcr*(1-partl2/2.0),temp_theight_2*0.5);
                                     autotext(false,(this.richness_val).toString() + " species",  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.5,1.4*r*this.arcr*(1-partl2/2.0),temp_theight_2*0.5);
                                     if (num_threatened > 0)
                                     {
                                     autotext(false,"(" +(num_threatened).toString() +" threatened)",  x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.1,1.3*r*this.arcr*(1-partl2/2.0),temp_theight_2*0.5);
                                     }
                                     }
                                     drawndetails = true;
                                     }
                                     //*/


                                    if ((!drawndetails)&&(r > thresholdtxt*50))
                                    {
                                        if (this.name1&&(!commonlabels))
                                        {
                                            context.fillStyle = intnodetextcolor;
                                            autotext(false,(this.richness_val).toString(),  x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.65,temp_twidth,temp_theight_2*0.6);

                                            autotext3(true,this.name1 , x+r*this.arcx,y+r*this.arcy,1.75*r*this.arcr*(1-partl2/2.0),temp_theight_2*0.8);
                                            if ((highlight_search)&&(this.searchin > 0))
                                            {
                                                if (this.searchin > 1)
                                                {
                                                    autotext(false,(this.searchin).toString() + " hits" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.65,temp_twidth,temp_theight_2*0.6);
                                                }
                                                else
                                                {
                                                    autotext(false,"1 hit" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.65,temp_twidth,temp_theight_2*0.6);
                                                }
                                            }

                                        }
                                        else
                                        {
                                            if (this.cname&&(commonlabels))
                                            {
                                                context.fillStyle = intnodetextcolor;
                                                autotext(false,(this.richness_val).toString() ,  x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.65,temp_twidth,temp_theight_2*0.6);

                                                autotext3(true,this.cname , x+r*this.arcx,y+r*this.arcy,1.75*r*this.arcr*(1-partl2/2.0),temp_theight_2*0.8);
                                                if ((highlight_search)&&(this.searchin > 0))
                                                {
                                                    if (this.searchin > 1)
                                                    {
                                                        autotext(false,(this.searchin).toString() + " hits" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.65,temp_twidth,temp_theight_2*0.6);
                                                    }
                                                    else
                                                    {
                                                        autotext(false,"1 hit" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.65,temp_twidth,temp_theight_2*0.6);
                                                    }
                                                }

                                            }
                                            else
                                            {
                                                context.fillStyle = intnodetextcolor;
                                                autotext(false,(this.richness_val).toString() + " species",  x+r*this.arcx,y+r*this.arcy-temp_theight_2*1,temp_twidth*1.1,temp_theight_2*0.8);
                                                autotext(false,this.datepart(), x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.2,1.75*r*this.arcr*(1-partl2/2.0),temp_theight_2);
                                                if ((highlight_search)&&(this.searchin > 0))
                                                {
                                                    if (this.searchin > 1)
                                                    {
                                                        autotext(false,(this.searchin).toString() + " hits" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.45,temp_twidth,temp_theight_2*0.6);
                                                    }
                                                    else
                                                    {
                                                        autotext(false,"1 hit" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*1.45,temp_twidth,temp_theight_2*0.6);
                                                    }
                                                }

                                            }
                                        }

                                        drawndetails = true;
                                    }





                                }
                                else
                                {
                                    if ((this.child1)&&(this.lengthbr))
                                    {
                                        context.fillStyle = this.datetextcolor();
                                        if (this.lengthbr >10)
                                        {
                                            autotext(false,(Math.round((this.lengthbr)*10)/10.0).toString() + " Mya", x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.32,temp_twidth,temp_theight_2/1.5);
                                            autotext(false,gpmapper(this.lengthbr) + " Period", x+r*this.arcx,y+r*this.arcy-temp_theight_2*0.82,temp_twidth,temp_theight_2/5.0);
                                        }
                                        else
                                        {
                                            if (this.lengthbr >1)
                                            {
                                                autotext(false,(Math.round((this.lengthbr)*100)/100.0).toString()  + " Mya", x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.32,temp_twidth,temp_theight_2/1.5);
                                                autotext(false,gpmapper(this.lengthbr) + " Period", x+r*this.arcx,y+r*this.arcy-temp_theight_2*0.82,temp_twidth,temp_theight_2/5.0);
                                            }
                                            else
                                            {
                                                autotext(false,(Math.round((this.lengthbr)*10000)/10.0).toString()  + " Kya", x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.32,temp_twidth,temp_theight_2/1.5);
                                                autotext(false,gpmapper(this.lengthbr) + " Period", x+r*this.arcx,y+r*this.arcy-temp_theight_2*0.82,temp_twidth,temp_theight_2/5.0);
                                            }
                                        }
                                    }


                                        context.fillStyle = this.richnesstextcolor();
                                        autotext(false,(this.richness_val).toString() + " species",  x+r*this.arcx,y+r*this.arcy+temp_theight_2*-0.17,temp_twidth*1.35,temp_theight_2/1.5);

                                        if(this.phylogenetic_diversity>1000.0)
                                        {
                                            autotext(false,(Math.round(this.phylogenetic_diversity/100)/10.0).toString() + " billion years total phylogenetic diversity" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.65,temp_twidth,temp_theight_2/5.0);
                                        }
                                        else
                                        {
                                            autotext(false,(Math.round(this.phylogenetic_diversity)).toString() + " million years total phylogenetic diversity" ,  x+r*this.arcx,y+r*this.arcy+temp_theight_2*0.65,temp_twidth,temp_theight_2/5.0);
                                        }

                                        if ((this.npolyt)||(polytype != 2))
                                        {
                                            if ((highlight_search)&&(this.searchin > 0))
                                            {
                                                context.fillStyle = this.hitstextcolor();
                                                if (this.searchin > 1)
                                                {
                                                    autotext(false,(this.searchin).toString() + " hits" ,  x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.85,temp_twidth*0.5,temp_theight_2*0.2);
                                                }
                                                else
                                                {
                                                    autotext(false,"1 hit" ,  x+r*this.arcx,y+r*this.arcy-temp_theight_2*1.85,temp_twidth*0.5,temp_theight_2*0.2);
                                                }

                                            }
                                        }


                                } // no traits
                            }
                            else
                            {
                                // polytomy node filling
                                if (polytype ==1)
                                {
                                    context.beginPath();
                                    context.arc(x+r*(this.arcx),y+r*this.arcy,r*this.arcr,0,Math.PI*2,true);
                                    context.fillStyle = this.barccolor();
                                    context.fill();
                                }
                            } // polytomies

                            /*
                             if ((drawsignposts&&!signdone))//&&(!drawndetails))
                             {

                             if (this.name1&&(!commonlabels)) // white signposts
                             {
                             if ((thresholdtxt*4.5 < r*((this.hxmax-this.hxmin)/10))&&(r <=thresholdtxt*60))
                             {
                             context.fillStyle = 'rgba(255,255,255,0.6)';
                             context.fillRect(x+r*(this.hxmin)+(r*(this.hxmax-this.hxmin)*0.15),y+r*(this.hymin)+r*(this.hymax-this.hymin)/2-r*(this.hxmax-this.hxmin)*0.225,r*(this.hxmax-this.hxmin)*0.7,r*(this.hxmax-this.hxmin)*0.45);
                             //context.arc(x+r*(this.hxmax+this.hxmin)/2,y+r*(this.hymax+this.hymin)/2,r*((this.hxmax-this.hxmin)/2),0,Math.PI*2,true);
                             // context.fill();
                             context.fillStyle = 'rgb(0,0,0)';
                             autotext3(true,this.name1 ,x+r*(this.hxmax+this.hxmin)/2,y+r*(this.hymax+this.hymin)/2,r*(this.hxmax-this.hxmin)*0.7,r*((this.hxmax-this.hxmin)/10));
                             signdone = true;
                             }
                             }
                             if (this.cname&&(commonlabels)) // white signposts
                             {
                             if ((thresholdtxt*4.5 < r*((this.hxmax-this.hxmin)/10))&&(r <=thresholdtxt*60))
                             {
                             context.fillStyle = 'rgba(255,255,255,0.6)';
                             //context.fillRect(x+r*(this.hxmax+this.hxmin)/2-r*((this.hxmax-this.hxmin)/4),y+r*(this.hymax+this.hymin)/2-r*((this.hymax-this.hymin)/10),r*((this.hxmax-this.hxmin)/2),r*(this.hymax-this.hymin)/5);
                             context.fillRect(x+r*(this.hxmin)+(r*(this.hxmax-this.hxmin)*0.15),y+r*(this.hymin)+r*(this.hymax-this.hymin)/2-r*(this.hxmax-this.hxmin)*0.225,r*(this.hxmax-this.hxmin)*0.7,r*(this.hxmax-this.hxmin)*0.45);
                             //context.arc(x+r*(this.hxmax+this.hxmin)/2,y+r*(this.hymax+this.hymin)/2,r*((this.hxmax-this.hxmin)/2),0,Math.PI*2,true);
                             // context.fill();
                             context.fillStyle = 'rgb(0,0,0)';
                             autotext3(true,this.cname ,x+r*(this.hxmax+this.hxmin)/2,y+r*(this.hymax+this.hymin)/2,r*(this.hxmax-this.hxmin)*0.7,r*((this.hxmax-this.hxmin)/10));
                             signdone = true;
                             }
                             }

                             }
                             //*/

                            // draw number of hits / number threatened
                        }


                        // END INT NODE DETAILS

                    }
                    else
                    {
                        // we are drawing a leaf
                        this.tipleaflogic(x+((r)*this.arcx),y+(r)*this.arcy,r*this.arcr,this.arca);
                        if ( (r*leafmult) > threshold*10)
                        {
                            this.leafdetail(x,y,r,leafmult,partc,partl2,Twidth,Tsize);
                        }
                    }
                }
            }
        }
        if (this.lengthbr <= timelim)
        {
            if (this.richness_val > 1)
            {
                this.growthleaflogic(x+((r)*(this.arcx)),y+(r)*(this.arcy),r*leafmult*0.5*partc,this.arca);
            }
            else
            {
                this.tipleaflogic(x+((r)*this.arcx),y+(r)*this.arcy,r*this.arcr,this.arca);
                if ( (r*leafmult) > threshold*10)
                {
                    this.leafdetail(x,y,r,leafmult,partc,partl2,Twidth,Tsize);
                }
            }
        }
    }
    return signdone;
}

midnode.prototype.leafdetail = function(x,y,r,leafmult,partc,partl2,Twidth,Tsize)
{
    var temp_twidth = (r*leafmult*partc-r*leafmult*partl2)*Twidth;
    var temp_theight = ((r*leafmult*partc-r*leafmult*partl2)*Tsize/3.0);

    if ( r > thresholdtxt*85)
    {

            if (this.linkclick)
            {
                context.fillStyle = 'rgb(0,0,0)';
                context.beginPath();
                context.arc(x+r*this.arcx,y+r*this.arcy-temp_theight*1.75,temp_theight*0.35,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = 'rgb(255,255,255)';
                context.beginPath();
                context.arc(x+r*this.arcx,y+r*this.arcy-temp_theight*1.75,temp_theight*0.28,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = 'rgb(0,0,0)';
                autotext(true,"Wiki", x+r*this.arcx,y+r*this.arcy-temp_theight*1.75,temp_twidth*0.2,temp_theight*0.2);
            }
            else
            {
                context.fillStyle = 'rgb(255,255,255)';
                context.beginPath();
                context.arc(x+r*this.arcx,y+r*this.arcy-temp_theight*1.75,temp_theight*0.35,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = this.leafcolor2();
                context.beginPath();
                context.arc(x+r*this.arcx,y+r*this.arcy-temp_theight*1.75,temp_theight*0.28,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = this.leafcolor3();
                autotext(true,"Wiki", x+r*this.arcx,y+r*this.arcy-temp_theight*1.75,temp_twidth*0.2,temp_theight*0.2);
            }


        context.fillStyle = this.leafcolor3();

        if (datahastraits)
        {
            if (this.cname)
            {
                if (commonlabels)
                {
                    if (this.name2)
                    {
                        autotext(true,this.name2 + " " + this.name1, x+r*this.arcx,y+r*this.arcy-temp_theight*1,temp_twidth*1,temp_theight*0.5);
                    }
                    else
                    {
                        autotext(true,this.name1, x+r*this.arcx,y+r*this.arcy-temp_theight*1,temp_twidth*1,temp_theight*0.5);
                    }
                    autotext2(false,this.cname,x+r*this.arcx,y+r*this.arcy,temp_twidth*1.4,temp_theight*0.75);
                }
                else
                {
                    if (this.name2)
                    {
                        autotext(true,this.name2 + " " + this.name1, x+r*this.arcx,y+r*this.arcy+temp_theight*0.25,temp_twidth*1.4,temp_theight*0.75);
                    }
                    else
                    {
                        autotext(true,this.name1, x+r*this.arcx,y+r*this.arcy+temp_theight*0.25,temp_twidth*1.4,temp_theight*0.75);
                    }
                    autotext2(false,this.cname,x+r*this.arcx,y+r*this.arcy-temp_theight*0.7,temp_twidth*1.1,temp_theight*0.4);
                }
            }
            else
            {
                autotext(false,"No common name", x+r*this.arcx,y+r*this.arcy-temp_theight*1.2,temp_twidth*1,temp_theight*0.5);
                if (this.name2)
                {
                    autotext2(true,this.name2 + " " + this.name1,x+r*this.arcx,y+r*this.arcy,temp_twidth*1.6,temp_theight*0.75);
                }
                else
                {
                    autotext2(true,this.name1,x+r*this.arcx,y+r*this.arcy,temp_twidth*1.6,temp_theight*0.75);
                }
            }
            autotext(false,"Conservation status: " + this.extxt() , x+r*this.arcx,y+r*this.arcy+temp_theight*1.2,temp_twidth*1.4,temp_theight*0.25);
            autotext(false,"Population " + this.poptxt() , x+r*this.arcx,y+r*this.arcy+temp_theight*1.65,temp_twidth*1.2,temp_theight*0.25);

            /*
            if (temp_theight*0.05 > threshold*1.5)
            {
                context.fillStyle = this.leafcolor3();

                for (i = 0 ; i < 9 ; i ++)
                {
                    context.beginPath();
                    context.arc(x+r*this.arcx+temp_theight*i*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.05,0,Math.PI*2,true);
                    context.fill();
                }

                context.fillStyle = redlistcolor("EX");
                context.beginPath();
                context.arc(x+r*this.arcx+temp_theight*0*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = redlistcolor("EW");
                context.beginPath();
                context.arc(x+r*this.arcx+temp_theight*1*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = redlistcolor("CR");
                context.beginPath();
                context.arc(x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = redlistcolor("EN");
                context.beginPath();
                context.arc(x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = redlistcolor("VU");
                context.beginPath();
                context.arc(x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = redlistcolor("NT");
                context.beginPath();
                context.arc(x+r*this.arcx+temp_theight*5*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = redlistcolor("LC");
                context.beginPath();
                context.arc(x+r*this.arcx+temp_theight*6*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = redlistcolor("DD");
                context.beginPath();
                context.arc(x+r*this.arcx+temp_theight*7*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = redlistcolor("NE");
                context.beginPath();
                context.arc(x+r*this.arcx+temp_theight*8*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,0,Math.PI*2,true);
                context.fill();
                context.fillStyle = this.leafcolor3();
                autotext(false,"EX", x+r*this.arcx+temp_theight*0*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,temp_theight*0.04);
                autotext(false,"EW", x+r*this.arcx+temp_theight*1*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,temp_theight*0.04);
                autotext(false,"CR", x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,temp_theight*0.04);
                autotext(false,"EN", x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,temp_theight*0.04);
                autotext(false,"VU", x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,temp_theight*0.04);
                autotext(false,"NT", x+r*this.arcx+temp_theight*5*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,temp_theight*0.04);
                autotext(false,"LC", x+r*this.arcx+temp_theight*6*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,temp_theight*0.04);
                autotext(false,"DD", x+r*this.arcx+temp_theight*7*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,temp_theight*0.04);
                autotext(false,"NE", x+r*this.arcx+temp_theight*8*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.9,temp_theight*0.04,temp_theight*0.04);
                autotext(false,conconvert("EX"), x+r*this.arcx+temp_theight*0*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.921,temp_theight*0.04,temp_theight*0.005);
                autotext(false,conconvert("EW"), x+r*this.arcx+temp_theight*1*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.921,temp_theight*0.04,temp_theight*0.005);
                autotext(false,conconvert("CR"), x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.921,temp_theight*0.04,temp_theight*0.005);
                autotext(false,conconvert("EN"), x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.921,temp_theight*0.04,temp_theight*0.005);
                autotext(false,conconvert("VU"), x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.921,temp_theight*0.04,temp_theight*0.005);
                autotext(false,conconvert("NT"), x+r*this.arcx+temp_theight*5*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.921,temp_theight*0.04,temp_theight*0.005);
                autotext(false,conconvert("LC"), x+r*this.arcx+temp_theight*6*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.921,temp_theight*0.04,temp_theight*0.005);
                autotext(false,conconvert("DD"), x+r*this.arcx+temp_theight*7*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.921,temp_theight*0.04,temp_theight*0.005);
                autotext(false,conconvert("NE"), x+r*this.arcx+temp_theight*8*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.921,temp_theight*0.04,temp_theight*0.005);
                autotext(true,"Threatened", x+r*this.arcx+temp_theight*2*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.879,temp_theight*0.04,temp_theight*0.005);
                autotext(true,"Threatened", x+r*this.arcx+temp_theight*3*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.879,temp_theight*0.04,temp_theight*0.005);
                autotext(true,"Threatened", x+r*this.arcx+temp_theight*4*0.15-4*0.15*temp_theight,y+r*this.arcy+temp_theight*1.879,temp_theight*0.04,temp_theight*0.005);
            }
            //*/
        }
        else
        {
            if (this.name2)
            {
                autotext2(true,this.name2 + " " + this.name1,x+r*this.arcx,y+r*this.arcy,temp_twidth*1.6,temp_theight*0.75);
            }
            else
            {
                autotext2(true,this.name1,x+r*this.arcx,y+r*this.arcy,temp_twidth*1.6,temp_theight*0.75);
            }
        }
    }
    else
    {
        if ( r > thresholdtxt*15)
        {
            context.fillStyle = this.leafcolor3();

            if (datahastraits)
            {
                if (this.iprimaryname())
                {
                    autotext3(false,this.iprimaryname(),x+r*this.arcx,y+r*this.arcy,temp_twidth*1.7,temp_theight*0.8);
                }
                else
                {
                    if (this.isecondaryname())
                    {
                        autotext3(false,this.isecondaryname(),x+r*this.arcx,y+r*this.arcy,temp_twidth*1.7,temp_theight*0.8);
                    }
                }
                //autotext(false,this.extxt() , x+r*this.arcx,y+r*this.arcy+temp_theight*1.6,temp_twidth*1.2,temp_theight*0.5);

             }
            else
            {
                if (this.name2)
                {
                    autotext3(true,this.name2 + " " + this.name1,x+r*this.arcx,y+r*this.arcy,temp_twidth*1.6,temp_theight*0.75);
                }
                else
                {
                    autotext3(true,this.name1,x+r*this.arcx,y+r*this.arcy,temp_twidth*1.6,temp_theight*0.75);
                }
            }
        }
    }
}

function performsearch2(toclear)
{
    searchinteriornodes = false;
    var changedvar = false;
    var stringin = document.forms["myform"]["tosearchfor"].value;

    stringin = stringin.replace("extinct in the wild", "EW");
    stringin = stringin.replace("extinct", "EX");
    stringin = stringin.replace("critically endangered", "CR");
    stringin = stringin.replace("endangered", "EN");
    stringin = stringin.replace("vulnerable", "VU");
    stringin = stringin.replace("near threatened", "NT");
    stringin = stringin.replace("least concern", "LC");
    stringin = stringin.replace("data deficient", "DD");
    stringin = stringin.replace("not evaluated", "NE");

    var searchinpartsnew = stringin.split(" ");

    if (searchinpartsnew.length == searchinparts.length)
    {
        for (i = 0 ; i < searchinpartsnew.length ; i ++)
        {
            if (searchinpartsnew[i] != searchinparts[i])
            {
                changedvar = true;
            }
        }
    }
    else
    {
        changedvar = true;
    }

    if (latin_search != (document.forms["myform"]["latinsearch"].checked))
    {
        changedvar = true;
        latin_search = (document.forms["myform"]["latinsearch"].checked)
    }
    if (common_search != (document.forms["myform"]["commonsearch"].checked))
    {
        changedvar = true;
        common_search = (document.forms["myform"]["commonsearch"].checked)
    }
    if (trait_search != (document.forms["myform"]["traitsearch"].checked))
    {
        changedvar = true;
        trait_search = (document.forms["myform"]["traitsearch"].checked)
    }

    if (!changedvar)
    {
        if (toclear)
        {
            fulltree.semiclearsearch();
        }
        changedvar = false;
    }
    else
    {
        fulltree.clearsearch();
        searchinparts = searchinpartsnew;
        numhits = fulltree.search();
        //if (numhits == 0)
       // {
        //    searchinteriornodes = true;
        //    fulltree.clearsearch();
        //    numhits = fulltree.search();
        //
        //}
        changedvar = true;
    }
    return changedvar;
}


midnode.prototype.searchone = function(stringin,leafonly)
{
    var foundstr = 0;

    if (document.forms["myform"]["traitsearch"].checked)
    {
        if ((((stringin == "EX")||(stringin == "EW"))||(((stringin == "EN")||(stringin == "CR"))||((stringin == "VU")||(stringin == "NT"))))||(((stringin == "DD")||(stringin == "LC"))||(stringin == "NE")))
        {
            if (!(this.child1))
            {
                if ((this.redlist)&&(this.redlist == stringin))
                {
                    foundstr +=this.richness_val;
                }
            }
        }
        else
        {
            if (((stringin.toLowerCase() == "increasing")&&(this.popstab))&&(this.popstab == "I"))
            {
                foundstr +=this.richness_val;
            }
            else
            {
                if (((stringin.toLowerCase() == "decreasing")&&(this.popstab))&&(this.popstab == "D"))
                {
                    foundstr +=this.richness_val;
                }
                else
                {
                    if (((stringin.toLowerCase() == "stable")&&(this.popstab))&&(this.popstab == "S"))
                    {
                        foundstr +=this.richness_val;
                    }
                    else
                    {
                        if ((stringin.toLowerCase() == "threatened")&&((this.redlist)&&(((this.redlist == "CR")||(this.redlist == "EN"))||(this.redlist == "VU"))))
                        {
                            foundstr +=this.richness_val;
                        }
                    }
                }
            }
        }
    }
    if (foundstr == 0 && (document.forms["myform"]["latinsearch"].checked))
    {

        if ((stringin.toLowerCase()) == stringin)
        {
            if (!((leafonly)&&(this.child1)))
            {
                if ((this.name1)&&((this.name1.toLowerCase()).search(stringin) != -1))
                {
                    foundstr += this.richness_val;
                }
                else
                {
                    if (((this.name2)&&((this.name2.toLowerCase()).search(stringin) != -1))&&(!this.child1))
                    {
                        foundstr +=this.richness_val;
                    }

                }

            }
        }
        else
        {
            if (!((leafonly)&&(this.child1)))
            {
                if ((this.name1)&&((this.name1).search(stringin) != -1))
                {
                    foundstr += this.richness_val;
                }
                else
                {
                    if (((this.name2)&&((this.name2).search(stringin) != -1))&&(!this.child1))
                    {
                        foundstr +=this.richness_val;
                    }

                }
            }
        }

    }

    if (foundstr == 0 && (document.forms["myform"]["commonsearch"].checked))
    {
        if (!((leafonly)&&(this.child1)))
        {
            if ((stringin.toLowerCase()) == stringin)
            {
                if ((this.cname)&&((this.cname.toLowerCase()).search(stringin) != -1))
                {
                    foundstr +=this.richness_val;
                }
            }
            else
            {
                if ((this.cname)&&((this.cname).search(stringin) != -1))
                {
                    foundstr +=this.richness_val;
                }
            }
        }
    }
    return foundstr;
}



midnode.prototype.searchtwo = function(stringin,leafonly)
{
    var foundstr = 0;

    if (document.forms["myform"]["traitsearch"].checked)
    {
        if ((((stringin == "EX")||(stringin == "EW"))||(((stringin == "EN")||(stringin == "CR"))||((stringin == "VU")||(stringin == "NT"))))||(((stringin == "DD")||(stringin == "LC"))||(stringin == "NE")))
        {
            if (!(this.child1))
            {
                if ((this.redlist)&&(this.redlist == stringin))
                {
                    foundstr +=this.richness_val;
                }
            }
        }
        else
        {
            if (((stringin.toLowerCase() == "increasing")&&(this.popstab))&&(this.popstab == "I"))
            {
                foundstr +=this.richness_val;
            }
            else
            {
                if (((stringin.toLowerCase() == "decreasing")&&(this.popstab))&&(this.popstab == "D"))
                {
                    foundstr +=this.richness_val;
                }
                else
                {
                    if (((stringin.toLowerCase() == "stable")&&(this.popstab))&&(this.popstab == "S"))
                    {
                        foundstr +=this.richness_val;
                    }
                    else
                    {
                        if ((stringin.toLowerCase() == "threatened")&&((this.redlist)&&(((this.redlist == "CR")||(this.redlist == "EN"))||(this.redlist == "VU"))))
                        {
                            foundstr +=this.richness_val;
                        }
                    }
                }
            }
        }
    }
    if (foundstr == 0 && (document.forms["myform"]["latinsearch"].checked))
    {

        if ((stringin.toLowerCase()) == stringin)
        {
            if (!((leafonly)&&(this.child1)))
            {
                if ((this.name1)&&((this.name1.toLowerCase()).search(stringin) != -1))
                {
                    foundstr += this.richness_val;
                }
                else
                {
                    if (((this.name2)&&((this.name2.toLowerCase()).search(stringin) != -1))&&(!this.child1))
                    {
                        foundstr +=this.richness_val;
                    }

                }
            }

        }
        else
        {
            if (!((leafonly)&&(this.child1)))
            {
                if ((this.name1)&&((this.name1).search(stringin) != -1))
                {
                    foundstr += this.richness_val;
                }
                else
                {
                    if (((this.name2)&&((this.name2).search(stringin) != -1))&&(!this.child1))
                    {
                        foundstr +=this.richness_val;
                    }

                }
            }

        }
        if ((this.child1)&&(foundstr == 0))
        {
            if ((fullsearchstring.toLowerCase()) == fullsearchstring)
            {
                if ((this.name1)&&((this.name1.toLowerCase()) == fullsearchstring))
                {
                    foundstr +=this.richness_val;
                }
            }
            else
            {
                if ((this.name1)&&((this.name1) == fullsearchstring))
                {
                    foundstr +=this.richness_val;
                }
            }
        }
    }

    if (foundstr == 0 && (document.forms["myform"]["commonsearch"].checked))
    {
        if (!((leafonly)&&(this.child1)))
        {
            if ((stringin.toLowerCase()) == stringin)
            {
                if ((this.cname)&&((this.cname.toLowerCase()).search(stringin) != -1))
                {
                    foundstr +=this.richness_val;
                }
            }
            else
            {
                if ((this.cname)&&((this.cname).search(stringin) != -1))
                {
                    foundstr +=this.richness_val;
                }
            }
        }

    }
    return foundstr;
}






function midnode (x)
{
    // all the graphics parameters referenced from the reference point and reference scale which are set once and changed only when the fractal form is changed

    // for bezier curve (basic graphics element 1 of 2)
    var bezsx; // start x position
    var bezsy; // start y position
    var bezex; // end x position
    var bezey; // end y position
    var bezc1x; // control point 1 x position
    var bezc1y; // control point 2 y position
    var bezc2x; // control point 2 x position
    var bezc2y; // control point 2 y position
    var bezr; // line width

    // for the circle (basic graphics element 2 of 2)
    var arcx; // centre x position
    var arcy; // centre y position
    var arcr; // radius
    var arca; // angle of the arc

    // for the horizon (the region within which all graphics elements of this node and all its child nodes are contained)
    var hxmin; // min x value
    var hxmax; // max x value
    var hymin; // min y value
    var hymax; // max y value

    // for the graphics box (the region within which all graphics elements of this node alone (excluding its children) are contained
    var gxmin; // min x value
    var gxmax; // max x value
    var gymin; // min y value
    var gymax; // max y value

    // for the flight box (frames the region that defines a nice flight to the target after a search)
    var fxmin; // min x value
    var fxmax; // max x value
    var fymin; // min y value
    var fymax; // max y value

    // for the reference points of the two children
    var nextx1; // x refernece point for both children
    var nexty1; // y reference point for both children
    var nextx2; // x refernece point for both children
    var nexty2; // y reference point for both children
    var nextr1; // r (scale) reference for child 1
    var nextr2; // r (scale) reference for child 2

    // stores the refernce point and reference scale which get updated with each redraw of the page
    var xvar; // x
    var yvar; // y
    var rvar; // the value of r for the current view (null means nothign to draw)

    // variables indicating if drawing is needed for this node or its children updated with each redraw of the page
    var dvar; // true if this or its children need to be drawn
    var gvar; // true if graphics elements in this node itself need to be drawn

    // flight and search data
    var searchin = 0;
    var startscore = 0; // gives this node a score for being the starting node
    var onroute = false;
    var targeted = false;
    var searchinpast = 0;
    var flysofarA = false;
    var flysofarB = false;

    // other data
    var npolyt = true; // true if node is NOT a polytomy
    var graphref = false; // true for one path of nodes through the tree, the IFIG is anchored on the node at the end of that path

    this.linkclick = false; // tells if a link has been clicked

    this.phylogenetic_diversity = 0.0;

    // This part of the code initialises the mode from newick format
    var bracketscount = 0;
    var cut;
    var end;

    if (x.charAt(x.length-1) == ';')
    {
        x = x.substr(0,x.length-1);
    }

    if (x.charAt(0) == '(')
    {
        for (i = 0; i < x.length ; i++)
        {
            if (x.charAt(i) == '(')
            {
                bracketscount ++;
            }
            if (x.charAt(i) == ')')
            {
                bracketscount --;
            }
            if (x.charAt(i) == ',')
            {
                if (bracketscount == 1)
                {
                    cut = i;
                }
            }
            if (bracketscount == 0)
            {
                end = i;
                i = x.length +1;
            }
        }

        var cut1 = x.substr(1,cut-1);
        var cut2 = x.substr(cut+1,end-cut-1);
        var cutname = x.substr(end+1,x.length-end);
        // this is an interior node with name 'cutname'
        // the two children are given by cut1 ad cut2

        var lengthcut = -1;
        for (i = 0; i < cutname.length ; i++)
        {
            if (cutname.charAt(i) == ':')
            {
                lengthcut = i;
            }
        }
        if (lengthcut == -1)
        {
            this.lengthbr = null;
        }
        else
        {
            this.lengthbr = parseFloat(cutname.substr(lengthcut+1,(cutname.length)-lengthcut));
            cutname = cutname.substr(0,lengthcut);
        }

        // at this stage cutname does not have the length data associated with it

        if ((cutname.length > 0)&&((cutname!=((parseFloat(cutname)).toString()))||innode_label_help))
        {

            //this.name2 = null;
            //this.name1 = cutname;

            lengthcut = -1;

            for (i = 0; i < cutname.length ; i++)
            {
                if (cutname.charAt(i) == '{')
                {
                    lengthcut = i;
                    i = cutname.length;
                }
            }
            if (lengthcut == -1)
            {
                // no common names
                this.cname = null;
                this.name1 = cutname;
                this.name2 = null;
            }
            else
            {
                // common names

                this.cname = cutname.substr(lengthcut+1,(cutname.length)-lengthcut-2);
                if (lengthcut != 1)
                {
                    this.name1 = cutname.substr(0,lengthcut);
                }
                else
                {
                    this.name1 = null;
                }

                // now we need to split [] out of cname and replace "*" with ","

                lengthcut = -1;
                //*
                for (i = 0; i < (this.cname).length ; i++)
                {
                    if ((this.cname).charAt(i) == '[')
                    {
                        lengthcut = i;
                        i = (this.cname).length;
                    }
                }
                //*/


                if (lengthcut == -1)
                {
                    this.name2 = null;
                }
                else
                {
                    this.name2 = (this.cname).substr(lengthcut+1,((this.cname).length)-lengthcut-2);
                    this.cname = (this.cname).substr(0,lengthcut);

                }


                for (i = 0; i < (this.cname).length ; i++)
                {
                    if ((this.cname).charAt(i) == '*')
                    {
                        (this.cname) = (this.cname).substr(0, i) + "," + (this.cname).substr(i+1,(this.cname).length-1);
                    }
                }

                /*
                 lengthcut = -1;
                 for (i = 0; i < this.cname.length ; i++)
                 {
                 if (this.cname.charAt(i) == '_')
                 {
                 lengthcut = i;
                 i = this.cname.length;
                 }
                 }
                 if (lengthcut == -1)
                 {
                 // no conservationdata
                 this.popstab = "U";
                 this.redlist = "NE";
                 }
                 else
                 {
                 this.redlist = this.cname.substr(lengthcut+1,(this.cname.length)-lengthcut-3);
                 this.popstab = this.cname.substr((this.cname.length)-1,1);
                 this.cname = this.cname.substr(0,lengthcut);
                 }
                 */


            }
        }
        else
        {

            this.name2 = null;
            this.name1 = null;
            this.cname = null;
        }

        // initialise children
        this.child1 = new midnode(cut1,this);
        this.child2 = new midnode(cut2,this);
        // initialise interior node variables
        this.richness_val = 0;
    }
    else
    {
        this.child1 = null;
        this.child2 = null;
        this.richness_val =0; // these richness values are sorted out later

        var lengthcut = -1;
        for (i = 0; i < x.length ; i++)
        {
            if (x.charAt(i) == ':')
            {
                lengthcut = i;
            }
        }
        if (lengthcut == -1)
        {
            this.lengthbr = null;
        }
        else
        {
            this.lengthbr = parseFloat(x.substr(lengthcut+1,(x.length)-lengthcut));
            x = x.substr(0,lengthcut);
        }

        if (x.length > 0)
        {
            lengthcut = -1;
            for (i = 0; i < x.length ; i++)
            {
                if (x.charAt(i) == '{')
                {
                    lengthcut = i;
                    i = x.length;
                }
            }
            if (lengthcut == -1)
            {
                // no metadata
                datahastraits = false;
            }
            else
            {
                // metadata

                /// ***** LEAF NODE SORT START

                this.cname = x.substr(lengthcut+1,(x.length)-lengthcut-2)
                x = x.substr(0,lengthcut);

                //*
                lengthcut = -1;
                for (i = 0; i < this.cname.length ; i++)
                {
                    if (this.cname.charAt(i) == '_')
                    {
                        lengthcut = i;
                        i = this.cname.length;
                    }
                }
                if (lengthcut == -1)
                {
                    // no conservationdata
                    this.popstab = "U";
                    this.redlist = "NE";
                }
                else
                {
                    this.redlist = this.cname.substr(lengthcut+1,(this.cname.length)-lengthcut-3);
                    this.popstab = this.cname.substr((this.cname.length)-1,1);
                    this.cname = this.cname.substr(0,lengthcut);
                }
            }


            lengthcut = -1;
            for (i = 0; i < x.length ; i++)
            {
                if (x.charAt(i) == '_')
                {
                    lengthcut = i;
                    i = x.length;
                }
            }
            if (lengthcut == -1)
            {
                this.name2 = null;
                this.name1 = x;
            }
            else
            {
                this.name1 = x.substr(lengthcut+1,(x.length)-lengthcut-1);
                this.name2 =  x.substr(0,lengthcut);
            }
        }
        else
        {
            this.name2 = null;
            this.name1 = null;
            datahastraits = false;
        }
    }
}

// SORTING OUT THE LINKS TO OUTSIDE THE PAGE

midnode.prototype.links2 = function()
{
    var x ;
    var y ;
    var r ;
    if(this.dvar)
    {
        if (this.rvar)
        {
            x = this.xvar;
            y = this.yvar;
            r = this.rvar;
        }
        if ((this.child1)&&(this.lengthbr > timelim))
        {
            if ((this.child1.links2())||(this.child2.links2()))
            {
                this.linkclick = true;
            }
        }
        if (this.lengthbr > timelim)
        {
            if (!(((this.richness_val > 1)&&(r<=threshold))&&(timelim <= 0)))
            {
                if (this.richness_val > 1)
                {
                    if (this.lengthbr > timelim)
                    {
                        var temp_twidth = (r*partc-r*partl2)*Twidth;
                        var temp_theight = (r*partc-r*partl2)*Tsize/2.0;
                        var temp_theight_2 = (r*partc-r*partl2)*Tsize/3.0;
                        if ((this.npolyt)||(polytype == 3))
                        {
                            if (datahastraits)
                            {
                                if(r > thresholdtxt*280)
                                {
                                    if (this.name1)
                                    {
                                      var linkpos = 0;
                                        if ((this.npolyt)||(polytype != 2))
                                        {
                                            if ((highlight_search)&&(this.searchin > 0))
                                            {
                                                linkpos = temp_theight_2*0.45;
                                            }
                                        }
                                        if ( r > threshold*200)
                                        {

                                            if ((      ((mouseX-(x+r*this.arcx+linkpos))*(mouseX-(x+r*this.arcx+linkpos)))+  ((mouseY-(y+r*this.arcy-temp_theight_2*1.95))*(mouseY-(y+r*this.arcy-temp_theight_2*1.95)))    ) <= ((temp_theight*0.12)*(temp_theight*0.12)))
                                            {
                                                this.linkclick = true;
                                            }

                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                else
                {
                    if ( (r*leafmult) > threshold*10)
                    {
                        if(this.leaflink(x,y,r,leafmult,partc,partl2,Twidth,Tsize))
                        {

                            this.linkclick = true;

                        }
                    }
                }
            }
        }
    }
    return this.linkclick;

}



midnode.prototype.leaflink = function(x,y,r,leafmult,partc,partl2,Twidth,Tsize)
{
    if ( r > threshold*6)
    {
        var temp_twidth = (r*leafmult*partc-r*leafmult*partl2)*Twidth;
        var temp_theight = ((r*leafmult*partc-r*leafmult*partl2)*Tsize/3.0);
        if (temp_theight*0.2 > threshold/2.5)
        {
            if (((mouseX-(x+r*this.arcx))*(mouseX-(x+r*this.arcx)))+((mouseY-(y+r*this.arcy-temp_theight*1.75))*(mouseY-(y+r*this.arcy-temp_theight*1.75))) <= ((temp_theight*0.35)*(temp_theight*0.35)))
            {
                this.linkclick = true;
            }
        }
    }
    return this.linkclick;
}

midnode.prototype.clearlinks = function()
{
    this.linkclick = false;
    if (this.child1)
    {
        this.child1.clearlinks();
        this.child2.clearlinks();
    }
}

midnode.prototype.wikilink = function()
{
     if (this.linkclick)
    {
        if (this.child1)
        {
            if (this.child1.linkclick)
            {
                this.child1.wikilink();
            }
            else
            {
                if (this.child2.linkclick)
                {
                    this.child2.wikilink();
                }
                else
                {
                    mywindow = window.open("http://en.wikipedia.org/wiki/" + this.name1.toLowerCase());
                }
            }
        }
        else
        {
            mywindow = window.open("http://en.wikipedia.org/wiki/" + this.name2 + "_" + this.name1);
        }
    }
}



midnode.prototype.extxt = function() // returns text for redlist status
{
    if (this.redlist)
    {
        return conconvert(this.redlist);
    }
    else
    {
        return ("Not Evaluated");
    }
}

midnode.prototype.poptxt = function() // returns text for redlist status
{
    if (this.popstab)
    {
        switch(this.popstab)
        {
            case "D":
                return ("decreasing");
            case "I":
                return ("increasing");
            case "S":
                return ("stable");
            case "U":
            {
                if ((this.redlist == "EX")||(this.redlist == "EW"))
                {
                    return ("extinct");
                }
                else
                {
                    return ("stability unknown");
                }
            }
            default:
                if ((this.redlist == "EX")||(this.redlist == "EW"))
                {
                    return ("extinct");
                }
                else
                {
                    return ("stability unknown");
                }
        }

    }
    else
    {
        if ((this.redlist == "EX")||(this.redlist == "EW"))
        {
            return ("extinct");
        }
        else
        {
            return ("stability unknown");
        }
    }
}

function conconvert(casein)
{
    switch(casein)
    {
        case "EX":
            return ("Extinct");
        case "EW":
            return ("Extinct in the Wild");
        case "CR":
            return ("Critically Endangered");
        case "EN":
            return ("Endangered");
        case "VU":
            return ("Vulnerable");
        case "NT":
            return ("Near Threatened");
        case "LC":
            return ("Least Concern");
        case "DD":
            return ("Data Deficient");
        case "NE":
            return ("Not Evaluated");
        default:
            return ("Not Evaluated");
    }
}

function conconvert2(casein)
{
    switch(casein)
    {
        case "EX":
            return (0);
        case "EW":
            return (1);
        case "CR":
            return (2);
        case "EN":
            return (3);
        case "VU":
            return (4);
        case "NT":
            return (5);
        case "LC":
            return (6);
        case "DD":
            return (7);
        case "NE":
            return (8);
        default:
            return (9);
    }
}




// POPUP BOX DRAWING

function AboutOZ()
{
    if (!popupboxabout)
    {
        popupboxabout = true;
        popupboxlicense = false;
        if (tutorialmode)
        {
            tutorialmode = false;
            draw2();
            tutorialmode = true;
        }
        else
        {
            draw2();
        }
        context.beginPath();
        context.lineWidth = 1;
        context.lineTo( myCanvas.width /6 , myCanvas.height *4/5 );
        context.lineTo( myCanvas.width /6, myCanvas.height /5);
        context.lineTo( myCanvas.width *5/6, myCanvas.height /5 );
        context.lineTo( myCanvas.width *5/6 , myCanvas.height *4/5 );
        context.fillStyle = 'rgba(0,0,0,0.85)';
        context.fill();
        context.fillStyle = 'rgb(255,255,255)';
        autotext(false,"OneZoom (TM) web version 1.1 (2012)" , myCanvas.width /2 , myCanvas.height *0.32 , myCanvas.width *0.6 , 20);
        autotext(false,"Please read the associated manuscript" , myCanvas.width /2 , myCanvas.height *0.37 , myCanvas.width *0.6 , 15);
        autotext(false,"\"OneZoom: A Fractal Explorer for the Tree of Life \"" , myCanvas.width /2 , myCanvas.height *0.42 , myCanvas.width *0.6 , 15);
        autotext(false,"written by J. Rosindell and L. J. Harmon" , myCanvas.width /2 , myCanvas.height *0.47 , myCanvas.width *0.6 , 15);
        autotext(false,"Concept and software by J. Rosindell, development by J. Rosindell and L. J. Harmon" , myCanvas.width /2 , myCanvas.height *0.56 , myCanvas.width *0.6 , 10);
        autotext(false,"Special thanks to Jonathan Eastman, James Foster, Custis Lisle, Ian Owens, William Pearse, Albert Phillimore and Andy Purvis" , myCanvas.width /2 , myCanvas.height *0.6 , myCanvas.width *0.6 , 10);
        autotext(false,"Data: The IUCN Red List of Threatened Species. Version 2012.1. <http://www.iucnredlist.org> and" , myCanvas.width /2 , myCanvas.height *0.64 , myCanvas.width *0.6 , 10);
        autotext(false,"\"The delayed rise of present-day mammals\" O.R.P. Bininda-Emonds  et.al. (2007) Nature 446, p.507" , myCanvas.width /2 , myCanvas.height *0.68 , myCanvas.width *0.6 , 10);
        autotext(false,"J. Rosindell is grateful to NERC for funding his research" , myCanvas.width /2 , myCanvas.height *0.72 , myCanvas.width *0.6 , 10);
    }
    else
    {
        popupboxabout = false;
        draw2();
    }
}

function LicenseOZ()
{
    if (!popupboxlicense)
    {
        if (tutorialmode)
        {
            tutorialmode = false;
            draw2();
            tutorialmode = true;
        }
        else
        {
            draw2();
        }
        popupboxlicense = true;
        popupboxabout = false;
        context.beginPath();
        context.lineWidth = 1;
        context.lineTo( myCanvas.width /6 , myCanvas.height *4/5 );
        context.lineTo( myCanvas.width /6, myCanvas.height /5);
        context.lineTo( myCanvas.width *5/6, myCanvas.height /5 );
        context.lineTo( myCanvas.width *5/6 , myCanvas.height *4/5 );
        context.fillStyle = 'rgba(0,0,0,0.85)';
        context.fill();
        context.fillStyle = 'rgb(255,255,255)';

        autotext(false,"OneZoom version (TM) web version 1.1 (2012)" , myCanvas.width /2 , myCanvas.height *0.25 , myCanvas.width *0.6 , 15);
        autotext(false,"Copyright (c) 2012 owned by James Rosindell and Imperial College, London" , myCanvas.width /2 , myCanvas.height *0.35 , myCanvas.width *0.6 , 10);
        autotext(false,"URL: www.onezoom.org - please refer to website for updates" , myCanvas.width /2 , myCanvas.height *0.39 , myCanvas.width *0.6 , 10);
        autotext(false,"Citation: \"OneZoom: A Fractal Explorer for the Tree of Life\" PLoS Biology (2012) Rosindell, J. and Harmon, L. J." , myCanvas.width /2 , myCanvas.height *0.43 , myCanvas.width *0.6 , 10);
        autotext(false,"All rights reserved. By using OneZoom, you agree to cite the associated paper in any resulting publications." , myCanvas.width /2 , myCanvas.height *0.47 , myCanvas.width *0.6 , 10);
        autotext(false,"Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the \"Software\")," , myCanvas.width /2 , myCanvas.height *0.51 , myCanvas.width *0.6 , 10);
        autotext(false,"to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense," , myCanvas.width /2 , myCanvas.height *0.55 , myCanvas.width *0.6 , 10);
        autotext(false,"and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:" , myCanvas.width /2 , myCanvas.height *0.59 , myCanvas.width *0.6 , 10);
        autotext(false,"The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software." , myCanvas.width /2 , myCanvas.height *0.63 , myCanvas.width *0.6 , 10);
        autotext(false,"THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY," , myCanvas.width /2 , myCanvas.height *0.67 , myCanvas.width *0.6 , 10);
        autotext(false,"FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY," , myCanvas.width /2 , myCanvas.height *0.71 , myCanvas.width *0.6 , 10);
        autotext(false,"WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE." , myCanvas.width /2 , myCanvas.height *0.75 , myCanvas.width *0.6 , 10);
    }
    else
    {
        popupboxlicense = false;
        draw2();
    }
}
