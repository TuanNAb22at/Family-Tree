package com.javaweb.service;

import com.javaweb.model.dto.PaymentInvoiceDTO;

import java.util.List;

public interface IPaymentIvoiceService {
    PaymentInvoiceDTO createInvoice(List<Long> receiptIds);
    void saveInvoice(Long customerId, List<Long> receiptIds);
}
