/*
* Conways game of life in systemerilog 
*/
//logic [31:0] number = $urandom(209);

module conway (
    input logic clk
);

  // Variables
  logic [7:0] grid_size = 60;  // We do not support more than 256 grid_size
  logic [31:0] half_grid = 32'(grid_size) / 2;

  logic [15:0] list[] = {
    (16'(half_grid - 1) << 8) + {8'd0, 8'(half_grid + 1)},  // 14, 16
    (16'(half_grid - 1) << 8) + {8'd0, 8'(half_grid)},  // 14, 15
    (16'(half_grid) << 8) + {8'd0, 8'(half_grid)},  // 15, 15
    (16'(half_grid) << 8) + {8'd0, 8'(half_grid - 1)},  // 15, 14
    (16'(half_grid + 1) << 8) + {8'd0, 8'(half_grid)}  // 16, 15
  };

  logic [7:0] directions[3] = {-1, 0, 1};
  logic init = 0;
  logic [15:0] vals[] = list;

  task automatic grid_display(input [15:0] cord[]);
    string char;
    int x = 0;

    // grid display
    for (int i = 0; i < grid_size; i++) begin
      logic [7:0] row_cord[] = {};
      foreach (cord[k]) begin
        if (cord[k][15:8] == 8'(i)) begin
          row_cord = new[x + 1] (row_cord);
          row_cord[x] = cord[k][7:0];
          x++;
        end
      end
      for (int j = 0; j < grid_size; j++) begin
        char = " ";
        foreach (row_cord[z]) char = (row_cord[z] == 8'(j)) ? "■" : char;
        $write("%s", char);
      end
      x = 0;
      $display();
    end
  endtask

  task automatic contains(input logic [15:0] values[], input logic [15:0] value,
                          output logic contains);
    contains = 0;
    foreach (values[i]) begin
      if (values[i] == value) begin
        contains = 1;
        break;
      end
    end
  endtask

  task automatic valid_neighbor(input logic [15:0] livingCells[], input logic [15:0] cord,
                                output logic valid);
    int match = 0;
    logic alive, contains_temp;
    valid = 0;
    foreach (directions[j]) begin
      if (!(cord[15:8] <= 0 && directions[j] == -1) && !(cord[15:8] >= grid_size && directions[j] == 1)) begin
        foreach (directions[z]) begin
          if (!(cord[7:0] <= 0 && directions[z] == -1) && !(cord[7:0] >= grid_size && directions[z] == 1)) begin
            if (!(directions[z] == 0 && directions[j] == 0)) begin
              logic [15:0] temp;
              temp[15:8] = (directions[j] != -1) ? cord[15:8] + directions[j] :
                  $unsigned($signed(cord[15:8]) + $signed(directions[j]));
              temp[7:0] = (directions[z] != -1) ? cord[7:0] + directions[z] :
                  $unsigned($signed(cord[7:0]) + $signed(directions[z]));
              contains(livingCells, temp, contains_temp);
              match = (contains_temp) ? match + 1 : match;
              if (match > 3) begin
                valid = 0;
                return;
              end
            end
          end
        end
      end
    end
    contains(livingCells, cord, alive);
    valid = (match == 3 || (match == 2 && alive));  // Conways rules
  endtask



  always @(posedge clk) begin
    int x, y = 0;
    logic [15:0] neighbors[], bad_neighbors[] = {};

    if (init) begin
      neighbors = {};
      bad_neighbors = {};
      foreach (vals[i]) begin
        foreach (directions[j]) begin
          if (!(vals[i][15:8] == 0 && directions[j] == -1) && !(vals[i][15:8] == grid_size && directions[j] == 1)) begin
            foreach (directions[z]) begin
              if (!(vals[i][7:0] == 0 && directions[z] == -1) && !(vals[i][7:0] == grid_size && directions[z] == 1)) begin
                logic [15:0] cord;
                logic exists;
                cord[15:8] = (directions[j] != -1) ? vals[i][15:8] + directions[j] :
                    $unsigned($signed(vals[i][15:8]) + $signed(directions[j]));
                cord[7:0] = (directions[z] != -1) ? vals[i][7:0] + directions[z] :
                    $unsigned($signed(vals[i][7:0]) + $signed(directions[z]));
                contains(bad_neighbors, cord, exists);
                if (!exists) begin
                  logic valid;
                  valid_neighbor(vals, cord, valid);
                  contains(neighbors, cord, exists);
                  if (valid && !exists) begin
                    neighbors = new[x + 1] (neighbors);
                    neighbors[x] = cord;
                    x++;
                  end else begin
                    bad_neighbors = new[y + 1] (bad_neighbors);
                    bad_neighbors[y] = cord;
                    y++;
                  end
                end
              end
            end
          end
        end
      end
      vals <= neighbors;
    end else begin
      init <= 1;
    end

    grid_display(vals);

  end
endmodule
