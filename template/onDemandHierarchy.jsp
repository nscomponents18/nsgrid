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
	<br/>
	<br/>
	<button type="button" onclick="showHideLoader();">Show/Hide Loader</button>
	<button type="button" onclick="dataSourceRefreshHandler();">Change DataSource</button>
	<button type="button" onclick="columnRefreshHandler();">Change Column</button>
	<button type="button" onclick="addColumn();">Add Column</button>
	<button type="button" onclick="hideColumn();">Remove Column</button>
	<button type="button" onclick="swapColumns();">Swap Column</button>
	<button type="button" onclick="expandAll();">Expand</button>
	<button type="button" onclick="collapseAll();">Collapse</button>
	<button type="button" onclick="sort();">Sort</button>
	<button type="button" onclick="changeFontSize();">Change Font Size</button>
	<button type="button" onclick="changeTheme();">Change Theme</button>
	
	<script>
	var column = [
		      		{headerText:"Id",dataField:"id",width:"20%",sortable:true,sortDescending:true,draggable:false,resizable:true,minWidth:50,filterRenderer:window["filterRenderer"],priority:1},
		      		{headerText:"First Name",dataField:"firstName",width:"20%",sortable:true,sortDescending:true,draggable:false,resizable:true,filterRenderer:window["filterRenderer"],priority:2},
		      		{headerText:"Last Name",dataField:"lastName",width:"20%",sortable:true,sortDescending:false,headerTruncateToFit:true,truncateToFit:true,priority:1},
		      		{headerText:"City",dataField:"city",width:"15%",sortable:true,sortDescending:true,filterRenderer:window["filterRenderer"],priority:3},
		      		{headerText:"Number",dataField:"phoneNumber",width:"20%",sortable:false,sortDescending:true,filterRenderer:window["filterRenderer"],priority:4},
		      		{headerText:"Birth Date",dataField:"birthDate",width:"20%",sortable:true,sortDescending:true,filterRenderer:window["filterRenderer"],priority:5}
		      	];
	var  icons = {
	        rowExpanded: '<img src="https://cdn.rawgit.com/ag-grid/ag-grid-docs/56853d5aa6513433f77ac3f808a4681fdd21ea1d/src/javascript-grid-icons/minus.png" style="width: 12px;padding-right: 2px"/>',
	        rowCollapsed: '<img src="https://cdn.rawgit.com/ag-grid/ag-grid-docs/56853d5aa6513433f77ac3f808a4681fdd21ea1d/src/javascript-grid-icons/plus.png" style="width: 12px;padding-right: 2px"/>'
	    };
	var settingOnDemand = {nsTitle:"OnDemand Hierarchical Grid Demo",type:"hierarchical",enableOnDemandHierarchy:true,onDemandChildDetectionField:"hasChildren",
				   onDemandChildFetchCallback:"getNthLevelData",enableVirtualScroll:false,
		 	   	   enableFilter:true,enableAdvancedFilter:true,enableMouseHover:true,enableMultipleSelection:true,
		 	   	   childField:"children",rowKeyField:"id",columnResizable:true,enableVariableRowHeight:false,
	           	   columnDraggable:true,rowHeight:22,leftFixedColumn:0,rightFixedColumn:0,
	           	   enableExport:true,enableResponsive:true,responsiveMode:"stack",enableMultiSort:true,
	           	   heightOffset:250,customClass:{nonFirstBodyColumn:"nonFirstGridBodyCell"},icons:icons};//,theme:"Black"
		
		var nsGrid = null;
		window["loadOnDemandHierarchyHandler"] = function ()
		{
			var dgDemo = document.getElementById("dgDemo");
			nsGrid = new NSGrid(dgDemo,settingOnDemand);
			nsGrid.setColumn(column);
				
			nsGrid.util.addEvent(dgDemo,NSGrid.ROW_SELECTED,itemSelectHandler);
			nsGrid.util.addEvent(dgDemo,NSGrid.ROW_UNSELECTED,itemUnSelectHandler);
			
			var ajax = new NSAjax();
			ajax.post("https://nscomponentjava.herokuapp.com/api/getData",{datalength: "10"},{dataType:"json"}).then(
					function(data) 
					{
						console.log(data);
						if(data && Array.isArray(data))
						{
							nsGrid.dataSource(data);	
						}
						else
						{
							alert("Data could not be fetched");
						}
					},
					function(error) 
					{ 
						/* handle an error */ 
					}
			);
			
		}
		
		window["getNthLevelData"] = function(item,rowIndex,rowLevel,event)
		{
			var ajax = new NSAjax();
			//https://nscomponentjava.herokuapp.com/api/getChildData
			ajax.get("https://nscomponentjava.herokuapp.com/api/getChildData",{dataLength: "10",parentID:item.id},{dataType:"json"}).then(
					function(data) 
					{
						console.log(data);
						if(data && data.length > 0)
						{
							nsGrid.addItemsAsChildren(item,data);
						}
						else
						{
							item.hasChildren = false;
							nsGrid.updateRowByIndex(rowIndex);
						}
					},
					function(error) 
					{ 
						/* handle an error */ 
					}
			);
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
		
		window["changeTheme"] = function (event)
		{
			nsGrid.setTheme("Black");
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
		
		
		var numRows = 50;
		var numLevels = 2;
		
		var rowCount = 0;
	    
		window["getRandomNumber"] = function (level){
			var nCount = 1 + Math.floor(Math.random() * 10);
			
			if (level === 0)
			{
				if (numLevels == 0)
					nCount = numRows;
				else
				{
					var derivative = 1;
					for (var k = 1; k <= numLevels; k++)
						derivative = (derivative * nCount) + 1;

					nCount = numRows / derivative + 1;
					if (nCount < 1000)
						nCount = 1000;
				}
			}
			
			return nCount;
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
		
		window["changeFontSize"] = function ()
		{
			nsGrid.setFontSize("14px");
		}
		
		var isReflowView = false;
		window["changeGridView"] = function ()
		{
			isReflowView = !isReflowView;
			nsGrid.changeDeviceView(isReflowView);
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
		
		window["hideColumn"] = function ()
		{
			nsGrid.hideColumn("country");
		}
		
		window["swapColumns"] = function ()
		{
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
		
		window["menuClickHandler"] = function(target,item)
		{
			if(item)
			{
				console.log("Menu with text " + item.title + " was selected for Target " + target.nodeName + " with text as "  + target.innerHTML);			
			}
		}
		//https://github.com/NeXTs/Clusterize.js/blob/master/clusterize.js
		window["itemSelectHandler"] = function(event)
		{
			console.log("Item Selected with details::" + event.detail + " with hierarchy " + event.detail.hierarchy);
			//console.log("Item Selected with details::" + event.detail + " with index " + event.index);
		}
		
		window["itemUnSelectHandler"] = function(event)
		{
			console.log("Item Unselected with details::" + event.detail  + " with hierarchy " + event.detail.hierarchy);
		}
		//# sourceURL=onDemandHierarchy.js
	</script>
</div>