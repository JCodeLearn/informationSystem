<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>修改头像</title>
    <style>
        .upload-box {
            max-width: 400px;
            margin: 2rem auto;
            padding: 2rem;
            border: 1px solid #ddd;
        }
        .preview {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
            margin: 1rem 0;
        }
        h2 {
            text-align: center;
        }
        .picture {
            text-align: center;
        }

    </style>
</head>
<body>
    <div class="upload-box">
        <h2>修改头像</h2>
        <div class="picture">
            <img id="preview" src="avatar" class="preview">
        <div/>

        <form action="avatar" method="post" enctype="multipart/form-data">
            <input type="file" name="avatar" accept="image/*" required
                   onchange="previewImage(this)">
            <button type="submit">上传头像</button>
        </form>
    </div>

    <script>
        function previewImage(input) {
            const preview = document.getElementById('preview');
            const file = input.files[0];
            const reader = new FileReader();

            reader.onload = function(e) {
                preview.src = e.target.result;
            };

            if (file) {
                reader.readAsDataURL(file);
            }
        }
    </script>
</body>
</html>