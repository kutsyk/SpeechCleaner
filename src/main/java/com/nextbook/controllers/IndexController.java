package com.nextbook.controllers;

import com.nextbook.services.ISpeechService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;

/**
 * Created by Kutsyk on 03.10.2015.
 */

@Controller
public class IndexController{

    private String word;
    private String text;
    @Autowired
    private ISpeechService speechService;

    @RequestMapping(value = {"/"})
    public String desktop() {
        word = null;
        return "main/index";
    }

    @RequestMapping(value = {"/savedwords"})
    public @ResponseBody List<String> savedWords(HttpServletRequest request) {
        return speechService.getSavedWords(request);
    }

    @RequestMapping(value = {"/savetext"})
    public @ResponseBody String saveText(@RequestParam(value = "text", required = true) String text,
                                         HttpServletRequest request, HttpServletResponse response) {
        if (word==null) {
            speechService.addWordToCookies(text, request, response);
            return word = text;
        } else {
            this.text = text;
        }
        System.out.println(word);
        System.out.println(text);
        for (Cookie c:request.getCookies())
            System.out.println(c.getValue());
        return speechService.countRepetitions(word, text)+"";
    }

}
