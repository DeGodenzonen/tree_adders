`timescale 1ns / 1ps
module grey #(parameter val=2)(output GG, input [val-1:0] g, input [val-1:1] p);
wire [val-1:0] gg,wr;
assign gg[0]= g[0];

genvar k;
generate
  for(k=0;k<(val-1);k=k+1)
  begin
    and(wr[k],p[k+1],gg[k]);
    or (gg[k+1],wr[k],g[k+1]);  
  end
endgenerate

assign GG= gg[val-1];

endmodule
