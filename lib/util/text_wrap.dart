/// 한글 줄바꿈 보정 유틸.
///
/// Flutter 기본 줄바꿈은 한글을 글자 단위로 아무 데서나 끊어
/// "클로버" → "클로/버" 처럼 어절이 깨집니다.
/// CSS 의 `word-break: keep-all` 처럼, 공백으로 나뉜 각 어절 안쪽에
/// word-joiner(U+2060) 를 끼워 넣어 어절이 통째로 유지되도록 하고
/// 줄바꿈은 공백 위치에서만 일어나게 합니다.
extension KeepAllWrap on String {
  String get keepAll {
    final wj = String.fromCharCode(0x2060); // WORD JOINER
    return split(' ')
        .map((word) => word.runes.map(String.fromCharCode).join(wj))
        .join(' ');
  }
}
