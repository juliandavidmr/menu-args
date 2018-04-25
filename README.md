# menu-args

Toolkit for creating command line interfaces without writing so much code.

> `menu-args` uses the [args](https://github.com/leo/args) package.

```js
const menu = require('menu-args')

var args = menu(`
Commands
    serve "Run server"
    build
    reload

Options
    user "Username"
    pass "Password system"
    state
    port (8080) "Port, default value"
`)

console.log(args.parse(process.argv))
```

If the command is executed:

```bash
node test.js -u the.user -p 1a2b3c
```

it is obtained:

```js
/* { P: '8080',
  port: '8080',
  u: 'the.user',
  user: 'the.user',
  p: '1a2b3c',
  pass: '1a2b3c' } */
```

> Note that the variable [`args`](https://github.com/leo/args) is exactly the args package

## Install

```bash
npm install menu-args --save
```

### Example

If you run function `args.showHelp()`, we'll see:

```txt
Usage: test.js [options] [command]

  Commands:

    build, b
    help      Display help
    reload    undefined
    serve     "Run server"
    version   Display version

  Options:

    -h, --help          Output usage information
    -p, --pass          Password system
    -P, --port [value]  Port, default value (defaults to "8080")
    -s, --state
    -u, --user          "Username"
    -v, --version       Output the version number
```

License MIT