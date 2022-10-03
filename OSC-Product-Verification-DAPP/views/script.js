// For triggering the file name at File position

document.querySelector("#file-upload").onchange = function () {
    document.querySelector("#file-name").textContent = this.files[0].name;
}

$(document).ready(function () {
    $('input[type="file"]').change(function (evt) {
        const fileUpload = evt.target.files[0].name;
        $("h4").text(fileUpload);
    });
});

