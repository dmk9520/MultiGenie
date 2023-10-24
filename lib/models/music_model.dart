class MusicData {
  String? title; 
  String? artist;
  String? album ;

  MusicData({
    required this.title,
    required this.artist,
    required this.album,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'title': title,
      'artist': artist,
      'album': album
    };
    return map;
  }

  MusicData.fromMap(Map<String, dynamic> map) {
    title = map['title'];
    artist = map['artist'];
    album = map['album'];
  }

  @override
  String toString() {
    return 'MusicData{title: $title, artist: $artist, album: $album}';
  }
}
