// Quy tắc commit của WorkCal: Conventional Commits 1.0.0 và footer bắt buộc "Refs: <mã task>".
// Mẫu đầy đủ: .claude/rules/working-agreement.md, mục 4. Chạy trong CI bằng wagoid/commitlint-github-action.
export default {
  extends: ['@commitlint/config-conventional'],
  plugins: [
    {
      rules: {
        'refs-footer': ({ raw }) => [
          /^Refs: \S+/m.test(raw ?? ''),
          'thiếu dòng footer "Refs: <mã task>" (ví dụ: Refs: P0-04)',
        ],
      },
    },
  ],
  rules: {
    // Thân và footer viết tiếng Việt, thường dài hơn 100 ký tự mỗi dòng
    'body-max-line-length': [0],
    'footer-max-line-length': [0],
    'refs-footer': [2, 'always'],
  },
};
