package com.javaweb.entity;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
@Entity
@Table(name = "rental_receipt")
public class RentalReceiptEntity extends BaseEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "session_rental_price")
    private BigDecimal sessionRentalPrice;

    @Column(name = "start_date")
    private String startDate;

    @Column(name = "end_date")
    private String endDate;

    @Column(name = "deposit")
    private BigDecimal deposit;

    @Column(name = "total_price")
    private BigDecimal totalPrice;

    @Column(name = "status")
    private Integer status;


    @Override
    public Long getId() {
        return id;
    }

    @Override
    public void setId(Long id) {
        this.id = id;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public BigDecimal getDeposit() {
        return deposit;
    }

    public void setDeposit(BigDecimal deposit) {
        this.deposit = deposit;
    }

    public BigDecimal getSessionRentalPrice() {
        return sessionRentalPrice;
    }

    public void setSessionRentalPrice(BigDecimal sessionRentalPrice) {
        this.sessionRentalPrice = sessionRentalPrice;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "payment_invoice_id")
    private PaymentInvoiceEntity paymentInvoice;

    @OneToMany(mappedBy = "rentalReceipt", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<UsedItemEntity> usedItems = new ArrayList<>();

    @OneToMany(mappedBy = "rentalReceipt", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<PitchRentalDetailEntity> pitchRentalDetails = new ArrayList<>();

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "customer_id")
    private CustomerEntity customer;


    public PaymentInvoiceEntity getPaymentInvoice() {
        return paymentInvoice;
    }

    public void setPaymentInvoice(PaymentInvoiceEntity paymentInvoice) {
        this.paymentInvoice = paymentInvoice;
    }

    public List<UsedItemEntity> getUsedItems() {
        return usedItems;
    }

    public void setUsedItems(List<UsedItemEntity> usedItems) {
        this.usedItems = usedItems;
    }

    public List<PitchRentalDetailEntity> getPitchRentalDetails() {
        return pitchRentalDetails;
    }

    public void setPitchRentalDetails(List<PitchRentalDetailEntity> pitchRentalDetails) {
        this.pitchRentalDetails = pitchRentalDetails;
    }


    public CustomerEntity getCustomer() {
        return customer;
    }

    public void setCustomer(CustomerEntity customer) {
        this.customer = customer;
    }
}