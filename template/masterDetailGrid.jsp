<div onload="loadHandler();">
	<style>
		.filterContainer{
		  padding: 3px 5px;
		}
		.filter{
			display: table-cell;
		  vertical-align: middle;
		  padding-left: 5px;
		}
	</style>
	<!-- hierarchical,group,normal -->
	<!-- scroll,pages -->
	<!-- auto,manual -->
	<!-- stack,columnToggle -->
	<div id="dgDemo" style="width:100%;"></div>
	<!--  <ns-grid id="dgDemo" nsTitle="Data Grid Demo" type="hierarchical" renderInCachedMode="false" enableVirtualScroll="true" 
			 enablePagination="false" paginationType="scroll" paginationMode="auto" enableAsyncLoadPagination="false"
			 enableMouseHover="true" enableMultiSelection="true" childField="children" 
	         style="width:90%;height:500px;" groupByField="country,year" columnResizable="true" enableVariableRowHeight="true"
	         columnDraggable="true" pageSize="10" totalRecords="2000" rowHeight="171" leftFixedColumn="0" rightFixedColumn="0"
	         enableContextMenu="false" contextMenuProvider="contextMenuProvider" enableExport="true" enableResponsive="false" responsiveMode="stack">
	</ns-grid> -->
	<br/>
	<br/>
	<button type="button" onclick="expandAll();">Expand</button>
	<button type="button" onclick="collapseAll();">Collapse</button>
	<button type="button" onclick="expandRowWithId2();">Expand Row With ID 2</button>
	<button type="button" onclick="collapseRowWithId2();">Collapse Row With ID 2</button>
	
	<script>
	var gridDetailColumn = [
  		{headerText:"Id",dataField:"id",width:"200px",sortable:true,sortDescending:true,sortType:"number"},
  		{headerText:"Country",dataField:"country",width:"200px",sortable:true,sortDescending:true},
  		{headerText:"Employees",dataField:"employees",width:"300px",sortable:false,sortDescending:true,headerTruncateToFit:true,
  			      	truncateToFit:true},
  		{headerText:"Price",dataField:"price",toolTipField:"price",width:"300px",sortable:true,sortDescending:true},
  		{headerText:"Hierarchy",dataField:"hierarchy",width:"300px",sortable:true,sortDescending:false},
  		{headerText:"Year",dataField:"year",width:"200px",sortable:true,sortDescending:true},
  		{headerText:"Date",dataField:"date",width:"200px",sortable:true,sortDescending:true,labelFunction:"dateLabelFunction"}
  	];
	//nsTitle:"Flat Grid Demo",
	var gridDetailSetting = {type:"normal",enableVirtualScroll:true};
	
	var column = [
		      		{headerText:"Id",dataField:"id",width:"20%",sortable:true,sortDescending:true,draggable:false,resizable:true,minWidth:50,filterRenderer:window["filterRenderer"],priority:1},
		      		{headerText:"Country",dataField:"country",width:"15%",sortable:true,sortDescending:true,draggable:false,resizable:true,filterRenderer:window["filterRenderer"],priority:2},
		      		{headerText:"Hierarchy",dataField:"hierarchy",width:"20%",sortable:true,sortDescending:false,headerTruncateToFit:true,truncateToFit:true,priority:1},
		      		{headerText:"Year",dataField:"year",width:"20%",sortable:true,sortDescending:true,filterRenderer:window["filterRenderer"],priority:3},
		      		{headerText:"Employees",dataField:"employees",width:"20%",sortable:false,sortDescending:true,filterRenderer:window["filterRenderer"],priority:4},
		      		{headerText:"Date",dataField:"date",width:"20%",sortable:true,sortDescending:true,labelFunction:"dateLabelFunction",filterRenderer:window["filterRenderer"],priority:5}
		      	];
	function generateDetailSource(masterItem) {
		var totalRecords = 50;
		var arrItem = [];
		var masterHierarchy = masterItem;
		for(var count = 0;count < totalRecords;count++)
		{
			var item = {id: count, hierarchy: masterHierarchy + ' ' + count, supervisor: "Supervisor " + count, country: masterItem.country, employees: "EmployeesEmployeesEmployees" + count, price: (10 * count), year: 1985 + count,checked:false};
			var date = new Date();
	        date.setFullYear(2015, Math.floor(Math.random() * 12), Math.floor(Math.random() * 27));
	        date.setHours(Math.floor(Math.random()*23), Math.floor(Math.random()*59), Math.floor(Math.random()*59), 0);
	        item["date"] = date;
	        arrItem.push(item);
		}
		return arrItem;
	};
	function detailDataSourceCallback(param) {
		var source = generateDetailSource(param.masterData);
		param.setDataSource(source);
	}
	var totalRowWithChildren = false;
	function renderDetailGridEverytime(params) {
		if((params.rowIndex % 4) == 0 && totalRowWithChildren < 5) {
			totalRowWithChildren++;
			return true;
		}
		return false;
	};
	function getDetailGridHTML(params) {
		var item = params.masterData;
		return (
		        '<div style="height: 100%; background-color: #EDF6FF; padding: 20px; box-sizing: border-box;">' +
		        '  <div style="height: 10%; padding: 2px; font-weight: bold;"> This Grid is for Id ' + item.id +
		        '</div>' +
		        '  <div data-ns-ref="detailGrid" style="height: 90%;"></div>' +
		        '</div>'
		 );
	};
	var masterDetailSetting = {hasChildField:"hasChildren",detailHeight: 400,
			detailGridSetting: gridDetailSetting,detailColumns: gridDetailColumn,detailDataSourceCallback: detailDataSourceCallback,
			gridRefreshEverytimeCallback: renderDetailGridEverytime,gridHtmlCallback: getDetailGridHTML};
	var setting = {nsTitle:"Master Detail Grid Demo",type:"masterdetail", masterDetailSetting: masterDetailSetting,enableVirtualScroll:false,enableColumnSetting:true,
		 	   enableFilter:true,enableAdvancedFilter:true,rowKeyField:"id",columnResizable:true,enableVariableRowHeight:true,
	           columnDraggable:true,rowHeight:22,leftFixedColumn:0,rightFixedColumn:0,
	           enableExport:true,heightOffset:250,customClass:{nonFirstBodyColumn:"nonFirstGridBodyCell"}};
		
		
		var rowCount = 0;
		var nsGrid = null;
		var arrItems = [];
		window["loadMasterDetailHandler"] = function ()
		{
			arrItems = []; 
			var dgDemo = document.getElementById("dgDemo");
			nsGrid = new NSGrid(dgDemo,setting);
			getDataSource(null,0,arrItems);
			nsGrid.setColumn(column);
			nsGrid.dataSource(arrItems);
		}
		
		window["getDataSource"] = function()
		{
			arrItems = [];
			var numChilds = 50;    
			for (var i = 0; i < numChilds; i++){
				var item = {id: rowCount, hierarchy: 'hierarchy ' + (rowCount+1).toString(), supervisor: null, country: 'US', employees: "Employee" + i, price: '10.90', year: '1985',date:new Date(2018, 11, i + 1),checked:true};
				item.hierarchy = 'hie ' + (rowCount + 1).toString();
				item.hasChildren = ((i % 2) === 0);
				arrItems.push(item);
				rowCount++;
			}
		};
	
		window["dateLabelFunction"] = function (item,dataField,colItem)
		{
			if(item && item[dataField])
			{
				var date = item[dataField];
				return ((date.getMonth() + 1) + '/' + date.getDate() + '/' +  date.getFullYear());
			}
			return "";
		}
	
		window["filterRenderer"] = function (colItem,colIndex)
		{
			var htmlText = "";
			if(colItem)
			{
				if(colItem["dataField"] === "date")
				{
					htmlText = "<div class='filterContainer'><input type='text' class='date filter' field='date' onchange='keyUpHandler(event)'/></div>";
					
				}
				else 
				{
					var field = colItem["dataField"];
					htmlText = "<div class='filterContainer'><input id='txt" + field + "' type='search' results='5' placeholder='Search " + field +"' +   field='" + field + "' class='filter' " +
								   " onkeyup='keyUpHandler(event)'/></div>";
				}
			}
			return htmlText;
		}
		
		window["themeChanged"] = function(theme)
		{
			nsGrid.setTheme(theme);
		}
		
		var timeout = null;
		window["keyUpHandler"] = function (event)
		{
			clearTimeout(timeout);
			timeout = setTimeout(function () {
					filterGrid();
			    }, 500);
		}
		
		window["filterGrid"] = function ()
		{
			var arrID = ["id","country","hierarchy","employees","year","date"];
			 //and condition
			 /*var filter = {};
			 var setting = {};
			 for(var count = 0;count < arrID.length ;count++)
			 {
				 var control = document.querySelector("#txt" + arrID[count]);
				 if(control && control.value)
				 {
					 var key = control.getAttribute("field");
					 if(key === "date")
					 {
						 filter[key] = filterDate;
						 setting[key] = {value:control.value};
					 }
					 else
					 {
						 filter[key] = control.value;
						 setting[key] = {caseSensitive:false,multiline:false,matchType:new NSFilter().CONTAINS};
					 } 
				 }
			 }
			 if(filter && Object.keys(filter).length > 0)
			 {
				 nsGrid.filter(filter,setting);
			 }
			 else
			 {
				 nsGrid.resetFilter();
			 }*/
			 //or condition
			 var filter = [];
			 var setting = {};
			 for(var count = 0;count < arrID.length ;count++)
			 {
				 var control = document.querySelector("#txt" + arrID[count]);
				 if(control && control.value)
				 {
					 var item = {};
					 var key = control.getAttribute("field");
					 if(key === "date")
					 {
						 item[key] = filterDate;
						 setting[key] = {value:control.value};
					 }
					 else
					 {
						 item[key] = control.value;
						 setting[key] = {caseSensitive:false,multiline:false,matchType:new NSFilter().CONTAINS};
					 } 
					 if(item)
					 {
						 filter.push(item);
					 }
				 }
			 }
			 if(filter && filter.length > 0)
			 {
				 nsGrid.filter(filter,setting);
			 }
			 else
			 {
				 nsGrid.resetFilter();
			 }
		}
		
		window["filterDate"] = function (item,setting)
		{
			if(item && setting && setting["value"])
			{
				var value = setting["value"];
				value = value.replace(/\\/g, "");
				var now = moment(item);
				if (moment(value).isAfter(now, 'day'))
				{
					return false;
				}
				return true;
			}
			return false;
		}
		
		window["returnAlphabets"] = function (alphabet,count)
		{
			var retValue = "";
			for(var innerCount= 1;innerCount < count;innerCount++)
			{
				retValue += alphabet;
			}
			return retValue;
		}
	
		window["setData"] = function (renderer,data,dataField,colItem,row)
		{
			if(renderer)
			{
				if(data)
				{
					renderer.rendererBody.chk.onchange = checkBox_changeHandler;
					renderer.rendererBody.chk.checked = data[dataField];
				}
				else
				{
					clearData(renderer);
				}
			}
		}
		
		window["clearData"] = function (renderer)
		{
			if(renderer)
			{
				renderer.rendererBody.chk.checked = false;
			}
		}
		
		window["checkBox_changeHandler"] = function (event) 
		{					
			var checked = event.target.checked ? "checked":"unchecked";
			event.target.data["hierarchy"] = event.target.data["hierarchy"] + "1"; 
			event.target.data["checked"] = checked;
		    alert(event.target.data["id"] + " is " + checked);
		    event.target.row.update();
		    event.stopImmediatePropagation();
		}
		
		window["expandAll"] = function ()
		{
			nsGrid.expandAll();
		}
		
		window["collapseAll"] = function ()
		{
			nsGrid.collapseAll();
		}
		
		window["expandRowWithId2"] = function ()
		{
			nsGrid.expandByKeyField(2);
		}
		
		window["collapseRowWithId2"] = function ()
		{
			nsGrid.collapseByKeyField(2);
		}
		
		//# sourceURL=masterDetailGrid.js
	</script>
</div>