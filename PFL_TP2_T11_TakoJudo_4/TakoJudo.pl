:-use_module(library(lists)).

%Main game function
play:- P is 1, show_tutorial, board_list(Board), choose_piece_to_play(Board, P).

%Internal representation of the board
board_list([square(1, 1, 8, ' '), square(2, 2, 8, ' '), square(3, 3, 8, 't'), square(4, 4, 8, 'h'), square(5, 5, 8, 'h'), square(6, 6, 8, 't'), square(7, 7, 8, ' '), square(8, 8, 8, ' '),
    square(9, 1, 7, ' '), square(10, 2, 7, ' '), square(11, 3, 7, 't'), square(12, 4, 7, 'h'), square(13, 5, 7, 'h'), square(14, 6, 7, 't'), square(15, 7, 7, ' '), square(16, 8, 7, ' '),
    square(17, 1, 6, ' '), square(18, 2, 6, ' '), square(19, 3, 6, 't'), square(20, 4, 6, 't'), square(21, 5, 6, 't'), square(22, 6, 6, 't'), square(23, 7, 6, ' '), square(24, 8, 6, ' '),
    square(25, 1, 5, ' '), square(26, 2, 5, ' '), square(27, 3, 5, ' '), square(28, 4, 5, ' '), square(29, 5, 5, ' '), square(30, 6, 5, ' '), square(31, 7, 5, ' '), square(32, 8, 5, ' '),
    square(33, 1, 4, ' '), square(34, 2, 4, ' '), square(35, 3, 4, ' '), square(36, 4, 4, ' '), square(37, 5, 4, ' '), square(38, 6, 4, ' '), square(39, 7, 4, ' '), square(40, 8, 4, ' '),
    square(41, 1, 3, ' '), square(42, 2, 3, ' '), square(43, 3, 3, 'T'), square(44, 4, 3, 'T'), square(45, 5, 3, 'T'), square(46, 6, 3, 'T'), square(47, 7, 3, ' '), square(48, 8, 3, ' '),
    square(49, 1, 2, ' '), square(50, 2, 2, ' '), square(51, 3, 2, 'T'), square(52, 4, 2, 'H'), square(53, 5, 2, 'H'), square(54, 6, 2, 'T'), square(55, 7, 2, ' '), square(56, 8, 2, ' '),
    square(57, 1, 1, ' '), square(58, 2, 1, ' '), square(59, 3, 1, 'T'), square(60, 4, 1, 'H'), square(61, 5, 1, 'H'), square(62, 6, 1, 'T'), square(63, 7, 1, ' '), square(64, 8, 1, ' ')]).

%Receives a square as an argument, prints its char
print_square(square(_,_,_,C)):- write(C).

%display_game auxiliar function; groups the squares in 8's so that the printing resembles a board
get_each_line([], _, [], []).
get_each_line(R, 0, [], R).
get_each_line([F|R], N, [F|UpLine], DownLine):-
            No is N-1,
            get_each_line(R, No, UpLine, DownLine).

%Resposible for printing and displaying the current game state after every move
display_game([]):- nl.
display_game([F|R]):- 
    get_each_line([F|R], 8, UpLine, DownLine),
    print_line(UpLine), 
    write('+---------------+'), nl,
    display_game(DownLine).

%Prints a single line of the board
print_line([]):- write('|'), nl.
print_line([F|R]):-write('|'), /*write(F)*/print_square(F), print_line(R).


%Receives de x and y coordinates of a square and the board, and searches it until it finds the square with those same coordinates, returning it uppon success
get_square_by_coordinates(_, _, [], []).
get_square_by_coordinates(X, Y, [square(I,X,Y,C)|_], square(I,X,Y,C)).
get_square_by_coordinates(X, Y, [square(_,_,_,_)|R], Square):-
            get_square_by_coordinates(X, Y, R, Square).

%Converts certain characters to integers
char_to_int('1', 1).
char_to_int('2', 2).
char_to_int('3', 3).
char_to_int('4', 4).
char_to_int('5', 5).
char_to_int('6', 6).
char_to_int('7', 7).
char_to_int('8', 8).
char_to_int('t', 10).
char_to_int('T', 11).
char_to_int('h', 12).
char_to_int('H', 13).




%Responsible for the main game loop. Receives the players' inputs, checks if the moves are valid and before proceding with the next play, confirms if the last player made a decisive game winning move
choose_piece_to_play(Board,P):- 
    display_game(Board),
    write('Which square do you wish to move?'), nl,
    write('type x coord: '), get_char(X), skip_line, nl,
    write('type y coord: '), get_char(Y), skip_line, nl,
    char_to_int(X, Xc), char_to_int(Y, Yc),
    get_square_by_coordinates(Xc, Yc, Board, CurrentSquare),
    get_square_char(CurrentSquare, C),
    check_correct_player(Board, C, P),
    (C = 12-> delete_head(Xc, Yc, Board, UpdatedBoard);
    (C = 13 -> delete_head(Xc, Yc, Board, UpdatedBoard);
    make_move(CurrentSquare,' ', Board, UpdatedBoard);nl)),
    write('To which square do you wish to move?'), nl,
    write('type x coord: '), get_char(Xi), skip_line, nl,
    write('type y coord: '), get_char(Yi), skip_line, nl,
    char_to_int(Xi, Xd), char_to_int(Yi, Yd),
    get_square_by_coordinates(Xd, Yd, UpdatedBoard, DestSquare),
    get_player_head(P, HeadChar),
    (C = 12 ->
    can_head_move(CurrentSquare, DestSquare, UpdatedBoard, R),
    failed_move(Board, P, R),
    move_head2(Xd, Yd, UpdatedBoard,FinalBoard);
    (C = 13 -> 
    can_head_move(CurrentSquare, DestSquare, UpdatedBoard, R),
    failed_move(Board, P, R),
    move_head1(Xd, Yd, UpdatedBoard,FinalBoard);
    (C = 10 ->
    can_tentacle_move(CurrentSquare, DestSquare, UpdatedBoard, 'h', R),
    failed_move(Board, P, R),
    move_tentacle2(DestSquare, UpdatedBoard, FinalBoard);
    (C = 11 ->
    print_square(CurrentSquare), nl, print_square(DestSquare), nl, nl,
    can_tentacle_move(CurrentSquare, DestSquare, UpdatedBoard, 'H', R), nl,
    failed_move(Board, P, R), write('chegou aqui'), nl,
    move_tentacle1(DestSquare, UpdatedBoard, FinalBoard); nl
    )
    )
    )
    ),
    check_game_over(FinalBoard, P, Lost),
    switch_turn(P, Pf),
    Lost = 1 -> game_over(FinalBoard, P);nl,
    choose_piece_to_play(FinalBoard, Pf).

%Prints text in case the move is not valid
failed_move(B, P, R):- R = 0 -> 
    write('That move is not valid, please repeat'), nl,  choose_piece_to_play(B, P); nl.



%Fills the current head position with blank spots
delete_head(X,Y,Board, Board4):-
    Xr is X+1, Yr is Y,
    Xrd is X+1, Yrd is Y-1,
    Xd is X, Yd is Y-1,
    get_square_by_coordinates(X, Y, Board, DestSquare),
    get_square_by_coordinates(Xr, Yr, Board, RightDestSquare),
    get_square_by_coordinates(Xrd, Yrd, Board, RightDownDestSquare),
    get_square_by_coordinates(Xd, Yd, Board, DownDestSquare),
    make_move(DestSquare, ' ', Board, Board1),
    make_move(RightDestSquare, ' ', Board1, Board2),
    make_move(RightDownDestSquare, ' ', Board2, Board3),
    make_move(DownDestSquare, ' ', Board3, Board4).


%Moves a tentacle from player 1 
move_tentacle1(DestSquare, UpdatedBoard, FinalBoard):- make_move(DestSquare, 'T', UpdatedBoard, FinalBoard).

%Moves a tentacle from player 2
move_tentacle2(DestSquare, UpdatedBoard, FinalBoard):- make_move(DestSquare, 't', UpdatedBoard, FinalBoard).

%Moves the head from the player 1
move_head1(X,Y,Board, Board4):-
    Xr is X+1, Yr is Y,
    Xrd is X+1, Yrd is Y-1,
    Xd is X, Yd is Y-1,
    get_square_by_coordinates(X, Y, Board, DestSquare),
    get_square_by_coordinates(Xr, Yr, Board, RightDestSquare),
    get_square_by_coordinates(Xrd, Yrd, Board, RightDownDestSquare),
    get_square_by_coordinates(Xd, Yd, Board, DownDestSquare),
    make_move(DestSquare, 'H', Board, Board1),
    make_move(RightDestSquare, 'H', Board1, Board2),
    make_move(RightDownDestSquare, 'H', Board2, Board3),
    make_move(DownDestSquare, 'H', Board3, Board4),
    %equal_board(Board, Board4),
    display_game(Board4).

%Moves the head from the player 2
move_head2(X,Y,Board, Board4):-
    Xr is X+1, Yr is Y,
    Xrd is X+1, Yrd is Y-1,
    Xd is X, Yd is Y-1,
    get_square_by_coordinates(X, Y, Board, DestSquare),
    get_square_by_coordinates(Xr, Yr, Board, RightDestSquare),
    get_square_by_coordinates(Xrd, Yrd, Board, RightDownDestSquare),
    get_square_by_coordinates(Xd, Yd, Board, DownDestSquare),
    make_move(DestSquare, 'h', Board, Board1),
    make_move(RightDestSquare, 'h', Board1, Board2),
    make_move(RightDownDestSquare, 'h', Board2, Board3),
    make_move(DownDestSquare, 'h', Board3, Board4),
    %equal_board(Board, Board4),
    display_game(Board4).

%Returns the char of a Square
get_square_char(square(_,_,_,C),C1):- char_to_int(C,C1).


%Makes a move to the chosen square
make_move(square(I, X, Y, _), DestChar, Board, UpdatedBoard):-
            BoardId is I-1,
            get_each_line(Board, BoardId, UpLine, [_|DownLine]),
            append(UpLine, [square(I, X, Y, DestChar)|DownLine], UpdatedBoard).

%Return the head character depending on the player
get_player_head(P, HeadChar):- P = 1 -> C = 'H'; C='h'.

%is_square_free(X,Y,Board, Return)
is_square_free(X,Y,Board,1):-get_square_by_coordinates(X,Y,Board,square(_,_,_,C)), C=' '.
is_square_free(X,Y,Board,0):-get_square_by_coordinates(X,Y,Board,square(_,_,_,C)), C\=' '.

%get_row(square,Board,ListRet) - Returns row for a given square
get_row(_,[],[]).
get_row(square(I1,_,Y,_),[square(I2,_,Y,Char)|R],[square(I2,_,Y,Char)|R1]) :- get_row(square(I1,_,Y,_),R,R1).
get_row(square(I1,_,Y,_),[square(_,_,_,_)|R],R1) :- get_row(square(I1,_,Y,_),R,R1).

%get_collumn(square,Board,ListRet) - Returns collumn for a given square
get_collumn(_,[],[]).
get_collumn(square(I1,X,_,_),[square(I2,X,_,Char)|R],[square(I2,X,_,Char)|R1]) :- get_collumn(square(I1,X,_,_),R,R1).
get_collumn(square(I1,X,_,_),[square(_,_,_,_)|R],R1) :- get_collumn(square(I1,X,_,_),R,R1).

%get_left_diagonal(square,Board,ListRet) - Returns left diagonal for a given square
get_left_diagonal(square(_,X,Y,_), Board, List):-include(is_left_diag(X,Y),Board,List).

%For two given squares, checks if they are left diagonally to each other
is_left_diag(X,Y,square(_,Xd,Yd,_)):- X+Y=:=Xd+Yd.

%get_rigth_diagonal(square,Board,ListRet) - Returns rigth diagonal for a given square
get_right_diagonal(square(_,X,Y,_), Board, List):-include(is_right_diag(X,Y),Board, List).

%For two given squares, checks if they are right diagonally to each other
is_right_diag(X,Y, square(_,Xd,Yd,_)):- X-Y=:=Xd-Yd.

%verifica se o caminho entre os squares está livre, list corresponde a linha, coluna ou diagonal a que pertencem ambos
is_path_clear(square(I,_,_,_), square(I1,_,_,_),List,Ret) :-
    include(index_between(I,I1), List, List1),
    is_path_clear_aux(List1, Ret).

is_path_clear_aux([],1).
is_path_clear_aux([square(_,_,_,' ')|R],Ret):-is_path_clear_aux(R, Ret).
is_path_clear_aux([square(_,_,_,_)|_],0).

%For three given index, checks if the last one, I2 is between I and I1
index_between(I,I1,square(I2,_,_,_)):- (I<I2, I2<I1) ; (I>I2, I2>I1).

%verifies if the given tentacle is within sight of any head
tentacle_linesight(square(I,X,Y,C), Board, Char, R):-
    (get_row(square(I,X,Y,C),Board, Row), search_for_head(square(I,_,_,_), Row, Row, Char, Ret)),
    (get_collumn(square(I,X,Y,C),Board, Collumn), search_for_head(square(I,_,_,_), Collumn, Collumn, Char, Ret1)),
    (get_left_diagonal(square(I,X,Y,C),Board, LD), search_for_head(square(I,_,_,_), LD, LD, Char, Ret2)),
    (get_right_diagonal(square(I,X,Y,C),Board, RD), search_for_head(square(I,_,_,_), RD, RD, Char, Ret3)),
    tentacle_linesight_aux(Ret, Ret1, Ret2, Ret3, R).

tentacle_linesight_aux(0,0,0,0,0).
tentacle_linesight_aux(_,_,_,_,1).

%search for heads in given list, check if there is a clear path to any
search_for_head(square(I,_,_,_),[square(I1,_,_,Char)|R], List, Char, 1):- is_path_clear(square(I,_,_,_), square(I1,_,_,_),List, 1).
search_for_head(square(I,_,_,_),[square(I1,_,_,Char)|R], List, Char, Ret):- is_path_clear(square(I,_,_,_), square(I1,_,_,_),List, 0), search_for_head(square(I,_,_,_),R,List,Char, Ret).
search_for_head(square(I,_,_,_),[square(_,_,_,_)|R], List, Char, Ret):-search_for_head(square(I,_,_,_),R, List, Char, Ret).
search_for_head(_,[],_,_,0).

%receives row,line,diag, checks if square is part of it
has_path(square(Id,Xd,Yd,Cd),[square(Id,_,_,_)|_],1).
has_path(square(Id,Xd,Yd,Cd),[square(_,_,_,_)|T],R):-has_path(square(Id,Xd,Yd,Cd),T,R).
has_path(_,[],0).

%Verifies if a certain tentacle can move to the chosen destination
can_tentacle_move(square(I,X,Y,_),square(Id, Xd, Yd,_), Board, Char, R):-
    write(I), nl, write(Id), nl,
    tentacle_linesight(square(I,X,Y,_), Board, Char, R1),
    is_square_free(Xd,Yd, Board, R2),
    get_row(square(I,X,Y,_), Board, Row), has_path(square(Id, Xd, Yd,_), Row, Ret1),
    get_collumn(square(I,X,Y,_), Board, Collumn), has_path(square(Id, Xd, Yd,_), Collumn, Ret2),
    get_left_diagonal(square(I,X,Y,_), Board, LD), has_path(square(Id, Xd, Yd,_), LD, Ret3),
    get_right_diagonal(square(I,X,Y,_), Board, RD), has_path(square(Id, Xd, Yd,_), RD, Ret4),
    pick_list(Ret1, Ret2, Ret3, Ret4, square(I,X,Y,_), Board, L, R3),
    is_path_clear(square(I,X,Y,_),square(Id, Xd, Yd,_), L, R4),
    can_tentacle_move_aux(R1,R2,R3,R4,R), nl.


pick_list(1,_,_,_,square(I,X,Y,C),Board,L,1):-get_row(square(I,X,Y,C), Board, L).
pick_list(_,1,_,_,square(I,X,Y,C),Board,L,1):-get_collumn(square(I,X,Y,C), Board, L).
pick_list(_,_,1,_,square(I,X,Y,C),Board,L,1):-get_left_diagonal(square(I,X,Y,C), Board, L).
pick_list(_,_,_,1,square(I,X,Y,C),Board,L,1):-get_right_diagonal(square(I,X,Y,C), Board, L).
pick_list(0,0,0,0,square(I,X,Y,C),Board,L,0).

can_tentacle_move_aux(1,1,1,1,1).
can_tentacle_move_aux(_,_,_,_,0).

%Verifies if a certain head can move to the chosen destination
can_head_move(square(I,X,Y,C), square(Idest, Xdest, Ydest, Cdest), Board, R):-
    Xr is X+1, Yr is Y, Ir is I+1,
    Xrd is X+1, Yrd is Y-1, Ird is I+9,
    Xd is X, Yd is Y-1, Id is I+8,
    Xr_dest is Xdest+1, Yr_dest is Ydest, Ir_dest is Idest+1,
    Xrd_dest is Xdest+1, Yrd_dest is Ydest-1, Ird_dest is Idest+9,
    Xd_dest is Xdest, Yd_dest is Ydest-1, Id_des is Idest+8,
    can_head_move_piece(square(I,X,Y,C), square(Idest, Xdest, Ydest, Cdest), Board, R1),
    can_head_move_piece(square(Ir,Xr,Yr,C), square(Ir_dest, Xr_dest, Yr_dest, Cdest), Board, R2),
    can_head_move_piece(square(Ird,Xrd,Yrd,C), square(Ird_dest, Xrd_dest, Yrd_dest, Cdest), Board, R3),
    can_head_move_piece(square(Id,Xd,Yd,C), square(Id_des, Xd_dest, Yd_dest, Cdest), Board, R4),
    can_head_move_aux(R1,R2,R3,R4,R).

%Verifies if each square of a head can move to the chosen destination
can_head_move_piece(square(I,X,Y,C), square(Idest, Xdest, Ydest, Cdest), Board, R):-
    is_square_free(Xdest, Ydest, Board, R1),
    get_row(square(I,X,Y,C), Board, Row), has_path(square(Idest, Xdest, Ydest, Cdest), Row, Ret1),
    get_collumn(square(I,X,Y,C), Board, Collumn), has_path(square(Idest, Xdest, Ydest, Cdest), Collumn, Ret2),
    get_left_diagonal(square(I,X,Y,C), Board, LD), has_path(square(Idest, Xdest, Ydest, Cdest), LD, Ret3),
    get_right_diagonal(square(I,X,Y,C), Board, RD), has_path(square(Idest, Xdest, Ydest, Cdest), RD, Ret4),
    pick_list(Ret1, Ret2, Ret3, Ret4, square(I,X,Y,C), Board, L, R2),
    is_path_clear(square(I,X,Y,C),square(Idest, Xdest, Ydest,Cdest), L, R3),
    can_head_move_aux1(R1,R2,R3, R).

can_head_move_aux(1,1,1,1,1).
can_head_move_aux(_,_,_,_,0).

can_head_move_aux1(1,1,1,1).
can_head_move_aux1(_,_,_,0).

%Returns the player who owns the square with the given char
player_ownership(10, 2).
player_ownership(11, 1).
player_ownership(12, 2).
player_ownership(13, 1).


%Checks if the piece chosen by a player belongs to him
check_correct_player(Board, Ci, P):- 
    player_ownership(Ci, Pi),
    P \= Pi -> (write('That piece does not belong to you, try again'), nl, choose_piece_to_play(Board, P)
    %mandar para repetir a jogada
    );
    nl.
switch_turn(1,2).
switch_turn(2,1).

%Returns a list with the squares that belong to the given player
get_owned_squares(_,[],[]).
get_owned_squares(Looser, [square(I,X,Y,C)|R], [square(I,X,Y,C)|Sqs]):- 
    get_owned_squares(Looser, R, Sqs).
get_owned_squares(Looser, [square(_,_,_,_)|R], Sq):-
    get_owned_squares(Looser, R, Sq).



%Checks if a list is empty
check_if_list_empty([_|_], 0).
check_if_list_empty([[]], 1).
check_if_list_empty([[]|R], Res):-
        check_if_list_empty(R, Res).


%Checks if the game ended
check_game_over(Board, Player, Lost):- 
    Player = 2 -> valid_moves(Board, 2, ListOfMoves); valid_moves(Board, 1, ListOfMoves),
    check_if_list_empty(ListOfMoves, Lost).

%Return in ListOfMoves the valid moves depending on the current board the player selected
valid_moves(Board, Player, ListOfMoves):-
            get_owned_squares(Player, Board, PlayerSquares),
            get_owned_squares(0, Board, FreeSquares),
            check_available_moves(Board, Player, PlayerSquares, FreeSquares, ListOfMoves).

%check_available_moves, check_square_availability, check_square_availability_aux, test_all_moves
%Resposible for checking for each square belonging to a player, given the current free squares on the board, if any movement is possible to be made
%

check_available_moves([], _, _, _, []).
check_available_moves(Board, Player, [PSq|PSqs], FreeSquares, [Mov|Movs]):-
            check_square_availability(Board, Player, PSq, FreeSquares, RList),
            exclude(empty, RList, Mov),
            check_available_moves(Board, Player, PSqs, FreeSquares, Movs).

check_square_availability(_, [], _, _, _).
check_square_availability(Board, Player, CurrentSquare, [FSq|FSqs], [Mov|Movs]):-
            check_square_availability_aux(Board, Player, CurrentSquare, FSq,  Mov),
            check_square_availability(Board, Player, CurrentSquare, FSqs, Movs).

check_square_availability_aux(Board, Player, CurrentSquare, DestSquare, Result):-
            test_all_moves(CurrentSquare, DestSquare, Board, Player, R),
            valid_move_found(R, Square-DestSquare, Result).

test_all_moves(CurrentSquare, DestSquare, Board, Player, R):-
    get_square_char(CurrentSquare, C),
    C = 12 -> can_head_move(CurrentSquare, DestSquare, Board, R);
    (C = 13 -> can_head_move(CurrentSquare, DestSquare, Board, R);
    (P = 2 -> can_tentacle_move(CurrentSquare, DestSquare, Board, 'h', R);
    can_tentacle_move(CurrentSquare, DestSquare, Board, 'H', R);nl)).  

valid_move_found(R, DestSquare, DestSquare).
valid_move_found(0, _, []).

% Prints a message announcing the winner of the game
game_over(Board, Winner):- 
    write('Game over! Player '), write(Winner), write('has won!'), nl.
  




%Prints the game tutorial
show_tutorial:- write('Welcome to TakoJudo!'), nl,
                write('If you are unfamiliar with the game, TakoJudo is a board game with very simple rules!'),nl,
                write('The objective of the game is to immobilize your opponent\'s octopus, which has 8 tentacles.'),nl,
                write('The tentacles are mobile only when they have a clear line of sight back to their octopus head.'),nl,
                write('Everything, including the octopus head, moves like a chess queen'),nl,
                write('The game ends once a player is able to immobilize the opponent\'s octopus, as well as all of their tentacles'),nl,
                write('We wish you a great experience!'),nl,
                write('Hope you enjoy and good luck!'),nl,nl,
                write('Additional notes: '),nl,
                write('When you wish to move your octopus head, always choose the right up corner of the piece!'),nl,nl.



/*
teste:-board_list(X), get_right_diagonal(square(43, 3, 3, 'T'),X,L), is_path_clear(square(43, 3, 3, 'T'), square(15, 7, 7, ' '), L, R), write(R).
teste1:-board_list(X), get_collumn(square(44, 4, 3, 'T'),X,L), search_for_head('H', L, I), write(I).
teste2:-board_list(X), tentacle_linesight(square(19, 3, 6, 't'),X,'h',R),nl,nl,nl, write(R).
teste10:-board_list(X), can_tentacle_move(square(43, 3, 3, 'T'),square(35, 3, 4, ' '), X, 'H', R),nl,nl, write(R).
teste3:-board_list(X), can_tentacle_move(square(19, 3, 6, 't'),square(33, 1, 4, _), X, 'h', R),nl,nl, write(R).
teste4:-board_list(X), tentacle_linesight(square(19, 3, 6, 't'), X, 'h', R), write(R).
teste5:-board_list(X), is_square_free(1,4,X,R), write(R).
teste6:-board_list(Board),
    get_row(square(19, 3, 6, 't'), Board, Row), has_path(square(33, 1, 4, ' '), Row, Ret1), write(Ret1),nl,
    get_collumn(square(19, 3, 6, 't'), Board, Collumn), has_path(square(33, 1, 4, ' '), Collumn, Ret2),write(Ret2),nl,
    get_left_diagonal(square(19, 3, 6, 't'), Board, LD), has_path(square(33, 1, 4, ' '), LD, Ret3),write(Ret3),nl,
    get_right_diagonal(square(19, 3, 6, 't'), Board, RD), has_path(square(33, 1, 4, ' '), RD, Ret4), write(Ret4),nl,
    pick_list(Ret1, Ret2, Ret3, Ret4, square(19, 3, 6, 't'), Board, L, R3), write(R3),nl,
    is_path_clear(square(19, 3, 6, 't'),square(33, 1, 4, ' '), L, R4),write('ispathclear '), write(R4).

teste7:-board_list(X), can_head_move(square(4, 4, 8, 'h'), square(1, 1, 8, ' '),X,R), write(R).
teste8:-board_list(X), get_row(square(13, 5, 7, 'h'), X, Row), has_path(square(10, 2, 7, _), Row, Ret1), write(Ret1).
*/