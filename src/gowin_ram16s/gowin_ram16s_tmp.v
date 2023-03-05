//Copyright (C)2014-2022 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//GOWIN Version: V1.9.8.09 Education
//Part Number: GW1NR-LV9QN88PC6/I5
//Device: GW1NR-9C
//Created Time: Sun Mar  5 19:25:49 2023

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_RAM16S your_instance_name(
        .dout(dout_o), //output [7:0] dout
        .wre(wre_i), //input wre
        .ad(ad_i), //input [10:0] ad
        .di(di_i), //input [7:0] di
        .clk(clk_i) //input clk
    );

//--------Copy end-------------------
