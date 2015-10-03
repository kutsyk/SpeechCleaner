package com.nextbook.services.impl;

import antlr.StringUtils;
import com.ctc.wstx.util.StringUtil;
import com.nextbook.services.ISpeechService;
import org.springframework.stereotype.Service;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by KutsykV on 03.10.2015.
 */
@Service
public class SpeechServiceImpl implements ISpeechService{

    @Override
    public int countRepetitions(String word, String text) {
        int matches = 0;
        Matcher matcher = Pattern.compile(text, Pattern.CASE_INSENSITIVE).matcher(word);
        while (matcher.find()) matches++;
        return matches;
    }
}
