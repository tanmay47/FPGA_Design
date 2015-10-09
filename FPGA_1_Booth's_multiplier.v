`include "FPGA_1.v"
module fpga_testbench_booth_mul();//io unit, LC unit tested,bus interconnections tested
  reg clk,temp0,temp1;
  reg [127:0]conf_data;
  reg [7:0]load_level,load_pos_h,load_pos_v,load_unit;
  wire [127:0]gpio;
  
  reg [3:0]a,b;
  wire [7:0]C;
  reg load;
  
  fpga fpga_new(clk, conf_data, load_unit, load_level, load_pos_h, load_pos_v, gpio);
  always
  begin
    #5 clk = ~clk;
  end
  
  assign gpio[64] = a[3];assign gpio[68] = a[2];assign gpio[72] = a[1];assign gpio[76] = a[0];
  assign gpio[80] = b[3];assign gpio[84] = b[2];assign gpio[88] = b[1];assign gpio[92] = b[0];
  
  assign C[7] = gpio[67];assign C[6] = gpio[71];assign C[5] = gpio[75];assign C[4] = gpio[79];
  assign C[3] = gpio[83];assign C[2] = gpio[87];assign C[1] = gpio[91];assign C[0] = gpio[95];
  
  assign gpio[65] = load;
  assign gpio[66] = clk;
  
  assign gpio[69] = temp0;
  assign gpio[70] = temp1;
  
  initial
  begin
    clk = 1;
    load = 0;
    temp0 = 0;
    temp1 = 1;
    
    //////////////////////////////
    /////////Input/Output/////////
    //////////////////////////////
    load_unit = 8'b00000001;//all h io's
    load_level = 8'b00000000;//don't care
    load_pos_v = 8'b00000000;//don't care
    load_pos_h = 8'b00000000;
    //                         op[7] clk  load    A3
    conf_data[23:0] = 24'b1000_00101_00000_00011_00100;
    #10;
    load_pos_h = 8'b00000001;
    //                         op[6]  hi    lo    A2
    conf_data[23:0] = 24'b1000_00101_00001_00010_00100;
    #10;
    load_pos_h = 8'b00000010;
    //                         op[5]  nc    nc    A1
    conf_data[23:0] = 24'b1000_00101_11111_11111_00100;
    #10;
    load_pos_h = 8'b00000011;
    //                         op[4]  nc    nc    A0
    conf_data[23:0] = 24'b1000_00101_11111_11111_00100;
    #10;
    load_pos_h = 8'b00000100;
    //                         op[3]  nc    nc    B3
    conf_data[23:0] = 24'b1000_00101_11111_11111_00100;
    #10;
    load_pos_h = 8'b00000101;
    //                         op[2]  nc    nc    B2
    conf_data[23:0] = 24'b1000_00101_11111_11111_00100;
    #10;
    load_pos_h = 8'b00000110;
    //                         op[1]  nc    nc    B1
    conf_data[23:0] = 24'b1000_00101_11111_11111_00100;
    #10;
    load_pos_h = 8'b00000111;
    //                         op[0]  nc    nc    B0
    conf_data[23:0] = 24'b1000_00101_11111_11111_00100;
    #10;
    
    
    //////////////////////////////////////
    /////////bus interconnections/////////
    //////////////////////////////////////
    
    load_unit = 8'b00000100;
    load_pos_h = 8'b00000000;
    load_pos_v = 8'b00001011;//11
    load_level = 8'b00000000;
    conf_data = {128{1'b0}};
    conf_data[0] = 1'b1;//clk
    #10
    load_pos_v = 8'b00001100;//12
    #10
    load_pos_v = 8'b00001101;//13
    #10
    load_pos_v = 8'b00001110;//14
    #10
    load_pos_v = 8'b00001111;//15
    #10
    
    load_pos_h = 8'b00000001;
    load_level = 8'b00000001;
    conf_data = {128{1'b0}};
    conf_data[1] = 1'b1;//hi
    load_pos_v = 8'b00001011;//11
    #10
    load_pos_v = 8'b00001100;//12
    #10
    load_pos_v = 8'b00001101;//13
    #10
    load_pos_v = 8'b00001110;//14
    #10
    load_pos_v = 8'b00001111;//15
    #10
    
    load_pos_h = 8'b00000001;
    load_level = 8'b00000010;
    conf_data = {128{1'b0}};
    conf_data[2] = 1'b1;//lo
    load_pos_v = 8'b00001011;//11
    #10
    load_pos_v = 8'b00001100;//12
    #10
    load_pos_v = 8'b00001101;//13
    #10
    load_pos_v = 8'b00001110;//14
    #10
    load_pos_v = 8'b00001111;//15
    #10
    
    load_pos_h = 8'b00000000;
    load_level = 8'b00000011;
    conf_data = {128{1'b0}};
    conf_data[3] = 1'b1;//load_bar
    load_pos_v = 8'b00001011;//11
    #10
    load_pos_v = 8'b00001100;//12
    #10
    load_pos_v = 8'b00001101;//13
    #10
    load_pos_v = 8'b00001110;//14
    #10
    load_pos_v = 8'b00001111;//15
    #10
    
    load_pos_h = 8'b00000111;//7
    load_pos_v = 8'b00001111;//15
    conf_data = {128{1'b0}};
    conf_data[6] = 1'b1;
    load_level = 8'b00000110;//6
    #10
    
    load_pos_h = 8'b00001001;//9
    load_pos_v = 8'b00001100;//12
    conf_data = {128{1'b0}};
    conf_data[0] = 1'b1;
    load_level = 8'b00000101;//5
    #10
    
    
    
    //////////////////////
    ////////reg M/////////
    //////////////////////
    //LC_BUS ==   op:right;   ip:left;
    //M3
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000000;
    load_pos_v = 8'b00001011;//11
    load_level = 8'b00000000;//a - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000001;//b - A (input gpio)
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000010;//c - only shift?(decider ckt) control_signal[2]
    conf_data = {128{1'b0}};
    conf_data[32+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - q(this)
    conf_data = {128{1'b0}};
    conf_data[6] = 1'b1;
    #10
    load_level = 8'b00000100;//e - A (input gpio)
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000101;//f - control_signal[2]
    conf_data = {128{1'b0}};
    conf_data[32+5] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001001;//y - output to adder
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00001010;//q - for feed back only (this)
    conf_data = {128{1'b0}};
    conf_data[6] = 1'b1;
    #10
    
    //M2
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000001;
    load_pos_v = 8'b00001011;//11
    load_level = 8'b00000000;//a - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000001;//b - A (input gpio)
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000010;//c - only shift?(decider ckt)control_signal[2]
    conf_data = {128{1'b0}};
    conf_data[32+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - q(this)
    conf_data = {128{1'b0}};
    conf_data[6] = 1'b1;
    #10
    load_level = 8'b00000100;//e - A (input gpio)
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000101;//f - control_signal[2]
    conf_data = {128{1'b0}};
    conf_data[32+5] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001001;//y - output to adder
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00001010;//q - for feed back only (this)
    conf_data = {128{1'b0}};
    conf_data[6] = 1'b1;
    #10
    
    //M1
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000010;
    load_pos_v = 8'b00001011;//11
    load_level = 8'b00000000;//a - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000001;//b - A (input gpio)
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000010;//c - only shift?(decider ckt)control_signal[2]
    conf_data = {128{1'b0}};
    conf_data[32+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - q(this)
    conf_data = {128{1'b0}};
    conf_data[6] = 1'b1;
    #10
    load_level = 8'b00000100;//e - A (input gpio)
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000101;//f - control_signal[2]
    conf_data = {128{1'b0}};
    conf_data[32+5] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001001;//y - output to adder
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00001010;//q - for feed back only (this)
    conf_data = {128{1'b0}};
    conf_data[6] = 1'b1;
    #10

    //M0
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000011;
    load_pos_v = 8'b00001011;//11
    load_level = 8'b00000000;//a - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000001;//b - A (input gpio)
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000010;//c - only shift?(decider ckt)control_signal[2]
    conf_data = {128{1'b0}};
    conf_data[32+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - q(this)
    conf_data = {128{1'b0}};
    conf_data[6] = 1'b1;
    #10
    load_level = 8'b00000100;//e - A (input gpio)
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000101;//f - control_signal[2]
    conf_data = {128{1'b0}};
    conf_data[32+5] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001001;//y - output to adder
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00001010;//q - for feed back only (this)
    conf_data = {128{1'b0}};
    conf_data[6] = 1'b1;
    #10
    //LC_LUT
    load_unit= 8'b00010000;
    load_pos_h = 8'b00000000;
    load_pos_v = 8'b00001011;//11
    conf_data = {128{1'b0}};
    conf_data[15:0] = 16'b1111_0000_0010_0010;//?????
    #10
    load_pos_h = 8'b00000001;
    #10
    load_pos_h = 8'b00000010;
    #10
    load_pos_h = 8'b00000011;
    #10
    // - - - - - - - - - reg M - - - - - - - - -
    
    
    
    
    ///////////////////////////
    //////////counter//////////
    ///////////////////////////
    //msb
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000100;//4
    load_pos_v = 8'b00001011;//11
    load_level = 8'b00000000;//a - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000001;//b - Q(msb)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - Q(mid)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q(LSB)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+8] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - Q(msb)
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    //mid
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000101;//5
    load_pos_v = 8'b00001011;//11
    load_level = 8'b00000000;//a - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000001;//b - Q(msb)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - Q(mid)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q(LSB)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+8] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - Q(mid)
    conf_data = {128{1'b0}};
    conf_data[96+7] = 1'b1;
    #10
    //lsb
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000110;//6
    load_pos_v = 8'b00001011;//11
    load_level = 8'b00000000;//a - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000001;//b - Q(msb)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - Q(mid)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q(LSB)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+8] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - Q(lsb)
    conf_data = {128{1'b0}};
    conf_data[96+8] = 1'b1;
    #10
    
    //control signal
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000111;//7
    load_pos_v = 8'b00001011;//11
    load_level = 8'b00000000;//a - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000001;//b - Q(msb)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - Q(mid)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q(LSB)(-1)
    conf_data = {128{1'b0}};
    conf_data[96+8] = 1'b1;
    #10
    load_level = 8'b00001001;//y - control_signal[0] ; stop
    conf_data = {128{1'b0}};
    conf_data[64+6] = 1'b1;
    #10
    //LC_LUT msb/lsb
    load_unit= 8'b00010000;
    load_pos_h = 8'b00000100;//4
    load_pos_v = 8'b00001011;//11
    conf_data = {128{1'b0}};
    conf_data[15:0] = 16'b1111_1111_1110_0000;
    #10
    conf_data[15:0] = 16'b0000_0000_1001_1000;
    load_pos_h = 8'b00000101;//5
    #10
    conf_data[15:0] = 16'b0000_0000_0101_0100;
    load_pos_h = 8'b00000110;//6
    #10
    load_pos_h = 8'b00000111;//7
    conf_data = {128{1'b0}};//control signal
    conf_data[15:0] = 16'b0000_0000_1111_1110;
    #10
    // - - - - - - - counter - - - - - - - - 
    
    
    
    ////////////////////////////////////
    //////////adder/subtractor//////////
    ////////////////////////////////////
    
    //sum[3]
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000000;//0
    load_pos_v = 8'b00001100;//12
    load_level = 8'b00000000;//a - control_signal[1] ; add / sub
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000001;//b - input from A reg
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000010;//c - from M reg
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[8] = 1'b1;
    #10
    load_level = 8'b00001001;//y - A reg input
    conf_data = {128{1'b0}};
    conf_data[9] = 1'b1;
    #10
    
    //sum[2]
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000001;//1
    load_pos_v = 8'b00001100;//12
    load_level = 8'b00000000;//a - control_signal[1] ; add / sub
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000001;//b - input from A reg
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000010;//c - from M reg
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[8] = 1'b1;
    #10
    load_level = 8'b00001001;//y - A reg input
    conf_data = {128{1'b0}};
    conf_data[9] = 1'b1;
    #10
    
    //sum[1]
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000010;//2
    load_pos_v = 8'b00001100;//12
    load_level = 8'b00000000;//a - control_signal[1] ; add / sub
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000001;//b - input from A reg
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000010;//c - from M reg
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[8] = 1'b1;
    #10
    load_level = 8'b00001001;//y - A reg input
    conf_data = {128{1'b0}};
    conf_data[9] = 1'b1;
    #10
    
    //sum[0]
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000011;//3
    load_pos_v = 8'b00001100;//12
    load_level = 8'b00000000;//a - control_signal[1] ; add / sub
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000001;//b - input from A reg
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000010;//c - from M reg
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - low
    conf_data = {128{1'b0}};
    conf_data[32+2] = 1'b1;
    #10
    load_level = 8'b00001001;//y - A reg input
    conf_data = {128{1'b0}};
    conf_data[9] = 1'b1;
    #10
    
    //carry/borrow[3]
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000000;//0
    load_pos_v = 8'b00001101;//13
    load_level = 8'b00000000;//a - control_signal[1] ; add / sub
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    load_level = 8'b00000001;//b - input from A reg
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000010;//c - from M reg
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[8] = 1'b1;
    #10
    load_level = 8'b00001001;//y - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[64+8] = 1'b1;
    #10
    
    //carry/borrow[2]
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000001;//1
    load_pos_v = 8'b00001101;//13
    load_level = 8'b00000000;//a - control_signal[1] ; add / sub
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    load_level = 8'b00000001;//b - input from A reg
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000010;//c - from M reg
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[8] = 1'b1;
    #10
    load_level = 8'b00001001;//y - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[64+8] = 1'b1;
    #10
    
    //carry/borrow[1]
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000010;//2
    load_pos_v = 8'b00001101;//13
    load_level = 8'b00000000;//a - control_signal[1] ; add / sub
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    load_level = 8'b00000001;//b - input from A reg
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000010;//c - from M reg
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[8] = 1'b1;
    #10
    load_level = 8'b00001001;//y - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[64+8] = 1'b1;
    #10
    
    //carry/borrow[0]
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000011;//3
    load_pos_v = 8'b00001101;//13
    load_level = 8'b00000000;//a - control_signal[1] ; add / sub
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    load_level = 8'b00000001;//b - input from A reg
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000010;//c - from M reg
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - low
    conf_data = {128{1'b0}};
    conf_data[32+2] = 1'b1;
    #10
    load_level = 8'b00001001;//y - carry/borrow
    conf_data = {128{1'b0}};
    conf_data[64+8] = 1'b1;
    #10
    
    //LC_LUT sum (add - 0; sub - 1 )
    load_unit= 8'b00010000;
    load_pos_h = 8'b00000000;//0
    load_pos_v = 8'b00001100;//12
    conf_data = {128{1'b0}};
    conf_data[15:0] = 16'b1001_0110_1001_0110;
    #10
    load_pos_h = 8'b00000001;//1
    #10
    load_pos_h = 8'b00000010;//2
    #10
    load_pos_h = 8'b00000011;//3
    #10
    
    //LC_LUT carry/borrow (add - 0; sub - 1 )
    load_unit= 8'b00010000;
    load_pos_h = 8'b00000000;//0
    load_pos_v = 8'b00001101;//13
    conf_data = {128{1'b0}};
    //                    sub        add
    conf_data[15:0] = 16'b1000_1110_1110_1000;
    #10
    load_pos_h = 8'b00000001;//1
    #10
    load_pos_h = 8'b00000010;//2
    #10
    load_pos_h = 8'b00000011;//3
    #10
    // - - - - - - - - adder/subtractor - - - - - - -
    
    
    
    ///////////////////////
    /////////Reg A/////////
    ///////////////////////
    //A3
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000000;
    load_pos_v = 8'b00001110;//14
    load_level = 8'b00000001;//b - control_signal[0];stop
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - q(this)
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - add/sub in
    conf_data = {128{1'b0}};
    conf_data[9] = 1'b1;
    #10
    load_level = 8'b00000100;//e - low
    conf_data = {128{1'b0}};
    conf_data[32+2] = 1'b1;
    #10
    load_level = 8'b00000101;//f - load_bar
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - output
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    
    //A2
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000001;
    load_pos_v = 8'b00001110;//14
    load_level = 8'b00000001;//b - control_signal[0];stop
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - q(this)
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - add/sub in
    conf_data = {128{1'b0}};
    conf_data[64+9] = 1'b1;
    #10
    load_level = 8'b00000100;//e - low
    conf_data = {128{1'b0}};
    conf_data[32+2] = 1'b1;
    #10
    load_level = 8'b00000101;//f - load_bar
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - output
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    
    //A1
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000010;
    load_pos_v = 8'b00001110;//14
    load_level = 8'b00000001;//b - control_signal[0];stop
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - q(this)
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - add/sub in
    conf_data = {128{1'b0}};
    conf_data[64+9] = 1'b1;
    #10
    load_level = 8'b00000100;//e - low
    conf_data = {128{1'b0}};
    conf_data[32+2] = 1'b1;
    #10
    load_level = 8'b00000101;//f - load_bar
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - output
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    
    //A0
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000011;
    load_pos_v = 8'b00001110;//14
    load_level = 8'b00000001;//b - control_signal[0];stop
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - q(this)
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - add/sub in
    conf_data = {128{1'b0}};
    conf_data[64+9] = 1'b1;
    #10
    load_level = 8'b00000100;//e - low
    conf_data = {128{1'b0}};
    conf_data[32+2] = 1'b1;
    #10
    load_level = 8'b00000101;//f - load_bar
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - output
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    
    //LUT - A reg
    load_unit= 8'b00010000;
    load_pos_h = 8'b00000000;//0
    load_pos_v = 8'b00001110;//14
    conf_data = {128{1'b0}};
    //                             a/s in   q    
    conf_data[15:0] = 16'b1010_1100_1010_1100;
    #10
    load_pos_h = 8'b00000001;//1
    #10
    load_pos_h = 8'b00000010;//2
    #10
    load_pos_h = 8'b00000011;//3
    #10
    // - - - - - - - A reg - - - - - - - - - 
    
    
    /////////////////////////
    //////////Q Reg//////////
    /////////////////////////
    
    //Q3
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000100;//4
    load_pos_v = 8'b00001110;//14
    load_level = 8'b00000001;//b - control_signal[0];stop
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - q(this)
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - add/sub in
    conf_data = {128{1'b0}};
    conf_data[64+9] = 1'b1;
    #10
    load_level = 8'b00000100;//e - input B
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000101;//f - load_bar
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - output
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    conf_data[7] = 1'b1;
    #10
    //LUT - Q(msb) reg
    load_unit= 8'b00010000;
    load_pos_h = 8'b00000100;//4
    load_pos_v = 8'b00001110;//14
    conf_data = {128{1'b0}};
    //                               q    a/s in
    conf_data[15:0] = 16'b1010_1100_1010_1100;
    #10
    
    
    
    //Q2
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000101;//5
    load_pos_v = 8'b00001110;//14
    load_level = 8'b00000001;//b - control_signal[0];stop
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - q(this)
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q left output
    conf_data = {128{1'b0}};
    conf_data[64+7] = 1'b1;
    #10
    load_level = 8'b00000100;//e - input B
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000101;//f - load_bar
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - output
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    conf_data[7] = 1'b1;
    #10
    
    //Q1
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000110;//6
    load_pos_v = 8'b00001110;//14
    load_level = 8'b00000001;//b - control_signal[0];stop
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - q(this)
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q left output
    conf_data = {128{1'b0}};
    conf_data[64+7] = 1'b1;
    #10
    load_level = 8'b00000100;//e - input B
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000101;//f - load_bar
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - output
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    conf_data[7] = 1'b1;
    #10
    
    //Q0
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000111;//7
    load_pos_v = 8'b00001110;//14
    load_level = 8'b00000001;//b - control_signal[0];stop
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - q(this)
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q left output
    conf_data = {128{1'b0}};
    conf_data[64+7] = 1'b1;
    #10
    load_level = 8'b00000100;//e - input B
    conf_data = {128{1'b0}};
    conf_data[64+4] = 1'b1;
    #10
    load_level = 8'b00000101;//f - load_bar
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - output
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    conf_data[7] = 1'b1;
    #10
    
    //Q-1
    load_unit = 8'b00001000;
    load_pos_h = 8'b00001000;//8
    load_pos_v = 8'b00001110;//14
    load_level = 8'b00000001;//b - control_signal[0];stop
    conf_data = {128{1'b0}};
    conf_data[32+6] = 1'b1;
    #10
    load_level = 8'b00000010;//c - q(this)
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q left output
    conf_data = {128{1'b0}};
    conf_data[64+7] = 1'b1;
    #10
    load_level = 8'b00000100;//e - low
    conf_data = {128{1'b0}};
    conf_data[32+2] = 1'b1;
    #10
    load_level = 8'b00000101;//f - load_bar
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000110;//clk - clk
    conf_data = {128{1'b0}};
    conf_data[32] = 1'b1;
    #10
    load_level = 8'b00000111;//clk_enable - hi
    conf_data = {128{1'b0}};
    conf_data[32+1] = 1'b1;
    #10
    load_level = 8'b00001010;//q - output
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    
    //LUT - Q[2:(-1)] reg
    load_unit= 8'b00010000;
    load_pos_h = 8'b00000101;//5
    load_pos_v = 8'b00001110;//14
    conf_data = {128{1'b0}};
    //                               q    a/s in
    conf_data[15:0] = 16'b1010_1100_1010_1100;
    #10
    load_pos_h = 8'b00000110;//6
    #10
    load_pos_h = 8'b00000111;//7
    #10
    load_pos_h = 8'b00001000;//8
    #10
    // - - - - - - - - Q Reg - - - - - - - - - 
    
    ///////////////////////////
    ////////Control_Ckt////////
    ///////////////////////////
    
    //control signal [1] - add/sub
    load_unit = 8'b00001000;
    load_pos_h = 8'b00000111;//7
    load_pos_v = 8'b00001101;//13
    load_level = 8'b00000001;//b - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000010;//c - Q 0
    conf_data = {128{1'b0}};
    conf_data[7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q -1
    conf_data = {128{1'b0}};
    conf_data[5] = 1'b1;
    #10
    load_level = 8'b00001001;//y - output
    conf_data = {128{1'b0}};
    conf_data[96+6] = 1'b1;
    #10
    
    //control signal [2] - shift only?
    load_unit = 8'b00001000;
    load_pos_h = 8'b00001000;//8
    load_pos_v = 8'b00001101;//13
    load_level = 8'b00000001;//b - load
    conf_data = {128{1'b0}};
    conf_data[32+3] = 1'b1;
    #10
    load_level = 8'b00000010;//c - Q 0
    conf_data = {128{1'b0}};
    conf_data[64+7] = 1'b1;
    #10
    load_level = 8'b00000011;//d - Q -1
    conf_data = {128{1'b0}};
    conf_data[64+5] = 1'b1;
    #10
    load_level = 8'b00001001;//y - output
    conf_data = {128{1'b0}};
    conf_data[0] = 1'b1;
    #10
    
    //LUT-add/sub control signal [1]
    load_unit= 8'b00010000;
    load_pos_h = 8'b00000111;//7
    load_pos_v = 8'b00001101;//13
    conf_data = {128{1'b0}};
    conf_data[15:0] = 16'b0100_0100_0100_0100;
    #10
    
    //LUT-shift only? control signal [2]
    load_unit= 8'b00010000;
    load_pos_h = 8'b00001000;//8
    load_pos_v = 8'b00001101;//13
    conf_data = {128{1'b0}};
    conf_data[15:0] = 16'b0000_0000_0000_1001;
    #10;
    // - - - - - - - - control ckt - - - - - - - - - 
    load = 1;
    load_unit= 8'b00000000;
    a = 4'b0001;
    b = 4'b0001;
    #10;
    load = 0;
    #50;
  end
endmodule
