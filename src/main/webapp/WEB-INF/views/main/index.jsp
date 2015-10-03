<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="security" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="/resources/js/jquery-2.1.3.min.js"></script>
    <script src="/resources/js/jquery.validate.min.js"></script>

    <link rel="stylesheet" type="text/css" href="/resources/css/template_style.css"/>
</head>
<body>
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
</div>
<script>
    var user_word = '';
    var langs =
            [
                ['English', ['en-GB']]
            ];
    var select_language = langs[0][0];
    var select_dialect = langs[0][1];
    showInfo('info_start');
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
        user_word = '';
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
    function getResultForText() {
        if (interim_span.innerHTML) {
            if (final_span.innerHTML)
                return final_span.innerHTML + interim_span.innerHTML;
            else
                return interim_span.innerHTML;
        } else return final_span.innerHTML;
    }

    function startButton(event) {
        if (recognizing) {
            recognition.stop();
            var result = getResultForText();
            while (user_word.indexOf('*') > -1)
                user_word = user_word.replace('*', '25A');
            while (result.indexOf('*') > -1)
                result = result.replace('*', '25A');
            console.log(interim_span.innerHTML);
            console.log(final_span.innerHTML);
            console.log(user_word);
            console.log(result);
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
