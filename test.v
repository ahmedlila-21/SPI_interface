module spi #(
    
    parameter  IDLE = 3'b000 , 
    parameter  CHK_CMD = 3'b001 , 
    parameter  WRITE = 3'b010 , 
    parameter  READ_ADD = 3'b011 , 
    parameter  READ_DATA = 3'b100 



)(

    input MOSI ,SS_n, clk , rst_n ,
    input tx_valid ,
    input [7:0] tx_data ,
    output reg rx_valid ,
    output reg [9:0] rx_data,
    output reg MISO ,
    

);



reg [2:0] cs , ns ;

// signal to detect read address or data 
reg add_exist ; 

//counters
reg [3:0] counter_in ;
reg [2:0] counter_out ;



// state memory 

always @(posedge clk or negedge rst_n ) begin
    if( rst_n )  
       cs <= IDLE ;
    
    else 
        cs <= ns ;
end


// next state logic 

always @ ( cs , MOSI , SS_n , tx_data , tx_valid ) begin 

    case (cs)

    IDLE :begin 
         if (SS_n == 0) 
           ns <= CHK_CMD ; 
         else 
           ns <= IDLE ;
            
    end

    CHK_CMD : begin
      if (SS_n == 0 && MOSI == 0 )
         ns <= WRITE ;
      else  if (SS_n == 1) 
         ns <= IDLE ; 
      else if ( SS_n == 0 && MOSI == 1 ) begin  

        if (add_exist)
          ns <= READ_DATA ;
        else
           ns <= READ_ADD ; 
            
        end  
        

    end

    WRITE : begin 
        if ( SS_n == 1  )
         ns <= IDLE ;
        else 
         ns <= WRITE ;

    end

    READ_ADD : begin 
        if ( SS_n == 1  )
         ns <= IDLE ;
        else 
          ns <= READ_ADD ; 
    end 

    READ_DATA : begin 
        if ( SS_n == 1  )
         ns <= IDLE ;
        else 
          ns <= READ_DATA ;

    end 

    default  : ns <= IDLE ;
        
    endcase 
end 


//output logic 


// counters
always @( posedge clk or negedge rst_n )begin 
    if (rst_n || SS_n )begin // idle state 
       add_exist <= 0; 
       counter_in <= 4'b0 ;
       counter_out <= 3'b0 ;
       rx_valid <= 0 ;
       rx_data <= 10'b0 ;
       MISO <= 0 ;   
    end 

    else begin
    counter_in <= counter_in+1 ;   // start count when ss_n become 0 
    
    end
end 


always @(posedge clk ) begin 


        if (counter_in < 4'd13)   
          rx_data <= {rx_data[9:1] , MOSI } ;
        if ( counter_in ==  4'd12 )   // valid only at time 12 
          rx_valid <= 1 ; 
        if (counter_in > 4'd12)
          rx_valid <= 0 ;



    case (cs)

  

    READ_DATA :   add_exist <= 1 ; 

    READ_ADD  :   add_exist <= 0 ; 
      
        
    endcase 
end 


    // piso convert 
    reg start_out ; 
    always @(posedge clk ) begin
        if (tx_valid)    //assume  tx_valid high at one clk 
         start_out <= 1 ;
        else if (start_out) begin 
            counter_out <= counter_out+1 ;
            MISO <= tx_data [counter_out+1]
         if  (counter_out == 3'b111)  
           start_out <= 0 ; 

        end 
    end 


endmodule 
         



    




    



      
