# Author switcher for git

`switch-author` is for git users using shared PC with multiple users

Side effects of this comamnd are only `git config user.name ...` and `git config user.email ...`

## Example usage

```bash
$ ./switch-author nwtgck
```

or

```bash
$ ./switch-author nw
```

(Smart search can solve by first letters `nw`)

## Author information

Put author information as `~/.git-authors.yaml`.

### Example of `~/.git-authors.yaml`

```yaml
- id : nwtgck
  name : Ryo Ota
  email: nwtgck@gmail.com

- id : exampleman
  name: Example Man
  email: test@example.com

- id : nbegin
  name: N Begin
  email: nbegin@example.com
```
