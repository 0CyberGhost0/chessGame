import 'package:chess/components/ChessPiece.dart';
import 'package:chess/components/square.dart';
import 'package:chess/values.dart';
import 'package:flutter/material.dart';

import 'helper/helper_methods.dart';

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  late List<List<ChessPiece?>> board;
  ChessPiece myPawn = ChessPiece(
      imagePath: 'lib/chess_images/pawn.png',
      isWhite: false,
      type: ChessPieceType.pawn);
  @override
  void initState() {
    _initializeBoard();
    super.initState();
  }

  ChessPiece? selectedPiece;

  int selectedRow = -1;
  int selectedCol = -1;
  List<List<int>> validMoves = [];
  void pieceSelected(int row, int col) {
    setState(() {
      if (board[row][col] != null) {
        selectedPiece = board[row][col];
        selectedCol = col;
        selectedRow = row;
      }
      validMoves = calculateValidMoves(selectedRow, selectedCol, selectedPiece);
    });
  }

  List<List<int>> calculateValidMoves(int row, int col, ChessPiece? piece) {
    List<List<int>> candidateMoves = [];
    int direction = piece!.isWhite ? -1 : 1;
    switch (piece?.type) {
      case ChessPieceType.pawn:
        //Move one ahead
        if (isValidMove(row + direction, col) &&
            board[row + direction][col] == null) {
          candidateMoves.add([row + direction, col]);
        }
        //Move two ahead
        if (row == 1 && !piece.isWhite || (row == 6 && piece.isWhite)) {
          if (isValidMove(row + 2 * direction, col) &&
              board[row + 2 * direction][col] == null &&
              board[row + direction][col] == null) {
            candidateMoves.add([row + 2 * direction, col]);
          }
        }
        //Move Diagonal
        if (isValidMove(row + direction, col - 1) &&
            board[row + direction][col - 1] != null) {
          candidateMoves.add([row + direction, col - 1]);
        }
        if (isValidMove(row + direction, col + 1) &&
            board[row + direction][col + 1] != null) {
          candidateMoves.add([row + direction, col + 1]);
        }
        break;
      case ChessPieceType.rook:
        var directions = [
          [0, -1],
          [-1, 0],
          [1, 0],
          [0, 1]
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + i * direction[0];
            var newCol = col + i * direction[1];
            if (!isValidMove(newRow, newCol)) break;
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.knight:
        var directions = [
          [2, 1],
          [1, 2],
          [-1, -2],
          [-2, -1],
          [-1, 2],
          [-2, 1],
          [1, -2],
          [2, -1]
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isValidMove(newRow, newCol)) continue;
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            continue;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      case ChessPieceType.bishop:
        var directions = [
          [-1, -1],
          [1, 1],
          [-1, 1],
          [1, -1]
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + direction[0] * i;
            var newCol = col + direction[1] + i;
            if (!isValidMove(newRow, newCol)) break;
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
            i++;
          }
        }
        break;
      case ChessPieceType.queen:
        var directions = [
          [-1, 0],
          [0, 1],
          [1, 0],
          [0, -1],
          [-1, -1],
          [-1, 1],
          [1, 1],
          [-1, -1]
        ];
        for (var direction in directions) {
          var i = 1;
          while (true) {
            var newRow = row + direction[0] * i;
            var newCol = col + direction[1] * i;
            if (!isValidMove(newRow, newCol)) break;
            if (board[newRow][newCol] != null) {
              if (board[newRow][newCol]!.isWhite != piece.isWhite) {
                candidateMoves.add([newRow, newCol]);
              }
              break;
            }
            candidateMoves.add([newRow, newCol]);
          }
        }
        break;
      case ChessPieceType.king:
        var directions = [
          [-1, -1],
          [-1, 1],
          [1, 1],
          [-1, -1]
        ];
        for (var direction in directions) {
          var newRow = row + direction[0];
          var newCol = col + direction[1];
          if (!isValidMove(newRow, newCol)) break;
          if (board[newRow][newCol] != null) {
            if (board[newRow][newCol]!.isWhite != piece.isWhite) {
              candidateMoves.add([newRow, newCol]);
            }
            break;
          }
          candidateMoves.add([newRow, newCol]);
        }
        break;
      default:
        break;
    }
    return candidateMoves;
  }

  @override
  void _initializeBoard() {
    List<List<ChessPiece?>> newBoard =
        List.generate(8, (index) => List.generate(8, (index) => null));
    //Place Pawn
    for (int i = 0; i < 8; i++) {
      newBoard[1][i] = ChessPiece(
          imagePath: 'lib/chess_images/pawn.png',
          isWhite: false,
          type: ChessPieceType.pawn);
      newBoard[6][i] = ChessPiece(
          imagePath: 'lib/chess_images/pawn.png',
          isWhite: true,
          type: ChessPieceType.pawn);
    }
    //Place Rook
    newBoard[0][0] = ChessPiece(
        imagePath: 'lib/chess_images/rook.png',
        isWhite: false,
        type: ChessPieceType.rook);
    newBoard[0][7] = ChessPiece(
        imagePath: 'lib/chess_images/rook.png',
        isWhite: false,
        type: ChessPieceType.rook);
    newBoard[7][0] = ChessPiece(
        imagePath: 'lib/chess_images/rook.png',
        isWhite: true,
        type: ChessPieceType.rook);
    newBoard[7][7] = ChessPiece(
        imagePath: 'lib/chess_images/rook.png',
        isWhite: true,
        type: ChessPieceType.rook);
    //Place Knights
    newBoard[0][1] = ChessPiece(
        imagePath: 'lib/chess_images/knight.png',
        isWhite: false,
        type: ChessPieceType.knight);
    newBoard[0][6] = ChessPiece(
        imagePath: 'lib/chess_images/knight.png',
        isWhite: false,
        type: ChessPieceType.knight);
    newBoard[7][1] = ChessPiece(
        imagePath: 'lib/chess_images/knight.png',
        isWhite: true,
        type: ChessPieceType.knight);
    newBoard[7][6] = ChessPiece(
        imagePath: 'lib/chess_images/knight.png',
        isWhite: true,
        type: ChessPieceType.knight);
    //Place Bishop
    newBoard[0][2] = ChessPiece(
        imagePath: 'lib/chess_images/bishop.png',
        isWhite: false,
        type: ChessPieceType.bishop);
    newBoard[0][5] = ChessPiece(
        imagePath: 'lib/chess_images/bishop.png',
        isWhite: false,
        type: ChessPieceType.bishop);
    newBoard[7][2] = ChessPiece(
        imagePath: 'lib/chess_images/bishop.png',
        isWhite: true,
        type: ChessPieceType.bishop);
    newBoard[7][5] = ChessPiece(
        imagePath: 'lib/chess_images/bishop.png',
        isWhite: true,
        type: ChessPieceType.bishop);
    //Place Queen
    newBoard[0][3] = ChessPiece(
        imagePath: 'lib/chess_images/queen.png',
        isWhite: false,
        type: ChessPieceType.queen);
    newBoard[7][4] = ChessPiece(
        imagePath: 'lib/chess_images/queen.png',
        isWhite: true,
        type: ChessPieceType.queen);

    //Place King

    newBoard[0][4] = ChessPiece(
        imagePath: 'lib/chess_images/king.png',
        isWhite: false,
        type: ChessPieceType.king);
    newBoard[7][3] = ChessPiece(
        imagePath: 'lib/chess_images/king.png',
        isWhite: true,
        type: ChessPieceType.king);

    board = newBoard;
  }

  void movePiece(int newRow, int newCol) {
    board[newRow][newCol] = selectedPiece;
    board[selectedRow][selectedCol] = null;
    setState(() {
      selectedRow = -1;
      selectedCol = -1;
      validMoves = [];
      selectedPiece = null;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: 64,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
        itemBuilder: (context, index) {
          int row = index ~/ 8;
          int col = index % 8;
          bool isSelected = (selectedRow == row && selectedCol == col);
          bool isValidMove = false;
          for (var position in validMoves) {
            if (position[0] == row && position[1] == col) {
              isValidMove = true;
            }
          }
          return Square(
            isWhite: isWhite(index),
            piece: board[row][col],
            isSelected: isSelected,
            onTap: () => {pieceSelected(row, col)},
            isValidMove: isValidMove,
          );
        },
      ),
    );
  }
}
