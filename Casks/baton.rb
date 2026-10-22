cask "baton" do
  version "1.3.0"
  sha256 "e848bcac020c7c62c50fbbf0ad34af107709dba7928ebaf69ee1947ada4f37fe"

  url "https://github.com/lmcjt37/baton-releases/releases/download/v#{version}/Baton-#{version}-universal.dmg"
  name "Baton"
  desc "Run Maestro E2E flows for React Native apps across git worktrees"
  homepage "https://lmcjt37.github.io/baton-releases/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :monterey

  app "Baton.app"
  binary "#{appdir}/Baton.app/Contents/Resources/bin/baton"

  uninstall quit:   "dev.lmcjt37.baton",
            script: {
              executable:   "#{appdir}/Baton.app/Contents/Resources/bin/baton",
              args:         ["stop", "--force"],
              must_succeed: false,
            }

  zap script: {
        executable:   "/bin/sh",
        args:         [
          "-c",
          'f="$HOME/.baton/state.json"; [ -f "$f" ] || exit 0; ' \
          'tr -d " \n" < "$f" | sed -n "s/.*\"ownedSimulators\":\[\([^]]*\)\].*/\1/p" | ' \
          'tr -d "\"" | tr "," "\n" | ' \
          'while read -r udid || [ -n "$udid" ]; do ' \
          '[ -n "$udid" ] && xcrun simctl delete "$udid" < /dev/null; done; exit 0',
        ],
        must_succeed: false,
      },
      trash:  [
        "~/.baton",
        "~/Library/Application Support/Baton",
        "~/Library/Caches/dev.lmcjt37.baton",
        "~/Library/HTTPStorages/dev.lmcjt37.baton",
        "~/Library/Preferences/dev.lmcjt37.baton.plist",
        "~/Library/Saved Application State/dev.lmcjt37.baton.savedState",
      ]

  caveats <<~EOS
    Open Baton from Applications once before using `baton`: macOS asks
    before running an app downloaded from the internet.
  EOS
end
