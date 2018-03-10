#!/bin/bash
date > /Users/pbrocoum/Bin/rsync_media.log
if [ -d /Volumes/Media/ -a -d /Volumes/Media\ B/ ]; then
  rsync --archive --progress --stats --delete --delete-excluded --exclude='.*' /Volumes/Media/ /Volumes/Media\ B/ | tee /Users/pbrocoum/Bin/rsync_media.log
fi
