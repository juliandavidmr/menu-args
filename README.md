# xargs

A simple creator of super-fast menus using the [args](https://github.com/leo/args) package.

```js
const menu = require('xargs')

var args = menu(`
Usage "Hola soy un mensaje"

Commands
    serve "Run server"
    build, b
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
node test.js -u the.user
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

> **Not yet published**

```bash
npm install xargs --save
```

License MIT