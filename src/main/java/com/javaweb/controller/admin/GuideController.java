package com.javaweb.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller(value = "guideControllerOfAdmin")
public class GuideController {

    @RequestMapping(value = "/admin/guide", method = RequestMethod.GET)
    public ModelAndView guidePage() {
        return new ModelAndView("admin/guide/index");
    }
}
