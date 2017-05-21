/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.pavikumbhar.javaheart.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 *
 * @author pravinkumbhar
 */
@Controller
public class Index {

    @RequestMapping
    public String index(ModelMap modelMap) {

        return "index";
    }

    
    @RequestMapping(value = "login",method = RequestMethod.GET)
    public String login(ModelMap modelMap) {

        return "login";
    }
    
     @RequestMapping(value = "login",method = RequestMethod.POST)
    public String loginRequest(ModelMap modelMap) {

        return "login";
    }
}
