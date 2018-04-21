const grammar = require("./grammar");

/**
 * 
 * @param {string} input input menu
 */
module.exports = function (input) {
	grammar.parse(input);
	return grammar.parser.args;
}