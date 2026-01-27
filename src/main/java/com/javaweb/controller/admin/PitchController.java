package com.javaweb.controller.admin;
import com.javaweb.model.dto.PitchDTO;
import com.javaweb.model.response.PitchSearchResponse;
import com.javaweb.service.IPitchService;
import com.javaweb.service.impl.PitchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import java.util.ArrayList;
import java.util.List;
@Transactional
@Controller(value = "PitchControllerOfAdmin")
public class PitchController {
    @Autowired
    private IPitchService pitchService;

    @RequestMapping(value = "/admin/pitchs-list",method = RequestMethod.GET)
    public ModelAndView getListPitchs( @RequestParam(name = "startDate",required = false) String startDateStr,
                                       @RequestParam(name = "endDate",required = false) String endDateStr,
                                       @RequestParam(name = "pitchTypeId",required = false) String pitchTypeId) {
        ModelAndView mav = new ModelAndView("/admin/pitch/list");
        List<String> pitchTypes = pitchService.getAllPitchTypes();
        mav.addObject("pitchTypes", pitchTypes);
        mav.addObject("selectedPitchType", pitchTypeId);
        List<PitchSearchResponse> pitchList = new ArrayList<>();
        if (startDateStr != null && endDateStr!=null){
            pitchList = pitchService.getAvailablePitches(startDateStr,endDateStr,pitchTypeId);
        }
        else {
            pitchList = pitchService.findAvailablePitchesToday();
        }
        mav.addObject("pitchList",pitchList);
        return mav;
    }

    @GetMapping("/admin/pitch-add")
    public ModelAndView addPitch() {
        ModelAndView mav = new ModelAndView("/admin/pitch/add");
        mav.addObject("pitchTypes", pitchService.getAllPitchTypes());
        return mav;
    }

    @GetMapping("/admin/pitch-edit")
    public ModelAndView editPitch(@RequestParam("id") Long id) {
        ModelAndView mav = new ModelAndView("/admin/pitch/edit");
        PitchDTO pitchDTO = pitchService.findById(id);
        mav.addObject("pitch", pitchDTO);
        mav.addObject("pitchTypes", pitchService.getAllPitchTypes());
        return mav;
    }

    @RequestMapping(value = "/admin/pitch-save", method = RequestMethod.POST)
    public ModelAndView savePitchAndEdit(@ModelAttribute PitchDTO pitchDTO) {
        if (pitchDTO.getId() == null) {
            pitchService.savePitch(pitchDTO);
        } else {
            pitchService.updatePitch(pitchDTO);
        }
        return new ModelAndView("redirect:/admin/pitchs-list");
    }

}

