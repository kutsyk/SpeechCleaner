package com.linguahack.services;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Set;

/**
 * Created by KutsykV on 03.10.2015.
 */
public interface ISpeechService {

    int countRepetitions(String word, String text);

    void addWordToCookies(String word, HttpServletRequest request, HttpServletResponse response);

    Set<String> getSavedWords(HttpServletRequest request);
}
