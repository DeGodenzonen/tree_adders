`timescale 1ns / 1ps



module test();
parameter size=16;
parameter Gsize=4;
reg [size:1] a,b;
reg cin;
wire [size:1] sum;
wire cout;

cla #(size,Gsize) dut6(a,b,cin,sum,cout);

initial
begin
a=16'habcb;b=16'h98bc;cin=0;
//#10 a=16'h5;b=4'd4;cin=0;
//#10 a=4'd2;b=4'd3;cin=1;
//#10 a=4'd15;b=4'd1;cin=0;



end
   
endmodule