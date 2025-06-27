import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/song_provider.dart';
import '../../models/song.dart';
import 'song_detail_screen.dart';

class SongsScreen extends StatefulWidget {
  @override
  _SongsScreenState createState() => _SongsScreenState();
}

class _SongsScreenState extends State<SongsScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SongProvider>(context, listen: false).loadSongs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search songs...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                Provider.of<SongProvider>(context, listen: false)
                    .loadSongs(search: value);
              },
            ),
          ),
          Expanded(
            child: Consumer<SongProvider>(
              builder: (context, songProvider, child) {
                if (songProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (songProvider.songs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.music_note, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No songs found',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: songProvider.songs.length,
                  itemBuilder: (context, index) {
                    final song = songProvider.songs[index];
                    return SongCard(song: song);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class SongCard extends StatelessWidget {
  final Song song;

  const SongCard({Key? key, required this.song}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Icon(
            Icons.music_note,
            color: Colors.blue.shade800,
            size: 30,
          ),
        ),
        title: Text(
          song.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('by ${song.singer}'),
            SizedBox(height: 4),
            Text(
              song.lyrics,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SongDetailScreen(song: song),
            ),
          );
        },
      ),
    );
  }
}
