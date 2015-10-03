package com.nextbook.controllers;

import com.nextbook.services.ISpeechService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
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


    @RequestMapping(value = {"/savetext"})
    public @ResponseBody String saveText(@RequestParam(value = "text", required = true) String text) {
        if (word==null)
            return word = text;
        else
            this.text = text;
        System.out.println(word);
        System.out.println(text);
        return speechService.countRepetitions(word, text)+"";
    }

}
