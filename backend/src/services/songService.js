// Service for song-related business logic
const Song = require('../models/song');

exports.findSongsByUser = async (userId) => {
  return await Song.find({ user: userId });
};

exports.createSong = async (songData) => {
  const song = new Song(songData);
  return await song.save();
};
