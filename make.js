var fs = new ActiveXObject("Scripting.FileSystemObject");

var Server_js = readFile("src\\Server.js");
var Tray_ps1 = readFile("src\\Tray.ps1");
var Server_ps1 = readFile("src\\Server.ps1");

writeFile("Server.js",
	Server_js
	.replace(
		"-f Tray.ps1",
		'-c \\"' +
			Tray_ps1
			.replace(
				"-f Server.ps1",
				'-c "' +
				Server_ps1
					.replace(/\r\n/g, " ")
					.replace(/\t+/g, " ")
					.replace(/  /g, " ")
					.replace(/'/g, "''")
				+ '"'
			)
			.replace(/\r\n/g, " ")
			.replace(/\t+/g, " ")
			.replace(/  /g, " ")
			.replace(/\\/g, "\\\\")
			.replace(/"/g, '\\"')
		+ '\\"'
	)
);

function readFile(path) {
	var stream = fs.openTextFile(path, /*ForReading*/ 1);
	var content = stream.readAll();
	stream.close();
	return content;
}

function writeFile(path, content) {
	var stream = fs.createTextFile(path, /*Overwrite*/ true);
	stream.write(content);
	stream.close();
}
