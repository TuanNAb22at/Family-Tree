package com.javaweb.model.dto;

import java.math.BigDecimal;

public class RentalReceiptDTO extends AbstractDTO<RentalReceiptDTO>{
    private Long id;
    private String startDate;
    private String endDate;
    private BigDecimal deposit;
    private BigDecimal sessionRentalPrice;
    private BigDecimal totalPrice;
    private String pitchName;
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

    public String getPitchName() {
        return pitchName;
    }

    public void setPitchName(String pitchName) {
        this.pitchName = pitchName;
    }
}
