package com.nextbook.controllers;

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

    @RequestMapping(value = {"/"})
    public String desktop() {
        return "main/index";
    }

    @RequestMapping(value = {"/query"})
    public @ResponseBody String Query(@RequestParam String text) {
        if (word==null)
            return word = text;
        else
            this.text = text;
        return "result of counting";
    }

}
