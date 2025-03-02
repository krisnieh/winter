# winter

## for Ubuntu 22.04
1.编译linux应用
flutter build linux --release --target-platform linux-x64
2.安装打包工机
dart pub global activate flutter_to_debian
export PATH="$PATH":"$HOME/.pub-cache/bin"
3.上传并更新
curl -X POST -F "file=@build/linux/x64/release/debian/winter_1.0.0_amd64.deb" http://172.16.0.7:5000/api/hsf/admin/upload/winter.deb