## Contributing to motion_photos

Here are the guidelines we'd like you to follow:
- [Setup](#setup)
- [Coding Rules](#rules)
- [Commit Message Guidelines](#commit)

---
*NOTE:*

Never push directly to main repository (upstream). Only push to your forked repo (origin) and send a pull request to
the main repository.

---

### <a id="setup"></a> Setup

* Clone the repository
    ```sh
    git clone <FORK_URL>
    ```
* Enable githooks
    ```sh
    git config core.hooksPath .githooks
    ```

---

### <a id="rules"></a> Coding Rules

To ensure consistency throughout the source code, keep these rules in mind as you are working:

- The coding style to be followed along with instructions to use flutter_lint
- Enable Sound-Null-Safety

### <a id="commit"></a> Git Commit Guidelines

#### Commit Message Format

Each commit message consists of a **header**, a **body** and a **footer**. The header has a special
format that includes a **type**, a **scope** and a **subject**:

```bash
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

Any line of the commit message cannot be longer 100 characters! This allows the message to be easier to read on github
as well as in various git tools.

#### Example Commit Message

```bash
feat(Profile): display QR code

fetch the qr code from API and display it on Profile page (profile_screen.dart)

fixes #1234
```

Please follow the conventions followed [here](http://karma-runner.github.io/latest/dev/git-commit-msg.html).

Also, refer [this page](https://chris.beams.io/posts/git-commit/) on how to write the body