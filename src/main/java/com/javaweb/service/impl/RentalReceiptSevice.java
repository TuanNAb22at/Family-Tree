package com.javaweb.service.impl;
import com.javaweb.converter.CustomerConverter;
import com.javaweb.converter.pitchConverter;
import com.javaweb.entity.CustomerEntity;
import com.javaweb.entity.PitchEntity;
import com.javaweb.entity.PitchRentalDetailEntity;
import com.javaweb.entity.RentalReceiptEntity;
import com.javaweb.model.dto.CustomerDTO;
import com.javaweb.model.dto.PitchDTO;
import com.javaweb.model.request.BookingRequest;
import com.javaweb.model.request.PitchRentalReceiptRequest;
import com.javaweb.model.response.RentalReceiptResponse;
import com.javaweb.repository.CustomerRepository;
import com.javaweb.repository.PitchRentalDetailRepository;
import com.javaweb.repository.PitchRepository;
import com.javaweb.repository.RentalReceiptRepository;
import com.javaweb.service.IRentalReceiptService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.transaction.Transactional;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

@Service
@Transactional
public class RentalReceiptSevice implements IRentalReceiptService {
    @Autowired
    private PitchRepository pitchRepository;
    @Autowired
    private CustomerRepository customerRepository;
    @Autowired
    private pitchConverter pitchDTOConverter;
    @Autowired
    private CustomerConverter customerConverter;

    @Autowired
    private RentalReceiptRepository rentalReceiptRepository;

    @Autowired
    private PitchRentalDetailRepository pitchRentalDetailRepository;

    @Override
    public List<RentalReceiptResponse> createBooking(BookingRequest request) {

        Long pitchId = request.getPitchId();
        Long customerId = request.getCustomerId();
        LocalDate startDate = LocalDate.parse(request.getStartDate());
        LocalDate endDate = LocalDate.parse(request.getEndDate());

        // find pitch and customer by id
        PitchEntity pitchEntity = pitchRepository.findById(pitchId).orElse(null);
        PitchDTO pitchDTO = pitchDTOConverter.toPitchDTO(pitchEntity);
        CustomerEntity customerEntity =  customerRepository.findById(customerId).orElse(null);
        CustomerDTO  customerDTO = customerConverter.toCustomerDTO(customerEntity);

        // tinh ngay va tong gia tien
        long daysBetween = ChronoUnit.DAYS.between(startDate, endDate) + 1;
        Double totalPrice = daysBetween * pitchDTO.getPrice();

        //getCreate booking
        RentalReceiptResponse rentalReceiptResponse  = new RentalReceiptResponse();
        rentalReceiptResponse.setIdKH(customerId);
        rentalReceiptResponse.setIdPitch(pitchId);
        rentalReceiptResponse.setTenKH(customerDTO.getFullname());
        rentalReceiptResponse.setTotalPrice(totalPrice);
        rentalReceiptResponse.setDeposit(totalPrice*0.1);
        rentalReceiptResponse.setPitchName(pitchDTO.getPitchName());
        rentalReceiptResponse.setPitchType(pitchDTO.getDescription());
        rentalReceiptResponse.setTotalDay(daysBetween);
        rentalReceiptResponse.setCustomerPhone(customerDTO.getPhone());
        rentalReceiptResponse.setNgayBD(startDate);
        rentalReceiptResponse.setNgayKT(endDate);
        List<RentalReceiptResponse> RentalReceiptResponses = new ArrayList<>();
        RentalReceiptResponses.add(rentalReceiptResponse);
        return RentalReceiptResponses;
    }

    @Override
    public List<PitchRentalReceiptRequest> saveBooKing(PitchRentalReceiptRequest request) {
        List<PitchRentalReceiptRequest> pitchRentalReceiptRequests =  new ArrayList<>();
        Long pitchId = request.getIdPitch();
        Long customerId = request.getIdKH();
        LocalDate startDate = request.getNgayBD();
        LocalDate endDate = request.getNgayKT();

        PitchEntity pitchEntity = pitchRepository.findById(pitchId).orElse(null);
        CustomerEntity customerEntity =  customerRepository.findById(customerId).orElse(null);

        RentalReceiptEntity r = new RentalReceiptEntity();
        r.setCustomer(customerEntity);
        r.setDeposit(request.getDeposit());
        r.setTotalPrice(request.getTotalPrice());
        r.setSessionRentalPrice(pitchEntity.getPrice());
        r.setStartDate(startDate.toString());
        r.setEndDate(endDate.toString());
        r.setStatus(0);
        rentalReceiptRepository.save(r);

        PitchRentalDetailEntity p = new PitchRentalDetailEntity();
        p.setRentalReceipt(r);
        p.setPitch(pitchEntity);
        p.setStDate(startDate.toString());
        p.setEndDate(endDate.toString());
        pitchRentalDetailRepository.save(p);

        return pitchRentalReceiptRequests;

    }
}
