package com.javaweb.controller.admin;

import com.javaweb.model.dto.PaymentInvoiceDTO;
import com.javaweb.model.dto.PitchDTO;
import com.javaweb.model.dto.RentalReceiptDTO;
import com.javaweb.model.response.CustomerResponse;
import com.javaweb.service.CustomerService;
import com.javaweb.service.IPaymentIvoiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.sql.SQLOutput;
import java.util.ArrayList;
import java.util.List;

@Transactional
@Controller(value = "PaymentControllerOfAdmin")
public class PaymentController {
    @Autowired
    private CustomerService customerService;

    @Autowired
    private IPaymentIvoiceService iPaymentIvoiceService;

    @RequestMapping(value = "/admin/payment-list", method = RequestMethod.GET)
    public ModelAndView getListCustomer(@RequestParam(name = "customerName", required = false) String customerName) {
        ModelAndView mav = new ModelAndView("/admin/payment/listCustomer");
        List<CustomerResponse> listCustomer = new ArrayList<>();
        if (customerName != null) {
            listCustomer = customerService.findCustomerByName(customerName);
        }
        mav.addObject("customerList", listCustomer);
        return mav;
    }

    @GetMapping("/admin/retalreciept-list")
    public ModelAndView getListRentalReciept(@RequestParam("id") Long id) {
        ModelAndView mav = new ModelAndView("/admin/payment/listRentalReceipt");
        List<RentalReceiptDTO> rentalReceiptDTOS = customerService.findByCustomerIdAndStatus(id, 0);
        mav.addObject("rentalReciptList", rentalReceiptDTOS);
        return mav;
    }

    @GetMapping(value = "/admin/create-invoice")
    public ModelAndView createInvoice(@RequestParam("rentalReceiptIds") List<Long> receiptIds) {
        ModelAndView mav = new ModelAndView("/admin/payment/paymentInvoice");
        PaymentInvoiceDTO paymentInvoiceDTO = iPaymentIvoiceService.createInvoice(receiptIds);
        mav.addObject("paymentInvoiceDTO", paymentInvoiceDTO);
        return mav;
    }

    @PostMapping("/admin/payment-confirm")
    public ModelAndView confirmPayment(
            @RequestParam Long customerId,
            @RequestParam List<Long> receiptIds) {
            iPaymentIvoiceService.saveInvoice(customerId, receiptIds);
        return new ModelAndView(
                "redirect:/admin/retalreciept-list?id=" + customerId
        );
    }

}
