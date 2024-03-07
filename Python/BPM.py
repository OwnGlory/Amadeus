import librosa

def calculate_bpm(audio_file):
    # Загрузка аудиофайла
    y, sr = librosa.load(audio_file)

    # Вычисление темпа (в ударах в минуту)
    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr)

    return tempo

bpm = calculate_bpm(audio_file)