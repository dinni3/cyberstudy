# Process Management

Examples recorded in artifacts/ps_sleep*.txt

- ps aux : list all processes
- pgrep sleep : find PIDs of 'sleep'
- kill <PID> : send SIGTERM
- kill -9 <PID> : send SIGKILL (force)
- nohup command & : run process immune to hangups
