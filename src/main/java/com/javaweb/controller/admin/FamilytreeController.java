package com.javaweb.controller.admin;

import com.javaweb.repository.PersonRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller(value = "FamilytreeControllerOfAdmin")
public class FamilytreeController {
    @Autowired
    private PersonRepository personRepository;

    @RequestMapping(value = "/admin/familytree", method = RequestMethod.GET)
    public ModelAndView familytreePage() {
        ModelAndView mav = new ModelAndView("admin/family-tree/familytree");
        long totalMembers = personRepository.countByBranchIsNotNull();
        Integer maxGeneration = personRepository.findMaxGenerationByBranchIsNotNull();
        int totalGenerations = (maxGeneration == null || maxGeneration <= 0) ? 1 : maxGeneration;
        mav.addObject("totalMembers", totalMembers);
        mav.addObject("totalGenerations", totalGenerations);
        return mav;
    }
}
