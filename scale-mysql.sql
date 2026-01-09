/*
MySQL Backup
Source Server Version: 5.7.17
Source Database: BH
Date: 2026/1/9 11:20:28
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
--  Procedure definition for `f_tool_scale_append`
-- ----------------------------
DROP FUNCTION IF EXISTS `f_tool_scale_append`;
DELIMITER ;;
CREATE DEFINER=`BH`@`%` FUNCTION `f_tool_scale_append`(iscale_info varchar(15360),iscale_segment varchar(15360)) RETURNS varchar(15360) CHARSET utf8mb4
myloop:
BEGIN
	#Routine body goes here...
  /*myinfo
    01 scale格式__组包
	  02 
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */
  declare oinfo varchar(15360);

  #,scale
  declare v_scale_0 int;
  declare v_scale_cfg varchar(1024);
  declare v_scale_cfg_length int;
  declare v_scale_info varchar(15360);
  declare v_scale_segment varchar(15360);
  #s, 设定操作异常返回值
  set oinfo='';
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, x

  #s,scale格式
  if ifnull(iscale_info,'') ='' then 
    #,新增
    set v_scale_cfg ='';
    set v_scale_info ='';   
  else 
    #,已有
    set v_scale_0 =substr(iscale_info,1,1);
    set v_scale_cfg_length =substr(iscale_info,2,v_scale_0);
    set v_scale_cfg =substr(iscale_info,1+v_scale_0+1,v_scale_cfg_length);
    set v_scale_info =substr(iscale_info,1+v_scale_0+v_scale_cfg_length+1);
  end if;

  #,
  set v_scale_segment =iscale_segment;
  set v_scale_cfg =concat(v_scale_cfg,char_length(v_scale_segment),',');
  set v_scale_info =concat(v_scale_info,v_scale_segment);

  #,scale_end
  set v_scale_cfg_length =char_length(v_scale_cfg);
  set v_scale_0=char_length(v_scale_cfg_length);
  set v_scale_info =concat(v_scale_0,v_scale_cfg_length,v_scale_cfg,v_scale_info);
  set oInfo =concat(oInfo,v_scale_info);

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, 设定操作完成返回值 
  return oinfo;
END
;;
DELIMITER ;

-- ----------------------------
--  Procedure definition for `f_tool_scale_at`
-- ----------------------------
DROP FUNCTION IF EXISTS `f_tool_scale_at`;
DELIMITER ;;
CREATE DEFINER=`BH`@`%` FUNCTION `f_tool_scale_at`(iscale_info varchar(15360),iscale_at int) RETURNS varchar(15360) CHARSET utf8mb4
myloop:
BEGIN
	#Routine body goes here...
  /*myinfo
    01 scale格式__获取指定刻度的info
	  02 
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */
  declare oinfo varchar(15360);

  #,scale
  declare v_scale_0 int;
  declare v_scale_cfg varchar(1024);
  declare v_scale_cfg_length int;
  declare v_scale_info varchar(15360);
  declare v_sclae_segment varchar(15360);

  #
  declare v_counter int;
  declare v_ix_delimiter_A int;
  declare v_ix_delimiter_B int;
  declare v_scale_info_A int;
  declare v_scale_info_B int;
  #s, 设定操作异常返回值
  set oinfo='';
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, x

  #s,验证输入
  if iscale_info is null 
     or iscale_info='' 
     or iscale_at is null then         
     set oinfo ='';
     return oinfo;
  end if;

  #,
  set v_scale_0 =substr(iscale_info,1,1);
  set v_scale_cfg_length =substr(iscale_info,2,v_scale_0);
  set v_scale_cfg =substr(iscale_info,1+v_scale_0+1,v_scale_cfg_length);
  #,
  set v_counter =0;
  set v_ix_delimiter_A =1;
  set v_scale_info_A =0;
  myrepeat:
  repeat 
    set v_ix_delimiter_B =locate(',',v_scale_cfg,v_ix_delimiter_A);
    set v_counter =v_counter+1;     
    if v_counter <iscale_at and v_ix_delimiter_B !=0 then        
      set v_scale_info_A =v_scale_info_A +substr(v_scale_cfg,v_ix_delimiter_A,v_ix_delimiter_B-1);
      set v_ix_delimiter_A =v_ix_delimiter_B+1;     
    else 
      leave myrepeat;
    end if;  
  until 1=0 end repeat;

  #,获取scale_info
  if v_ix_delimiter_B !=0 then 
    set v_scale_info_A =1+v_scale_0+v_scale_cfg_length +v_scale_info_A+1;
    set v_scale_info_B =substr(v_scale_cfg,v_ix_delimiter_A,v_ix_delimiter_B-v_ix_delimiter_A);
    set oinfo =substr(iscale_info,v_scale_info_A,v_scale_info_B);
  else 
    set oinfo ='';   
  end if;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, 设定操作完成返回值 
  return oinfo;
END
;;
DELIMITER ;

-- ----------------------------
--  Procedure definition for `f_tool_scale_is`
-- ----------------------------
DROP FUNCTION IF EXISTS `f_tool_scale_is`;
DELIMITER ;;
CREATE DEFINER=`BH`@`%` FUNCTION `f_tool_scale_is`(iscale_info varchar(16383)) RETURNS int(11)
myloop:
BEGIN
	#Routine body goes here...
  /*myinfo
    01 scale格式__获取指定刻度的info
	  02 
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */
  
  #,scale
  declare v_scale_0 int;
  declare v_scale_cfg varchar(16383);
  declare v_scale_cfg_length int;
  declare v_scale_info varchar(16383);
  declare v_sclae_segment varchar(16383);

  #
  declare v_counter int;
  declare v_ix_delimiter_A int;
  declare v_ix_delimiter_B int;
  declare v_scale_info_A int;
  declare v_scale_info_B int;
  #
	declare v_str_curr varchar(16383);
	declare v_scale_length int;
  declare v_scale_is01 int;
  #异常处理
	declare exit handler for SQLEXCEPTION
					begin 					
						return v_scale_is01;
					end;
  #s, 设定操作异常返回值
  set v_scale_is01 =0;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, x

  #s,验证输入  
  if iscale_info is null or iscale_info ='' then		
    return v_scale_is01;
	else 
		set v_scale_info =iscale_info;
  end if;

	
  #chk: L3	
	set v_str_curr =substr(v_scale_info,1,1);
	set v_scale_length =cast(v_str_curr as signed);
	if v_scale_length >=1 and v_scale_length <=9 then 
	  set v_scale_0 =v_scale_length;
	else 
		return v_scale_is01;
	end if;
  #chk: L2
	set v_str_curr =substr(v_scale_info,2,v_scale_length);
	if char_length(v_str_curr) =v_scale_length then 
		set v_scale_length =cast(v_str_curr as signed);
	else 
		return v_scale_is01;
	end if;
	if v_scale_length >=1 and v_scale_length <=power(10,v_scale_0)-1 then 
	  set v_scale_is01 =0;
	else 
		return v_scale_is01;
	end if;
  #chk: L1
	set v_str_curr =substr(v_scale_info,(1+v_scale_0+1),v_scale_length);
	if char_length(v_str_curr) =v_scale_length then 
		set v_scale_is01 =1;
	else 
		return v_scale_is01;
	end if;
   
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, 设定操作完成返回值 
  return v_scale_is01;
END
;;
DELIMITER ;

-- ----------------------------
--  Procedure definition for `f_tool_scale_len`
-- ----------------------------
DROP FUNCTION IF EXISTS `f_tool_scale_len`;
DELIMITER ;;
CREATE DEFINER=`BH`@`%` FUNCTION `f_tool_scale_len`(iscale_info varchar(16383)) RETURNS int(11)
    DETERMINISTIC
myloop:
BEGIN
	#Routine body goes here...
  /*myinfo
    01 scale格式__获取指定刻度的info
	  02 
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */
  declare oinfo int;

  #,scale
  declare v_scale_0 int;
  declare v_scale_cfg varchar(16383);
  declare v_scale_cfg_length int;
  declare v_scale_info varchar(16383);
  declare v_sclae_segment varchar(16383);

  #
  declare v_counter int;
  declare v_ix_delimiter_A int;
  declare v_ix_delimiter_B int;
  declare v_scale_info_A int;
  declare v_scale_info_B int;
  #
	declare v_str_curr varchar(16383);
	declare v_scale_length int;
  #异常处理
	declare exit handler for SQLEXCEPTION
					begin 					
						return v_counter;
					end;
  #s, 设定操作异常返回值
  set v_counter =0;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, x

  #s,验证输入
  if iscale_info is null or iscale_info ='' then		
    return v_counter;
	else 
		set v_scale_info =iscale_info;
  end if;


  #chk: L3	
	set v_scale_length =1;
	set v_str_curr =substr(v_scale_info,1,v_scale_length);
	set v_scale_length =cast(v_str_curr as signed);
	if v_scale_length >=1 and v_scale_length <=9 then 
	  set v_scale_0 =v_scale_length;
	else 
		return v_counter;
	end if;
  #chk: L2
	set v_str_curr =substr(v_scale_info,2,v_scale_length);
	if char_length(v_str_curr) =v_scale_length then 
		set v_scale_length =cast(v_str_curr as signed);
	else 
		return v_counter;
	end if;
	if v_scale_length >=1 and v_scale_length <=power(10,v_scale_0)-1 then 
	  set v_counter =0;
	else 
		return v_counter;
	end if;
  #chk: L1
	set v_str_curr =substr(v_scale_info,(1+v_scale_0+1),v_scale_length);
	if char_length(v_str_curr) =v_scale_length then 
		set v_scale_cfg =v_str_curr;
	else 
		return v_counter;
	end if;

  #,
  #set v_scale_0 =substr(iscale_info,1,1);
  #set v_scale_cfg_length =substr(iscale_info,2,v_scale_0);
  #set v_scale_cfg =substr(iscale_info,1+v_scale_0+1,v_scale_cfg_length);
  #,
  set v_counter =0;
  set v_ix_delimiter_A =1;
  set v_scale_info_A =0;
  myrepeat:
  repeat 
    set v_ix_delimiter_B =locate(',',v_scale_cfg,v_ix_delimiter_A);         
    if v_ix_delimiter_B !=0 then          
			set v_counter =v_counter +1;    
      set v_ix_delimiter_A =v_ix_delimiter_B +1;     
    else 
      leave myrepeat;
    end if;  
  until 1=0 end repeat;


	set oinfo =v_counter;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, 设定操作完成返回值 
  return oinfo;
END
;;
DELIMITER ;

-- ----------------------------
--  Procedure definition for `f_tool_scale_list`
-- ----------------------------
DROP FUNCTION IF EXISTS `f_tool_scale_list`;
DELIMITER ;;
CREATE DEFINER=`BH`@`%` FUNCTION `f_tool_scale_list`(ilist varchar(15360)) RETURNS varchar(10240) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
myloop:
BEGIN
	#Routine body goes here...
  /*myinfo
    01 say something
	  02 组包scale格式：以逗号分割的列表
		03 char(11)
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */

  declare oinfo varchar(15360);
  declare v_sign_cut varchar(1);
  declare v_ix_A int;
  declare v_ix_B int;
  declare v_AB varchar(10240);
  #s, 设定操作异常返回值
  set oinfo =null;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, x

	if ifnull(ilist,'') ='' then 
		return null;
  end if;

  #s, 
  set v_sign_cut =substr(ilist,1,1);
  
  set v_ix_A =2;
  set v_ix_B =locate(v_sign_cut,ilist,v_ix_A);
  myrepeat:
  repeat     

    set v_AB=substr(ilist,v_ix_A,v_ix_B -v_ix_A);    
    set oinfo =f_tool_scale_append(oinfo,v_AB);     
    set v_ix_A =v_ix_B +1;
    set v_ix_B =locate(v_sign_cut,ilist,v_ix_A);

    #,
    if v_ix_B >0 then 
			set v_ix_B =v_ix_B;
		else
      leave myrepeat;
    end if;
  until 1=0 end repeat;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, 设定操作完成返回值 
  return oinfo;
END
;;
DELIMITER ;

-- ----------------------------
--  Procedure definition for `f_tool_scale_list3s`
-- ----------------------------
DROP FUNCTION IF EXISTS `f_tool_scale_list3s`;
DELIMITER ;;
CREATE DEFINER=`root`@`%` FUNCTION `f_tool_scale_list3s`(ilist varchar(15360)) RETURNS varchar(10240) CHARSET utf8mb4 COLLATE utf8mb4_unicode_ci
myloop:
BEGIN
	#Routine body goes here...
  /*myinfo
    01 say something
	  02 组包scale格式：以逗号分割的列表
	  03 分隔符参考：char(9),char(10),char(11)
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */

  declare oinfo varchar(15360);
  declare v_sign_cut varchar(3);
  declare v_ix_A int;
  declare v_ix_B int;
  declare v_AB varchar(10240);
  #s, 设定操作异常返回值
  set oinfo =null;
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, x

	if ifnull(ilist,'') ='' then 
		return null;
  end if;

  #s, 
  set v_sign_cut =substr(ilist,1,3);
  
  set v_ix_A =4;
  set v_ix_B =locate(v_sign_cut,ilist,v_ix_A);
  myrepeat:
  repeat     

    set v_AB=substr(ilist,v_ix_A,v_ix_B -v_ix_A); 
    set oinfo =f_tool_scale_append(oinfo,v_AB);  
    set v_ix_A =v_ix_B +3;
    set v_ix_B =locate(v_sign_cut,ilist,v_ix_A);

    #,
    if v_ix_B >0 then 
			set v_ix_B =v_ix_B;
		else
      leave myrepeat;
    end if;
  until 1=0 end repeat;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, 设定操作完成返回值 
  return oinfo;
END
;;
DELIMITER ;

-- ----------------------------
--  Procedure definition for `f_tool_scale_update`
-- ----------------------------
DROP FUNCTION IF EXISTS `f_tool_scale_update`;
DELIMITER ;;
CREATE DEFINER=`BH`@`%` FUNCTION `f_tool_scale_update`(isource_scale varchar(16383),iupdate_pos int,iupdate_info varchar(16383)) RETURNS varchar(16383) CHARSET utf8
myloop:
BEGIN
	#Routine body goes here...
  /*myinfo
    01 scale格式__组包
	  02 
    -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- */
  declare oinfo varchar(15360);

  #,scale
  declare v_scale_0 int;
  declare v_scale_cfg varchar(16383);
  declare v_scale_cfg_length int;
  declare v_scale_info varchar(16383);
  declare v_scale_segment varchar(16383);
  #
	declare v_source_scale varchar(16383);
	declare v_source_count int;
	declare v_update_pos int;
	declare v_update_info varchar(16383);
	declare v_pos_curr int;
	declare v_pos_info varchar(16383);
  #s, 设定操作异常返回值
  set oinfo='';
  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, x
	set v_source_scale =isource_scale;
	set v_update_pos =iupdate_pos;
	set v_update_info =iupdate_info;
  
	#chk：输入参数
	if char_length(v_source_scale) >0 and char_length(v_update_info) >=0 and v_update_pos >0 then 
		set oinfo =null;
	else 
		return v_source_scale;
	end if;
  #
	set v_scale_0 =substr(v_source_scale,1,1);
	set v_scale_cfg_length =substr(v_source_scale,2,v_scale_0);
	set v_scale_cfg =substr(v_source_scale,1+v_scale_0+1,v_scale_cfg_length);
	set v_source_count =v_scale_cfg_length -char_length(replace(v_scale_cfg,',',''));

	#chk：超出位置
	if v_update_pos >v_source_count then 
		return v_source_scale;
	end if;
  #
  set v_pos_curr =1;
	set oinfo ='';
  myrepeat:
  repeat     
    #
		if v_pos_curr =v_update_pos then 
			set oinfo =f_tool_scale_append(oinfo,v_update_info);
		else 
			set v_pos_info =f_tool_scale_at(v_source_scale,v_pos_curr);
			set oinfo =f_tool_scale_append(oinfo,v_pos_info);
		end if;

		#计数器
		if v_pos_curr =v_source_count then 
			leave myrepeat;
		else 
			set v_pos_curr =v_pos_curr +1;
		end if;				
  until 1=0 end repeat;

  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --  -- --
  #s, 设定操作完成返回值 
  return oinfo;
END
;;
DELIMITER ;

-- ----------------------------
--  Records 
-- ----------------------------
