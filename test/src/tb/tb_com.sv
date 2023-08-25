class Car;

    semaphore key;
    function new();
        key = new(0);
    endfunction

    task stall();
        $display("car::stall started");
        #1ns;
        key.put();
        $display("stall put");
        key.get();
        $display("stall get");
        $display("car::stall finished");
    endtask

    task park();
        key.get();
        $display("park get");
        $display("car::park started");
        #1ns;
        key.put();
        $display("park put");
        $display("car::park finished");
    endtask

    task drive();
        fork
            this.stall();
            this.park();
        join_none
    endtask

endclass

module tb_com;
    Car car = new();

    initial begin
        car.drive();
    end
endmodule
