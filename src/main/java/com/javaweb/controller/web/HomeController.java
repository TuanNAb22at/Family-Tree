package com.javaweb.controller.web;
import com.javaweb.exception.MyException;
import com.javaweb.model.request.BuildingSearchRequest;
import com.javaweb.service.IActivityLogService;
import com.javaweb.service.IUserService;
import com.javaweb.utils.MessageUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.servlet.ModelAndView;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Map;
import java.time.LocalDate;

@Controller(value = "homeControllerOfWeb")
public class HomeController {

    @Autowired
    private IUserService userService;

    @Autowired
    private MessageUtils messageUtils;

    @Autowired
    private IActivityLogService activityLogService;

    @RequestMapping(value = "/trang-chu", method = RequestMethod.GET)
    public ModelAndView homePage(BuildingSearchRequest buildingSearchRequest, HttpServletRequest request) {
        ModelAndView mav = new ModelAndView("web/home");
        mav.addObject("modelSearch", buildingSearchRequest);
        return mav;
    }

    @GetMapping(value="/gioi-thieu")
    public ModelAndView introducceBuiding(){
        ModelAndView mav = new ModelAndView("web/introduce");
        return mav;
    }

    @GetMapping(value="/san-pham")
    public ModelAndView buidingList(){
        ModelAndView mav = new ModelAndView("/web/list");
        return mav;
    }

    @GetMapping(value="/tin-tuc")
    public ModelAndView news(){
        ModelAndView mav = new ModelAndView("/web/news");
        return mav;
    }

    @GetMapping(value="/lien-he")
    public ModelAndView contact(){
        ModelAndView mav = new ModelAndView("/web/contact");
        return mav;
    }

    @GetMapping("/dang-ky")
    public ModelAndView register(@RequestParam(value = "message", required = false) String message,
                                 HttpServletRequest request) {
        return buildRegisterModelAndView(message, request);
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView login() {
        ModelAndView mav = new ModelAndView("login");
        return mav;
    }

    @GetMapping(value = "/register")
    public ModelAndView registerPage(@RequestParam(value = "message", required = false) String message,
                                     HttpServletRequest request) {
        return buildRegisterModelAndView(message, request);
    }

    @PostMapping(value = "/register")
    public ModelAndView register(@RequestParam("fullName") String fullName,
                                 @RequestParam("userName") String userName,
                                 @RequestParam("gender") String gender,
                                 @RequestParam("dob") String dob,
                                 @RequestParam(value = "email", required = false) String email,
                                 @RequestParam(value = "phone", required = false) String phone,
                                 @RequestParam("password") String password,
                                 @RequestParam("confirmPassword") String confirmPassword,
                                 RedirectAttributes redirectAttributes) {
        try {
            LocalDate dobValue = StringUtils.isBlank(dob) ? null : LocalDate.parse(dob.trim());
            userService.register(fullName, userName, gender, dobValue, email, phone, password, confirmPassword);
            redirectAttributes.addFlashAttribute("registerSuccessMessage", "Dang ky thanh cong. Vui long dang nhap.");
            return new ModelAndView("redirect:/login");
        } catch (MyException exception) {
            String message = StringUtils.defaultIfBlank(exception.getMessage(), "register_fail");
            return new ModelAndView("redirect:/register?message=" + message);
        } catch (Exception exception) {
            return new ModelAndView("redirect:/register?message=register_fail");
        }
    }

    @RequestMapping(value = "/access-denied", method = RequestMethod.GET)
    public ModelAndView accessDenied(HttpServletRequest request) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated()) {
            activityLogService.logAccessDenied(auth.getName(), request, request.getRequestURI());
        }
        return new ModelAndView("redirect:/login?accessDenied");
    }

    @RequestMapping(value = "/logout", method = RequestMethod.GET)
    public ModelAndView logout(HttpServletRequest request, HttpServletResponse response, HttpSession session) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null) {
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return new ModelAndView("redirect:/trang-chu");
    }

    private ModelAndView buildRegisterModelAndView(String message, HttpServletRequest request) {
        ModelAndView mav = new ModelAndView("register");
        String normalizedMessage = StringUtils.trimToEmpty(message);
        if (StringUtils.isBlank(normalizedMessage)) {
            if (request.getParameter("register_required_fields") != null) normalizedMessage = "register_required_fields";
            else if (request.getParameter("register_confirm_password_not_match") != null) normalizedMessage = "register_confirm_password_not_match";
            else if (request.getParameter("register_username_existed") != null) normalizedMessage = "register_username_existed";
            else if (request.getParameter("register_gender_invalid") != null) normalizedMessage = "register_gender_invalid";
            else if (request.getParameter("register_role_not_found") != null) normalizedMessage = "register_role_not_found";
            else if (request.getParameter("register_fail") != null) normalizedMessage = "register_fail";
        }
        if (StringUtils.isNotBlank(normalizedMessage)) {
            Map<String, String> messageMap = messageUtils.getMessage(normalizedMessage);
            mav.addObject("alert", messageMap.get("alert"));
            mav.addObject("messageResponse", messageMap.get("messageResponse"));
        }
        return mav;
    }
}
