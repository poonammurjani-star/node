
#!/bin/bash

APP_DIR="/var/www/nodeapp"
BRANCH="main"
LOG="/home/nodeuser/deploy.log"

exec >> "$LOG" 2>&1

echo "Deployment check: $(date)"

cd "$APP_DIR" || exit 1

git fetch origin "$BRANCH" || exit 1

LOCAL=$(git rev-parse HEAD)
REMOTE=$(git rev-parse "origin/$BRANCH")
BASE=$(git merge-base HEAD "origin/$BRANCH")

if [ "$LOCAL" = "$REMOTE" ]; then
    echo "Already up to date."
elif [ "$LOCAL" = "$BASE" ]; then
    echo "New changes found."

    git merge --ff-only "origin/$BRANCH" || exit 1

    npm install || exit 1

    # Add your build command here if required
    # npm run build

    pm2 restart nodeapp --update-env || \
        pm2 start npm --name nodeapp -- start

    pm2 save

    echo "Deployment successful: $(date)"
else
    echo "Branches diverged. Manual intervention required."
    exit 1
fi
