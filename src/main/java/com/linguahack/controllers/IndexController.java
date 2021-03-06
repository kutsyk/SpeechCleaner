package com.linguahack.controllers;

import com.linguahack.services.ISpeechService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * Created by Kutsyk on 03.10.2015.
 */

@Controller
public class IndexController{

    @Autowired
    private ISpeechService speechService;

    @RequestMapping(value = {"/"})
    public String desktop() {
        return "main/index";
    }

    @RequestMapping(value = {"/savedwords"})
    public @ResponseBody Set<String> savedWords(HttpServletRequest request) {
        return speechService.getSavedWords(request);
    }

    @RequestMapping(value = {"/countWords"})
    public @ResponseBody String countWords(@RequestParam(value = "word", required = true) String word,
                                           @RequestParam(value = "text", required = true) String text,
                                           HttpServletRequest request, HttpServletResponse response) {
        word = word.toLowerCase();
        text = text.toLowerCase();
        speechService.addWordToCookies(word, request, response);
        return speechService.countRepetitions(word, text)+"";
    }

}
