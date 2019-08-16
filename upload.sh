#! /bin/bash
echo '开始验证'
pod spec lint Develop-debug.podspec --use-libraries --allow-warnings --verbose
echo '开始推送'
pod trunk push Develop-debug.podspec --allow-warnings --use-libraries --verbose
