-module(counter).
-export([run/0, counter/1]).

run() ->
    S = spawn(counter, counter, [0]),
    send_msgs(S, 100000),
    S ! value.

counter(Sum) ->
%    io:fwrite("Sum is ~w~n",[Sum]),
    receive
        value -> io:fwrite("Value is ~w~n", [Sum]);
        {inc, Amount} -> counter(Sum+Amount)
    end.

send_msgs(_, 0) -> true;
send_msgs(S, Count) ->
    io:fwrite("Count is ~w~n",[Count]),
    S ! {inc, 1},
    send_msgs(S, Count-1).

% Usage:
%    1> c(counter).
%    2> S = counter:run().
%       ... Wait a bit until all children have run ...
%    3> S ! value.
%    Value is 100000
