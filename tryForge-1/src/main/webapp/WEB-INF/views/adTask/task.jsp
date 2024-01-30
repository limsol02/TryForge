<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%-- <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="path" value="${pageContext.request.contextPath }"/> --%>
<jsp:include page="${path}/template/module/module_admain.jsp"
	flush="true" />
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
	$(document).ready(function() {
		$("#uptBtn").click(function(){
	        uptTask();
	    });
		
		$("#clsBtn").click(function() {
			$("#myModal form")[0].reset()

		})
		$("#xBtn").click(function() {
			$("#myModal form")[0].reset()

		})
		// 동적으로 생성된 버튼에 대한 이벤트 처리
		$(document).on('click', '.btn-open', function() {
			var memberName = $(this).data("member-name");
			var memberKey = $(this).data("member-key");
			var projectKey = $(this).data("project-key");
			$("#mname").val(memberName);
			$("#modalFrm [name=member_key]").val(memberKey);
			$("#modalFrm [name=project_key]").val(projectKey);
			// 모달 열기
			$("#myModal").modal('show');
		});

	});

	function insTask() {
		$.ajax({
			url : "${path}/insertTask",
			type : "post",
			dataType : "json",
			data : $("#modalFrm").serialize(),
			success : function(data) {
				var insMsg = data.insMsg;
				if (insMsg != null) {
					Swal.fire({
						title : insMsg,
						text : ' ',
						icon : 'success',
					}).then(function() {
						$("#clsBtn").click();
						window.location.reload();
					});

				}
			},
			error : function(err) {
				console.log(err)
			}
		})
	}

	function taskList(member_key) {
	    $.ajax({
	        url: "${path}/taskList?member_key="+member_key,
	        dataType: "json",
	        success: function (data) {
	                var tlist = data.getTask;
	                var memberName = $("#memname").data("member-name");
	                $("#myModal02 [name=member_name]").val(memberName);
	                var row = "";
	                $(tlist).each(function (idx, task) {
	                    row += "<tr>";
	                    row += "<input name='id' type='hidden' value='" + task.id+ "'>";
	                    row += "<td><input name='text' type='text' class='form-control' value='" + task.text + "'></td>";
	                    row += "<td><input name='detail' type='text' class='form-control' value='" + task.detail + "'></td>";
	                    row += "<td><button type='button' class='btn btn-danger delBtn'>삭제</button></td>";
	                    row += "<td><button type='button' class='btn btn-' data-task-key='task.id' style='background-color: #007FFF; color: white;'>수정</button></td>";
	                    row += "</tr>";
	                });
	                $("#taskTable").html(row);
	                $("#myModal02").modal('show');
	                var 

	        },
	        error: function (err) {
	            console.log(err)
	        }
	    });
	}
	
	function uptTask(key){
		alert($("#modalFrm02").serialize())
		$.ajax({
			url:"${path}/uptTask?id="+key,
			dataType:"json",
			success:function(data){
				alert(data.uptMsg)
			},
			error:function(err){
				console.log(err)
			}
		})
	}
</script>

<div class="main-panel">
	<div class="content-wrapper">
		<div class="row">
			<div class="col-md-12">
				<div class="card">
					<div class="card-body">
						<h4 class="card-title">Task Management</h4>
						<!-- 구성원 검색 -->
						<form id="frm01">
							<div style="display: flex;">
								<div class="form-group" style="margin-left: 8%; width: 10%;">
									<select class="js-example-basic-single w-100" name="title"
										id="stitle"
										style="border: 1px solid #f3f3f3; font-weight: 400; font-size: 0.875rem; height: 2.875rem;">
										<option value=" ">전체</option>
										<c:forEach var="title" items="${title}">
											<option>${title}</option>
										</c:forEach>
									</select>
									<script type="text/javascript">
										$("[name=title]").val("${task.title}")
									</script>
								</div>
								<input type="text" class="form-control mb-2" name="member_name"
									placeholder="사원명 검색" style="width: 54%; margin-left: 10px;">
								<button type="submit" class="btn btn-" id="regBtn"
									style="background-color: #007FFF; color: white; margin-left: 5%; height: 2.875rem;">검색</button>
							</div>
						</form>
						<div class="table-responsive"
							style="width: 95%; margin-left: 4%; max-height: 2000px; overflow-x: auto;">
							<table class="table table-hover" style="width: 100%;">
								<thead>
									<tr>
										<th>구성원정보</th>
										<th>이메일</th>
										<th>참여중인 프로젝트</th>
										<th></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="mlist" items="${memList}">
    									<tr ondblclick='taskList("${mlist.member_key}")'>
											<td id="memname" data-member-name="${mlist.member_name}">${mlist.member_name}</td>
											<td>${mlist.member_email}</td>
											<td>${mlist.title}</td>
											<td>
												<button type="button" class="btn btn-open"
													data-toggle="modal" data-target="#myModal"
													data-member-name="${mlist.member_name}"
													data-member-key="${mlist.member_key}"
													data-project-key="${mlist.project_key}"
													style="background-color: #007FFF; color: white;">업무할당
												</button>
											</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>

			<!--구성원 검색 end -->


		</div>
		<br>

	</div>
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
					<h3 id=proTitle>업무 할당</h3>

				</div>

			</div>
			<form class="forms-sample" id="modalFrm">
				<input type="hidden" name="member_key" /> <input type="hidden"
					name="project_key" />
				<div class="form-group">
					<label for="exampleInputUsername1">이름</label> <input
						name="member_name" readonly type="text" class="form-control"
						id="mname" placeholder="member name">
				</div>
				<div class="form-group">
					<label for="exampleInputUsername1">업무이름</label> <input name="text"
						type="text" class="form-control" id="" placeholder="title">
				</div>
				<div class="form-group">
					<label for="exampleTextarea1">상세내용</label>
					<textarea class="form-control" id="" rows="4" name="detail"></textarea>
				</div>
				<div class="form-group">
					<label for="exampleInputPassword1">업무 시작일</label> <input
						name="start_date" type="date" class="form-control" id=""
						placeholder="startDate">
				</div>
				<div class="form-group">
					<label for="exampleInputConfirmPassword1">업무 종료일</label> <input
						name="end_date" type="date" class="form-control" id=""
						placeholder="endDate">
				</div>




			</form>


			<!-- Modal footer -->
			<div class="modal-footer">
				<div class="mx-auto">
					<button type="button" class="btn btn-" id="regBtn"
						onclick="insTask()"
						style="background-color: #007FFF; color: white;">할당</button>

					<button type="button" class="btn btn-danger" data-dismiss="modal"
						id="clsBtn">닫기</button>
				</div>
			</div>

		</div>
	</div>
</div>


<!-- 업무정보 모달창 -->
<div class="modal fade" id="myModal02" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" >
    <div class="modal-dialog modal-xl"> <!-- modal-lg를 사용하거나 원하는 크기를 직접 지정할 수 있습니다. -->
        <div class="modal-content">

			<!-- Modal Header -->
			<div class="modal-header">
				<h2 class="modal-title">Task Information</h2>

				<button type="button" class="close" data-dismiss="modal" id="xBtn02">×</button>
			</div>

			<!-- Modal body -->
			<div class="modal-body">
				<div style="display: flex;">
					<h3 id=proTitle>업무 확인</h3>

				</div>

			</div>
			<form class="forms-sample" id="modalFrm02">
				<input type="hidden" name="member_key" /> <input type="hidden"
					name="project_key" />
				<div class="form-group" style="width:80%; margin-left:10%;">
					<label for="exampleInputUsername1">이름</label> <input
						name="member_name" readonly type="text" class="form-control"
						id="mname" placeholder="member name">
				</div>

				<div class="table-responsive"
					style="width: 95%; margin-left: 4%; max-height: 2000px; overflow-x: auto;">
					<table class="table table-hover" style="width: 100%;">
						<thead>
							<tr>
								<th>업무이름</th>
								<th>업무설명</th>
								<th></th>
							</tr>
						</thead>
						<tbody id="taskTable">		
						</tbody>
					</table>
				</div>


			</form>


			<!-- Modal footer -->
			<div class="modal-footer">
				<div class="mx-auto">
					<button type="button" class="btn btn-danger" data-dismiss="modal"
						id="clsBtn02">닫기</button>
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

