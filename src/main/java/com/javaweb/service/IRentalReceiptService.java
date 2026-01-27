package com.javaweb.service;

import com.javaweb.model.request.BookingRequest;
import com.javaweb.model.request.PitchRentalReceiptRequest;
import com.javaweb.model.response.RentalReceiptResponse;
import com.javaweb.model.response.ResponseDTO;
import org.springframework.web.bind.annotation.RequestBody;

import java.util.List;

public interface IRentalReceiptService {
    RentalReceiptResponse createBooking(@RequestBody BookingRequest request);
    public ResponseDTO saveBooKing(@RequestBody PitchRentalReceiptRequest request);
}
