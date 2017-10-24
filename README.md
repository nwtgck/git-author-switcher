# Author switcher for git

`switch-author` is for git users using shared PC with multiple users

Side effects of this comamnd are only `git config user.name ...` and `git config user.email ...`

## Requirements

* Shards (Dependency manager for the Crystal)

## How to build

```bash
$ cd <this repo>
$ shards build
```


## Example usages

```bash
$ ./bin/switch-author nwtgck
```

or

```bash
$ ./bin/switch-author nw
```

(Smart search can solve by first letters `nw`)

## Smart/Safe completion

An error will occur if you type just `n` like the follwoing.

```bash
./bin/switch-author n
Error: Duplicate ids: Ryo Ota and N Begin
```
This error is for avoiding unexpected config for user.

## Authors' information

Put authors' information as `$HOME/.git-authors.yaml`.

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
