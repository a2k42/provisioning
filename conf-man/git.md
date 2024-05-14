# Git

## Worktrees

When you `clone` or `init` a regular repository then there is a `.git` that stores all the repository information.

You can then add worktrees `git worktree add -b docs ../docs-tree` but not all the trees are equal.

This might be fine if you always want to have one main worktree, but you can also use a **bare** repository without a working directory / worktree.


```bash
mkdir project-dir && cd project-dir

# .bare or project-name.git
git init --bare .bare

cd .bare

git worktree add --orphan ../main

```

## Rebasing

### Starting State

```bash
* c09275c (develop) delta on develop
* 4e2c5b1 charlie on develop
| * 43cb10f (HEAD -> main) foxtrot on main
| * 506e08e echo on main
|/
* b3af902 bravo on main
* 06939b6 alpha on main
```

### Rebase 1


We put the last two commits of `main` onto `develop`

```bash
git rebase develop main
```

```bash
* 27631b9 (HEAD -> main) foxtrot on main
* c64b762 echo on main
* c09275c (develop) delta on develop
* 4e2c5b1 charlie on develop
* b3af902 bravo on main
* 06939b6 alpha on main
```

### Rebase 2

On the `develop` branch

```bash
git rebase develop
Current branch develop is up to date.
```

Now we rebase the current branch `develop` onto `main`

```bash
git rebase main
```

```bash
* 1faa4e5 (HEAD -> develop) delta on develop
* 08a223f charlie on develop
* 43cb10f (main) foxtrot on main
* 506e08e echo on main
* b3af902 bravo on main
* 06939b6 alpha on main
```

### Rebase 3

On branch `main`

```bash
git rebase develop
```

This is the same as [Rebase 1](#rebase-1) `git rebase deveop main`

```bash
* ec9bce6 (HEAD -> main) foxtrot on main
* 3c849b7 echo on main
* c09275c (develop) delta on develop
* 4e2c5b1 charlie on develop
* b3af902 bravo on main
* 06939b6 alpha on main
```

> Rebase the **current** branch onto the `upstream` branch.

### Rebase 4

The last version is where we specifically rebase the branch `develop` onto the upstream `main`

```bash
git rebase main develop
```

```bash
* 3844a59 (HEAD -> develop) delta on develop
* 62d98d5 charlie on develop
* 43cb10f (main) foxtrot on main
* 506e08e echo on main
* b3af902 bravo on main
* 06939b6 alpha on main
```

This is indeed the same as [Rebase 2](#rebase-2)

The **branch** being rebased will have its commit history rewritten, whereas the **upstream** will remain intact.

The general form is:

```bash
git rebase upstream [branch-or-current]
```

After a rebase, you might want to move both branches to point at `HEAD`. To do this checkout the branch that is behind and reset it softly.

```bash
git switch main
git reset --soft develop
```

After a square rebase and soft reset

```bash
* c476d4c (HEAD -> main, develop) This is a new commit message of C & D
* d0c64f3 foxtrot on main
* f16f576 echo on main
* 3d76799 bravo on main
* 569030c alpha on main
```

## Squash Merge

Squash `develop` into `main`

```bash
git merge --squash develop
git commit -m "Squash merge"
```

```bash
* b523adf (main) Squash merge
* 0214f38 foxtrot on main
* e58b83c echo on main
| * b5ecdf9 (HEAD -> develop) delta on develop
| * f1c6b13 charlie on develop
|/
* 8d9c30b bravo on main
* 4f72995 alpha on main
```

If we look at the logs just for `main`, it now looks a bit like the rebase of `develop` onto `main`

```bash
b523adf (HEAD -> main) Squash merge
0214f38 foxtrot on main
e58b83c echo on main
8d9c30b bravo on main
4f72995 alpha on main
```

## Git Commit Graphs

1. You want to sort out potential merge conflicts on your own feature branch
1. You never want to rewrite the commit history on a main branch that has been shared with others
1. Preferably, you don't want to have a messy commit history

Update feature and merge back to main (conflicts resolved on feature)

```pikchr {kroki}
scale = 0.8
fill = white
linewid *= 0.5

circle "C0" fit
circlerad = previous.radius
arrow
circle "C1"
arrow
circle "C2"
arrow
circle "C4"
arrow
circle "C5"
arrow
circle "FF"
circle "C3" at dist(C2,C4) heading 30 from C2
arrow
circle "C6"
arrow
circle "M1"

arrow from C2 to C3 chop
arrow from C5 to M1 chop
arrow from M1 to FF chop

box height C3.y-C2.y \
    width (FF.e.x-C0.w.x)+linewid \
    with .w at 0.5*linewid west of C0.w \
    behind C0 \
    fill 0xc6e2ff thin color gray
box same width previous.e.x - C2.w.x \
    with .se at previous.ne \
    fill 0x9accfc
"trunk" below at 2nd last box.s
"feature branch" above at last box.n
```

Rebase feature onto main (main will need to be reset to point at the latest commit)

```pikchr {kroki}
scale = 0.8
fill = white
linewid *= 0.5
circle "C0" fit
circlerad = previous.radius
arrow
circle "C1"
arrow
circle "C2"
arrow
circle "C4"
arrow
circle "C6"
circle "C3" at dist(C2,C4) heading 30 from C2
arrow
circle "C5"
arrow from C2 to C3 chop
C3P: circle "C3'" at dist(C4,C6) heading 30 from C6
arrow right from C3P.e
C5P: circle "C5'"
arrow from C6 to C3P chop

box height C3.y-C2.y \
    width (C5P.e.x-C0.w.x)+linewid \
    with .w at 0.5*linewid west of C0.w \
    behind C0 \
    fill 0xc6e2ff thin color gray
box same width previous.e.x - C2.w.x \
    with .se at previous.ne \
    fill 0x9accfc
"trunk" below at 2nd last box.s
"feature branch" above at last box.n
```