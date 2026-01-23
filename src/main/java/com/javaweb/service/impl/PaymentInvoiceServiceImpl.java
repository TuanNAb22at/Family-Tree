package com.javaweb.service.impl;

import com.javaweb.converter.CustomerConverter;
import com.javaweb.entity.CustomerEntity;
import com.javaweb.entity.PaymentInvoiceEntity;
import com.javaweb.entity.RentalReceiptEntity;
import com.javaweb.model.dto.CustomerDTO;
import com.javaweb.model.dto.PaymentInvoiceDTO;
import com.javaweb.repository.CustomerRepository;
import com.javaweb.repository.PaymentInvoiceRepository;
import com.javaweb.repository.RentalReceiptRepository;
import com.javaweb.service.IPaymentIvoiceService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@Service
public class PaymentInvoiceServiceImpl implements IPaymentIvoiceService {
    @Autowired
    RentalReceiptRepository rentalReceiptRepository;

    @Autowired
    CustomerConverter customerConverter;

    @Autowired
    CustomerRepository customerRepository;

    @Autowired
    PaymentInvoiceRepository paymentInvoiceRepository;
    @Override
    public PaymentInvoiceDTO createInvoice(List<Long> receiptIds) {
        PaymentInvoiceDTO paymentInvoiceDTO = new PaymentInvoiceDTO();
        BigDecimal totalPrice = BigDecimal.ZERO;
        RentalReceiptEntity r = rentalReceiptRepository.findById(receiptIds.get(0)).get();
        CustomerDTO customerDTO = customerConverter.toCustomerDTO(r.getCustomer());
        for(long id : receiptIds){
            RentalReceiptEntity rentalReceiptEntity = rentalReceiptRepository.findById(id).get();
            totalPrice = totalPrice.add(rentalReceiptEntity.getTotalPrice());
        }
        paymentInvoiceDTO.setCustomer(customerDTO);
        paymentInvoiceDTO.setReceiptIds(receiptIds);
        paymentInvoiceDTO.setTotalPrice(totalPrice);
        paymentInvoiceDTO.setPaymentDate(LocalDateTime.now().toString());
        return paymentInvoiceDTO;
    }

    @Override
    public void saveInvoice(Long customerId, List<Long> receiptIds) {
        BigDecimal totalPrice = BigDecimal.ZERO;
        PaymentInvoiceEntity paymentInvoiceEntity = new PaymentInvoiceEntity();
        CustomerEntity customerEntity = customerRepository.findById(customerId).get();
        for(long id : receiptIds){
            RentalReceiptEntity rentalReceiptEntity = rentalReceiptRepository.findById(id).get();
            totalPrice = totalPrice.add(rentalReceiptEntity.getTotalPrice());
        }
        paymentInvoiceEntity.setCustomer(customerEntity);
        paymentInvoiceEntity.setTotalPrice(totalPrice);
        paymentInvoiceEntity.setPaymentDate(LocalDateTime.now().toString());
        paymentInvoiceRepository.save(paymentInvoiceEntity);

        for(long id : receiptIds){
            RentalReceiptEntity rentalReceiptEntity = rentalReceiptRepository.findById(id).get();
            rentalReceiptEntity.setStatus(1);
            rentalReceiptEntity.setPaymentInvoice(paymentInvoiceEntity);
        }
    }
}
