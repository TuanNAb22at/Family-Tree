package com.javaweb.converter;
import com.javaweb.entity.RentalReceiptEntity;
import com.javaweb.model.dto.RentalReceiptDTO;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
@Component
public class RentalRecieptConverter {
    @Autowired
    private ModelMapper modelMapper;
    public RentalReceiptDTO toRentalRecieptDTO(RentalReceiptEntity rentalReceipt) {
        RentalReceiptDTO rentalReceiptDTO = modelMapper.map(rentalReceipt, RentalReceiptDTO.class);
        rentalReceiptDTO.setTotalPrice(rentalReceipt.getTotalPrice());
        return  rentalReceiptDTO;
    }
    public RentalReceiptEntity toEntity(RentalReceiptDTO rentalReceiptDTO) {
        return modelMapper.map(rentalReceiptDTO, RentalReceiptEntity.class);
    }
}
