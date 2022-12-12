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

genvar m,n,q;  // for first 5 levels 
generate
  for(m=1;m<=level;m=m+1)// level loop
   begin
    for(n=(2**(m+1)-1);n<size;n=n+(2**m)) //for black cells 
      begin
      if (m==1)  // first level is taking bitwise g and p
      begin
        black #(2) dut (wg[n],wp[n],{g[n],g[n-1]},{p[n],p[n-1]});
      end
      else     // all other levels takes the wires from previous level
       begin
        black #(2) dut1 (wg[n+((m-1)*size)],wp[n+((m-1)*size)],{wg[(n+((m-1)*size))-size],wg[(n+((m-1)*size))-size-(2**(m-1))]},{wp[n+((m-1)*size)-size],wp[(n+((m-1)*size))-size-(2**(m-1))]});
      end
     end // n loop ends
     for(q=((2**m)-1);q<=((2**m)-1);q=q+1) //for grey cells 
      begin
      if(m==1)
        begin
          grey #(2) dut2 (gn2o[q],{g[q],g[q-1]},p[q]);
        end
      else
        begin 
          grey #(2) dut3 (gn2o[q],{wg[q+((m-1)*size)-size],gn2o[q-(2**(m-1))]},wp[q+((m-1)*size) - size]);
        end
     end//q loop ends
  end
 endgenerate
 
 genvar r,e,d; // reverse loop for remaining grey cells
 generate
  for(r=(level-1);r>=1;r=r-1)// level loop
   begin
        if(r==1)
         begin
          for(d=2;d<=size;d=d+2)
          begin
               grey #(2) dut4(gn2o[d],{g[d],gn2o[d-1]},p[d]);
          end
        end
       else       
        begin
         for(e=((2**r)+(2**(r-1)-1));e<=size;e=e+(2**r))
           begin
             grey #(2) dut5 (gn2o[e],{wg[e+((r-1)*size)-size],gn2o[((2**r)-r)]},wp[q+((m-1)*size) - size]);
           end
       end         
     end
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