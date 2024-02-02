<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<jsp:include page="${path}/template/module/module_main.jsp" flush="true"/>
<style>
    #myModal .modal-dialog {
        max-width: 50%; /* 모달의 최대 너비를 80%로 설정 */
    }

    /* 입력 요소 여백 조절 */
    #myModal .form-group {
        margin-bottom: 15px; /* 각 입력 요소 아래 여백 조절 */
        margin-left: 3%;
        margin-right: 8%;
    }

    #myModal .form-control {
        margin-right: 3%; /* 입력 요소 오른쪽 여백 조절 */
        margin-left: 3%; /* 입력 요소 왼쪽 여백 조절 */
    }

    #searchResults {
        height: 150px;
        overflow-y: auto;
    }

</style>
<script>
    $(document).ready(function () {
        $("#clsBtn").click(function () {
            $("#modelFrm")[0].reset()
        })
        $("#xBtn").click(function () {
            $("#modelFrm")[0].reset()
        })
    })

    function uptConfirm(id) {
        $.ajax({
            url: "${path}/uptConfirm",
            data: "id=" + id,
            dataType: "json",
            success: function (data) {
                var uptMsg = data.uptMsg
                if (uptMsg != null) {
                    alert(uptMsg)
                }
            },
            error: function (err) {
                console.log(err)
            }
        })
    }

    function openDetail(id) {
        console.log(id)
        $.ajax({
            url: "${path}/taskDetail",
            data: "id=" + id,
            dataType: "json",
            success: function (data) {
                var detail = data.taskDetail
                $("#modalFrm [name=text]").val(detail.text)
                $("#modalFrm [name=detail]").val(detail.detail)
                var startDate = new Date(detail.start_date);
                startDate.setDate(startDate.getDate() + 1);
                var formattedStartDate = startDate.toISOString().split('T')[0];
                var endDate = new Date(detail.end_date);
                endDate.setDate(endDate.getDate() + 1);
                var formateedendtDate = endDate.toISOString().split('T')[0];
                $("#modalFrm [name=start_date]").val(formattedStartDate)
                $("#modalFrm  [name=end_date]").val(formateedendtDate)
                if (detail.confirm === '1' || detail.confirm === 1) {
                    $("#confirmBtn").hide();
                    $("#proTitle").text("진행중인 업무")
                    $(".modal-title").text("Ongoing Task")
                } else {
                    $("#confirmBtn").show();
                    $("#proTitle").text("새 업무")
                    $(".modal-title").text("New Task")
                }
                $("#myModal").modal('show');

                $("#confirmBtn").click(function () {
                    uptConfirm(id)
                })
            },
            error: function (err) {
                console.log(err)
            }
        })

    }

    function uptConfirm(id) {
        $.ajax({
            url: "${path}/uptConfirm",
            data: "id=" + id,
            dataType: "json",
            success: function (data) {
                var uptMsg = data.uptMsg;
                if (uptMsg != null) {
                    Swal.fire({
                        title: uptMsg,
                        text: ' ',
                        icon: 'success',
                    }).then(function () {
                        //$("#clsBtn").click();
                        window.location.reload();
                    });
                }
            },
            error: function (err) {
                console.log(err)
            }
        })
    }
</script>
<div class="main-panel">
    <div class="content-wrapper">
        <div class="row">
            <!-- 새 업무 -->
            <div class="col-md-12">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">New Task</h4>
                        <!-- 새 업무 테이블 -->
                        <div class="table-responsive"
                             style="width: 95%; margin-left: 4%; max-height: 2000px; overflow-x: auto;">
                            <table class="table table-hover" style="width: 100%;">
                                <thead>
                                <tr>
                                    <th>업무명</th>
                                    <th>업무시작일</th>
                                    <th>업무종료일</th>
                                    <th>전달자</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="tlist" items="${getTask}" varStatus="sts">
                                    <c:if
                                            test="${tlist.member_key == loginMem.member_key && tlist.confirm == 0}">

                                        <tr class="member-row" data-member-key="${tlist.id}"
                                            ondblclick='openDetail("${tlist.id}")'>
                                            <td>${tlist.text}</td>
                                            <c:set var="formattedStartDate"
                                                   value="${fn:substring(tlist.start_date, 0, 10)}"/>
                                            <td><c:out value="${formattedStartDate}"/></td>
                                            <c:set var="formattedEndDate"
                                                   value="${fn:substring(tlist.end_date, 0, 10)}"/>
                                            <td><c:out value="${formattedEndDate}"/></td>
                                            <td>${tlist.assignor}</td>
                                            <td>
                                                <button type="button" class="btn btn-open"
                                                        style="background-color: #007FFF; color: white;">
                                                    리스크등록
                                                </button>
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:if test="${empty getTask}">
                                        <tr>
                                            <td>새로운 업무가 없습니다.</td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 새 업무 end -->

            <!-- 진행중인 업무 -->
            <div class="col-md-12" style="margin-top: 3%;">
                <div class="card">
                    <div class="card-body">
                        <h4 class="card-title">Ongoing Task</h4>
                        <!-- 진행중인 업무 테이블 -->
                        <div class="table-responsive"
                             style="width: 95%; margin-left: 4%; max-height: 2000px; overflow-x: auto;">
                            <table class="table table-hover" style="width: 100%;">
                                <thead>
                                <tr>
                                    <th>업무명</th>
                                    <th>업무시작일</th>
                                    <th>업무종료일</th>
                                    <th>전달자</th>
                                    <th></th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="tlist" items="${getTask}" varStatus="sts">
                                    <c:if test="${tlist.member_key == loginMem.member_key && tlist.confirm == 1}">

                                        <tr class="task-row" data-member-key="${tlist.id}"
                                            ondblclick='openDetail("${tlist.id}")'>
                                            <td>${tlist.text}</td>
                                            <c:set var="formattedStartDate"
                                                   value="${fn:substring(tlist.start_date, 0, 10)}"/>
                                            <td><c:out value="${formattedStartDate}"/></td>
                                            <c:set var="formattedEndDate"
                                                   value="${fn:substring(tlist.end_date, 0, 10)}"/>
                                            <td><c:out value="${formattedEndDate}"/></td>
                                            <td>${tlist.assignor}</td>
                                            <td>
                                                <button type="button" class="btn btn-open"
                                                        style="background-color: #007FFF; color: white;">
                                                    리스크등록
                                                </button>
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:if test="${empty getTask}">
                                        <tr>
                                            <td>진행중인 업무가 없습니다.</td>
                                        </tr>
                                    </c:if>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
            <!-- 진행중인 업무 end -->
        </div>

        <!-- The Modal -->
        <div class="modal" id="myModal">
            <div class="modal-dialog">
                <div class="modal-content">

                    <!-- Modal Header -->
                    <div class="modal-header">
                        <h2 class="modal-title">New Task</h2>

                        <button type="button" class="close" data-dismiss="modal" id="xBtn">×</button>
                    </div>

                    <!-- Modal body -->
                    <div class="modal-body">
                        <div style="display: flex;">
                            <h3 id=proTitle>새 업무</h3>

                        </div>

                    </div>
                    <form class="forms-sample" id="modalFrm">
                        <div class="form-group">
                            <label for="exampleInputUsername1">업무이름</label> <input
                                name="text" type="text" class="form-control" placeholder="title">
                        </div>
                        <div class="form-group">
                            <label for="exampleTextarea1">상세내용</label>
                            <textarea class="form-control" rows="4" name="detail"></textarea>
                        </div>
                        <div class="form-group">
                            <label for="exampleInputPassword1">업무 시작일</label> <input
                                name="start_date" type="date" class="form-control" placeholder="startDate">
                        </div>
                        <div class="form-group">
                            <label for="exampleInputConfirmPassword1">업무 종료일</label>
                            <input name="end_date" type="date" class="form-control" placeholder="endDate">
                        </div>
                    </form>
                    <!-- Modal footer -->
                    <div class="modal-footer">
                        <div class="mx-auto">
                            <button type="button" class="btn btn-" id="confirmBtn"
                                    style="background-color: #007FFF; color: white;">확인완료
                            </button>
                            <button type="button" class="btn btn-danger" data-dismiss="modal"
                                    id="clsBtn">닫기
                            </button>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- 풋터 -->
        <!-- content-wrapper ends -->
        <!-- partial:partials/_footer.html -->
        <!-- <footer class="footer">
                <div class="card">
                    <div class="card-body">
                        <div
                            class="d-sm-flex justify-content-center justify-content-sm-between">
                            <span
                                class="text-muted text-center text-sm-left d-block d-sm-inline-block">Copyright
                                Â© 2020 <a href="https://www.bootstrapdash.com/"
                                class="text-muted" target="_blank">Bootstrapdash</a>. All
                                rights reserved.
                            </span> <span
                                class="float-none float-sm-right d-block mt-1 mt-sm-0 text-center text-muted">Free
                                <a href="https://www.bootstrapdash.com/" class="text-muted"
                                target="_blank">Bootstrap dashboard</a> templates from
                                Bootstrapdash.com
                            </span>
                        </div>
                    </div>
                </div>
            </footer> -->
        <!-- partial -->
        <!-- </div> -->
        <!-- main-panel ends -->
        <!-- 이 밑은 복붙할때 알아서 붙이쇼 -->
    </div>
    <!-- page-body-wrapper ends -->
</div>
<!-- container-scroller -->


</body>

</html>

