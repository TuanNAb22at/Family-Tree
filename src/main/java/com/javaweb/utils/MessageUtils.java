package com.javaweb.utils;

import com.javaweb.constant.SystemConstant;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;

@Component
public class MessageUtils {

	public Map<String, String> getMessage(String message) {
		Map<String, String> result = new HashMap<>();
		String responseText = "";
		String alertType = "info";
		if (message.equals("update_success")) {
			responseText = "Cap nhat thanh cong";
			alertType = "success";
		} else if (message.equals("insert_success")) {
			responseText = "Them moi thanh cong";
			alertType = "success";
		} else if (message.equals("delete_success")) {
			responseText = "Xoa thanh cong";
			alertType = "success";
		} else if (message.equals("error_system")) {
			responseText = "Co loi he thong";
			alertType = "danger";
		} else if (message.equals("register_required_fields")) {
			responseText = "Vui long nhap day du thong tin bat buoc.";
			alertType = "danger";
		} else if (message.equals("register_confirm_password_not_match")) {
			responseText = "Mat khau xac nhan khong khop.";
			alertType = "danger";
		} else if (message.equals("register_username_existed")) {
			responseText = "Ten dang nhap da ton tai.";
			alertType = "danger";
		} else if (message.equals("register_gender_invalid")) {
			responseText = "Gioi tinh khong hop le.";
			alertType = "danger";
		} else if (message.equals("register_role_not_found")) {
			responseText = "Khong tim thay vai tro mac dinh cho tai khoan.";
			alertType = "danger";
		} else if (message.equals("register_fail")) {
			responseText = "Dang ky that bai. Vui long thu lai.";
			alertType = "danger";
		}
		result.put("message", responseText);
		result.put(SystemConstant.MESSAGE_RESPONSE, responseText);
		result.put("alert", alertType);
		return result;
	}
}
