# Author switcher for git

`chauthor` (Change Author) is for git users using shared PC with multiple users

### Command's side effects

Side effects of this comamnd are only `git config user.name ...` and `git config user.email ...`

## How to build

### Build requirements

* Shards (Dependency manager for the Crystal)


```bash
$ cd <this repo>
$ shards build
```



## Authors' information

Put authors' information as `$HOME/.git-authors.yaml`.

### Example of `$HOME/.git-authors.yaml`

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


## Example usages

### How to change author

```bash
$ ./bin/chauthor nwtgck
```

```bash
$ ./bin/chauthor nbegin
```

or

```bash
$ ./bin/chauthor nw
```

```bash
$ ./bin/chauthor nb
```

(Smart search can solve by first letters `nw`)

## Smart/Safe completion

An error will occur if you type just `n` like the follwoing.

```bash
./bin/chauthor n
Error: Duplicate ids: Ryo Ota and N Begin
```
This error is for avoiding unexpected config for user.

### How to list all author

```
$ ./bin/chauthor --list
```

### How to unset author name and email in git-config 

```
$ ./bin/chauthor --unset
```