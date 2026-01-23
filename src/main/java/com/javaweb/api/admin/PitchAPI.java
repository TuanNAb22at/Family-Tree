package com.javaweb.api.admin;
import com.javaweb.model.request.BookingRequest;
import com.javaweb.model.request.PitchRentalReceiptRequest;
import com.javaweb.model.response.CustomerResponse;
import com.javaweb.model.response.RentalReceiptResponse;
import com.javaweb.service.CustomerService;
import com.javaweb.service.IPitchService;
import com.javaweb.service.IRentalReceiptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController(value = "pitchAPIOfAdmin")
@RequestMapping("/api/pitch")
public class PitchAPI {
    @Autowired
    private IRentalReceiptService rentalReceiptService;

    @Autowired
    private IPitchService pitchService;

    @Autowired
    private CustomerService customerService;

    @GetMapping("/searchCustomer")
    @ResponseBody
    public List<CustomerResponse> searchCustomer(@RequestParam("name") String name) {
        return customerService.findCustomerByName(name);
    }

    @PostMapping("/createBooking")
    @ResponseBody
    public List<RentalReceiptResponse> createBooking(@RequestBody BookingRequest request) {
        return rentalReceiptService.createBooking(request);
    }

    @PostMapping("/confirmbooking")
    public List<PitchRentalReceiptRequest> saveBooKing(@RequestBody PitchRentalReceiptRequest request) {
        return rentalReceiptService.saveBooKing(request);
    }

    @DeleteMapping("/delete/{id}")
    @ResponseBody
    public void deletePitch(@PathVariable Long id) {
        pitchService.deletePitch(id);
    }



}
