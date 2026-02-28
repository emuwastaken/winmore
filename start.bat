@echo off
start cmd /k "cd /d %~dp0winmore-backend && mvnw spring-boot:run"
start cmd /k "cd /d %~dp0winmore_frontend_web && flutter run -d edge --web-renderer canvaskit"