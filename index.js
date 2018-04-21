const grammar = require("./grammar");
module.exports = function (input) {
	grammar.parse(input);
	return grammar.parser.args;
}