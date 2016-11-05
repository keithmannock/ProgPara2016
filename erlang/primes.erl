-module(primes).
-export([primes/1,check/3,limit/1]).
-import(ts,[in/2,out/2,new/0]). 
-import(math,[sqrt/1]).


% Utilities
limit(N) -> trunc(math:sqrt(N)).

%prime_atom(C) -> [S|_] = io_lib:fwrite("~w",[C]),
%                 list_to_atom(lists:append(atom_to_list(prime),S)).



primes(N) -> % compute the first N primes, starting with 2.
     TS = new(),                 
     No_of_Workers = 5,          % let's not kill the machine!
     initialise(TS),             
     start_workers(No_of_Workers,N,TS),
     io:fwrite("~w~n",[2]), 
     printResults(N-1,3,TS).

initialise(TS) -> ts:out(TS,{nextCandidate,3}).

start_workers(0,_,_) -> ok;
start_workers(K,N,TS) ->
  spawn(fun () -> worker(N,TS) end),
  start_workers(K-1,N,TS).

worker(N,TS) -> 
  {nextCandidate,C} = ts:in(TS,{nextCandidate,any}),
  ts:out(TS,{nextCandidate,C+2}),
  ts:out(TS,{C,isPrime(C)}),
  worker(N,TS).
  

printResults(0,_,_) -> ok;
printResults(N,C,TS) ->
   {_,B} = ts:in(TS,{C,any}), 
   case B of
     true ->  io:fwrite("~w~n",[C]),
              printResults(N-1,C+2,TS);
     false -> printResults(N,C+2,TS)
   end.

isPrime(C) -> check(C,2,limit(C)).

check(_,D,L) when L < D -> true;
check(C,D,L) when L >= D -> case (C rem D) > 0 of
                              true -> check(C,D+1,L);
                              false -> false
                            end.
 
