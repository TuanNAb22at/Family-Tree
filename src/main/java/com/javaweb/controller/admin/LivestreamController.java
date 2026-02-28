package com.javaweb.controller.admin;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

@Controller(value = "LivestreamControllerOfAdmin")
public class LivestreamController {

    private static final String DEFAULT_ICE_SERVERS_JSON = "[{\"urls\":\"stun:stun.l.google.com:19302\"},{\"urls\":\"stun:stun1.l.google.com:19302\"}]";

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Value("${livestream.webrtc.ice-servers-json:[]}")
    private String configuredIceServersJson;

    @RequestMapping(value = "/admin/livestream", method = RequestMethod.GET)
    public ModelAndView livestreamPage() {
        ModelAndView mav = new ModelAndView("admin/livestream/livestream");
        mav.addObject("livestreamIceServersJson", resolveIceServersJson());
        return mav;
    }

    private String resolveIceServersJson() {
        String raw = configuredIceServersJson == null ? "" : configuredIceServersJson.trim();
        if (raw.isEmpty()) {
            return DEFAULT_ICE_SERVERS_JSON;
        }
        try {
            JsonNode node = objectMapper.readTree(raw);
            if (!node.isArray() || node.size() == 0) {
                return DEFAULT_ICE_SERVERS_JSON;
            }
            return node.toString();
        } catch (Exception ex) {
            return DEFAULT_ICE_SERVERS_JSON;
        }
    }
}
