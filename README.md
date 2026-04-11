> private 레포 fallback. public 레포에는 적용되지 않습니다.

# .github-private
GitHub 특수 레포. **조직 계정**의 private/internal 레포들이 community health files 를 가지지 않을 때 fallback 으로 사용된다. 개인 계정에서는 동작하지 않는다.

## 포함 파일
- [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md): 행동 강령
- [CONTRIBUTING.md](CONTRIBUTING.md): 기여 가이드
- [SECURITY.md](SECURITY.md): 보안 취약점 신고 절차
- [SUPPORT.md](SUPPORT.md): 지원 채널 안내
- [PULL_REQUEST_TEMPLATE.md](PULL_REQUEST_TEMPLATE.md): PR 작성 시 기본 본문
- [ISSUE_TEMPLATE/](ISSUE_TEMPLATE/): 이슈 생성 시 뜨는 양식
- [CODEOWNERS](CODEOWNERS): 리뷰어 자동 지정 (fallback 미적용, 참고용)
- [FUNDING.yml](FUNDING.yml): 스폰서 버튼 설정 (fallback 미적용, 참고용)

<br>

## fallback 동작
이 레포의 파일은 같은 조직의 다른 private/internal 레포가 해당 파일을 가지지 않을 때 GitHub UI 에 자동으로 표시된다. 각 레포가 자체 파일을 가지면 그 파일이 우선한다.

<br>

## fallback 적용 대상
- `CODE_OF_CONDUCT.md`
- `CONTRIBUTING.md`
- `SECURITY.md`
- `SUPPORT.md`
- `PULL_REQUEST_TEMPLATE.md`
- `ISSUE_TEMPLATE/`

<br>

## fallback 미적용
- `CODEOWNERS`: 각 레포에 직접 둬야 동작한다.
- `FUNDING.yml`: 각 레포에 직접 둬야 동작한다.

<br>

## 우선순위 (private 레포 입장)
1. 해당 레포 자체의 파일
2. `.github-private` 의 파일
3. `.github` 의 파일

<br>

## 중요 제약
- **조직 계정 전용**. 개인 계정의 `.github-private` 는 GitHub 가 fallback 으로 인식하지 않는다.
- 이 레포 자체도 반드시 **private** 이어야 한다. public 으로 두면 fallback 이 동작하지 않는다.
- public 레포에는 절대 fallback 되지 않는다. public 레포는 [.github](https://github.com/Jinsun-Lee/.github) 만 참고한다.

<br>

## 조직으로 옮기는 방법
GitHub UI 에서 이 레포를 조직으로 fork 한다. Fork 시 레포 이름을 반드시 `.github-private` 로 유지하고 visibility 를 **private** 으로 설정한다.

또는 `gh` CLI 사용:
```bash
gh repo fork Jinsun-Lee/.github-private --org my-org --fork-name .github-private
gh repo edit my-org/.github-private --visibility private
```

<br>

fork 후 조직의 private/internal 레포들에 자동으로 fallback 이 적용된다. 별도 설정은 필요 없다.