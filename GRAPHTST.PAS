progrAM graph_test;
uses graph;
var
graphmode:integer;
graphdriver:integer;

begin
graphdriver := detect;
initgraph(graphdriver,graphmode,'A:cgadrvr');
line(10,10,200,200);
closegraph;
end.