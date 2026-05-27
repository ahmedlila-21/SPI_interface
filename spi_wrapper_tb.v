module spi_wrapper_tb ();

reg MOSI , SS_n , clk , rst_n ; 
wire MISO ;
reg [7:0] write_address;

spi_wrapper dut (

     MOSI , clk , rst_n , SS_n ,
     MISO 
);

initial begin 
   clk = 0; 
   forever #5 clk = ~clk ;
end 

initial begin 
    
    $readmemh ("mem.dat", dut.u1.mem) ;
    rst_n = 0 ; 
    if ( MISO != 0 && dut.rx_valid != 0 && dut.rx_data != 10'b0) begin 
        $display ("error in reset");
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
     MOSI=1;
      @(negedge clk );
     MOSI=0;
      @(negedge clk );
     MOSI=1;
      @(negedge clk );
     MOSI=0;
      @(negedge clk );
     MOSI=0;
      @(negedge clk );
     MOSI=1;
      @(negedge clk );
     MOSI=1;
      @(negedge clk );
     MOSI=1;
      @(negedge clk );
 if (dut.rx_valid != 1)begin 
        $display ("error in write address");
        $stop ; 
    end
    write_address = dut.rx_data[7:0]; 
    
    $display ( "write_address =%b" , dut.rx_data[7:0]) ;  // addres accces in the memory 
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
     MOSI=0;
      @(negedge clk ); 
     MOSI=0;
      @(negedge clk ); 
     MOSI=0;
      @(negedge clk ); 
     MOSI=1;
      @(negedge clk ); 
     MOSI=0;
      @(negedge clk ); 
     MOSI=1;
      @(negedge clk ); 
    MOSI=0;
      @(negedge clk ); 
     MOSI=1;
      @(negedge clk ); 
     if (dut.rx_valid != 1)begin 
        $display ("error in write data");
        $stop ; 
    end
    $display ( "write_data =%b" , dut.rx_data[7:0]) ; // data write in the memory 
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
     MOSI=1;
      @(negedge clk );
     MOSI=0;
      @(negedge clk );
     MOSI=1;
      @(negedge clk );
     MOSI=0;
      @(negedge clk );
     MOSI=0;
      @(negedge clk );
     MOSI=1;
      @(negedge clk );
     MOSI=1;
      @(negedge clk );
     MOSI=1;
      @(negedge clk );
     if (dut.rx_valid != 1)begin 
        $display ("error in read ");
        $stop ; 
    end
    
     $display ( "read_address =%b" , dut.rx_data[7:0]) ; // address read   
       
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
     MOSI=0;
      @(negedge clk ); 
     MOSI=0;
      @(negedge clk ); 
     MOSI=0;
      @(negedge clk ); 
     MOSI=1;
      @(negedge clk ); 
     MOSI=0;
      @(negedge clk ); 
     MOSI=1;
      @(negedge clk ); 
    MOSI=0;
      @(negedge clk ); 
     MOSI=1;
      @(negedge clk ); 
     if (dut.rx_valid != 1)begin 
        $display ("error in read ");
        $stop ; 
    end
    if(dut.rx_data[7:0] != dut.u1.mem[write_address])begin
        $display("error in read data");
        $stop;
    end
     $display ( "read_data =%b" , dut.rx_data[7:0]) ; // data read
      
      end 
endmodule  
