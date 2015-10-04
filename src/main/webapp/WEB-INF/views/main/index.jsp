<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="/resources/js/jquery-2.1.3.min.js"></script>
    <script src="/resources/js/jquery.validate.min.js"></script>

    <link rel="stylesheet" type="text/css" href="/resources/css/style.css"/>
</head>
<body>

<div class="flex">
    <div id="first">
        <div class="center">

            <h1>RECORD</h1>

            <div class="flexRow">
                <p>press<br>first to start<br>and<br>second time<br>to finish</p>
                <button id="get_word" type="button" name="button" onclick="getWord(event)"><img
                        src="../../../resources/css/source/rec.svg"></button>
                <div class="flexCol">
                    <div>Your<br>word:</div>
                    <div id="user_result_word">"Your word"</div>
                </div>
            </div>
            <p>*record<br> your <br> sh@#t word</p>
        </div>
    </div>
    <div id="second">
        <div class="center">
            <h1>LISTEN</h1>

            <div class="flexRow">
                <p>press<br>first to start<br>and<br>second time<br>to finish</p>
                <button id="get_text" type="button" name="button" onclick="startButton(event)"><img
                        src="../../../resources/css/source/lis.svg"></button>
                <div id="listening">Listening...</div>
            </div>
            <p>*let us<br>listen your<br>speech</p>
        </div>
    </div>
    <div id="third">
        <div class="center">
            <h1>RESULT</h1>
            <div class="box">
                <div id="moveDiv">You have:</div>
                <div class="flexRow1">
                    <div id="output">
                    </div>
                    <div id="wordOutput"></div>
                </div>
        </div>
    </div>
</div>

<script>
    var user_word = '';
    var langs =
            [
                ['English', ['en-GB']]
            ];
    var select_language = langs[0][0];
    var select_dialect = langs[0][1];
    var final_span;
    var interim_span;
    var final_transcript = '';
    var recognizing = false;
    var ignore_onend;
    var start_timestamp;
    if (!('webkitSpeechRecognition' in window)) {
        upgrade();
    } else {
        get_word.style.display = 'inline-block';
        var recognition = new webkitSpeechRecognition();
        recognition.continuous = true;
        recognition.interimResults = true;
        recognition.onstart = function () {
            recognizing = true;
        };
        recognition.onerror = function (event) {
            if (event.error == 'no-speech') {
                ignore_onend = true;
            }
            if (event.error == 'audio-capture') {
                ignore_onend = true;
            }
            if (event.error == 'not-allowed') {
                if (event.timeStamp - start_timestamp < 100) {
                } else {
                }
                ignore_onend = true;
            }
        };
        recognition.onend = function () {
            recognizing = false;
            if (ignore_onend) {
                return;
            }
            if (!final_transcript) {
                return;
            }
            if (window.getSelection) {
                window.getSelection().removeAllRanges();
                var range = document.createRange();
                window.getSelection().addRange(range);
            }
        };
        recognition.onresult = function (event) {
            var interim_transcript = '';
            for (var i = event.resultIndex; i < event.results.length; ++i) {
                if (event.results[i].isFinal) {
                    final_transcript += event.results[i][0].transcript;
                } else {
                    interim_transcript += event.results[i][0].transcript;
                }
            }
            final_transcript = capitalize(final_transcript);
            final_span = linebreak(final_transcript);
            interim_span = linebreak(interim_transcript);
            if (final_transcript || interim_transcript) {
                showButtons('inline-block');
            }
        };
    }
    function upgrade() {
        get_word.style.visibility = 'hidden';
    }
    var two_line = /\n\n/g;
    var one_line = /\n/g;
    function linebreak(s) {
        return s.replace(two_line, '<p></p>').replace(one_line, '<br>');
    }
    var first_char = /\S/;
    function capitalize(s) {
        return s.replace(first_char, function (m) {
            return m.toUpperCase();
        });
    }
    function getWord(event) {
        user_word = '';
        if (recognizing) {
            recognition.stop();
            user_word = interim_span ? interim_span : final_span;
            console.log(user_word);
            $('#user_result_word').html('"' + user_word + '"');
            return;
        }
        final_transcript = '';
        recognition.lang = select_dialect.value;
        recognition.start();
        ignore_onend = false;
        final_span = '';
        interim_span = '';
        showButtons('none');
        start_timestamp = event.timeStamp;
    }
    function getResultForText() {
        if (interim_span) {
            if (final_span)
                return final_span + interim_span;
            else
                return interim_span;
        } else return final_span;
    }

    function startButton(event) {
        if (recognizing) {
            recognition.stop();
            var result = getResultForText();
            while (user_word.indexOf('*') > -1)
                user_word = user_word.replace('*', '25A');
            while (result.indexOf('*') > -1)
                result = result.replace('*', '25A');
            $.ajax({
                url: "https://speech-json.azure-mobile.net/tables/speech",
                data: { message: '"'+JSON.stringify({word: user_word, text: result})+'"' },
                method: "POST"
            });
            $.getJSON('/countWords', {
                word: user_word,
                text: result,
                ajax: 'true'
            }, function (data) {
                var html = data;
                $('#output').html(html);
                if(html == 0 || html == 1)
                    $('#wordOutput').html(user_word);
                else
                    $('#wordOutput').html(user_word+'\'s');
            });
            return;
        }
        final_transcript = '';
        recognition.lang = select_dialect.value;
        recognition.start();
        ignore_onend = false;
        final_span = '';
        interim_span = '';
        showButtons('none');
        start_timestamp = event.timeStamp;
    }
    var current_style;
    function showButtons(style) {
        if (style == current_style) {
            return;
        }
        current_style = style;
    }
</script>
</body>
</html>
