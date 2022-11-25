name: Bug fix
description: Create a pull request to help us fix bugs
labels: "pr: bugfix"
assignees: fikinoob
body:
- type: textarea
  attributes:
    label: Describe the bug being fixed
    description: A clear and concise description of what the bugfix is about. If an issue exists for the bug, mention that this PR fixes that issue.
  validations:
    required: true
- type: textarea
  attributes:
    label: Anything we need to know about this fix?
    description: Try to state things that you changed in this PR.
  validations:
    required: true
