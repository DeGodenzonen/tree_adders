`timescale 1ns / 1ps

module main#(parameter size=128 ,parameter level=7)(input [size:1] a, input [size:1] b, input cin,
                             output [size:1] sum ,output  cout);
wire [size:0] p;
wire [size:0] g;
wire [size:0] gn2o;
wire [level*size:0] wg; // for wiring logic
wire [level*size:0] wp; // for wiring logic


assign g[0]=cin;
assign gn2o[0]=cin;
assign wg[0]=cin;


genvar i;
generate
  for(i=1;i<=size;i=i+1)
    begin
     and(g[i],a[i],b[i]);
     xor(p[i],a[i],b[i]);
    end
endgenerate


genvar m,n,o,q,r,s;
generate
for(m=1;m<=level;m=m+1)// level loop
   begin
      if (m==1)  // first level is taking bitwise g and p
      begin
        grey #(2) dut2 (gn2o[1],{g[1],g[0]},p[1]);
        for(n=3;n<=size;n=n+2)
        begin
            black #(2) dut (wg[n],wp[n],{g[n],g[n-1]},{p[n],p[n-1]});
            assign wg[n-1]=g[n-1];
            assign wp[n-1]=p[n-1];
        end
      end
      else 
      begin
       for(q=(2**m+(2**(m-1)));q<size;q=q+(2**m)) //for black cells 
       begin
         for(o=1;o<=2**(m-1);o=o+1)
         begin
            black #(2) dut1 (wg[q+(o-1)+((m-1)*size)],wp[q+(o-1)+((m-1)*size)],
                             {wg[q+(o-1)+((m-1)*size)-size],wg[q+((m-1)*size)-size-1]},
                             {wp[q+(o-1)+((m-1)*size)-size],wp[q+((m-1)*size)-size-1]});
            
            assign wp[q+((m-1)*size)-2**(m-1)+(o-1)] = wp [q+((m-2)*size)-2**(m-1)+(o-1)];
            assign wg[q+((m-1)*size)-2**(m-1)+(o-1)] = wg [q+((m-2)*size)-2**(m-1)+(o-1)];
        end
        end
        for(r=2**(m-1);r<=(2**m)-1;r=r+1)
            begin
                grey #(2) dut3 (gn2o[r],{wg[r+((m-1)*size)-size],gn2o[2**(m-1)-1]},wp[r+((m-1)*size)-size]);
            end  
         
       end
   end
  
  
    //grey cells
     

 endgenerate     



genvar x;
  generate
  
     for(x=1;x<=size;x=x+1)
          begin
             xor(sum[x],gn2o[x-1],p[x]);
          end
   
  endgenerate
   
    grey #(2) dut4 (gn2o[size],{g[size],gn2o[size-1]},p[size]);
   assign cout= gn2o[size] ;


endmodule