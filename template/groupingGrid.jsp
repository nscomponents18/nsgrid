<div>
	<!-- hierarchical,group,normal -->
	<!-- scroll,pages -->
	<!-- auto,manual -->
	<!-- stack,columnToggle -->
	<!--  <ns-grid id="dgDemo" nsTitle="Data Grid Demo" type="group" isSingleLevelGrouping="false" groupColumnHeaderName="Grouped Column" groupColumnFieldName="group" renderInCachedMode="false" 
			enableVirtualScroll="true" enablePagination="false" paginationType="scroll" 
			 paginationMode="auto" enableMouseHover="true" enableMultiSelection="true" childField="children" 
	         style="width:90%;height:300px;" groupByField="country,year" columnResizable="true" enableVariableRowHeight="true"
	         columnDraggable="true" pageSize="10" fetchRecordCallBack="addRows" totalRecords="50" rowHeight="0" leftFixedColumn="0" rightFixedColumn="1"
	         enableFixedColumnAnimation="false" enableRowMove="false" isSameTableMove="false" rowMoverDropEndHandler="rowDropEndHandler"
	         enableToolTipForTruncateText="true"
	         enableContextMenu="false" contextMenuProvider="contextMenuProvider" enableExport="true"  enableResponsive="true" responsiveMode="stack">
	</ns-grid> -->
	<div id="dgDemo" style="width:100%">
	</div> 
	<br/>
	<br/>
	<button type="button" onclick="showHideLoader();">Show/Hide Loader</button>
	<button type="button" onclick="dataSourceRefreshHandler();">Change DataSource</button>
	<button type="button" onclick="columnRefreshHandler();">Change Column</button>
	<button type="button" onclick="addColumn();">Add Column</button>
	<button type="button" onclick="removeColumn();">Remove Column</button>
	<button type="button" onclick="swapColumns();">Swap Column</button>
	<button type="button" onclick="expandAll();">Expand</button>
	<button type="button" onclick="collapseAll();">Collapse</button>
	<button type="button" onclick="sort();">Sort</button>
	<button type="button" onclick="changeGroupBy('country,year');">Group By Country,Year</button>
	<button type="button" onclick="changeFontSize();">Change Font Size</button>
	<br/>
	<br/>
	<script>
	var nsGrid = null;
	var arrItems = [];
	var column = [
		      		{headerText:"Id",dataField:"id",width:"20%",sortable:true,sortDescending:true,draggable:false,resizable:true,showMenu:true,minWidth:50,priority:1},
		      		{headerText:"Country",dataField:"country",width:"15%",sortable:true,sortDescending:true,draggable:false,resizable:true,showMenu:true,priority:2},
		      		{headerText:"Hierarchy",dataField:"hierarchy",width:"20%",sortable:true,sortDescending:false,showMenu:true,headerTruncateToFit:true,truncateToFit:true,priority:1},
		      		{headerText:"Year",dataField:"year",width:"20%",sortable:true,sortDescending:true,showMenu:true,priority:3},
		      		{headerText:"Employees",dataField:"employeesID",width:"20%",sortable:false,sortDescending:true,priority:4,
		      			itemRenderer:"employeeItemRenderer",groupRenderer:"employeeGroupRenderer",enableFilter:false},
		      		{headerText:"Date",dataField:"date",width:"20%",sortable:true,sortDescending:true,showMenu:true,labelFunction:"dateLabelFunction",truncateToFit:true,priority:5},
		      		{headerText:"",dataField:"checked",width:"5%",draggable:false,sortable:false,sortDescending:false,itemRenderer:"itemRenderer",
		      			isExportable:false,showMenu:false,enableFilter:false,
		      		 filter:{enableAdvancedFilter:false}}
		      	];
	var setting = {nsTitle:"Grouping Grid Demo",type:"group",isSingleLevelGrouping:"true",enableVirtualScroll:true,groupByField:"country",
			 	   enableFilter:true,enableAdvancedFilter:true,enableMouseHover:true,enableMultipleSelection:true,
			 	   childField:"children",rowKeyField:"id",columnResizable:true,enableVariableRowHeight:false,
		           columnDraggable:true,rowHeight:22,leftFixedColumn:0,rightFixedColumn:0,
		           enableExport:true,enableResponsive:true,responsiveMode:"stack",enableToolTipForTruncateText:true,
		           heightOffset:250,customClass:{nonFirstBodyColumn:"nonFirstGridBodyCell"}};
	
	window["loadGroupHandler"] = function ()
	{
		arrItems = [];
		var item = {};
		var count = 0;
		var dgDemo = document.getElementById("dgDemo");
		nsGrid = new NSGrid(dgDemo,setting);
		var totalRecords = 1000;
		var arrEmployee = [];
		for(count = 0;count < 10;count++)
		{
			var item = {};
			item.employee = "Employee " + (count + 1);
			item.employeeID = count;
			arrEmployee.push(item);
		}
		for(var count = 0;count < totalRecords;count++)
		{
			item = {id: count, hierarchy: 'Hierarchy ' + count, supervisor: "Supervisor " + count, country: 'UK', employeeSrc: arrEmployee, employeesID: getRandomInt(0,9), price: (10 * count), year: 1985 + count,checked:false};
			if((count % 2) === 0)
			{
				item["country"] = "US";
			}
			var date = new Date();
	        date.setFullYear(2015, Math.floor(Math.random() * 12), Math.floor(Math.random() * 27));
	        date.setHours(Math.floor(Math.random()*23), Math.floor(Math.random()*59), Math.floor(Math.random()*59), 0);
	        item["date"] = date;
			arrItems.push(item);
		}
		nsGrid.setColumn(column);
		nsGrid.dataSource(arrItems);
		
		nsGrid.util.addEvent(dgDemo,NSGrid.ROW_SELECTED,itemSelectHandler);
		nsGrid.util.addEvent(dgDemo,NSGrid.ROW_UNSELECTED,itemUnSelectHandler);
		nsGrid.fixFixedHeader();
	}
	
	window["dateLabelFunction"] = function (item,dataField,colItem)
	{
		if(item && item[dataField])
		{
			var date = item[dataField];
			//return date.format("mm/dd/yyyy hh:MM:ss TT");
			return date
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
		
	window["employeeItemRenderer"] = function (item,dataField,colIndex,row)
	{
		var htmlText = "";
		if(item && item["employeeSrc"] && dataField)
		{
			var arrEmployee = item["employeeSrc"];
			cmbSelect = document.createElement("SELECT");
			cmbSelect.onclick = employeeClickHandler;
			cmbSelect.onchange = employeeChangeHandler;
			cmbSelect.style.width = "100%";
			for(var count = 0;count < arrEmployee.length; count++)
			{
				var empItem = arrEmployee[count];
				if(parseInt(item[dataField]) === parseInt(empItem.employeeID))
				{
					htmlText += "<option value='" + empItem.employeeID + "' selected>" + empItem.employee + "</option>";	
				}
				else
				{
					htmlText += "<option value='" + empItem.employeeID + "'>" + empItem.employee + "</option>";
				}
				//htmlText += "<option value='" + empItem.employeeID + "'>" + empItem.employee + "</option>";
			}
			cmbSelect.innerHTML = htmlText;
		}
		return cmbSelect;
	}
	window["employeeGroupRenderer"] = function (item,dataField,rowIndex,columnIndex,row)
	{
		var htmlText = "";
		if(item)
		{
			var arrChildren = item["children"];
			if(arrChildren && arrChildren.length > 0)
			{
				var arrEmployee = [];
				if(arrChildren[0].hasOwnProperty("employeeSrc") && arrChildren[0]["employeeSrc"])
				{
					arrEmployee = arrChildren[0]["employeeSrc"];
				}
				else if(arrChildren[0]["children"] && arrChildren[0]["children"].length > 0 && arrChildren[0]["children"][0].hasOwnProperty("employeeSrc") && arrChildren[0]["children"][0]["employeeSrc"])
				{
					arrEmployee = arrChildren[0]["children"][0]["employeeSrc"];
				}
				htmlText = "<select onclick='employeeClickHandler(event);' onchange='employeeGroupChangeHandler(event);' style='width: 100%;'>";
				htmlText += "<option value='" + -1 + "'>" + "Select Employee" + "</option>";
				for(var count = 0;count < arrEmployee.length; count++)
				{
					var empItem = arrEmployee[count];
					if(parseInt(item[dataField]) === parseInt(empItem.employeeID))
					{
						htmlText += "<option value='" + empItem.employeeID + "' selected>" + empItem.employee + "</option>";	
					}
					else
					{
						htmlText += "<option value='" + empItem.employeeID + "'>" + empItem.employee + "</option>";
					}
					//htmlText += "<option value='" + empItem.employeeID + "'>" + empItem.employee + "</option>";
				}
				htmlText += "</select>";
			}
		}
		return htmlText;
	}
	
	window["employeeClickHandler"] = function (event)
	{
		event.stopImmediatePropagation();
	}
	
	window["employeeGroupChangeHandler"] = function (event)
	{
		nsGrid.cascadeValues(event);
	}
	
	window["employeeChangeHandler"] = function (event)
	{
		var objItem = nsGrid.getItemInfo(event);
		if(objItem)
		{
			objItem.item.employeesID = event.target.value;
			nsGrid.updateItemInDataSource(objItem.item);
		}
	}

	window["setGroupChange"] = function (cascadeControl,childControl,item,dataField,cellIndex,colItem,cell,row)
	{
		var value = null;
		if(cascadeControl && childControl)
		{
			value = cascadeControl.value;
			childControl.value =  value;
		}
		return value;
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
	
	window["itemRenderer"] = function (data,dataField,rowIndex,columnIndex,row)
	{
		var selected = data[dataField];
		//row.update();
		/*if(selected)
		{
			return '<input type="checkbox" checked>';
		}
		else
		{
			return '<input type="checkbox">';
		}*/
		var checkbox = document.createElement('input');
		checkbox.type = "checkbox";
		if(selected)
		{
			checkbox.setAttribute("checked",true);
		}
		checkbox.addEventListener('click', window["checkBoxClickHandler"].bind(window,event,data,dataField,rowIndex,columnIndex,row));
		return checkbox;
		/*if(data["checked"])
		{
			return "<a href=# class='purple' onclick='anchorClick(event," + rowIndex +"," + data["id"] +")'>" + returnAlphabets("a",rowIndex + 1) + "</a>";
		}
		else
		{
			return "<a href=# onclick='anchorClick(event," + rowIndex +"," + data["id"] +")'>" + returnAlphabets("a",rowIndex + 1) + "</a>";
		}*/
	}
	
	window["checkBoxClickHandler"] = function (event,data,dataField,rowIndex,columnIndex,row)
	{
		data[dataField] = true;
		nsGrid.updateItemInDataSource(data);
		nsGrid.updateRowByKeyField(data.id);
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
	
	
	window["getRandomInt"] = function (min, max) {
		  return Math.floor(Math.random() * (max - min + 1)) + min;
	}
	
	var showingLoader = false;
	window["showHideLoader"] = function ()
	{
		if(showingLoader)
		{
			nsGrid.hideLoader();
		}
		else
		{
			nsGrid.showLoader();
		}
		showingLoader = !showingLoader;
	}
	
	window["dataSourceRefreshHandler"] = function ()
	{
		nsGrid.dataSource(arrItems);
	}
	
	window["columnRefreshHandler"] = function ()
	{
		nsGrid.setColumn(column);
		dataSourceRefreshHandler();
	}
	
	window["changeGroupBy"] = function (fieldName)
	{
		nsGrid.groupBy(fieldName);
	}
	
	window["changeFontSize"] = function ()
	{
		nsGrid.setFontSize("14px");
	}
	
	window["addColumn"] = function ()
	{
		var column = {};
		column.headerText = "Price";
		column.dataField = "price";
		column.width = "100px";
		column.sortable = true;
		column.sortDescending = true;
		
		nsGrid.addColumn(column);
		
	}
	
	window["removeColumn"] = function ()
	{
		//nsGrid.removeColumn(0);
		nsGrid.hideColumn("country");
	}
	
	window["swapColumns"] = function ()
	{
		//nsGrid.swapColumns(0);
		nsGrid.swapColumns(3,4);
	}
	
	window["expandAll"] = function ()
	{
		nsGrid.expandAll();
	}
	
	window["collapseAll"] = function ()
	{
		nsGrid.collapseAll();
	}
	
	window["sort"] = function ()
	{
		nsGrid.sortBy("year");
	}
	
	window["contextMenuProvider"] = function (item,columnIndex,rowIndex)
	{
		console.log(item + "," + columnIndex + "," + rowIndex);
		var index = columnIndex + rowIndex;
		var source = [];
		for(var count = index;count < index + 5;count++)
		{
			source.push({title: 'Menu ' + count,iconHTML: '<i class="fa fa-folder-open"></i>',handler: menuClickHandler});
		}
		return source;
	}
	
	window["menuClickHandler"] = function (target,item)
	{
		if(item)
		{
			console.log("Menu with text " + item.title + " was selected for Target " + target.nodeName + " with text as "  + target.innerHTML);			
		}
	}
	//https://github.com/NeXTs/Clusterize.js/blob/master/clusterize.js
	window["itemSelectHandler"] = function (event)
	{
		console.log("Item Selected with details::" + event.detail + " with hierarchy " + event.detail.hierarchy);
		//console.log("Item Selected with details::" + event.detail + " with index " + event.index);
	}
	
	window["itemUnSelectHandler"] = function (event)
	{
		console.log("Item Unselected with details::" + event.detail  + " with hierarchy " + event.detail.hierarchy);
	}
	
	window["themeChanged"] = function(theme)
	{
		nsGrid.setTheme(theme);
	}
	
	//# sourceURL=groupingGrid.js
	</script>
</div>