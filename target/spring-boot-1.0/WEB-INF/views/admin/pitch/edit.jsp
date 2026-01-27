<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/common/taglib.jsp" %>

<html>
<head>
    <title>Sửa sân bóng</title>
</head>

<body style="font-family: 'Times New Roman', Times, serif">

<div class="container mt-4">
    <div class="row justify-content-center">
        <div class="col-md-8">

            <div class="card border-primary">
                <div class="card-header bg-primary text-white">
                    <h5 class="mb-0">✏️ Sửa sân bóng</h5>
                </div>

                <div class="card-body">
                    <form action="/admin/pitch-save" method="post">
                        <!-- ID bắt buộc khi sửa -->
                        <input type="hidden" name="id" value="${pitch.id}"/>

                        <div class="form-group">
                            <label>Tên sân</label>
                            <input type="text" name="pitchName"
                                   class="form-control"
                                   value="${pitch.pitchName}"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Loại sân</label>
                            <select name="type" class="form-control" required>
                                <c:forEach var="t" items="${pitchTypes}">
                                    <option value="${t}"
                                        <c:if test="${t eq pitch.type}">selected</c:if>>
                                        ${t}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Giá thuê (VNĐ)</label>
                            <input type="number" name="price"
                                   class="form-control"
                                   min="0"
                                   value="${pitch.price}"
                                   required>
                        </div>

                        <div class="form-group">
                            <label>Mô tả</label>
                            <textarea name="description"
                                      class="form-control"
                                      rows="3">${pitch.description}</textarea>
                        </div>

                        <div class="text-center mt-4">
                            <button class="btn btn-primary px-4">💾 Cập nhật</button>
                            <a href="/admin/pitchs-list" class="btn btn-secondary px-4 ml-2">❌ Hủy</a>
                        </div>

                    </form>
                </div>

            </div>

        </div>
    </div>
</div>

</body>
</html>
