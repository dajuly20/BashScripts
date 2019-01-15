#!/bin/bash
#tmux new -s occ_rescan_session
# This contents is within /bin/ocfs (OwncloudFileScan)
tmux new-session -d -s ocfs_session 'sudo ocfs'

#sudo -u www-data php /usr/share/owncloud/occ files:scan --all
#occ files:scan --all

