module fsm_tb ;
  
  reg clk;
  reg rstn;
  reg seq;
  wire detector;

  fsm fsm_inst(

      .clk(clk),
      .rstn(rstn),
      .seq(seq),
      .detector(detector)
  );


reg [13:0] seq_data;
integer i;


initial begin
  clk = 1'b0;

    forever begin
      #5 clk = ~clk;
    end

end


initial begin
  rstn = 1'b0;

    forever begin
      repeat(2)@(posedge clk);
        rstn = 1'b1;
    end

end


initial begin
  seq = 1'b0 ;
  seq_data = 14'b001101011011011 ;

    for (i = 0; i < 14; i = i+1) begin
      @(posedge clk);
      seq = seq_data [13-i];  
    end

  #500;
  $finish;

end
  

initial begin
  $dumpfile("waveform.vcd");     // Name of the output VCD file
  $dumpvars(0, fsm_tb);       // 0 = dump all levels of hierarchy under 'testbench'
end

endmodule 