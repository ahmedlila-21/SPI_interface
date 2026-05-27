module spi_wrapper_mytb ();

reg MOSI , SS_n , clk , rst_n ; 
wire MISO ;

spi_wrapper dut (

     MOSI , clk , rst_n , SS_n ,
     MISO 
);

always begin 
   clk = 0; 
   forever #5 clk = ~clk ;
end 

initial begin 
    $readmemh ("mem.dat", dut.u1.mem) ;
    rst_n = 0 ; 
    if ( MISO != 0 && dut.rx_valid != 0 && dut.rx_data != 10'b0) begin 
        $display ("error in reseat");
        $stop ; 
    end
    @(negedge clk ) ; 

    rst_n =  1;
    SS_n = 0 ;
     @(negedge clk ) ; 
    // write adress
    MOSI = 0 ;
     @(negedge clk ) ;
     MOSI =0 ; 
     @(negedge clk ); 
     MOSI =0 ; 
     @(negedge clk ); 

     repeat (8) begin 
        MOSI = 0 ; 
         @(negedge clk ) ;
     end
     if (dut.rx_valid != 1)begin 
        $display ("error in write address");
        $stop ; 
    end
    $display ( "write_address =%b" , dut.rx_data) ;  // addres accces in the memory 
    SS_n = 1;
      @(negedge clk ) ; 
    SS_n = 0; 
     @(negedge clk ) ;
     // write data 
    MOSI = 0 ;
     @(negedge clk ) ;
      MOSI =0 ; 
     @(negedge clk ); 
     MOSI =1 ; 
     @(negedge clk ); 
     repeat (8) begin 
        MOSI = $random ; 
         @(negedge clk ) ;
     end
     if (dut.rx_valid != 1)begin 
        $display ("error in write data");
        $stop ; 
    end
    $display ( "write_data =%b" , dut.rx_data) ; // data write in the memory 
    SS_n = 1; 
     @(negedge clk ) ; 
    SS_n = 0; 
     @(negedge clk ) ; 
     // read address
    MOSI = 1 ;
     @(negedge clk ) ;
      MOSI =1 ; 
     @(negedge clk ); 
     MOSI =0 ; 
     @(negedge clk ); 
     repeat (8) begin 
        MOSI = 0 ; 
         @(negedge clk ) ;
     end
     if (dut.rx_valid != 1)begin 
        $display ("error in read ");
        $stop ; 
    end
     $display ( "write_data =%b" , dut.rx_data) ; // address read   
       
    SS_n = 1; 
     @(negedge clk ) ; 
    SS_n = 0; 
     @(negedge clk ) ; 
     // reading
    MOSI = 1 ;
     @(negedge clk ) ;
      MOSI =1 ; 
     @(negedge clk ); 
     MOSI =1 ; 
     @(negedge clk ); 
      // garbage data
     repeat (8) begin 
        MOSI = $random ; 
         @(negedge clk ) ;
     end
     if (dut.rx_valid != 1)begin 
        $display ("error in read ");
        $stop ; 
    end
     $display ( "read_data =%b" , dut.tx_data) ; // data read
      repeat (8) begin    // miso out  
     
         @(negedge clk ) ;
     end

     $stop ; 
end 
endmodule 
     

       





