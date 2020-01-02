% CS 314 Fall 2019
% Programming Assignment V
% Due: December 11 at 11:00 PM
% Hand in by 3:00 AM, December 12
%
% Name: Allison Coopersmith
% NetID: aec138
%
:- use_module(library(clpfd)).
:- use_module(library(dif)).

% Part I: Binary trees
% --------------------

% We re-use the definition of binary tree used in problem set 8:

tree(tip).
tree(bin(L,_,R)) :- tree(L), tree(R).

% (Note that it is not generally necessary to use tree/1 to require an argument
% to be a tree.)


% height(+Tree, -Int) is deterministic
% height(+Tree, +Int) is semi-deterministic
%
% The height of a tree is number of nodes in the longest path from the root to
% a leaf in the tree.
%
% ?- height(tip, N).
% N = 0.
%
% ?- height(bin(tip, 5, bin(tip, x, tip)), N).
% N = 2.
%
% ?- height(bin(bin(bin(tip, x, tip), a, tip), 15, bin(tip, x, tip)), N).
% N = 3.
%
% ?- height(bin(1,2,3), N).
% false.
% (Because it isn't a tree.)


height(tip, 0).
height(bin(L,_,R), Height) :-
    height(L, LeftHeight),
    height(R, RightHeight),
    (LeftHeight >= RightHeight ->
    Height is LeftHeight + 1;
   Height is RightHeight + 1 ), !.
height(_,_) :- false.



% bst(++TreeOfInts) is semi-deterministic
%
% bst/1 holds for binary trees containing integers, where each node bin(L,X,R)
% has the property that every node in L is at most X and every node in R is at
% least X. Note that bst/1 is not required to succeed for partially instantiated
% arguments.
%
% ?- bst(tip).
% true.
%
% ?- bst(bin(tip, 3, bin(tip, 4, tip))).
% true.
%
% ?- bst(bin(tip, 3, bin(tip, 2, tip))).
% false.

check(null, X) :-
    !.
check(X, null) :-
    !.
check(X, Y) :-
    X < Y.

bst(Tree) :-
  bst(Tree, null, null).

bst(tip, _, _).
bst(bin(L, V1, R), V0, V2) :-
      check(V0, V1),
      check(V1, V2),
      bst(L, V0, V1),
      bst(R, V1, V2).



% Part II: Lists
% --------------

% zip(?List, ?List, ?ListOfPairs)
% zip(+List, +List, -List) is deterministic
% zip(-List, -List, ++List) is non-deterministic
%
% zip/3 relates three lists, where the third list contains pairs whose elements
% are the elements at the same indices of the first two lists. We will use -/2
% to represent pairs.
%
% The third list will always be as long as the shorter of the first two lists;
% additional elements in the longer list are discarded.
%
% ?- zip([1,2],[a,b],Z).
% Z = [1-a, 2-b].
%
% ?- zip([a,b,c,d], [1,X,y], Z).
% Z = [a-1, b-X, c-y] .
%
% ?- length(A,2), length(B,2), zip(A, B, [1-a, 2-b]).
% A = [1,2],
% B = [a,b] .

zip([], [], C) :- C = [].
zip([], _, C) :- C = [].
zip(_, [], C) :- C = [].
zip([A | AX], [B | BY], C) :- zip(AX, BY, D), append([A-B], D, C), !.

% sorted(++ListOfInts) is semi-deterministic
%
% sorted/1 holds for lists of zero or more integers in ascending order.
%
% ?- sorted([1,2,3]).
% true.
%
% ?- sorted([]).
% true.
%
% ?- sorted([1,2,3,2]).
% false.

sorted( []      ) .
sorted( [_]     ) .
sorted( [X,Y|Z] ) :- X < Y , sorted( [Y|Z] ), !.




% insert(+Int, ++SortedList, ?SortedListWithItem) is semi-deterministic
%
% insert/3 is a relation between an integer, a sorted list of integers, and a
% second sorted list of integers that contains the first argument and all the
% elements of the second argument.
%
% ?- insert(3, [2,4,5], L).
% L = [2,3,4,5].
%
% ?- insert(3, [1,2,3], L).
% L = [1,2,3,3].
%
% ?- insert(3, [1,2,4], [1,2,3]).
% false.
%
%
% For full credit, insert/3 should also be able to remove an element from a
% list. That is, it should also work in this mode:
%
% insert(+Int, ?SortedList, ++SortedListWithItem) is semi-deterministic
%
% ?- insert(3, L, [2,3,4,5]).
% L = [2,4,5].
%
% ?- insert(3, L, [1,4,9]).
% false.
%
% The behavior of insert/3 when given a non-sorted list is undetermined.

insert(N, [], L) :- L = [N].
insert(N, [S | SX], L) :- S #>= N, L = [N, S | SX].
insert(N, [S | SX], L) :- L = [S | T], insert(N, SX, T), !.

bonus(height).
