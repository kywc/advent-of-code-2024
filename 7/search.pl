:- module('main', [has_solutionl/2]).
?- [library(clpfd)].

has_solutionr([ N ] , A) :- N #= A.
has_solutionr([ N | M ] , A) :-
  N #> 0,
  A #> 0,
  (N + B #= A; N * B #= A),
	has_solutionr(M, B).
has_solutionl(L, A) :- reverse(L, R), has_solutionr(R, A).
