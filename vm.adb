with Ada.Text_IO;      use Ada.Text_IO;
with Ada.Command_Line; use Ada.Command_Line;
with Ada.Integer_Text_IO;

procedure VM is
   package IntIO renames Ada.Integer_Text_IO;
   type Code_Arr is array(0..255) of Integer;

   Program    : File_Type;
   Num, Mindex : Integer:= 0;
   Memory     : Code_Arr := (others => 0);

   procedure Mem(code: in out Code_Arr) is
    IP, NextIP : Integer:= 0;
    function Src return Integer is (code(IP));
    function Dest return Integer is (code(IP + 1));
    function Branch return Integer is (code(IP + 2));
    begin
        while IP >= 0 loop
            NextIP := NextIP+3;

            if src = -1 then
                declare 
                    Ch: Character;
                begin
                    Get(Ch);
                    code(Dest) := Character'Pos(Ch);
                end;

            elsif Dest = -1 then
            Put(Character'Val(Code(Src)));
            else
                code(Dest) := code(Dest) - code(Src);
                if code(Dest) <= 0 then
                    NextIP := Branch;
                end if;
            end if;

            IP := NextIP;
        end loop;
        exception when others => Put_Line("Mem program execution error.");
    end Mem;

begin
    if Argument_Count < 1 then
        Put_Line("VM Need atleast one argument.");
        Put_Line("Usage: ./VM <filename>");
    else
        Open(Program, In_File, Argument(1));

        while not End_Of_File(Program) loop
            IntIO.Get(Program, Num);
            Memory(Mindex) := Num;
            Mindex := Mindex + 1;
        end loop;              
        Close(Program);
        Mem(Memory);
    end if;
end VM;
