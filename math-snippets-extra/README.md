# Math Snippets Extra

A snippets extension for VS Code.

This extension is not currently available in the marketplace, instead:

```bash
pnpm load
```

This will create a `.vsix` file an install it locally. Then run `Developer: Reload Window` in the command palette.

Unlike the basic [math-snippets](https://github.com/thomanq/math-snippets), the extra snippets only appear in a latex environment or tex environment, e.g. when surround with double dollar signs `$$   $$` for display math, or single dollar signs `$  $` for inline math. This helps keeps suggestions for markdown files lean.

The [snippet generator](https://github.com/wenfangdu/vscode-snippet-generator) extension is also included so you can make your own.

## Suggested Settings

I personally find that the quick suggestions can get in the way when typing mathematics in markdown documents. With these settings you have to explicitly activate completion with `ctrl` + `space` after starting to type out a prefix.

```json
"[latex]": {
    "editor.tabCompletion": "off",
    "editor.suggest.snippetsPreventQuickSuggestions": true
},
"[markdown]": {
    "editor.quickSuggestions": {
        "comments": "off",
        "strings": "off",
        "other": "off",
    },
    "editor.suggest.showWords": false,
},
```

## Prefixes

Prefixes are arrange by subject, e.g.

- calculus
- combinatorics
- foundation
- linear-algebra
- trigonometry
- vector

With some more general snippets

- environments
- font
- latex

## Example

In a latex environment, start typing `calculus`, then select `ftc1-calculus` from the suggestions:

$$ \int_a^b f(x) dx = F(b) - F(a) = F(x) \Big|_a^b $$

Or perhaps type `linear` and select `characteristic-determinant-linear`

$$ \mathrm{det}(\lambda\mathbf{I} - \mathbf{A}) =
\begin{vmatrix}
\lambda - 1 & 0 & 0 \\
0 & \lambda - 1 & 0 \\
0 & 0 & \lambda - 1 \\
\end{vmatrix} $$
