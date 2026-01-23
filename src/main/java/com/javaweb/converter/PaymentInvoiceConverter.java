package com.javaweb.converter;

import com.javaweb.entity.PaymentInvoiceEntity;
import com.javaweb.model.dto.CustomerDTO;
import com.javaweb.model.dto.PaymentInvoiceDTO;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class PaymentInvoiceConverter {
    @Autowired
    private ModelMapper modelMapper;
    public PaymentInvoiceDTO toPaymentInvoiceDTO(PaymentInvoiceEntity paymentInvoiceEntity){
        PaymentInvoiceDTO paymentInvoiceDTO = modelMapper.map(paymentInvoiceEntity, PaymentInvoiceDTO.class);
        return paymentInvoiceDTO;
    }

    public PaymentInvoiceEntity toPaymentInvoiceEntity(PaymentInvoiceDTO paymentInvoiceDTO){
        PaymentInvoiceEntity paymentInvoiceEntity = modelMapper.map(paymentInvoiceDTO,PaymentInvoiceEntity.class);
        return paymentInvoiceEntity;
    }
}
