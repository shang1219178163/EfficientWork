#!/usr/bin/env swift

import Foundation

func die(_ m: String) -> Never { fputs(m + "\n", stderr); exit(1) }

guard let yaml = try? String(contentsOfFile: "pubspec.yaml", encoding: .utf8) else { die("错误: 找不到 pubspec.yaml 文件") }
guard let ver = yaml.split(separator: "\n")
        .map({ $0.trimmingCharacters(in: .whitespaces) })
        .first(where: { $0.hasPrefix("version:") })?
        .dropFirst(8)
        .trimmingCharacters(in: .whitespaces),
      ver.contains("+")
else { die("错误: 无法提取版本信息") }
let pair = ver.split(separator: "+", maxSplits: 1)

let envs = ["1": "test", "2": "pre", "0": "prod"]
var env = ""
while env.isEmpty {
  print("请选择环境: 1:test  2:pre  0:prod")
  env = envs[readLine()?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""] ?? ""
  if env.isEmpty { print("请输入有效的选项 (1 或 2 或 0)") }
}

let fmt = DateFormatter()
fmt.locale = Locale(identifier: "en_US_POSIX")
fmt.dateFormat = "yyyy-MM-dd-HH-mm"

let p = Process()
p.executableURL = URL(fileURLWithPath: "/usr/bin/env")
p.arguments = ["flutter", "build", "apk", "--release", "--dart-define=app_env=\(env)"]
p.standardOutput = FileHandle.standardOutput
p.standardError = FileHandle.standardError
do { try p.run(); p.waitUntilExit() } catch { die("错误: APK 构建失败") }
if p.terminationStatus != 0 { die("错误: APK 构建失败") }

let dir = "build/app/outputs/flutter-apk"
let dest = "\(dir)/kbisai-\(pair[0])_\(pair[1])_\(fmt.string(from: Date()))_\(env).apk"
_ = try? FileManager.default.removeItem(atPath: dest)
do { try FileManager.default.copyItem(atPath: "\(dir)/app-release.apk", toPath: dest) }
catch { die("错误: APK 构建失败") }

let out = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
  .appendingPathComponent(dir, isDirectory: true)
  .resolvingSymlinksInPath()
print("\n在编辑器中打开文件目录 (Cmd + 单击)")
// OSC 8 + 绝对路径，Cursor/VS Code 终端才能 Cmd+单击跳转
print("\u{001B}[35m\u{001B}]8;;\(out.absoluteString)\u{001B}\\\(out.path)/\u{001B}]8;;\u{001B}\\\u{001B}[0m")
