package com.nextbook.services.impl;

import com.nextbook.services.ISpeechService;
import org.springframework.stereotype.Service;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.HashSet;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by KutsykV on 03.10.2015.
 */
@Service
public class SpeechServiceImpl implements ISpeechService {

    @Override
    public int countRepetitions(String word, String text) {
        int matches = 0;
        Matcher matcher = Pattern.compile(word).matcher(text);
        while (matcher.find()) matches++;
        return matches;
    }

    @Override
    public void addWordToCookies(String word, HttpServletRequest request, HttpServletResponse response) {
        for (Cookie c : request.getCookies()) {
            if (c.getName().equals("words")) {
                if (countRepetitions(word, c.getValue()) == 0) {
                    Cookie cookie = new Cookie("words", c.getValue() + " " + word);
                    cookie.setSecure(false);
                    response.addCookie(cookie);
                }
                return;
            }
            Cookie cookie = new Cookie("words", word);
            cookie.setSecure(false);
            response.addCookie(cookie);
        }
    }

    @Override
    public Set<String> getSavedWords(HttpServletRequest request) {
        Set<String> res = new HashSet<String>();
        if (request.getCookies() != null)
            for (Cookie c : request.getCookies())
                if (c.getName().equals("words")) {
                    String[] words = c.getValue().split(" ");
                    for (int i = 0; i < words.length; ++i)
                        if (words[i].length() > 0) res.add(words[i]);
                }
        return res;
    }


}
