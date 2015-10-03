package com.nextbook.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import java.util.*;

/**
 * Created by Polomani on 09.07.2015.
 */

@Controller
public class IndexController {

    @RequestMapping(value = {"/"})
    public String desktop(Model model, Locale locale) {
        return "main/index";
    }

}
