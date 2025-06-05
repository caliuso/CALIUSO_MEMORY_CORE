@echo off
cd caliuso-memory-core
git add .
set timestamp=%date% %time%
git commit -m "Auto-backup: %timestamp%"
git push origin main