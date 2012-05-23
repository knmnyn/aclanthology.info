#!/bin/sh

ps xww | grep 'heroku' | cut -c1-5 | xargs -i kill {} 2>/dev/null
cd /home/praveen/RoR/aclantho3/stat_logs/
heroku logs --source app --tail > stat.log &
