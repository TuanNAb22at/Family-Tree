package com.javaweb.repository;

import com.javaweb.entity.PaymentInvoiceEntity;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PaymentInvoiceRepository extends JpaRepository<PaymentInvoiceEntity,Long> {
}
