# phpunit.vim

![phpunit.vim](https://pbs.twimg.com/media/CPwwG-4UcAA-KXs.png:large)


## Install via Vundle

```vim
Plugin "c9s/phpunit.vim"
```

## Configurations


```vim
" the directory that contains your phpunit test cases.
let g:phpunit_testroot = 'tests'
```

```vim
" the directory that contains source files
let g:phpunit_srcroot = 'src'
```

```vim
" the location of your phpunit file.
let g:phpunit_bin = 'phpunit'
```

```vim
" php unit command line options
let g:phpunit_options = ["--stop-on-failure"]
```

## Key Mappings

- `<leader>ta` - Run all test cases
- `<leader>ts` - Switch between source & test file
- `<leader>tf` - Run current test case class

## Notice

Since vim doesn't support pipe output to a buffer, this plugin only renders the content to buffer when the command completed.

## License

MIT License
