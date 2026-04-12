#!/usr/bin/env bash
#
# 홈 디렉토리에 쌓이는 캐시/임시 파일 정리 스크립트
# 사용법: bash cleanup.sh [--dry-run]
#

set -euo pipefail

DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

cleaned=0

remove() {
    local target="$1"
    local desc="$2"

    if [[ -e "$target" ]]; then
        if $DRY_RUN; then
            echo -e "  ${YELLOW}[dry-run]${NC} $desc → $target"
        else
            rm -rf "$target"
            echo -e "  ${GREEN}[삭제]${NC} $desc → $target"
        fi
        ((cleaned++))
    fi
}

remove_glob() {
    local dir="$1"
    local pattern="$2"
    local desc="$3"

    if [[ -d "$dir" ]]; then
        while IFS= read -r -d '' f; do
            remove "$f" "$desc"
        done < <(find "$dir" -maxdepth 1 -name "$pattern" -print0 2>/dev/null)
    fi
}

echo -e "${BLUE}=== 홈 디렉토리 정리 시작 ===${NC}\n"

# ── wget ──
echo -e "${BLUE}[wget]${NC}"
remove "$HOME/.wget-hsts" "HSTS 캐시"

# ── Python ──
echo -e "${BLUE}[Python]${NC}"
remove "$HOME/.python_history" "Python 대화형 셸 명령어 기록"

# ── 썸네일 캐시 ──
echo -e "${BLUE}[썸네일]${NC}"
remove "$HOME/.cache/thumbnails" "썸네일 캐시"

# ── 최근 사용 파일 기록 ──
echo -e "${BLUE}[최근 기록]${NC}"
remove "$HOME/.local/share/recently-used.xbel" "최근 사용 파일 목록"

# ── Trash ──
echo -e "${BLUE}[휴지통]${NC}"
remove "$HOME/.local/share/Trash" "휴지통"

# ── 패키지 매니저 캐시 ──
echo -e "${BLUE}[패키지 매니저]${NC}"
remove "$HOME/.cache/pip" "pip 캐시"
remove "$HOME/.npm/_cacache" "npm 캐시"
remove "$HOME/.cache/yarn" "yarn 캐시"

# ── 브라우저 크래시 리포트 ──
echo -e "${BLUE}[크래시 리포트]${NC}"
remove "$HOME/.config/google-chrome/Crash Reports" "Chrome 크래시 리포트"
remove "$HOME/.mozilla/firefox/Crash Reports" "Firefox 크래시 리포트"

# ── 각종 로그 ──
echo -e "${BLUE}[로그]${NC}"
remove "$HOME/.xsession-errors" "X 세션 에러 로그"
remove "$HOME/.xsession-errors.old" "X 세션 에러 로그 (이전)"
remove_glob "$HOME" ".*.swp" "Vim swap 파일"
remove_glob "$HOME" "*~" "백업 파일 (*~)"

# ── 결과 ──
echo ""
if [[ $cleaned -eq 0 ]]; then
    echo -e "${GREEN}정리할 항목이 없습니다.${NC}"
else
    echo -e "${GREEN}총 ${cleaned}개 항목 정리 완료.${NC}"
fi
