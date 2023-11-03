import { VideoView, useVideoPlayer } from '@expo/video';
import React, { useCallback, useEffect, useRef } from 'react';
import { PixelRatio, ScrollView, StyleSheet, View } from 'react-native';

import Button from '../../components/Button';

const bunny = 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
const dream = 'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4';

export default function VideoScreen() {
  const [fullscreen, setFullscreen] = React.useState(false);
  const [currentItem, setCurrentItem] = React.useState(bunny);
  const ref = useRef<VideoView>(null);

  const enterFullscreen = useCallback(() => {
    if (fullscreen) {
      ref.current?.exitFullscreen();
    } else {
      ref.current?.enterFullscreen();
    }
    setFullscreen((fs) => !fs);
  }, [ref, fullscreen]);

  const player = useVideoPlayer(bunny);

  const togglePlayer = useCallback(() => {
    if (player.isPlaying) {
      player.pause();
    } else {
      player.play();
    }
  }, [player]);

  const replaceItem = useCallback(() => {
    const nextItem = currentItem === bunny ? dream : bunny;
    player.replace(nextItem);
    setCurrentItem(nextItem);
  }, [currentItem, player]);

  const seekBy = useCallback(() => {
    player.seekBy(10);
  }, []);

  const replay = useCallback(() => {
    player.replay();
  }, []);

  const toggleMuted = useCallback(() => {
    player.isMuted = !player.isMuted;
  }, []);

  useEffect(() => {
    player.play();
  }, []);

  return (
    <ScrollView contentContainerStyle={styles.contentContainer}>
      <VideoView
        ref={ref}
        style={styles.video}
        player={player}
        nativeControls={false}
        contentFit="cover"
        contentPosition={{ dx: 0, dy: 0 }}
        allowsFullscreen
        showsTimecodes={false}
        requiresLinearPlayback
      />

      <View style={styles.buttons}>
        <Button style={styles.button} title="Toggle" onPress={togglePlayer} />
        <Button style={styles.button} title="Replace" onPress={replaceItem} />
        <Button style={styles.button} title="Seek by 10 seconds" onPress={seekBy} />
        <Button style={styles.button} title="Replay" onPress={replay} />
        <Button style={styles.button} title="Toggle mute" onPress={toggleMuted} />
        <Button
          style={styles.button}
          title={`${fullscreen ? 'Exit' : 'Enter'} fullscreen`}
          onPress={enterFullscreen}
        />
      </View>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  contentContainer: {
    padding: 10,
    alignItems: 'center',
  },
  video: {
    width: 400,
    height: 300,
    borderBottomWidth: 1.0 / PixelRatio.get(),
    borderBottomColor: '#cccccc',
  },
  buttons: {
    flexDirection: 'column',
  },
  button: {
    margin: 5,
  },
});
