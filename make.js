var fs = new ActiveXObject("Scripting.FileSystemObject");

writeFile("Server.bat",
	readFile("src\\MainCLI.bat")
	.replace(
		"-f CLI.ps1",
		'-c "' +
			readFile("src\\CLI.ps1")
			.replace(
				"-f Server.ps1",
				'-c "' +
				readFile("src\\Server.ps1")
					.replace(/\r\n/g, " ")
					.replace(/\t+/g, " ")
					.replace(/  /g, " ")
					.replace(/'/g, "''")
					.replace(/ $/, "")
				+ '"'
			)
			.replace(/\r\n/g, " ")
			.replace(/\t+/g, " ")
			.replace(/  /g, " ")
			.replace(/__REPLACE_PORT__/g, "%port%")
			.replace(/__REPLACE_ROOT__/g, "%root%")
			.replace(/__REPLACE_INDEX__/g, "%index%")
			.replace(/ $/, "")
		+ '"'
	)
);

writeFile("Server.js",
	readFile("src\\MainGUI.js")
	.replace(
		"-f GUI.ps1",
		'-c \\"' +
			readFile("src\\GUI.ps1")
			.replace(
				"-f Server.ps1",
				'-c "' +
				readFile("src\\Server.ps1")
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
			.replace(/__REPLACE_PORT__/g, '" + port + "')
			.replace(/__REPLACE_ROOT__/g, '" + root + "')
			.replace(/__REPLACE_INDEX__/g, '" + index + "')
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
