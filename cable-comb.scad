$fn = 40;

wireDiams = [15,5,5,5,5,5,20];

gf = 0.5; //gap factor
t=10; //thickness
wtf = 0.1; //wall thickness factor
minWt = 2; //min wall thickness
h1 =4;
h2 =2;
h3 =5; 

//Calcuated constants
maxDiam = max(wireDiams);
h0 = maxDiam+h1+h2+h3;




//function add(v, i = 0, r = 0) = i < len(v) ? add(v, i + 1, r + v[i]) : r;

function addN(v,n, i = 0, r = 0) = i < n ? addN(v,n, i + 1, r + v[i]) : r;


function clearWidth(d) = 2*h0*sin(asin(((d-d*gf)/2)/(h3+maxDiam)))+d+2*max([minWt,d*wtf]);


function clearWidth2(d) = d+2*max([minWt,d*wtf])+2*(h0*sin(asin(((d-w1)/2)/(h3+maxDiam))));
    

clearWidths = [for (a =wireDiams)clearWidth(a)] ;

echo("ClearWidths:");
echo(clearWidths);







echo(addN(clearWidths,1));

offsets = [for(i=[0:1:len(wireDiams)]) addN(clearWidths,i)];

echo("offsets:");
echo(offsets);


//clearWidths = for(curDiam=wireDiams) clearWidth(curDiam);
    

for(i = [0:1:len(wireDiams)-1]){

    echo(wireDiams[i]);


}
    



module clip(diam){
    //Clips specific variables
    w1=diam*gf;
    wt = max([minWt,diam*wtf]); //wall thickness
    w0 = diam+2*wt;  //totalwidth
    rot = asin(((diam-w1)/2)/(h3+maxDiam)); //max clip rotation
    clear = h0*sin(rot); //required clearance


translate([w0/2+clear,-h0+h1+h2,0]){

        translate([0,h0/2-h1-h2,0]){
            translate([clear/2+w0/2,0,0]){
                %cube([clear,h0,t],true);
            }

            translate([-(clear/2+w0/2),0,0]){
                %cube([clear,h0,t],true);
            }
        }

        difference(){
            translate([0,h0/2-h1-h2,0]){
                cube([w0,h0,t],true); //gap    
            }
            translate([0,h0/2-h1-h2,0]){
                cube([w1,h0,t],true); //gap    
            }
            translate([0,diam/2,0]){
                cylinder(h=t, d=diam,  center = true);
            }
            linear_extrude(height=t,center=true){
            polygon([[-diam/2,-h1-h2],[diam/2,-h1-h2],[w1/2,-h2],[-w1/2,-h2]]);
            }
        }
    }
}




for(i = [0:1:len(wireDiams)-1]){
    translate([offsets[i],0,0]){
        clip(wireDiams[i]);
    }

}



