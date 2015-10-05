///////////////////////////
//////Logic Cell unit//////
///////////////////////////

//this unit can be split into 2 units :
//1.LC unit
//2.LC to bus interconnection's unit

//D flipflop with clock enable
module D_ff(input clk, input clk_enable, input reset, input d, output reg q);
  always @ (negedge clk)
  begin
    if(clk_enable == 1)
    begin
      if(reset==1)
       q=0;
      else
       q=d;
    end    
  end
endmodule

//16 bit register for the look up table
module LUTregister_16b(input [15:0]cell_values, input load, input clk, output reg [15:0]LUT);
  initial 
  begin
    LUT = 0;
  end
  always@(negedge clk)
  begin
    if(load ==1)
    begin
      LUT = cell_values;
    end
  end
endmodule

//4 to 16 mux for the look up table
module mux4to16_1b(input [15:0] LUT, input [3:0] ip, output reg y);
  always@(LUT or ip)
  begin
  case(ip)
    4'b0000: y = LUT[0];
    4'b0001: y = LUT[1];
    4'b0010: y = LUT[2];
    4'b0011: y = LUT[3];
    4'b0100: y = LUT[4];
    4'b0101: y = LUT[5];
    4'b0110: y = LUT[6];
    4'b0111: y = LUT[7];
    4'b1000: y = LUT[8];
    4'b1001: y = LUT[9];
    4'b1010: y = LUT[10];
    4'b1011: y = LUT[11];
    4'b1100: y = LUT[12];
    4'b1101: y = LUT[13];
    4'b1110: y = LUT[14];
    4'b1111: y = LUT[15];
    default: y = 0;
  endcase
  end
endmodule

//2 to 1 mux for logic cell
module mux1to2_1b(input ip1, input ip2, input sel, output reg y);
  always@(ip1 or ip2 or sel)
  case(sel)
    0: y = ip1;
    1: y = ip2;
  endcase
endmodule

//Logic Cell
module LC (input clk, input clk_LC, input clk_enable, input load_LC, input [15:0]LUT_values, input [3:0]to_lut,input e, input f, input reset, inout y, inout q);
  wire [15:0]LUT;
  wire d;
  LUTregister_16b LUTregister_16b0 (LUT_values,load_LC,clk,LUT);
  mux4to16_1b mux4to16_1b0(LUT,to_lut,y);
  mux1to2_1b mux1to2_1b0 (y,e,f,d);
  D_ff D_ff0(clk_LC,clk_enable,reset,d,q);
endmodule

//128 bit register for logic cell's input output connection to buses
module LC_reg(input clk, input [127:0]in, input load, output reg [127:0]out); //32 bit bus
  initial 
  begin
    out = {128{1'b0}};
  end
  always@(negedge clk)
  begin
    if(load ==1)
    begin
      out = in;
    end
  end
endmodule

//4 to 16 decoder
module decoder4to16 (input [3:0] binary_in, output [15:0] decoder_out);
  assign decoder_out = (1 << binary_in);
endmodule

//32 tristate buffers for connecting input(of LC) to buses
module LC_bus_tri_row_ip(input [31:0]ip, input [31:0]sel, output op);
  assign op = sel[0] ? ip[0] : 1'bz;
  assign op = sel[1] ? ip[1] : 1'bz;
  assign op = sel[2] ? ip[2] : 1'bz;
  assign op = sel[3] ? ip[3] : 1'bz;
  assign op = sel[4] ? ip[4] : 1'bz;
  assign op = sel[5] ? ip[5] : 1'bz;
  assign op = sel[6] ? ip[6] : 1'bz;
  assign op = sel[7] ? ip[7] : 1'bz;
  assign op = sel[8] ? ip[8] : 1'bz;
  assign op = sel[9] ? ip[9] : 1'bz;
  assign op = sel[10] ? ip[10] : 1'bz;
  assign op = sel[11] ? ip[11] : 1'bz;
  assign op = sel[12] ? ip[12] : 1'bz;
  assign op = sel[13] ? ip[13] : 1'bz;
  assign op = sel[14] ? ip[14] : 1'bz;
  assign op = sel[15] ? ip[15] : 1'bz;
  assign op = sel[16] ? ip[16] : 1'bz;
  assign op = sel[17] ? ip[17] : 1'bz;
  assign op = sel[18] ? ip[18] : 1'bz;
  assign op = sel[19] ? ip[19] : 1'bz;
  assign op = sel[20] ? ip[20] : 1'bz;
  assign op = sel[21] ? ip[21] : 1'bz;
  assign op = sel[22] ? ip[22] : 1'bz;
  assign op = sel[23] ? ip[23] : 1'bz;
  assign op = sel[24] ? ip[24] : 1'bz;
  assign op = sel[25] ? ip[25] : 1'bz;
  assign op = sel[26] ? ip[26] : 1'bz;
  assign op = sel[27] ? ip[27] : 1'bz;
  assign op = sel[28] ? ip[28] : 1'bz;
  assign op = sel[29] ? ip[29] : 1'bz;
  assign op = sel[30] ? ip[30] : 1'bz;
  assign op = sel[31] ? ip[31] : 1'bz;
endmodule

//32 tristate buffers for connecting output(of LC) to buses
module LC_bus_tri_row_op(input ip, input [31:0]sel, output [31:0]op);
  assign op[0] = sel[0] ? ip : 1'bz;
  assign op[1] = sel[1] ? ip : 1'bz;
  assign op[2] = sel[2] ? ip : 1'bz;
  assign op[3] = sel[3] ? ip : 1'bz;
  assign op[4] = sel[4] ? ip : 1'bz;
  assign op[5] = sel[5] ? ip : 1'bz;
  assign op[6] = sel[6] ? ip : 1'bz;
  assign op[7] = sel[7] ? ip : 1'bz;
  assign op[8] = sel[8] ? ip : 1'bz;
  assign op[9] = sel[9] ? ip : 1'bz;
  assign op[10] = sel[10] ? ip : 1'bz;
  assign op[11] = sel[11] ? ip : 1'bz;
  assign op[12] = sel[12] ? ip : 1'bz;
  assign op[13] = sel[13] ? ip : 1'bz;
  assign op[14] = sel[14] ? ip : 1'bz;
  assign op[15] = sel[15] ? ip : 1'bz;
  assign op[16] = sel[16] ? ip : 1'bz;
  assign op[17] = sel[17] ? ip : 1'bz;
  assign op[18] = sel[18] ? ip : 1'bz;
  assign op[19] = sel[19] ? ip : 1'bz;
  assign op[20] = sel[20] ? ip : 1'bz;
  assign op[21] = sel[21] ? ip : 1'bz;
  assign op[22] = sel[22] ? ip : 1'bz;
  assign op[23] = sel[23] ? ip : 1'bz;
  assign op[24] = sel[24] ? ip : 1'bz;
  assign op[25] = sel[25] ? ip : 1'bz;
  assign op[26] = sel[26] ? ip : 1'bz;
  assign op[27] = sel[27] ? ip : 1'bz;
  assign op[28] = sel[28] ? ip : 1'bz;
  assign op[29] = sel[29] ? ip : 1'bz;
  assign op[30] = sel[30] ? ip : 1'bz;
  assign op[31] = sel[31] ? ip : 1'bz;
endmodule

//LC with configurable inout/output to buses on right(R), left(L), above(A), bellow(B).
module LC_bus(input clk, input [1:0]load_unit, input [7:0]load_level, input [127:0]conf_bus, inout [31:0]bus_R, inout [31:0]bus_A, inout [31:0]bus_L, inout [31:0]bus_B);
  wire [15:0]load_dec;
  tri0 clk_LC, clk_enable, load_LC, e, f, reset, y, q;
  tri0 [3:0]to_lut;
  wire [127:0]reg_out_LUT3,reg_out_LUT2,reg_out_LUT1,reg_out_LUT0,reg_out_e,reg_out_f,reg_out_clkLC,reg_out_clke,reg_out_reset,reg_out_y,reg_out_q;
  LC LC0(clk, clk_LC, clk_enable, load_unit[1], conf_bus[15:0], to_lut, e, f, reset, y, q);
  decoder4to16 decoder4to160(load_level[3:0], load_dec);
  LC_reg LC_reg_LUT3 (clk, conf_bus, load_unit[0] & load_dec[0], reg_out_LUT3  ); //32 bit bus
  LC_reg LC_reg_LUT2 (clk, conf_bus, load_unit[0] & load_dec[1], reg_out_LUT2  );
  LC_reg LC_reg_LUT1 (clk, conf_bus, load_unit[0] & load_dec[2], reg_out_LUT1  );
  LC_reg LC_reg_LUT0 (clk, conf_bus, load_unit[0] & load_dec[3], reg_out_LUT0  );
  LC_reg LC_reg_e    (clk, conf_bus, load_unit[0] & load_dec[4], reg_out_e     );
  LC_reg LC_reg_f    (clk, conf_bus, load_unit[0] & load_dec[5], reg_out_f     );
  LC_reg LC_reg_clkLC(clk, conf_bus, load_unit[0] & load_dec[6], reg_out_clkLC );
  LC_reg LC_reg_clke (clk, conf_bus, load_unit[0] & load_dec[7], reg_out_clke  );
  LC_reg LC_reg_reset(clk, conf_bus, load_unit[0] & load_dec[8], reg_out_reset );
  LC_reg LC_reg_y    (clk, conf_bus, load_unit[0] & load_dec[9], reg_out_y     );
  LC_reg LC_reg_q    (clk, conf_bus, load_unit[0] & load_dec[10], reg_out_q    );
  LC_bus_tri_row_ip LC_bus_tri_row_ip0R(bus_R, reg_out_LUT3[31:0], to_lut[3]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip0A(bus_A, reg_out_LUT3[63:32], to_lut[3]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip0L(bus_L, reg_out_LUT3[95:64], to_lut[3]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip0B(bus_B, reg_out_LUT3[127:96], to_lut[3]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip1R(bus_R, reg_out_LUT2[31:0], to_lut[2]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip1A(bus_A, reg_out_LUT2[63:32], to_lut[2]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip1L(bus_L, reg_out_LUT2[95:64], to_lut[2]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip1B(bus_B, reg_out_LUT2[127:96], to_lut[2]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip2R(bus_R, reg_out_LUT1[31:0], to_lut[1]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip2A(bus_A, reg_out_LUT1[63:32], to_lut[1]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip2L(bus_L, reg_out_LUT1[95:64], to_lut[1]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip2B(bus_B, reg_out_LUT1[127:96], to_lut[1]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip3R(bus_R, reg_out_LUT0[31:0], to_lut[0]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip3A(bus_A, reg_out_LUT0[63:32], to_lut[0]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip3L(bus_L, reg_out_LUT0[95:64], to_lut[0]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip3B(bus_B, reg_out_LUT0[127:96], to_lut[0]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip4R(bus_R, reg_out_e[31:0], e);
  LC_bus_tri_row_ip LC_bus_tri_row_ip4A(bus_A, reg_out_e[63:32], e);
  LC_bus_tri_row_ip LC_bus_tri_row_ip4L(bus_L, reg_out_e[95:64], e);
  LC_bus_tri_row_ip LC_bus_tri_row_ip4B(bus_B, reg_out_e[127:96], e);
  LC_bus_tri_row_ip LC_bus_tri_row_ip5R(bus_R, reg_out_f[31:0], f);
  LC_bus_tri_row_ip LC_bus_tri_row_ip5A(bus_A, reg_out_f[63:32], f);
  LC_bus_tri_row_ip LC_bus_tri_row_ip5L(bus_L, reg_out_f[95:64], f);
  LC_bus_tri_row_ip LC_bus_tri_row_ip5B(bus_B, reg_out_f[127:96], f);
  LC_bus_tri_row_ip LC_bus_tri_row_ip6R(bus_R, reg_out_clkLC[31:0], clk_LC);
  LC_bus_tri_row_ip LC_bus_tri_row_ip6A(bus_A, reg_out_clkLC[63:32], clk_LC);
  LC_bus_tri_row_ip LC_bus_tri_row_ip6L(bus_L, reg_out_clkLC[95:64], clk_LC);
  LC_bus_tri_row_ip LC_bus_tri_row_ip6B(bus_B, reg_out_clkLC[127:96], clk_LC);
  LC_bus_tri_row_ip LC_bus_tri_row_ip7R(bus_R, reg_out_clke[31:0], clk_enable);
  LC_bus_tri_row_ip LC_bus_tri_row_ip7A(bus_A, reg_out_clke[63:32], clk_enable);
  LC_bus_tri_row_ip LC_bus_tri_row_ip7L(bus_L, reg_out_clke[95:64], clk_enable);
  LC_bus_tri_row_ip LC_bus_tri_row_ip7B(bus_B, reg_out_clke[127:96], clk_enable);
  LC_bus_tri_row_ip LC_bus_tri_row_ip8R(bus_R, reg_out_reset[31:0], reset);
  LC_bus_tri_row_ip LC_bus_tri_row_ip8A(bus_A, reg_out_reset[63:32], reset);
  LC_bus_tri_row_ip LC_bus_tri_row_ip8L(bus_L, reg_out_reset[95:64], reset);
  LC_bus_tri_row_ip LC_bus_tri_row_ip8B(bus_B, reg_out_reset[127:96], reset);
  LC_bus_tri_row_op LC_bus_tri_row_op9R(y, reg_out_y[31:0], bus_R);
  LC_bus_tri_row_op LC_bus_tri_row_op9A(y, reg_out_y[63:32], bus_A);
  LC_bus_tri_row_op LC_bus_tri_row_op9L(y, reg_out_y[95:64], bus_L);
  LC_bus_tri_row_op LC_bus_tri_row_op9B(y, reg_out_y[127:96], bus_B);
  LC_bus_tri_row_op LC_bus_tri_row_op10R(q, reg_out_q[31:0], bus_R);
  LC_bus_tri_row_op LC_bus_tri_row_op10A(q, reg_out_q[63:32], bus_A);
  LC_bus_tri_row_op LC_bus_tri_row_op10L(q, reg_out_q[95:64], bus_L);
  LC_bus_tri_row_op LC_bus_tri_row_op10B(q, reg_out_q[127:96], bus_B);
endmodule

//Row of configurable LC units - contains 15 units (14:0)
module LC_bus_row(input clk, input [1:0]load_unit, input [7:0]load_level,input [15:0]load_pos_h, input [127:0]conf_data,inout [31:0]bus_A, inout [31:0]bus_B,
  inout [31:0]bus_v0,
  inout [31:0]bus_v1,
  inout [31:0]bus_v2,
  inout [31:0]bus_v3,
  inout [31:0]bus_v4,
  inout [31:0]bus_v5,
  inout [31:0]bus_v6,
  inout [31:0]bus_v7,
  inout [31:0]bus_v8,
  inout [31:0]bus_v9,
  inout [31:0]bus_v10,
  inout [31:0]bus_v11,
  inout [31:0]bus_v12,
  inout [31:0]bus_v13,
  inout [31:0]bus_v14,
  inout [31:0]bus_v15);
  LC_bus LC_bus_0(clk, load_unit & {2{load_pos_h[0]}}, load_level, conf_data, bus_v1, bus_A, bus_v0, bus_B);
  LC_bus LC_bus_1(clk, load_unit & {2{load_pos_h[1]}}, load_level, conf_data, bus_v2, bus_A, bus_v1, bus_B);
  LC_bus LC_bus_2(clk, load_unit & {2{load_pos_h[2]}}, load_level, conf_data, bus_v3, bus_A, bus_v2, bus_B);
  LC_bus LC_bus_3(clk, load_unit & {2{load_pos_h[3]}}, load_level, conf_data, bus_v4, bus_A, bus_v3, bus_B);
  LC_bus LC_bus_4(clk, load_unit & {2{load_pos_h[4]}}, load_level, conf_data, bus_v5, bus_A, bus_v4, bus_B);
  LC_bus LC_bus_5(clk, load_unit & {2{load_pos_h[5]}}, load_level, conf_data, bus_v6, bus_A, bus_v5, bus_B);
  LC_bus LC_bus_6(clk, load_unit & {2{load_pos_h[6]}}, load_level, conf_data, bus_v7, bus_A, bus_v6, bus_B);
  LC_bus LC_bus_7(clk, load_unit & {2{load_pos_h[7]}}, load_level, conf_data, bus_v8, bus_A, bus_v7, bus_B);
  LC_bus LC_bus_8(clk, load_unit & {2{load_pos_h[8]}}, load_level, conf_data, bus_v9, bus_A, bus_v8, bus_B);
  LC_bus LC_bus_9(clk, load_unit & {2{load_pos_h[9]}}, load_level, conf_data, bus_v10, bus_A, bus_v9, bus_B);
  LC_bus LC_bus_10(clk, load_unit & {2{load_pos_h[10]}}, load_level, conf_data, bus_v11, bus_A, bus_v10, bus_B);
  LC_bus LC_bus_11(clk, load_unit & {2{load_pos_h[11]}}, load_level, conf_data, bus_v12, bus_A, bus_v11, bus_B);
  LC_bus LC_bus_12(clk, load_unit & {2{load_pos_h[12]}}, load_level, conf_data, bus_v13, bus_A, bus_v12, bus_B);
  LC_bus LC_bus_13(clk, load_unit & {2{load_pos_h[13]}}, load_level, conf_data, bus_v14, bus_A, bus_v13, bus_B);
  LC_bus LC_bus_14(clk, load_unit & {2{load_pos_h[14]}}, load_level, conf_data, bus_v15, bus_A, bus_v14, bus_B);
endmodule

////////////////////////////////////////////
//////Buses and their interconnections//////
////////////////////////////////////////////

//32 bit register for interconnection's config data ,with initial value 0 corresponds to no connection (to avoid shorts at startup)
//(each line of a bus can be connected to 32 diff. lines of other bus)
module bus_reg_1(input clk, input [31:0]conf_data, input load, output reg [31:0]out);
  initial 
  begin
    out = {32{1'b0}};
  end
  always@(negedge clk)
  begin
    if(load ==1)
    begin
      out = conf_data;
    end
  end
endmodule

//5 to 32 decoder
module decoder5to32 (input [4:0] binary_in, output [31:0] decoder_out);
  assign decoder_out = (1 << binary_in);
endmodule

//block with 32*32 bits to support all connections between 2 buses(each 32 bit)
//2 such instances will be needed to support signal flow in both directions (i.e. busA->busB and busA<-busB)
module bus_reg_2(input clk, input [31:0]conf_data, input load_unit, input [7:0]load_level, output [1023:0]out);
  wire [4:0]load_t;
  wire [31:0]load;
  assign load_t = load_level[4:0] & {5{load_unit}};
  decoder5to32 decoder5to320(load_t, load);
  bus_reg_1 bus_reg_10(clk, conf_data, load[0], out[31:0]);
  bus_reg_1 bus_reg_11(clk, conf_data, load[1], out[63:32]);
  bus_reg_1 bus_reg_12(clk, conf_data, load[2], out[95:64]);
  bus_reg_1 bus_reg_13(clk, conf_data, load[3], out[127:96]);
  bus_reg_1 bus_reg_14(clk, conf_data, load[4], out[159:128]);
  bus_reg_1 bus_reg_15(clk, conf_data, load[5], out[191:160]);
  bus_reg_1 bus_reg_16(clk, conf_data, load[6], out[223:192]);
  bus_reg_1 bus_reg_17(clk, conf_data, load[7], out[255:224]);
  bus_reg_1 bus_reg_18(clk, conf_data, load[8], out[287:256]);
  bus_reg_1 bus_reg_19(clk, conf_data, load[9], out[319:288]);
  bus_reg_1 bus_reg_110(clk, conf_data, load[10], out[351:320]);
  bus_reg_1 bus_reg_111(clk, conf_data, load[11], out[383:352]);
  bus_reg_1 bus_reg_112(clk, conf_data, load[12], out[415:384]);
  bus_reg_1 bus_reg_113(clk, conf_data, load[13], out[447:416]);
  bus_reg_1 bus_reg_114(clk, conf_data, load[14], out[479:448]);
  bus_reg_1 bus_reg_115(clk, conf_data, load[15], out[511:480]);
  bus_reg_1 bus_reg_116(clk, conf_data, load[16], out[543:512]);
  bus_reg_1 bus_reg_117(clk, conf_data, load[17], out[575:544]);
  bus_reg_1 bus_reg_118(clk, conf_data, load[18], out[607:576]);
  bus_reg_1 bus_reg_119(clk, conf_data, load[19], out[639:608]);
  bus_reg_1 bus_reg_120(clk, conf_data, load[20], out[671:640]);
  bus_reg_1 bus_reg_121(clk, conf_data, load[21], out[703:672]);
  bus_reg_1 bus_reg_122(clk, conf_data, load[22], out[735:704]);
  bus_reg_1 bus_reg_123(clk, conf_data, load[23], out[767:736]);
  bus_reg_1 bus_reg_124(clk, conf_data, load[24], out[799:768]);
  bus_reg_1 bus_reg_125(clk, conf_data, load[25], out[831:800]);
  bus_reg_1 bus_reg_126(clk, conf_data, load[26], out[863:832]);
  bus_reg_1 bus_reg_127(clk, conf_data, load[27], out[895:864]);
  bus_reg_1 bus_reg_128(clk, conf_data, load[28], out[927:896]);
  bus_reg_1 bus_reg_129(clk, conf_data, load[29], out[959:928]);
  bus_reg_1 bus_reg_130(clk, conf_data, load[30], out[991:960]);
  bus_reg_1 bus_reg_131(clk, conf_data, load[31], out[1023:992]);
endmodule

//configurable bus interconnection block with 2 buses (32*32 + 32*32) bits ,with both side data flow (i.e. busA->busB and busA<-busB)
module bus_reg(input clk, input [31:0]conf_data, input load_unit, input [7:0]load_level, inout [31:0]bus_h, inout [31:0]bus_v);
  wire load_unit_t1,load_unit_t2;
  wire [1023:0]out1,out2;
  //horiz to vertical 1(msb)
  assign load_unit_t1 = load_unit & load_level[7];
  assign load_unit_t2 = load_unit & (~load_level[7]);
  bus_reg_2 bbus_reg_20(clk, conf_data, load_unit_t1, load_level, out1);
  bus_reg_2 bbus_reg_21(clk, conf_data, load_unit_t2, load_level, out2);
  
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov0(bus_h, out1[31:0], bus_v[0]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov1(bus_h, out1[63:32], bus_v[1]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov2(bus_h, out1[95:64], bus_v[2]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov3(bus_h, out1[127:96], bus_v[3]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov4(bus_h, out1[159:128], bus_v[4]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov5(bus_h, out1[191:160], bus_v[5]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov6(bus_h, out1[223:192], bus_v[6]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov7(bus_h, out1[255:224], bus_v[7]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov8(bus_h, out1[287:256], bus_v[8]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov9(bus_h, out1[319:288], bus_v[9]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov10(bus_h, out1[31+320:0+320], bus_v[10]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov11(bus_h, out1[63+320:32+320], bus_v[11]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov12(bus_h, out1[95+320:64+320], bus_v[12]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov13(bus_h, out1[127+320:96+320], bus_v[13]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov14(bus_h, out1[159+320:128+320], bus_v[14]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov15(bus_h, out1[191+320:160+320], bus_v[15]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov16(bus_h, out1[223+320:192+320], bus_v[16]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov17(bus_h, out1[255+320:224+320], bus_v[17]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov18(bus_h, out1[287+320:256+320], bus_v[18]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov19(bus_h, out1[319+320:288+320], bus_v[19]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov20(bus_h, out1[31+640:0+640], bus_v[20]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov21(bus_h, out1[63+640:32+640], bus_v[21]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov22(bus_h, out1[95+640:64+640], bus_v[22]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov23(bus_h, out1[127+640:96+640], bus_v[23]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov24(bus_h, out1[159+640:128+640], bus_v[24]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov25(bus_h, out1[191+640:160+640], bus_v[25]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov26(bus_h, out1[223+640:192+640], bus_v[26]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov27(bus_h, out1[255+640:224+640], bus_v[27]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov28(bus_h, out1[287+640:256+640], bus_v[28]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov29(bus_h, out1[319+640:288+640], bus_v[29]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov30(bus_h, out1[31+960:0+960], bus_v[30]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_htov31(bus_h, out1[63+960:32+960], bus_v[31]);
  
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh0(bus_v, out2[31:0], bus_h[0]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh1(bus_v, out2[63:32], bus_h[1]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh2(bus_v, out2[95:64], bus_h[2]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh3(bus_v, out2[127:96], bus_h[3]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh4(bus_v, out2[159:128], bus_h[4]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh5(bus_v, out2[191:160], bus_h[5]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh6(bus_v, out2[223:192], bus_h[6]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh7(bus_v, out2[255:224], bus_h[7]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh8(bus_v, out2[287:256], bus_h[8]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh9(bus_v, out2[319:288], bus_h[9]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh10(bus_v, out2[31+320:0+320], bus_h[10]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh11(bus_v, out2[63+320:32+320], bus_h[11]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh12(bus_v, out2[95+320:64+320], bus_h[12]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh13(bus_v, out2[127+320:96+320], bus_h[13]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh14(bus_v, out2[159+320:128+320], bus_h[14]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh15(bus_v, out2[191+320:160+320], bus_h[15]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh16(bus_v, out2[223+320:192+320], bus_h[16]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh17(bus_v, out2[255+320:224+320], bus_h[17]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh18(bus_v, out2[287+320:256+320], bus_h[18]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh19(bus_v, out2[319+320:288+320], bus_h[19]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh20(bus_v, out2[31+640:0+640], bus_h[20]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh21(bus_v, out2[63+640:32+640], bus_h[21]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh22(bus_v, out2[95+640:64+640], bus_h[22]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh23(bus_v, out2[127+640:96+640], bus_h[23]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh24(bus_v, out2[159+640:128+640], bus_h[24]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh25(bus_v, out2[191+640:160+640], bus_h[25]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh26(bus_v, out2[223+640:192+640], bus_h[26]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh27(bus_v, out2[255+640:224+640], bus_h[27]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh28(bus_v, out2[287+640:256+640], bus_h[28]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh29(bus_v, out2[319+640:288+640], bus_h[29]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh30(bus_v, out2[31+960:0+960], bus_h[30]);
  LC_bus_tri_row_ip LC_bus_tri_row_ip_vtoh31(bus_v, out2[63+960:32+960], bus_h[31]);
endmodule

//row of (configurable bus interconnection block)
//1 horizontal bus;  16 vertical buses
module bus_reg_row(input clk, input [31:0]conf_data, input load_unit, input [15:0]load_pos_h, input [7:0]load_level, inout [31:0]bus_h,
  inout [31:0]bus_v0,
  inout [31:0]bus_v1,
  inout [31:0]bus_v2,
  inout [31:0]bus_v3,
  inout [31:0]bus_v4,
  inout [31:0]bus_v5,
  inout [31:0]bus_v6,
  inout [31:0]bus_v7,
  inout [31:0]bus_v8,
  inout [31:0]bus_v9,
  inout [31:0]bus_v10,
  inout [31:0]bus_v11,
  inout [31:0]bus_v12,
  inout [31:0]bus_v13,
  inout [31:0]bus_v14,
  inout [31:0]bus_v15);
  
  bus_reg bus_reg0( clk,  conf_data,  load_unit & load_pos_h[0],  load_level,  bus_h,  bus_v0);
  bus_reg bus_reg1( clk,  conf_data,  load_unit & load_pos_h[1],  load_level,  bus_h,  bus_v1);
  bus_reg bus_reg2( clk,  conf_data,  load_unit & load_pos_h[2],  load_level,  bus_h,  bus_v2);
  bus_reg bus_reg3( clk,  conf_data,  load_unit & load_pos_h[3],  load_level,  bus_h,  bus_v3);
  bus_reg bus_reg4( clk,  conf_data,  load_unit & load_pos_h[4],  load_level,  bus_h,  bus_v4);
  bus_reg bus_reg5( clk,  conf_data,  load_unit & load_pos_h[5],  load_level,  bus_h,  bus_v5);
  bus_reg bus_reg6( clk,  conf_data,  load_unit & load_pos_h[6],  load_level,  bus_h,  bus_v6);
  bus_reg bus_reg7( clk,  conf_data,  load_unit & load_pos_h[7],  load_level,  bus_h,  bus_v7);
  bus_reg bus_reg8( clk,  conf_data,  load_unit & load_pos_h[8],  load_level,  bus_h,  bus_v8);
  bus_reg bus_reg9( clk,  conf_data,  load_unit & load_pos_h[9],  load_level,  bus_h,  bus_v9);
  bus_reg bus_reg10( clk, conf_data,  load_unit & load_pos_h[10], load_level,  bus_h,  bus_v10);
  bus_reg bus_reg11( clk, conf_data,  load_unit & load_pos_h[11], load_level,  bus_h,  bus_v11);
  bus_reg bus_reg12( clk, conf_data,  load_unit & load_pos_h[12], load_level,  bus_h,  bus_v12);
  bus_reg bus_reg13( clk, conf_data,  load_unit & load_pos_h[13], load_level,  bus_h,  bus_v13);
  bus_reg bus_reg14( clk, conf_data,  load_unit & load_pos_h[14], load_level,  bus_h,  bus_v14);
  bus_reg bus_reg15( clk, conf_data,  load_unit & load_pos_h[15], load_level,  bus_h,  bus_v15);
  
endmodule

/////////////////////////////
//////input output unit//////
/////////////////////////////

//can be realiized as a tristate mux and tirstate demux
//mux's input and demux's output connected together to bus
//mux's output and demux's input connected together to gpio
module basic_io(inout [31:0]bus, input [4:0]sel, input Hiz, inout gpio_pin);
  wire [63:0]temp;
  wire [63:0]temp1;
  assign temp[32] = gpio_pin;
  assign temp1 = (temp << sel);
  assign gpio_pin = (Hiz == 1'b1) ? bus[sel] : 1'bz;
  assign bus = ((Hiz == 1'b0) && (sel<5'b11111)) ? (temp1[63:32]) : {32{1'bz}};
endmodule

//4 such basic_io's connected to one 32 bit bus
module input_output (input clk, inout [31:0]bus, input [19:0]sel,input [3:0]Hiz, input load, inout [3:0] gpio);
  reg [19:0]selr;
  reg [3:0]Hizr;
  wire ignore1,ignore2,ignore3,ignore4;
  initial
  begin
    selr = {20{1'b1}};  //ignore state
    Hizr = {4{1'b0}};   //both i/o input mode
  end
  always@(negedge clk)
  begin
    if(load == 1)
      begin
        selr = sel;
        Hizr = Hiz;
      end
  end
  basic_io basic_io0(bus, selr[4:0], Hizr[0], gpio[0]);
  basic_io basic_io1(bus, selr[9:5], Hizr[1], gpio[1]);
  basic_io basic_io2(bus, selr[14:10], Hizr[2], gpio[2]);
  basic_io basic_io3(bus, selr[19:15], Hizr[3], gpio[3]);
endmodule

////////////////////////////////////////////
////////////////====FPGA====////////////////
////////////////////////////////////////////

//consists of 16 horizontal and 16 vertical (32 bits) buses, with configurable interconnections block at every intersection of horizontal and vertical buses
//4 gpio's for each bus mentioned above
//15*15 LC units , each unit is sourounded by buses from all directions ie right(R), left(L), above(A), bellow(B).
//has a 128 bits conf data bus for loading the configuration and diff load lines to specify where the data has to be loaded
module fpga(input clk, input [127:0]conf_data, input [7:0]load_unit, input [7:0]load_level, input [7:0]load_pos_h, input [7:0]load_pos_v, inout [127:0]gpio);
  wire [31:0]bus_h[15:0];
  wire [31:0]bus_v[15:0];
  wire [15:0]split_load_pos_h,split_load_pos_v;
  decoder4to16 decoder4to16hpos(load_pos_h[3:0], split_load_pos_h);
  decoder4to16 decoder4to16vpos(load_pos_v[3:0], split_load_pos_v);
  
  input_output input_outputv0(clk,  bus_h[0],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[0]), gpio[3:0]);
  input_output input_outputv1(clk,  bus_h[1],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[1]), gpio[7:4]);
  input_output input_outputv2(clk,  bus_h[2],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[2]), gpio[11:8]);
  input_output input_outputv3(clk,  bus_h[3],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[3]), gpio[15:12]);
  input_output input_outputv4(clk,  bus_h[4],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[4]), gpio[19:16]);
  input_output input_outputv5(clk,  bus_h[5],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[5]), gpio[23:20]);
  input_output input_outputv6(clk,  bus_h[6],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[6]), gpio[27:24]);
  input_output input_outputv7(clk,  bus_h[7],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[7]), gpio[31:28]);
  input_output input_outputv8(clk,  bus_h[8],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[8]), gpio[35:32]);
  input_output input_outputv9(clk,  bus_h[9],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[9]), gpio[39:36]);
  input_output input_outputv10(clk,  bus_h[10],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[10]), gpio[3+40:0+40]);
  input_output input_outputv11(clk,  bus_h[11],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[11]), gpio[7+40:4+40]);
  input_output input_outputv12(clk,  bus_h[12],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[12]), gpio[11+40:8+40]);
  input_output input_outputv13(clk,  bus_h[13],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[13]), gpio[15+40:12+40]);
  input_output input_outputv14(clk,  bus_h[14],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[14]), gpio[19+40:16+40]);
  input_output input_outputv15(clk,  bus_h[15],  conf_data[19:0], conf_data[23:20], (load_unit[1] & split_load_pos_v[15]), gpio[23+40:20+40]);
  
  input_output input_outputh0(clk,  bus_v[0],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[0]), gpio[27+40:24+40]);
  input_output input_outputh1(clk,  bus_v[1],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[1]), gpio[31+40:28+40]);
  input_output input_outputh2(clk,  bus_v[2],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[2]), gpio[35+40:32+40]);
  input_output input_outputh3(clk,  bus_v[3],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[3]), gpio[39+40:36+40]);
  input_output input_outputh4(clk,  bus_v[4],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[4]), gpio[3+80:0+80]);
  input_output input_outputh5(clk,  bus_v[5],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[5]), gpio[7+80:4+80]);
  input_output input_outputh6(clk,  bus_v[6],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[6]), gpio[11+80:8+80]);
  input_output input_outputh7(clk,  bus_v[7],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[7]), gpio[15+80:12+80]);
  input_output input_outputh8(clk,  bus_v[8],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[8]), gpio[19+80:16+80]);
  input_output input_outputh9(clk,  bus_v[9],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[9]), gpio[23+80:20+80]);
  input_output input_outputh10(clk,  bus_v[10],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[10]), gpio[27+80:24+80]);
  input_output input_outputh11(clk,  bus_v[11],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[11]), gpio[31+80:28+80]);
  input_output input_outputh12(clk,  bus_v[12],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[12]), gpio[35+80:32+80]);
  input_output input_outputh13(clk,  bus_v[13],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[13]), gpio[39+80:36+80]);
  input_output input_outputh14(clk,  bus_v[14],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[14]), gpio[3+120:0+120]);
  input_output input_outputh15(clk,  bus_v[15],  conf_data[19:0], conf_data[23:20], (load_unit[0] & split_load_pos_h[15]), gpio[7+120:4+120]);
  
  bus_reg_row bus_reg_row0(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[0], split_load_pos_h, load_level, bus_h[0],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row1(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[1], split_load_pos_h, load_level, bus_h[1],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row2(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[2], split_load_pos_h, load_level, bus_h[2],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row3(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[3], split_load_pos_h, load_level, bus_h[3],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row4(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[4], split_load_pos_h, load_level, bus_h[4],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row5(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[5], split_load_pos_h, load_level, bus_h[5],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row6(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[6], split_load_pos_h, load_level, bus_h[6],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row7(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[7], split_load_pos_h, load_level, bus_h[7],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row8(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[8], split_load_pos_h, load_level, bus_h[8],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row9(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[9], split_load_pos_h, load_level, bus_h[9],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row10(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[10], split_load_pos_h, load_level, bus_h[10],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row11(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[11], split_load_pos_h, load_level, bus_h[11],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row12(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[12], split_load_pos_h, load_level, bus_h[12],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row13(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[13], split_load_pos_h, load_level, bus_h[13],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row14(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[14], split_load_pos_h, load_level, bus_h[14],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  bus_reg_row bus_reg_row15(clk, conf_data[31:0], load_unit[2] & split_load_pos_v[15], split_load_pos_h, load_level, bus_h[15],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  
  
  LC_bus_row LC_bus_row0(clk, load_unit[4:3] & {2{split_load_pos_v[0]}}, load_level, split_load_pos_h, conf_data,bus_v[1], bus_v[0],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row1(clk, load_unit[4:3] & {2{split_load_pos_v[1]}}, load_level, split_load_pos_h, conf_data,bus_v[2], bus_v[1],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row2(clk, load_unit[4:3] & {2{split_load_pos_v[2]}}, load_level, split_load_pos_h, conf_data,bus_v[3], bus_v[2],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row3(clk, load_unit[4:3] & {2{split_load_pos_v[3]}}, load_level, split_load_pos_h, conf_data,bus_v[4], bus_v[3],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row4(clk, load_unit[4:3] & {2{split_load_pos_v[4]}}, load_level, split_load_pos_h, conf_data,bus_v[5], bus_v[4],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row5(clk, load_unit[4:3] & {2{split_load_pos_v[5]}}, load_level, split_load_pos_h, conf_data,bus_v[6], bus_v[5],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row6(clk, load_unit[4:3] & {2{split_load_pos_v[6]}}, load_level, split_load_pos_h, conf_data,bus_v[7], bus_v[6],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row7(clk, load_unit[4:3] & {2{split_load_pos_v[7]}}, load_level, split_load_pos_h, conf_data,bus_v[8], bus_v[7],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row8(clk, load_unit[4:3] & {2{split_load_pos_v[8]}}, load_level, split_load_pos_h, conf_data,bus_v[9], bus_v[8],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row9(clk, load_unit[4:3] & {2{split_load_pos_v[9]}}, load_level, split_load_pos_h, conf_data,bus_v[10], bus_v[9],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row10(clk, load_unit[4:3] & {2{split_load_pos_v[10]}}, load_level, split_load_pos_h, conf_data,bus_v[11], bus_v[10],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row11(clk, load_unit[4:3] & {2{split_load_pos_v[11]}}, load_level, split_load_pos_h, conf_data,bus_v[12], bus_v[11],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row12(clk, load_unit[4:3] & {2{split_load_pos_v[12]}}, load_level, split_load_pos_h, conf_data,bus_v[13], bus_v[12],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row13(clk, load_unit[4:3] & {2{split_load_pos_v[13]}}, load_level, split_load_pos_h, conf_data,bus_v[14], bus_v[13],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
  LC_bus_row LC_bus_row14(clk, load_unit[4:3] & {2{split_load_pos_v[14]}}, load_level, split_load_pos_h, conf_data,bus_v[15], bus_v[14],
    bus_v[0],bus_v[1],bus_v[2],bus_v[3],bus_v[4],bus_v[5],bus_v[6],bus_v[7],bus_v[8],bus_v[9],bus_v[10],bus_v[11],bus_v[12],bus_v[13],bus_v[14],bus_v[15]);
endmodule


//////////////////////////
//// FPGA testbenceh /////
//////////////////////////

module fpga_testbench_adder_4bit();//io unit, LC unit tested
  //common for all testbenches
  reg clk;
  reg [127:0]conf_data;
  reg [7:0]load_level,load_pos_h,load_pos_v,load_unit;
  wire [127:0]gpio;
  
  //application specific
  wire[3:0]a,b,C;
  wire cin,cout;
  
  //common for all testbenches
  fpga fpga_new(clk, conf_data, load_unit, load_level, load_pos_h, load_pos_v, gpio);
  always
  begin
    #5 clk = ~clk;
  end
  
  //application specific
  assign gpio[76] = a[0];
  assign gpio[72] = a[1];
  assign gpio[68] = a[2];
  assign gpio[64] = a[3];
  assign gpio[77] = b[0];
  assign gpio[73] = b[1];
  assign gpio[69] = b[2];
  assign gpio[65] = b[3];
  assign C[0] = gpio[78];
  assign C[1] = gpio[74];
  assign C[2] = gpio[70];
  assign C[3] = gpio[66];
  assign cout = gpio[67];
  assign gpio[80] = cin;
  
  //uploadind configuration
  //every cofiguration upload will happen at negedge of clk
  initial
  begin
    clk = 1;
    //uploading input/output configuration (gpio)
    //directions
    // load_unit = 8'b00000001; for horizontal gpio (connected to vertical buses)
    // load_unit = 8'b00000010; for vertical gpio (connected to horizontal buses)
    // load_pos_h = 8'b00000011; (stands for 3) for seclecting vertical position of gpio to be configured (from 0 to 15)
    // each position has 4 gpios
    // conf_data[23:20] = 4b'1000; for setting gpio no. 4 as output(1) and rest as input(0) in that set of gpios
    // gpio can never be connected to msb of the bus as input
    // conf_data[19:0] = 20'b 111111 11111 00001 00110;
    // gpio4 connected to bus[31] as output
    // gpio3 not connected 
    // gpio2 connected to bus[1] as input
    // gpio1 connected to bus[6] as input
    
    load_unit = 8'b00000001; // load_unit [0] for h io
    load_pos_h = 8'b00000000;
    load_pos_v = 8'b00000000;
    conf_data[23:0] = 24'b110000011000100000100000;
    #10;
    conf_data[23:0] = 24'b010011111000100000100000;
    load_pos_h = 8'b00000001;
    #10;
    load_pos_h = 8'b00000010;
    #10;
    load_pos_h = 8'b00000011;
    #10
    conf_data = 24'b000011111111111111100011;
    load_pos_h = 8'b00000100;
    #10
    
    //uploading bus interconnections configuration 
    //directions
    // load_unit = 8'b00000100;
    // load_pos_h = 8'b00000010; selecting position
    // load_pos_v = 8'b00000011; selecting position
    // load_level = 8'b00001100; signal flow : v to h , horizontal line = 12
    // load_level[7] determines direction of signal flow 1-> h to v ; 0-> v to h;
    // load_level[4:0] determines wich horizontal line the config is to be loaded in.
    // conf_data = {128{1'b0}};
    // conf_data[25] = 1'b1; 25 will seclect wich vertical line to connect
    // above set of commands will connect:
    // bus_v2[25] to bus_h3[12]
    
    
    //uploading LC to bus interconnections configuration 
    //directions
    // load_unit = 8'b00001000;
    // load_pos_h = 8'b00000010; selecting position
    // load_pos_v = 8'b00000011; selecting position
    // load_level = 8'b00000100; selects which io of LC to configure 4->e
    // conf_data = {128{1'b0}};
    // conf_data[X+Y] = 1'b1;
    //a 0
    //b 1
    //c 2
    //d 3
    //e 4
    //f 5
    //clk 6
    //clk_enable 7
    //reset 8
    //y 9
    //q 10
    //line of the bus = X ;and bus position Y => R=+0; A=+32; L=+64 ;B=+96
    load_unit = 8'b00001000;
    load_level = 8'b00000011;
    load_pos_h = 8'b00000000;
    load_pos_v = 8'b00001101;//13
    conf_data = {128{1'b0}};//LC_bus d
    conf_data[64] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    
    load_pos_h = 8'b00000000;//c
    conf_data = {128{1'b0}};
    load_level = 8'b00000010;
    conf_data[65] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10

    load_pos_h = 8'b00000000;//op y
    conf_data = {128{1'b0}};
    load_level = 8'b00001001;
    conf_data[66] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10

    load_pos_h = 8'b00000000;//b
    conf_data = {128{1'b0}};
    load_level = 8'b00000001;
    conf_data[3] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    
    load_pos_h = 8'b00000000; //a
    conf_data = {128{1'b0}};
    load_level = 8'b00000000;
    conf_data[3] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    
    load_unit = 8'b00001000;//d
    load_level = 8'b00000011;
    load_pos_h = 8'b00000000;
    load_pos_v = 8'b00001110;//14 (0-14)
    conf_data = {128{1'b0}};
    conf_data[64] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    
    load_pos_h = 8'b00000000;//c
    conf_data = {128{1'b0}};
    load_level = 8'b00000010;
    conf_data[65] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    
    load_pos_h = 8'b00000000;//y
    conf_data = {128{1'b0}};
    load_level = 8'b00001001;
    conf_data[67] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    
    load_pos_h = 8'b00000000;//b
    conf_data = {128{1'b0}};
    load_level = 8'b00000001;
    conf_data[3] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    
    load_pos_h = 8'b00000000;//a
    conf_data = {128{1'b0}};
    load_level = 8'b00000000;
    conf_data[3] = 1'b1;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    
    //uploading lut of LC configuration 
    //directions
    // load_unit = 8'b00010000;
    // load_pos_h = 8'b00000010; selecting position
    // load_pos_v = 8'b00000011; selecting position
    // conf_data[15:0] = 16'b1010101010101010; to lut where select is = a(msb),b,c,d(lsb)
    load_unit= 8'b00010000;//lut
    load_pos_h = 8'b00000000;
    load_pos_v = 8'b00001101;//13
    conf_data = {128{1'b0}};
    conf_data[15:0] = 16'b1001011010010110;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    
    
    load_pos_h = 8'b00000000;
    load_pos_v = 8'b00001110;//14
    conf_data[15:0] = 16'b1110100011101000;
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    load_unit= 8'b00000000;
  end
endmodule

module fpga_testbench_add_sub_4bit();
  //common for all testbenches
  reg clk;
  reg [127:0]conf_data;
  reg [7:0]load_level,load_pos_h,load_pos_v,load_unit;
  wire [127:0]gpio;
  
  //application specific
  wire[3:0]a,b,C;
  wire cin,cout;
  
  //common for all testbenches
  fpga fpga_new(clk, conf_data, load_unit, load_level, load_pos_h, load_pos_v, gpio);
  always
  begin
    #5 clk = ~clk;
  end
endmodule
