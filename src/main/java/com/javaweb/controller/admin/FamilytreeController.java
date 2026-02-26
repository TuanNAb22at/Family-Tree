package com.javaweb.controller.admin;

import com.javaweb.model.dto.PersonDTO;
import com.javaweb.repository.PersonRepository;
import com.javaweb.service.IPersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller(value = "FamilytreeControllerOfAdmin")
public class FamilytreeController {
    @RequestMapping(value = "/admin/familytree", method = RequestMethod.GET)
    public ModelAndView familytreePage() {
        ModelAndView mav = new ModelAndView("admin/family-tree/familytree");
        return mav;
    }
}
