$fn = 40;

wireDiams = [6.9,5.7,3.5]; //wire 

gapFact = 0.5; //gap factor

wallThkFact = 0.1; //wall thickness factor
wallThkMin = 2; //min wall thickness
h1 =2;
h2 =2;
h3 =3; 

baseHeight = 4; //height of the base
thickness=10; //thickness

//Calcuated constants
maxDiam = max(wireDiams);
clipHeight = maxDiam+h1+h2+h3;



function clearance(d) = clipHeight*sin(asin(((d-(d*gapFact))/2)/(h3+maxDiam)));
clearances = [for (d =wireDiams)clearance(d)];

clipLengths = [for(d=wireDiams)d+2*max([wallThkMin,d*wallThkFact])];

centerSpacing = [for(i=[0:1:len(wireDiams)-2]) clipLengths[i]/2+clipLengths[i+1]/2+max([clearances[i],clearances[i+1]])];

function addN(v,n, i = 0, r = 0) = i < n ? addN(v,n, i + 1, r + v[i]) : r;
offsets = [for(i=[0:1:len(wireDiams)-1]) addN(centerSpacing,i)];


module clip(diam){

    l1=diam*gapFact;
    wallThk = max([wallThkMin,diam*wallThkFact]); //wall thickness
    l0 = diam+2*wallThk;  //totalwidth
    rot = asin(((diam-l1)/2)/(h3+maxDiam)); //max clip rotation
    clear = clipHeight*sin(rot); //required clearance

    translate([0,-clipHeight+h1+h2,0]){

        translate([0,clipHeight/2-h1-h2,0]){
            translate([clear/2+l0/2,0,0]){
                %cube([clear,clipHeight,thickness],true);
            }

            translate([-(clear/2+l0/2),0,0]){
                %cube([clear,clipHeight,thickness],true);
            }
        }

        difference(){
            translate([0,clipHeight/2-h1-h2,0]){
                cube([l0,clipHeight,thickness],true); //gap    
            }
            translate([0,clipHeight/2-h1-h2,0]){
                cube([l1,clipHeight,thickness],true); //gap    
            }
            translate([0,diam/2,0]){
                cylinder(h=thickness, d=diam,  center = true);
            }
            linear_extrude(height=thickness,center=true){
            polygon([[-diam/2,-h1-h2],[diam/2,-h1-h2],[l1/2,-h2],[-l1/2,-h2]]);
            }
        }
    }
}

clipsLength = clipLengths[0]/2+clipLengths[len(clipLengths)-1]/2+ addN(centerSpacing,len(centerSpacing));


baseLength = clipsLength;


translate([0,-baseHeight/2,thickness/2]){
    cube([baseLength,baseHeight,thickness],true);
}



translate([clipLengths[0]/2-clipsLength/2,-baseHeight,thickness/2]){

    for(i = [0:1:len(wireDiams)-1]){
        translate([offsets[i],0,0]){
            clip(wireDiams[i]);
        }

    }
}




