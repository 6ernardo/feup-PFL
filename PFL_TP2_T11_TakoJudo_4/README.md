# TakoJudo

## Game and Group Identification
The goal for this project was the implementation of the TakoJudo board game using Prolog. 

We are part of group TakoJudo_4, from class 8, Bernardo Ferreira Campos - up202006056 and José Manuel Henriques Valente Marques de Sousa - up202006141.

Both contributed 50% to the project.

## Installation and Execution

## Game Description
Tako Judo is a strategy game played with an 8x8 square board. Each player controls the head and 8 tentacles of an octopus. 

Each piece can move through its row, collumn and diagonals, without moving over other pieces, like a chess queen, the one condition being that to move a tentacle, there must be a clear line of sight from the original position to its respective head.

The objective of the game is to trap the opponent so they can no longer move their pieces, once this happens, the player that can still move wins the game. 

Site containing a description of the game: https://boardgamegeek.com/boardgame/29291/tako-judo

## Game Logic
### Internal representation of the state of the game
The board is represented by a list of functors. Each functor, a square, contains an index number, information on its position on the board, an index and a character. 'T' and 't' are used to represent tentacles, 'H' and 'h' are used to represent heads, and ' ' is used to represent empty spots on the board.
The pieces with capital letters belong to Player 1, the others belong to Player 2.

*Initial representation of the board:*

    board_list([square(1, 1, 8, ' '), square(2, 2, 8, ' '),
        square(3, 3, 8, ' '), square(4, 4, 8, 'h'), 
        square(5, 5, 8, 'h'), square(6, 6, 8, 't'), 
        square(7, 7, 8, ' '), square(8, 8, 8, ' '), 
        square(9, 1, 7, ' '), square(10, 2, 7, ' '),
        square(11, 3, 7, ' '), square(12, 4, 7, 'h'),
        square(13, 5, 7, 'h'), square(14, 6, 7, 't'), 
        square(15, 7, 7, ' '), square(16, 8, 7, ' '),
        square(17, 1, 6, ' '), square(18, 2, 6, ' '), 
        square(19, 3, 6, 't'), square(20, 4, 6, 't'), 
        square(21, 5, 6, 't'), square(22, 6, 6, 't'), 
        square(23, 7, 6, ' '), square(24, 8, 6, ' '),
        square(25, 1, 5, ' '), square(26, 2, 5, ' '), 
        square(27, 3, 5, ' '), square(28, 4, 5, ' '), 
        square(29, 5, 5, ' '), square(30, 6, 5, ' '), 
        square(31, 7, 5, ' '), square(32, 8, 5, ' '),
        square(33, 1, 4, ' '), square(34, 2, 4, ' '), 
        square(35, 3, 4, ' '), square(36, 4, 4, ' '), 
        square(37, 5, 4, ' '), square(38, 6, 4, ' '), 
        square(39, 7, 4, ' '), square(40, 8, 4, ' '),
        square(41, 1, 3, ' '), square(42, 2, 3, ' '), 
        square(43, 3, 3, 'T'), square(44, 4, 3, 'T'), 
        square(45, 5, 3, 'T'), square(46, 6, 3, 'T'), 
        square(47, 7, 3, ' '), square(48, 8, 3, ' '),
        square(49, 1, 2, ' '), square(50, 2, 2, ' '), 
        square(51, 3, 2, 'T'), square(52, 4, 2, 'H'), 
        square(53, 5, 2, 'H'), square(54, 6, 2, 'T'), 
        square(55, 7, 2, ' '), square(56, 8, 2, ' '),
        square(57, 1, 1, ' '), square(58, 2, 1, ' '), 
        square(59, 3, 1, 'T'), square(60, 4, 1, 'H'), 
        square(61, 5, 1, 'H'), square(62, 6, 1, 'T'), 
        square(63, 7, 1, ' '), square(64, 8, 1, ' ')]).


### Game State View

*In-Game represetation of the initial gamestate*

    | | |t|h|h|t| | |
    +---------------+
    | | |t|h|h|t| | |
    +---------------+
    | | |t|t|t|t| | |
    +---------------+
    | | | | | | | | |
    +---------------+
    | | | | | | | | |
    +---------------+
    | | |T|T|T|T| | |
    +---------------+
    | | |T|H|H|T| | |
    +---------------+
    | | |T|H|H|T| | |
    +---------------+

For this to be written, the `display_game(+Board)` function is called. This function will then call three auxiliary functions: `get_each_line(+Board, +Size, +Upline, +Downline)` that will group the squares in lines with *Size* length, `print_line(+Line)` that will print the line square by square, using the final auxiliary function `print_square(+Square)`.

The function `choose_piece_to_play(+Board, +Player)`, while responsible for the flow of the play, will also call the printing functions and asked for input of the player.


### Moves Execution

After asking the user for the coordinates of the piece they desire to move, the function `check_correct_player(+Board, +Char, +Player)` will be called to confirm if the selected piece does belong to the player. If not, the player will be prompted to select a piece again.
To select the head, the top left piece coordinate must be input.

Having the piece selected, the user will now be asked to insert the coordinates of the square they want to move the piece to. Here, depending on wether the user selected a Head or a Tentacle, either the `can_head_move(+CurrentSquare, +DestinationSquare, +Board, -Result)` or the `can_tentacle_move(+CurrentSquare, +DestinationSquare, +Board, -Result)`. The *Result* will be 1 if the piece can move, 0 if it can not.

These functions call a number of auxiliary functions, as you can see below:

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

    can_head_move_piece(square(I,X,Y,C), square(Idest, Xdest, Ydest, Cdest), Board, R):-
        is_square_free(Xdest, Ydest, Board, R1),
        get_row(square(I,X,Y,C), Board, Row), has_path(square(Idest, Xdest, Ydest, Cdest), Row, Ret1),
        get_collumn(square(I,X,Y,C), Board, Collumn), has_path(square(Idest, Xdest, Ydest, Cdest), Collumn, Ret2),
        get_left_diagonal(square(I,X,Y,C), Board, LD), has_path(square(Idest, Xdest, Ydest, Cdest), LD, Ret3),
        get_right_diagonal(square(I,X,Y,C), Board, RD), has_path(square(Idest, Xdest, Ydest, Cdest), RD, Ret4),
        pick_list(Ret1, Ret2, Ret3, Ret4, square(I,X,Y,C), Board, L, R2),
        is_path_clear(square(I,X,Y,C),square(Idest, Xdest, Ydest,Cdest), L, R3),
        can_head_move_aux1(R1,R2,R3, R).

For the Tentacle, these functions will check if the Tentacle is with line of sight of the head, if the destination square is empty, wether the destionation square is in the same line, row or diagonal of the Tentacle square, and if the path to that square is not blocked.

For the Head, each of the 4 pieces that are part of it will be tested. In the same fashion as the Tentacle, it will be checked if the destionation square is empty, if it shares a line, row, or diagonal with the piece, and if the path to the destination square is not blocked.

If the movement is allowed the changes will be made to the game state, otherwise the user will be prompted to select a piece and destination square again.

### List of Valid Moves
Using `valid_moves(+Board, +Player, -ListOfMoves)` and `check_available_moves(+Board, +Player, +PlayerSquares, +FreeSquares, -ListOfMoves)`, given each piece, it will be tested if a move every empty square is valid.

### End of Game
There are two functions responsible for the end of game. `check_game_over(+Board, +Player, -Lost)` will use an auxiliary function, `valid_moves(+Board, +Player, -ListOfMoves)` to check if any player still has any move. If one of them does not, the other will win. The function `game_over(+Board, +Winner)` is then used to print a message stating the winner.

### Board Evaluation
There are no functions performing board evaluation.

### Computer Move
Functions to allow for automatic interaction with the game were not written.

## Conclusion

This project allowed us to grasp the fundamentals of Prolog.
Due to the course's workload and time restrictions, we were not able to implement the following features: human-computer and computer-computer gameplay, restrictions on twiddling (moving the piece back and forth). 

We also believe that with more time we could have made the code more efficient and robust.

## Bibliography
Course's resources available on Moodle.

https://stackoverflow.com/

https://www.swi-prolog.org/