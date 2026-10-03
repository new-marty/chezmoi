#!/bin/bash
set -euo pipefail

TARGET_PROFILE="${1:-}"
if [[ -z "$TARGET_PROFILE" ]]; then
    echo "Usage: $0 <profile-name>" >&2
    exit 1
fi

PROFILES_DIR="$HOME/.gemini/profiles"
# agy itself reads its OAuth token from this Keychain item.
ACTIVE_SERVICE="gemini"
ACTIVE_ACCOUNT="antigravity"
# Each profile's token is kept in its own Keychain item, never on disk.
PROFILE_SERVICE="gemini-profile"

# The token goes to `security` through stdin, so it never appears in argv (ps).
keychain_store() {
    printf 'add-generic-password -U -s "%s" -a "%s" -w "%s"\n' "$1" "$2" "$3" | security -i >/dev/null
}
CURRENT_FILE="$PROFILES_DIR/.current"
mkdir -p "$PROFILES_DIR"
chmod 700 "$PROFILES_DIR"

CURRENT_PROFILE=""
if [[ -f "$CURRENT_FILE" ]]; then
    CURRENT_PROFILE=$(cat "$CURRENT_FILE")
fi
if [[ -z "$CURRENT_PROFILE" ]]; then
    CURRENT_PROFILE="personal"
fi

# 既に指定プロファイルなら何もしない
if [[ "$CURRENT_PROFILE" == "$TARGET_PROFILE" ]]; then
    exit 0
fi

# 1. 現在のプロファイルの状態を保存
mkdir -p "$PROFILES_DIR/$CURRENT_PROFILE"
chmod 700 "$PROFILES_DIR/$CURRENT_PROFILE"

current_token=$(security find-generic-password -s "$ACTIVE_SERVICE" -a "$ACTIVE_ACCOUNT" -w 2>/dev/null || true)
if [[ -n "$current_token" ]]; then
    keychain_store "$PROFILE_SERVICE" "$CURRENT_PROFILE" "$current_token"
fi

for f in google_accounts.json settings.json state.json; do
    if [[ -f "$HOME/.gemini/$f" ]]; then
        cp "$HOME/.gemini/$f" "$PROFILES_DIR/$CURRENT_PROFILE/$f"
        chmod 600 "$PROFILES_DIR/$CURRENT_PROFILE/$f"
    fi
done

# 2. ターゲットプロファイルのディレクトリを確保
mkdir -p "$PROFILES_DIR/$TARGET_PROFILE"
chmod 700 "$PROFILES_DIR/$TARGET_PROFILE"

# 3. ターゲットプロファイルの復元
target_token=$(security find-generic-password -s "$PROFILE_SERVICE" -a "$TARGET_PROFILE" -w 2>/dev/null || true)
if [[ -n "$target_token" ]]; then
    keychain_store "$ACTIVE_SERVICE" "$ACTIVE_ACCOUNT" "$target_token"
else
    # ターゲットのトークンがない場合（初回など）は Keychain をクリアして新規ログインを促す
    security delete-generic-password -s "$ACTIVE_SERVICE" -a "$ACTIVE_ACCOUNT" >/dev/null 2>&1 || true
fi

for f in google_accounts.json settings.json state.json; do
    if [[ -f "$PROFILES_DIR/$TARGET_PROFILE/$f" ]]; then
        cp "$PROFILES_DIR/$TARGET_PROFILE/$f" "$HOME/.gemini/$f"
    else
        if [[ "$f" == "google_accounts.json" ]]; then
            rm -f "$HOME/.gemini/$f"
        fi
    fi
done

# 4. 現在のプロファイル記録を更新
echo -n "$TARGET_PROFILE" > "$CURRENT_FILE"
echo "🔄 Switched Antigravity profile: $CURRENT_PROFILE -> $TARGET_PROFILE" >&2
