"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// The module 'vscode' contains the VS Code extensibility API
// Import the module and reference it with the alias vscode in your code below
const vscode = require("vscode");
// this method is called when your extension is activated
// your extension is activated the very first time the command is executed
var Range = vscode.Range;
function activate(context) {
    // Use the console to output diagnostic information (console.log) and errors (console.error)
    // This line of code will only be executed once when your extension is activated
    console.log('extension "hex-ascii-converter" is now active!');
    // The command has been defined in the package.json file
    // Now provide the implementation of the command with registerCommand
    // The commandId parameter must match the command field in package.json
    let disposable1 = vscode.commands.registerCommand('extension.convertAsciiToHex', () => {
        // The code you place here will be executed every time your command is executed
        // Get the active text editor
        let editor = vscode.window.activeTextEditor;
        if (editor) {
            let document = editor.document;
            // let selection = editor.selection;
            // // Get the word within the selection
            // let ascii = document.getText(selection);
            // let hex = asciiToHex(ascii);
            // editor.edit(editBuilder => {
            //     editBuilder.replace(selection, hex);
            // });

            // editor.edit(function (edit) {
            //     // itterate through the selections and convert all text to Upper
            //     for (var x = 0; x < selections.length; x++) {
            //         let txt = document.getText(new Range(selections[x].start, selections[x].end));
            //         console.log(txt);
            //         edit.replace(selections[x], asciiToHex(txt));
            //     }
            // });
            let sels = editor.selections;

            editor.edit(editBuilder => {
                for (var x = 0; x < sels.length; x++) {
                    let ascii = document.getText(new Range(sels[x].start, sels[x].end));
                    console.log(x,hex);
                    let hex = hexToAscii(ascii);
                    editBuilder.replace(sels[x], hex);
                }
            });

        }
    });
    // The command has been defined in the package.json file
    // Now provide the implementation of the command with registerCommand
    // The commandId parameter must match the command field in package.json
    let disposable2 = vscode.commands.registerCommand('extension.convertHexToAscii', () => {
        // The code you place here will be executed every time your command is executed
        // Get the active text editor
        let editor = vscode.window.activeTextEditor;
        if (editor) {
            let document = editor.document;
            // let selection = editor.selection;
            // Get the word within the selection
            // let hex = document.getText(selection);
            // if (hex.length > 0) {
            //     let ascii = hexToAscii(hex);
            //     if (ascii.length == 0) {
            //         vscode.window.showErrorMessage('Hex string format is wrong.');
            //     }
            //     else {
            //         editor.edit(editBuilder => {
            //             editBuilder.replace(selection, ascii);
            //         });
            //     }
            // }
            let sels = editor.selections;

            editor.edit(editBuilder => {
                for (var x = 0; x < sels.length; x++) {
                    let hex = document.getText(new Range(sels[x].start, sels[x].end));
                    console.log(x,hex);
                    let ascii = hexToAscii(hex);
                    if (ascii.length == 0) {
                        vscode.window.showErrorMessage('Hex string format is wrong.');
                    }
                editBuilder.replace(sels[x], ascii);
                }
            });
            

        }
    });
    context.subscriptions.push(disposable1);
    context.subscriptions.push(disposable2);
}
exports.activate = activate;
// this method is called when your extension is deactivated
function deactivate() { }
exports.deactivate = deactivate;
// Convert input ascii string to hex string
function asciiToHex(ascii) {
    console.log('input ascii:', ascii);
    var hex = '';
    for (var i = 0; i < ascii.length; i++) {
        var tmp = "00" + ascii.charCodeAt(i).toString(16);
        hex += tmp.substr(tmp.length - 2).toUpperCase();
    }
    console.log('return hex:', hex);
    return hex;
}
// Check input string is correct hex string or not
function isCorrectHexStr(str) {
    if (/^(\-|\+)?([0-9A-Fa-f]+|Infinity)$/.test(str)) {
        return true;
    }
    return false;
}
// Convert input hex string to ascii string
function hexToAscii(hex) {
    console.log('input hex:', hex);
    var ascii = '';
    if (isCorrectHexStr(hex) == false) {
        return '';
    }
    for (var i = 0; i < hex.length; i += 2) {
        var subStr = hex.substr(i, 2).trim();
        if (subStr.length != 2) {
            return '';
        }
        var parsed = Number.parseInt(subStr, 16);
        if (Number.isNaN(parsed)) {
            return '';
        }
        ascii += String.fromCharCode(parsed);
    }
    console.log('return ascii:', ascii);
    return ascii;
}
//# sourceMappingURL=extension.js.map
