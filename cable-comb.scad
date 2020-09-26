
$fn = 40;


wireDiams = [5,10,15,20];




gf = 0.5; //gap factor
t=10; //thickness
wtf = 0.1; //wall thickness factor
minWt = 3; //min wall thickness
diam = 15;
h1 =5;
h2 =2;
h3 =10; 




//Calcuated constants
maxDiam = max(wireDiams);
h0 = maxDiam+h1+h2+h3;


//function add(v, i = 0, r = 0) = i < len(v) ? add(v, i + 1, r + v[i]) : r;

function addN(v,n, i = 0, r = 0) = i < n ? addN(v,n, i + 1, r + v[i]) : r;


function clearWidth(d) = 2*h0*sin(asin(((d-d*gf)/2)/(h3+maxDiam)))+diam+2*max([minWt,d*wtf]);
    

clearWidths = [for (a =wireDiams)clearWidth(a)] ;

echo("ClearWidths:");
echo(clearWidths);


echo(addN(clearWidths,1));



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

clip(20);

