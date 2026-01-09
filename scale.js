function f_tool_scale_append(
					iscale_info
				   ,iscale_segment
				   ){
	var oinfo;
	
	var v_scale_0;
	var v_scale_cfg;
	var v_scale_cfg_length;
	
	var v_scale_info;
	var v_scale_segment;
	
	oinfo ="";

	if(iscale_info.length ==0){
		v_scale_cfg ="";
		v_scale_info ="";
	}else{	
		v_scale_0 				=Number(iscale_info.substr(0,1)); 
		v_scale_cfg_length =Number(iscale_info.substr(1,v_scale_0)); 
		v_scale_cfg				=iscale_info.substr(1+Number(v_scale_0),v_scale_cfg_length);  
		v_scale_info 			=iscale_info.substr(1+Number(v_scale_0)+Number(v_scale_cfg_length),iscale_info.length);
	}

	//,
	v_scale_segment =iscale_segment;
	v_scale_cfg			=String(v_scale_cfg) +String(v_scale_segment.length) +",";
	v_scale_info			=String(v_scale_info) +String(v_scale_segment);

	//,scale_end
    v_scale_cfg_length =v_scale_cfg.length; 
    v_scale_0					=String(v_scale_cfg_length).length; 	
    v_scale_info 			=String(v_scale_0)+String(v_scale_cfg_length)+String(v_scale_cfg)+String(v_scale_info);

    oinfo =String(oinfo)+String(v_scale_info);
    //-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    //Éè¶¨²Ù×÷Íê³É·µ»ØÖµ
    return oinfo;
}

function f_tool_scale_list(
					list
				   ){

	var oinfo;
	var v_oinfo;
	
	oinfo ="";
    for (var i = 0; i < list.length; i++) {
    	oinfo =f_tool_scale_append(oinfo, list[i]); 
     }
     return oinfo;		
}		

function f_tool_request_info(
					list
				   ){

	var v_branchID;
	var v_dataSegment;
	var v_requestInfo;
	
	v_branchID ="";
	v_dataSegment ="";
    //¶ÁÈ¡List
    for (var i = 0; i < list.length; i++) {
          if (i == 0) {
              v_branchID =list[i];
              v_dataSegment = "";
          } else {
              v_dataSegment = f_tool_scale_append(v_dataSegment, list[i]);
          }
    }

      //ÇëÇó²ÎÊý
      v_requestInfo = "";
      v_requestInfo = f_tool_scale_append(v_requestInfo, v_branchID);   //+·ÖÖ§ID
      v_requestInfo = f_tool_scale_append(v_requestInfo, v_dataSegment);//+Êý¾Ý¶Î
      return v_requestInfo;	  
}


//解析scale格式
function f_tool_scale_get(
									iscale_info
									,iscale_at
									){
	
 	var oinfo;

 	//,scale
  	var v_scale_0;
  	var v_scale_cfg;
  	var v_scale_cfg_length;
  	
  	var v_scale_info;
  	var v_sclae_segment;

  	//
  	var v_counter;
  	var v_ix_delimiter_A;
  	var v_ix_delimiter_B;
  	
  	var v_scale_info_A;
  	var v_scale_info_B;
  	//s, 设定操作异常返回值
  	oinfo='';
  	//-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  	//s, x

  	//s,验证输入
  	if(iscale_info.length ==0){         
     	oinfo ='';
     	return oinfo;
  	}

  	//,
  	v_scale_0 =Number(iscale_info.substr(0,1)); 
 	v_scale_cfg_length =Number(iscale_info.substr(1,v_scale_0)); 
  	v_scale_cfg =iscale_info.substr(1+Number(v_scale_0),v_scale_cfg_length); 
  	
  	//,
  	v_counter =0;
  	v_ix_delimiter_A =0;
  	v_scale_info_A 	 =0;  	
  	while(true){
  		  	
    	v_ix_delimiter_B =v_scale_cfg.indexOf(',',v_ix_delimiter_A);
    	v_counter =v_counter+1;     
    	if(v_counter <iscale_at && v_ix_delimiter_B !=0){        
      		v_scale_info_A =v_scale_info_A +Number(v_scale_cfg.substr(v_ix_delimiter_A,v_ix_delimiter_B-v_ix_delimiter_A));
      		v_ix_delimiter_A =v_ix_delimiter_B+1;
      	}
    	else{
    		break;
    	}      	 
  	}

  	//#,获取scale_info
  	if(v_ix_delimiter_B !=0){  	
    	v_scale_info_A =1+v_scale_0+v_scale_cfg_length +v_scale_info_A; 
    	v_scale_info_B =Number(v_scale_cfg.substr(v_ix_delimiter_A,v_ix_delimiter_B-v_ix_delimiter_A));
    	oinfo =String(iscale_info.substr(v_scale_info_A,v_scale_info_B));
    }
  	else{
  		oinfo ='';   
  	}

  	//-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  	//#s, 设定操作完成返回值 
  	return oinfo;
}

//get获取
//alert(f_tool_scale_get('161,1,1,13你',3));

// //--
// alert(f_tool_scale_append('','B')); 
// //alert(f_tool_scale_append('121,A','B')); 
// alert(f_tool_scale_append('','Ëü'));  //ÑéÖ¤ÖÐÎÄ

// //--
// //alert(f_tool_scale_list(new Array('A','B')));

// //--
// alert(f_tool_request_info(new Array('1','A','B')));
// alert(f_tool_request_info(new Array('1','Ëü','B')));   //ÑéÖ¤ÖÐÎÄ

//alert("121,A".substr(2,2));
function get_pic_url(picName,picTypeId) {
	var  v_pic_size_id =picTypeId;
	var v_pic_type_id =picName.substring(0,1);
	var v_pic_name =picName.substring(1);

	var v_pic_path_head ="http://www.shxhui.com/pic/";
	var v_pic_path_tail =String(v_pic_type_id)
			+"/" + String(v_pic_size_id)
			+"/" + String(v_pic_name.substring(0,8))
			+"/" + String(v_pic_name)
		;

	return (v_pic_path_head +v_pic_path_tail);
}


