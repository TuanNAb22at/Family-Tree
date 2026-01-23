package com.javaweb.model.dto;

import com.javaweb.entity.CustomerEntity;

import java.math.BigDecimal;
import java.util.List;

public class PaymentInvoiceDTO {
    private Long id;
    private String paymentMethod;
    private String paymentDate;
    private BigDecimal totalPrice;
    private List<Long> receiptIds;
    private CustomerDTO customer;
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(String paymentDate) {
        this.paymentDate = paymentDate;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public List<Long> getReceiptIds() {
        return receiptIds;
    }

    public void setReceiptIds(List<Long> receiptIds) {
        this.receiptIds = receiptIds;
    }

    public CustomerDTO getCustomer() {
        return customer;
    }

    public void setCustomer(CustomerDTO customer) {
        this.customer = customer;
    }
}
