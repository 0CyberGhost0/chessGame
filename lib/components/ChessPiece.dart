enum ChessPieceType { pawn, rook, knight, bishop, queen, king }

class ChessPiece {
  late final ChessPieceType type;
  late final bool isWhite;
  late final String imagePath;
  ChessPiece(
      {required this.imagePath, required this.isWhite, required this.type});
}
