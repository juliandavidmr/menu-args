const menu = require('./')

var args = menu(`
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
// console.log(args.showHelp())