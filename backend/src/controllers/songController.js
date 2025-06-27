const Song = require('../models/song');

// Create a new song
exports.createSong = async (req, res) => {
  try {
    const song = new Song(req.body);
    await song.save();
    res.status(201).json(song);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Get all songs
exports.getAllSongs = async (req, res) => {
  try {
    const songs = await Song.find().populate('user');
    res.json(songs);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get a single song by ID
exports.getSongById = async (req, res) => {
  try {
    const song = await Song.findById(req.params.id).populate('user');
    if (!song) return res.status(404).json({ error: 'Song not found' });
    res.json(song);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Update a song
exports.updateSong = async (req, res) => {
  try {
    const song = await Song.findByIdAndUpdate(req.params.id, req.body, { new: true });
    if (!song) return res.status(404).json({ error: 'Song not found' });
    res.json(song);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// Delete a song
exports.deleteSong = async (req, res) => {
  try {
    const song = await Song.findByIdAndDelete(req.params.id);
    if (!song) return res.status(404).json({ error: 'Song not found' });
    res.json({ message: 'Song deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};
