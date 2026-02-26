package com.javaweb.controller.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller(value = "LivestreamControllerOfAdmin")
public class LivestreamController {

    @RequestMapping(value = "/admin/livestream", method = RequestMethod.GET)
    public ModelAndView livestreamPage() {
        return new ModelAndView("admin/livestream/livestream");
    }
}
