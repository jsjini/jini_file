<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Insert title here</title>
    </head>

    <body>
        async 테스트
        <div id="div"></div>
        <script>

            async function docload() {

                await fetch("FetchServ")
                    .then(result => result.text())
                    .then(result => {
                        div.innerHTML += result + "<br>";
                        div.innerHTML += "완료" + "<br>"; // 1
                    })

                div.innerHTML += "fetch 호출"; // 2
            }
            // 같다.
            async function docload() {

                let result = await fetch("FetchServ");
                result = await result.text();
                div.innerHTML += result + "<br>";
                div.innerHTML += "완료" + "<br>"; // 1

                div.innerHTML += "fetch 호출"; // 2
            }

            docload();
        </script>
    </body>

    </html>