`timescale 1ns / 1ps
module black #(parameter val=2)(output G,output P, input [val-1:0] g, input [val-1:0] p);
wire [val-1:0] gg,wr;
wire [val:0] pp;
assign gg[0]= g[0];
assign pp[0]=p[0];
genvar k,i;
generate
  for(k=0;k<(val-1);k=k+1)
  begin
    and(wr[k],p[k+1],gg[k]);
    or (gg[k+1],wr[k],g[k+1]);  
    end
   for(i=0;i<(val-1);i=i+1)
   begin
    and(pp[i+1],p[i+1],pp[i]);
   end
  
endgenerate
assign P=pp[val-1];
assign G= gg[val-1];

endmodule
