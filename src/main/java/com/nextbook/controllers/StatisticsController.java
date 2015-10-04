package com.nextbook.controllers;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * Created by Polomani on 04.10.2015.
 */

@Controller
public class StatisticsController {
    @RequestMapping(value = {"/statistics"})
    public String statistics(Model model) {
        RestTemplate restTemplate = new RestTemplate();
        String res = restTemplate.getForObject("https://speech-json.azure-mobile.net/tables/speech", String.class);
        JSONArray jsonArray = null;
        HashMap<String, Integer> hashMap= new HashMap<String, Integer>();
        try {
            jsonArray = (JSONArray) new JSONParser().parse(res);
            for (Object obj:jsonArray) {
                String str = (String) ((JSONObject) obj).get("message");
                str = str.substring(1);
                str = str.substring(0, str.length()-1);
                String word = (String)(((JSONObject)new JSONParser().parse(str)).get("word"));
                if (word!=null && word.length()>0)
                    if (hashMap.containsKey(word))
                        hashMap.put(word, hashMap.get(word)+1);
                    else
                        hashMap.put(word, 1);
            }
        } catch (ParseException e) {
            e.printStackTrace();
        }
        model.addAttribute("data", hashMap);
        return "main/statistics";
    }
}
