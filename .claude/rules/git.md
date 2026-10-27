# Git 규칙

## PR 머지
- 머지 방식은 merge commit (squash·rebase 머지 사용 안 함)
- 머지 커밋 제목은 `type: 한글 설명 (#PR번호)` 형식, 본문은 비움
  - `type`·설명은 PR 제목과 같게 씀. 예: `feat: 매물 상세 사진 크게 보기 (#6)`
  - GitHub 기본값 `Merge pull request #N from ...` 그대로 머지하지 않음
- `gh`로 머지할 때: `gh pr merge <번호> --merge --subject "type: 한글 설명 (#번호)" --body ""`
- 웹에서 머지할 때: Merge pull request → 입력창 첫 줄을 위 형식으로 수정 → Confirm merge
- 이미 머지된 커밋 메시지는 고치지 않음 (main 기록 재작성·force push 필요)
