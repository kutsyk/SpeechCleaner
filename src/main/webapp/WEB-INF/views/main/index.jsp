<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="/resources/js/jquery-2.1.3.min.js"></script>
    <script src="/resources/js/jquery.validate.min.js"></script>
</head>
<body>
<style>
    * {
        font-family: Verdana, Arial, sans-serif;
    }

    a:link {
        color: #000;
        text-decoration: none;
    }

    a:visited {
        color: #000;
    }

    a:hover {
        color: #33F;
    }

    .button {
        background: -webkit-linear-gradient(top, #008dfd 0, #0370ea 100%);
        border: 1px solid #076bd2;
        border-radius: 3px;
        color: #fff;
        display: none;
        font-size: 13px;
        font-weight: bold;
        line-height: 1.3;
        padding: 8px 25px;
        text-align: center;
        text-shadow: 1px 1px 1px #076bd2;
        letter-spacing: normal;
    }

    .center {
        padding: 10px;
        text-align: center;
    }

    .final {
        color: black;
        padding-right: 3px;
    }

    .interim {
        color: gray;
    }

    .info {
        font-size: 14px;
        text-align: center;
        color: #777;
        display: none;
    }

    .sidebyside {
        display: inline-block;
        width: 45%;
        min-height: 40px;
        text-align: left;
        vertical-align: top;
    }

    #headline {
        font-size: 40px;
        font-weight: 300;
    }

    #info {
        font-size: 20px;
        text-align: center;
        color: #777;
        visibility: hidden;
    }

    #results {
        font-size: 14px;
        font-weight: bold;
        border: 1px solid #ddd;
        padding: 15px;
        text-align: left;
        min-height: 150px;
    }

    #get_word {
        border: 0;
        background-color: transparent;
        padding: 0;
    }
</style>
<button id="get_word" onclick="getWord(event)">
    <img id="start_img" src="../../../resources/css/images/record.png" alt="Start" height="50" width="50">
</button>
<button id="get_text" onclick="startButton(event)">
    <img id="start_imge" src="../../../resources/css/images/listen.png" alt="Start" height="50" width="50">
</button>
<div id="word_quantity">
</div>
<div id="info">
    <p id="info_start">Click on the microphone icon and begin speaking.</p>

    <p id="info_speak_now">Speak now.</p>

    <p id="info_no_speech">No speech was detected. You may need to adjust your
        <a href="//support.google.com/chrome/bin/answer.py?hl=en&amp;answer=1407892">
            microphone settings</a>.</p>

    <p id="info_no_microphone" style="display:none">
        No microphone was found. Ensure that a microphone is installed and that
        <a href="//support.google.com/chrome/bin/answer.py?hl=en&amp;answer=1407892">
            microphone settings</a> are configured correctly.</p>

    <p id="info_allow">Click the "Allow" button above to enable your microphone.</p>

    <p id="info_denied">Permission to use microphone was denied.</p>

    <p id="info_blocked">Permission to use microphone is blocked. To change,
        go to chrome://settings/contentExceptions#media-stream</p>

    <p id="info_upgrade">Web Speech API is not supported by this browser.
        Upgrade to <a href="//www.google.com/chrome">Chrome</a>
        version 25 or later.</p>
</div>
<div id="results">
    <span id="final_span" class="final"></span>
    <span id="interim_span" class="interim"></span>
</div>
<div class="center">
    <%--<div id="div_language">--%>
        <%--<select id="select_language" style="visibility: hidden;" ></select>--%>
        <%--&nbsp;&nbsp;--%>
        <%--<select id="select_dialect" style="visibility: hidden;" ></select>--%>
    <%--</div>--%>
</div>
<script>
var user_word = '';
var langs =
        [
            ['English', ['en-GB']],
        ];
//for (var i = 0; i < langs.length; i++) {
//    select_language.options[i] = new Option(langs[i][0], i);
//}
var select_language  = langs[0][0];
updateCountry();
var  select_dialect = langs[0][1];
showInfo('info_start');
function updateCountry() {
//    for (var i = select_dialect.options.length - 1; i >= 0; i--) {
//        select_dialect.remove(i);
//    }
//    var list = langs[select_language.selectedIndex];
//    for (var i = 1; i < list.length; i++) {
//        select_dialect.options.add(new Option(list[i][1], list[i][0]));
//    }
//    select_dialect.style.visibility = list[1].length == 1 ? 'hidden' : 'visible';
}
var create_email = false;
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
        showInfo('info_speak_now');
        start_img.src = '../../../resources/css/images/mic-animate.gif';
    };
    recognition.onerror = function (event) {
        if (event.error == 'no-speech') {
            start_img.src = '../../../resources/css/images/mic.gif';
            showInfo('info_no_speech');
            ignore_onend = true;
        }
        if (event.error == 'audio-capture') {
            start_img.src = '../../../resources/css/images/mic.gif';
            showInfo('info_no_microphone');
            ignore_onend = true;
        }
        if (event.error == 'not-allowed') {
            if (event.timeStamp - start_timestamp < 100) {
                showInfo('info_blocked');
            } else {
                showInfo('info_denied');
            }
            ignore_onend = true;
        }
    };
    recognition.onend = function () {
        recognizing = false;
        if (ignore_onend) {
            return;
        }
        start_img.src = '../../../resources/css/images/mic.gif';
        if (!final_transcript) {
            showInfo('info_start');
            return;
        }
        showInfo('');
        if (window.getSelection) {
            window.getSelection().removeAllRanges();
            var range = document.createRange();
            range.selectNode(document.getElementById('final_span'));
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
        final_span.innerHTML = linebreak(final_transcript);
        interim_span.innerHTML = linebreak(interim_transcript);
        if (final_transcript || interim_transcript) {
            showButtons('inline-block');
        }
    };
}
function upgrade() {
    get_word.style.visibility = 'hidden';
    showInfo('info_upgrade');
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
function copyButton() {
    if (recognizing) {
        recognizing = false;
        recognition.stop();
    }
    showInfo('');
}
function getWord(event) {
    if (recognizing) {
        recognition.stop();
        user_word = interim_span.innerHTML ? interim_span.innerHTML : final_span.innerHTML;
        return;
    }
    final_transcript = '';
    recognition.lang = select_dialect.value;
    recognition.start();
    ignore_onend = false;
    final_span.innerHTML = '';
    interim_span.innerHTML = '';
    start_img.src = '../../../resources/css/images/mic-slash.gif';
    showInfo('info_allow');
    showButtons('none');
    start_timestamp = event.timeStamp;
}

function startButton(event) {
    if (recognizing) {
        recognition.stop();
        var result = interim_span.innerHTML ? interim_span.innerHTML : final_span.innerHTML;
        while(user_word.indexOf('*') > -1)
            user_word = user_word.replace('*','25A');
        while(result.indexOf('*') > -1)
            result = result.replace('*','25A');
        $.getJSON('/countWords', {
            word: user_word,
            text: result,
            ajax: 'true'
        }, function (data) {
            var html = data;
            $('#word_quantity').html(html);
        });
        return;
    }
    final_transcript = '';
    recognition.lang = select_dialect.value;
    recognition.start();
    ignore_onend = false;
    final_span.innerHTML = '';
    interim_span.innerHTML = '';
    start_img.src = '../../../resources/css/images/mic-slash.gif';
    showInfo('info_allow');
    showButtons('none');
    start_timestamp = event.timeStamp;
}
function showInfo(s) {
    if (s) {
        for (var child = info.firstChild; child; child = child.nextSibling) {
            if (child.style) {
                child.style.display = child.id == s ? 'inline' : 'none';
            }
        }
        info.style.visibility = 'visible';
    } else {
        info.style.visibility = 'hidden';
    }
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
