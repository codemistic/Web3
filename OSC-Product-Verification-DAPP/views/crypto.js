// For triggering generate button to create a hash 

function generateHash() {
    const text = $("#file-name").text();
    if (text.length !== 0) {
        const hashText = CryptoJS.SHA1(text);
        document.getElementById("hashText").innerHTML = hashText;
    }
    else{
        alert("Please Upload The File.")
    }
}