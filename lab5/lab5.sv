// A full memory hierarchy. 
//
// Parameter:
// MODEL_NUMBER: A number used to specify a specific instance of the memory.  Different numbers give different hierarchies and settings.
//   This should be set to your student ID number.
// DMEM_ADDRESS_WIDTH: The number of bits of address for the memory.  Sets the total capacity of main memory.
//
// Accesses: To do an access, set address, data_in, byte_access, and write to a desired value, and set start_access to 1.
//   All these signals must be held constant until access_done, at which point the operation is completed.  On a read,
//   data_out will be set to the correct data for the single cycle when access_done is true.  Note that you can do
//   back-to-back accesses - when access_done is true, if you keep start_access true the memory will start the next access.
// 
//   When start_access = 0, the other input values do not matter.
//   bytemask controls which bytes are actually written (ignored on a read).
//     If bytemask[i] == 1, we do write the byte from data_in[8*i+7 : 8*i] to memory at the corresponding position.  If == 0, that byte not written.
//   To do a read: write = 0,  data_in does not matter.  data_out will have the proper data for the single cycle where access_done==1.
//   On a write, write = 1 and data_in must have the data to write.
//
//   Addresses must be aligned.  Since this is a 64-bit memory (8 bytes), the bottom 3 bits of each address must be 0.
//
//   It is an error to set start_access to 1 and then either set start_access to 0 or change any other input before access_done = 1.
//
//   Accessor tasks (essentially subroutines for testbenches) are provided below to help do most kinds of accesses.

// Line to set up the timing of simulation: says units to use are ns, and smallest resolution is 10ps.
`timescale 1ns/10ps

module lab5 #(parameter [22:0] MODEL_NUMBER = 1350364, parameter DMEM_ADDRESS_WIDTH = 20) (
	// Commands:
	//   (Comes from processor).
	input		logic [DMEM_ADDRESS_WIDTH-1:0]	address,			// The byte address.  Must be word-aligned if byte_access != 1.
	input		logic [63:0]							data_in,			// The data to write.  Ignored on a read.
	input		logic [7:0]								bytemask,		// Only those bytes whose bit is set are written.  Ignored on a read.
	input		logic										write,			// 1 = write, 0 = read.
	input		logic										start_access,	// Starts a memory access.  Once this is true, all command inputs must be stable until access_done becomes 1. 
	output	logic										access_done,	// Set to true on the clock edge that the access is completed.
	output	logic	[63:0]							data_out,		// Valid when access_done == 1 and access is a read.
	// Control signals:
	input		logic										clk,
	input		logic										reset				// A reset will invalidate all cache entries, and return main memory to the default initial values.
); 
	
	DataMemory #(.MODEL_NUMBER(MODEL_NUMBER), .DMEM_ADDRESS_WIDTH(DMEM_ADDRESS_WIDTH)) dmem
		(.address, .data_in, .bytemask, .write, .start_access, .access_done, .data_out, .clk, .reset);
	
	always @(posedge clk)
		assert(reset !== 0 || start_access == 0 || address[2:0] == 0); // All accesses must be aligned.
	
endmodule

// Test the data memory, and figure out the settings.

module lab5_testbench ();
	localparam USERID = 2335689;  // Set to your student ID #
	localparam ADDRESS_WIDTH = 20;
	localparam DATA_WIDTH = 8;
	
	logic [ADDRESS_WIDTH-1:0]			address;		   // The byte address.  Must be word-aligned if byte_access != 1.
	logic [63:0]							data_in;			// The data to write.  Ignored on a read.
	logic [7:0]								bytemask;		// Only those bytes whose bit is set are written.  Ignored on a read.
	logic										write;			// 1 = write, 0 = read.
	logic										start_access;	// Starts a memory access.  Once this is true, all command inputs must be stable until access_done becomes 1. 
	logic										access_done;	// Set to true on the clock edge that the access is completed.
	logic	[63:0]							data_out;		// Valid when access_done == 1 and access is a read.
	// Control signals:
	logic										clk;
	logic										reset;				// A reset will invalidate all cache entries, and return main memory to the default initial values.

	lab5 #(.MODEL_NUMBER(USERID), .DMEM_ADDRESS_WIDTH(ADDRESS_WIDTH)) dut
		(.address, .data_in, .bytemask, .write, .start_access, .access_done, .data_out, .clk, .reset); 

	// Set up the clock.
	parameter CLOCK_PERIOD=10;
	initial begin
		clk <= 0;
		forever #(CLOCK_PERIOD/2) clk <= ~clk;
	end

	// Force %t's to print in a nice format.
	initial $timeformat(-9, 5, " ns", 10);

	// --- Keep track of number of clock cycles, for statistics.
	integer cycles;
	always @(posedge clk) begin
		if (reset)
			cycles <= 0;
		else
			cycles <= cycles + 1;
	end
		
	// --- Tasks are subroutines for doing various operations.  These provide read and write actions.
	
	// Set memory controls to an idle state, no accesses going.
	task mem_idle;
		address			<= 'x;
		data_in			<= 'x;
		bytemask			<= 'x;
		write				<= 'x;
		start_access	<= 0;
		#1;
	endtask
	
	// Perform a read, and return the resulting data in the read_data output.
	// Note: waits for complete cycle of "access_done", so spends 1 cycle more than the access time.
	task readMem;
		input		[ADDRESS_WIDTH-1:0]		read_addr;
		output	[DATA_WIDTH-1:0][7:0]	read_data;
		output	int							delay;		// Access time actually seen.
		
		int startTime, endTime;
		
		startTime = cycles;
		address			<= read_addr;
		data_in			<= 'x;
		bytemask			<= 'x;
		write				<= 0;
		start_access	<= 1;
		@(posedge clk);
		while (~access_done) begin
			@(posedge clk);
		end
		mem_idle(); #1;
		read_data = data_out;
		endTime = cycles;
		delay = endTime - startTime - 1;
	endtask
	
	function int min;
		input int x;
		input int y;
		
		min = ((x<y) ? x : y);
	endfunction
	function int max;
		input int x;
		input int y;
		
		max = ((x>y) ? x : y);
	endfunction
	
	// Perform a series of reads, and returns the min and max access times seen.
	// Accesses are at read_addr, read_addr+stride, read_addr+2*stride, ... read_addr+(num_reads-1)*stride.
	task readStride;
		input		[ADDRESS_WIDTH-1:0]		read_addr;
		input		int							stride;
		input		int							num_reads;
		output	int							min_delay;	// Fastest access time actually seen.
		output	int							max_delay;	// Slowest access time actually seen.
		
		int i, delay;
		logic [DATA_WIDTH-1:0][7:0]		read_data;
		
		//$display("%t readStride(%d, %d, %d)", $time, read_addr, stride, num_reads);
		readMem(read_addr, read_data, delay);
		min_delay = delay;
		max_delay = delay;
		//$display("1  delay: %d", delay);
		
		for(i=1; i<num_reads; i++) begin
			readMem(read_addr+stride*i, read_data, delay);
			min_delay = min(min_delay, delay);
			max_delay = max(max_delay, delay);
			//$display("2  delay: %d", delay);
		end
		//$display("%t min_delay: %d max_delay: %d", $time, min_delay, max_delay);

		mem_idle(); #1;
	endtask
	
	// Perform a write.
	// Note: waits for complete cycle of "access_done", so spends 1 cycle more than the access time.
	task writeMem;
		input [ADDRESS_WIDTH-1:0]			write_address;
		input [DATA_WIDTH-1:0][7:0]		write_data;
		input [DATA_WIDTH-1:0]				write_bytemask;
		output	int							delay;		// Access time actually seen.
		
		int	startTime, endTime;
		
		startTime = cycles;
		address			<= write_address;
		data_in			<= write_data;
		bytemask			<= write_bytemask;
		write				<= 1;
		start_access	<= 1;
		@(posedge clk);
		while (~access_done) begin
			@(posedge clk);
		end
		mem_idle(); #1;
		endTime = cycles;
		delay = endTime - startTime - 1;
	endtask
	
	// Perform a series of writes, and returns the min and max access times seen.
	// Accesses are at write_addr, write_addr+stride, write_addr+2*stride, ... write_addr+(num_writes-1)*stride.
	task writeStride;
		input		[ADDRESS_WIDTH-1:0]		write_addr;
		input		int							stride;
		input		int							num_writes;
		output	int							min_delay;	// Fastest access time actually seen.
		output	int							max_delay;	// Slowest access time actually seen.
		
		int i, delay;
		logic [DATA_WIDTH-1:0][7:0]		write_data;
		
		//$display("%t writeStride(%d, %d, %d)", $time, write_addr, stride, num_writes);
		writeMem(write_addr, write_data, 8'hFF, delay);
		min_delay = delay;
		max_delay = delay;
		//$display("1  delay: %d", delay);
		
		for(i=1; i<num_writes; i++) begin
			writeMem(write_addr+stride*i, write_data, 8'hFF, delay);
			min_delay = min(min_delay, delay);
			max_delay = max(max_delay, delay);
			//$display("2  delay: %d", delay);
		end
		//$display("%t min_delay: %d max_delay: %d", $time, min_delay, max_delay);

		mem_idle(); #1;
	endtask
	
	// Skip doing an access for a cycle.
	task noopMem;
		mem_idle();
		@(posedge clk); #1;
	endtask
	
	// Reset the memory.
	task resetMem;
		mem_idle();
		reset <= 1;
		@(posedge clk);
		reset <= 0;
		#1;
	endtask
	
	logic	[DATA_WIDTH-1:0][7:0]	dummy_data;
	logic [ADDRESS_WIDTH-1:0]		addr;
	int	i, delay, minval, maxval;
	int j;
int l2_hit_total_cycles = delay;
int l2_block_size_bytes = 16;  // Start with L1 block size (minimum possible for L2)
logic l2_block_size_found = 0;
		
	
	// actual testing here
	initial begin
		dummy_data <= '0;
		addr <= '0;
		resetMem();				// Initialize the memory.
		
		
		
		// Do 20 random reads.
//		for (i=0; i<20; i++) begin
//			addr = $random()*8; // *8 to doubleword-align the access.
//			readMem(addr, dummy_data, delay);
//			$display("%t Read took %d cycles", $time, delay);
//		end
//		
//		// Do 5 random double-word writes of random data.
//		for (i=0; i<5; i++) begin
//			addr = $random()*8; // *8 to doubleword-align the access.
//			dummy_data = $random();
//			writeMem(addr, dummy_data, 8'hFF, delay);
//			$display("%t Write took %d cycles", $time, delay);
//		end
		
		// Reset the memory.
		// resetMem();
		
		// Read all of the first KB
		// readStride(0, 8, 1024/8, minval, maxval);
		// $display("%t Reading the first KB took between %d and %d cycles each", $time, minval, maxval);
		
		
		// DETERMINE block size (of L1  )
		// sequential reads until miss after series of hits (contiguous addresses within same block should be loaded on the first read)
		// observed:
		// First read takes 83 cycles (MISS), second takes 5 (HIT), third takes 83 (MISS)
		// Therefore block size of 16 bytes (each read is 8 bytes)
		readMem(addr, dummy_data, delay);
		$display("%t Reading address 0 took %d cycles", $time, delay);
		for (i=0; i<32; i++) begin
			addr = i * 8; // *8 to doubleword-align the access.
			readMem(addr, dummy_data, delay);
			$display("%t Reading address %d took %d cycles", $time, addr, delay);
		end
		
		// DETERMINE number of blocks (of L1)
		// read addr 0 into cache initially
		// OBSERVED:
		// Note that the previous loop to determine block size fills the caches with addresses 0-31 (blocks 0-15)
		// Reading block 0 initially takes 19 cycles, subsequent reads to other blocks take 19 cycles, and reads to block 0 take
		// 5 cycles, UNTIL block 8 is read. The following read to block 0 after takes 19 cycles (indicating block 8 resolved to the same
		// index as block 0 and therefore the cache was full). therefore 8 blocks
		
		$display("RUNNING TEST FOR NUM BLOCKS");
		readMem('0, dummy_data, delay);
		$display("%t Reading address 0 took %d cycles", $time, delay);
		for (i=1; i<64; i++) begin
			addr = 16 * i; // 16 for block size
			readMem(addr, dummy_data, delay);
			$display("%t Reading address %d took %d cycles", $time, addr, delay);
			// read addr 0 to check for long delay ==> miss
			readMem('0, dummy_data, delay);
			$display("%t Reading address %d took %d cycles", $time, 0, delay);
		end
		
		// reset memory to get empty caches
		resetMem();
		
		// DETERMINE associativity:
		// we know L1: blocksize = 16 bytes, #blocks = 8, size = 128 bytes
		// Sequentially read L1CacheSize bytes, check to see when addr 0 is kicked out (so reading 0 is a miss)
		// OBSERVED:
		// first read of addr 0 takes 83 cycles (miss on entirely empty memory hierarchy), next read on 
		// addr 16 also takes 83 cycles (MISS fetch from memory), second read from addr 0 takes 19 cycles (L1 miss)
		$display("TESTING L1 ASSOC");
		// assoc must be less than block size so can limit iteration count
		readMem('0, dummy_data, delay);
		$display("%t Reading address 0 took %d cycles", $time, delay);
		for (i = 1; i < 9;i ++) begin
			addr = 128 * i; // 16 for cache size (so we want to jump addr by 128 bytes at a time)
			readMem(addr, dummy_data, delay);
			$display("%t Reading address %d took %d cycles", $time, addr, delay);
			readMem('0, dummy_data, delay);
			$display("%t Reading address %d took %d cycles", $time, 0, delay);
		end

		resetMem();
		

//		$display("Testing L2 Block size");
//		// get data into L1 (and therefore also in L2) At least 128 bytes
//		// fills L1 Cache
//		for (j = 0; j < 5; j++) begin
//			for (i = 8 * j; i < 8*(j+1); i++) begin
//				addr = i * 16; // 16 byte per block
//				readMem(addr, dummy_data, delay);
//				$display("%t Reading address %d took %d cycles", $time, addr, delay);
//			end
//		end
//		
//		// now L1 holds block 8-16
//		// see how long it takes to read 0 --> took 19 cycles, so must be in L2 cache
//		// when j = 4 hit, when j = 5 miss, so size: 4 * 128 = 512
//		readMem('0, dummy_data, delay);
//		$display("%t Reading address %d took %d cycles", $time, 0, delay);
//		$display("=== DETERMINING L2 BLOCK SIZE ===");


$display("=== DETERMINING L2 BLOCK SIZE ===");

// Step 1: Fill L1 cache completely to force evictions to L2
$display("Step 1: Filling L1 cache...");
for (i = 0; i < 8; i++) begin  // 8 blocks in L1 cache
    addr = i * 16;  // 16-byte block size for L1
    readMem(addr, dummy_data, delay);
    $display("Loaded L1 block %d (addr %d): %d cycles", i, addr, delay);
end

// Step 2: Read a new block that will evict block 0 from L1 to L2
$display("Step 2: Evicting block 0 from L1...");
addr = 8 * 16;  // Block 8 maps to same L1 index as block 0
readMem(addr, dummy_data, delay);
$display("Read block 8 (addr %d): %d cycles - should evict block 0", addr, delay);

// Step 3: Now block 0 is only in L2. Test sequential addresses to find L2 block boundaries
$display("Step 3: Testing L2 block size...");


// First, establish what different access times mean:
// L1 hit: ~5 cycles
// L2 hit (L1 miss): L1_miss_time + L2_hit_time (~19 cycles total)
// L2 miss: L1_miss_time + L2_miss_time + Main_memory_time (~83 cycles total)

// Read address 0 first - this should be L2 hit (L1 miss + L2 hit = ~19 cycles)
readMem(0, dummy_data, delay);
$display("Read addr 0 (should be L2 hit): %d cycles", delay);

// Test at L1 block boundaries first (addresses 16, 32, 48...)
// since L2 blocks must be >= L1 block size
for (i = 1; i <= 16; i++) begin  // Test up to 256 bytes
    addr = i * 16;  // Test addresses 16, 32, 48, 64, ... (L1 block boundaries)
    readMem(addr, dummy_data, delay);
    $display("Read addr %d: %d cycles", addr, delay);
    
    if (delay == l2_hit_total_cycles) begin
        // Same total time = L2 hit (same L2 block as addr 0)
        l2_block_size_bytes = (i + 1) * 16;
        $display("  -> L2 HIT: block size >= %d bytes", l2_block_size_bytes);
    end else if (delay > l2_hit_total_cycles) begin
        // Much longer time = L2 miss, went to main memory
        $display("  -> L2 MISS: block boundary found at %d bytes", l2_block_size_bytes);
        l2_block_size_found = 1;
        break;
    end else begin
        // Shorter time = L1 hit (shouldn't happen in this test, but handle it)
        $display("  -> Unexpected L1 HIT at addr %d", addr);
    end
end

$display("=== L2 BLOCK SIZE RESULT ===");
if (l2_block_size_found) begin
    $display("L2 block size: %d bytes", l2_block_size_bytes);
end else begin
    $display("L2 block size: >= %d bytes (may be larger)", l2_block_size_bytes);
end

// Alternative method: Test with larger jumps if needed
if (!l2_block_size_found) begin
    $display("Testing larger block sizes...");
    
    // Reset and try with bigger jumps
    resetMem();
    
    // Fill L1 again
    for (i = 0; i < 8; i++) begin
        addr = i * 16;
        readMem(addr, dummy_data, delay);
    end
    
    // Evict block 0 again
    readMem(8 * 16, dummy_data, delay);
    
    // Test with 64-byte jumps (multiples of L1 block size)
    readMem(0, dummy_data, delay);
    l2_hit_total_cycles = delay;
    
    for (i = 1; i <= 8; i++) begin  // Test 64, 128, 192, 256, 320, 384, 448, 512
        addr = i * 64;
        readMem(addr, dummy_data, delay);
        $display("Read addr %d: %d cycles", addr, delay);
        
        if (delay > l2_hit_total_cycles) begin
            l2_block_size_bytes = i * 64;
            $display("L2 block size found: %d bytes", l2_block_size_bytes);
            break;
        end
    end
end


// Find L2 cache size - assuming 16 byte block size
$display("=== FINDING L2 CACHE SIZE ===");

// Strategy: Fill L1 completely, then read enough data to fill L2.
// When L2 is full, previously cached data gets evicted to main memory.
// We detect this by seeing when a previously fast access becomes slow.

// Step 1: Fill L1 cache completely (8 blocks × 16 bytes = 128 bytes)
$display("Step 1: Filling L1 cache...");
for (i = 0; i < 8; i++) begin
    addr = i * 16;  // Addresses 0, 16, 32, 48, 64, 80, 96, 112
    readMem(addr, dummy_data, delay);
    $display("Loaded L1 block %d (addr %d): %d cycles", i, addr, delay);
end

// Step 2: Force address 0 to be evicted from L1 to L2 only
$display("Step 2: Evicting address 0 from L1 to L2...");
addr = 8 * 16;  // Address 128 - maps to same L1 index as address 0
readMem(addr, dummy_data, delay);
$display("Read addr %d: %d cycles (evicts addr 0 to L2)", addr, delay);

// Step 3: Verify address 0 is in L2 (should be medium delay ~19 cycles)
readMem(0, dummy_data, delay);
$display("Read addr 0: %d cycles (should be L2 hit)", delay);

// Step 4: Read sequential blocks to fill L2 cache
// Keep checking if address 0 is still in L2 or gets evicted to main memory
$display("Step 3: Testing L2 capacity...");

for (i = 1; i <= 8192; i++) begin  // Test up to 64 blocks (1024 bytes)
    // Read a new block that will consume L2 capacity
    addr = (8 + i) * 16;  // Addresses 144, 160, 176, 192, ...
    readMem(addr, dummy_data, delay);
    $display("Read addr %d: %d cycles", addr, delay);
    
    // Keep L1 full by reading the most recent 8 blocks
    // This prevents address 0 from being pulled back into L1
    for (j = 0; j < 8; j++) begin
        readMem((8 + i - 7 + j) * 16, dummy_data, delay);
    end
    
    // Now check if address 0 is still in L2
    readMem(0, dummy_data, delay);
    $display("  Check addr 0: %d cycles", delay);
    
    if (delay > 50) begin  // If > 50 cycles, it's been evicted to main memory
        $display("  -> L2 CACHE FULL! Address 0 evicted after reading %d blocks", i);
        $display("  -> L2 cache size: %d bytes", i * 16);
        break;
    end else begin
        $display("  -> Address 0 still in L2 (cache size > %d bytes)", i * 16);
    end
end
		
		
		$stop();
	end
	
endmodule
