const { exec } = require('child_process');
const fs = require('fs');
const path = require('path');

// Run the forge script
exec("forge script script/PrintAdoptAHyphenScript.s.sol:PrintAdoptAHyphenScript -vvv", (error, stdout, stderr) => {
    if (error) {
        console.log(`error: ${error.message}`);
        return;
    }
    if (stderr) {
        console.log(`stderr: ${stderr}`);
        return;
    }
    
    const regex = /data:application\/json;base64,[a-zA-Z0-9+/]+=*/g;
    const base64Jsons = stdout.match(regex);
    const matches = [];

    base64Jsons?.forEach(base64Json => {
        const startIndex = base64Json.indexOf(',') + 1;
        const encodedJson = base64Json.slice(startIndex);
  
        try {
            const decodedJson = atob(encodedJson);
            const parsedJson = JSON.parse(decodedJson);
    
            if(parsedJson.image_data !== undefined) {
                matches.push(parsedJson.image_data);
            }
        } catch(e) {
            console.error('Error in decoding/parsing JSON:', e);
        }
    });

    // Specify the directory
    const dir = path.join(__dirname, 'preview');

    // Create the directory if it doesn't exist
    if (!fs.existsSync(dir)){
        fs.mkdirSync(dir, { recursive: true });
    }

    fs.readdir(dir, (err, files) => {
        if (err) throw err;

        for (const file of files) {
            fs.unlink(path.join(dir, file), err => {
                if (err) throw err;
            });
        }

        for (let i = 0; i < matches.length; i++) {
            const base64Data = matches[i].replace('data:image/svg+xml;base64,', '');
    
            const fileName = `${i + 1}.svg`;

            fs.writeFile(path.join(dir, fileName), Buffer.from(base64Data, 'base64'), { flag: 'w' }, function(err) {
                if(err) {
                    console.log(err);
                } else {
                    console.log(`saved ${fileName}`);
                }
            });
        }
    });
});
