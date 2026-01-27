package com.javaweb.service;

import com.javaweb.entity.PitchEntity;
import com.javaweb.model.dto.PitchDTO;
import com.javaweb.model.response.PitchSearchResponse;

import java.util.List;

public interface IPitchService {
    PitchDTO savePitch(PitchDTO pitchDTO);
    PitchDTO updatePitch(PitchDTO pitchDTO);
    PitchDTO findById(Long id);
    List<PitchSearchResponse> getAvailablePitches(String startDate, String endDate, String pitchTypeId);
    List<PitchSearchResponse> findAvailablePitchesToday();
    List<String> getAllPitchTypes();
    void deletePitch(Long id);
}
