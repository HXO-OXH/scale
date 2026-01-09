package mymodule;

import java.util.List;

/*
 * 组件名称：scaleInfo
 * 组件描述：
 * 		1.scale格式数据
 * 	
 * */

//scale格式： 数据操作
public class scaleInfo {

	//顺序组包
	public static String f_tool_scale_list(List<String> list) {

		String oinfo;
		oinfo = "";
		// 读取list
		for (int i = 0; i < list.size(); i++) {
			oinfo = f_tool_scale_append(oinfo, list.get(i));
		}
		return oinfo;
	}

	//组包请求参数：分支ID+info数据
	public static String f_tool_request_info(List<String> list) {

		String v_branchID;
		String v_dataSegment;
		String v_requestInfo;

		v_branchID = "";
		v_dataSegment = "";
		//读取list
		for (int i = 0; i < list.size(); i++) {
			if (i == 0) {
				v_branchID = list.get(i);
				v_dataSegment = "";
			} else {
				v_dataSegment = f_tool_scale_append(v_dataSegment, list.get(i));
			}
		}

		// 请求参数
		v_requestInfo = "";
		v_requestInfo = f_tool_scale_append(v_requestInfo, v_branchID); // +分支ID
		v_requestInfo = f_tool_scale_append(v_requestInfo, v_dataSegment);//+数据段
		return v_requestInfo;
	}

	//追加scale:
	public static String f_tool_scale_append(String iscale_info,
			String iscale_segment) {

		String oinfo;

		//
		int v_scale_0; //scale根位置

		String v_scale_cfg; //配置数据
		int v_scale_cfg_length; //配置数据__长度

		// String v_scale_info; //info数据
		String v_scale_info;
		String v_scale_segment;

		//设定操作异常返回值
		oinfo = "";
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		// -- -- --
		// s,scale格式
		if (iscale_info == null || iscale_info.equals("")) {
			//,新增
			v_scale_cfg = "";
			v_scale_info = "";
		} else {
			//,已有
			v_scale_0 = Integer.parseInt(iscale_info.substring(0, 1));
			v_scale_cfg_length = Integer.parseInt(iscale_info.substring(1,
					v_scale_0 + 1));
			v_scale_cfg = iscale_info.substring(1 + v_scale_0, 1 + v_scale_0
					+ v_scale_cfg_length);
			v_scale_info = iscale_info.substring(1 + v_scale_0
					+ v_scale_cfg_length, iscale_info.length());
		}

		// ,
		v_scale_segment = iscale_segment;
		v_scale_cfg = v_scale_cfg + v_scale_segment.length() + ",";
		v_scale_info = v_scale_info + v_scale_segment;

		// ,scale_end
		v_scale_cfg_length = v_scale_cfg.length();
		v_scale_0 = Integer.toString(v_scale_cfg_length).length();
		v_scale_info = Integer.toString(v_scale_0)
				+ Integer.toString(v_scale_cfg_length) + v_scale_cfg
				+ v_scale_info;
		oinfo = oinfo + v_scale_info;
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		// -- -- --
		 //,scale_end
		return oinfo;
	}

	//解析sclae:  获取指定位置的数据段
	public static String f_tool_scale_get(String iScaleStr, int whichSegment) {

		String oinfo;

		//
		int v_scale_0; //scale根位置

		String v_scale_cfg;  //配置数据
		int v_scale_cfg_length; //配置数据__长度

		// String v_scale_info;  //info数据
		int v_scale_info_A;  //info数据__起始位置
		int v_scale_info_B;  //info数据__结束位置

		//设定操作异常返回值
		oinfo = "";
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		// -- -- --
		//,验证scale数据包不为空
		if (iScaleStr == null || iScaleStr.equals("")) {
			oinfo = "";
			return oinfo;
		} else {
			//,scale根位置
			v_scale_0 = Integer.parseInt(iScaleStr.substring(0, 1));
			v_scale_cfg_length = Integer.parseInt(iScaleStr.substring(1,
					v_scale_0 + 1));
			v_scale_cfg = iScaleStr.substring(v_scale_0 + 1, v_scale_0
					+ v_scale_cfg_length + 1);

			//,获取段__相关配置数据
			int v_counter;
			int v_ix_delimiter_A;
			int v_ix_delimiter_B;
			v_counter = 0;
			v_ix_delimiter_A = 0;
			v_scale_info_A = 0;
			do {
				v_ix_delimiter_B = v_scale_cfg.indexOf(",", v_ix_delimiter_A);
				v_counter = v_counter + 1;
				if (v_counter < whichSegment && v_ix_delimiter_B != -1) {
					//同步	与数据段首部的距离长度
					v_scale_info_A = v_scale_info_A
							+ Integer.parseInt(v_scale_cfg.substring(
									v_ix_delimiter_A, v_ix_delimiter_B));
					 //重置
					v_ix_delimiter_A = v_ix_delimiter_B + 1;
				} else {
					break;
				}
			} while (true);

			//获取oinfo
			if (v_ix_delimiter_B != -1) {
				v_scale_info_A = 1 + v_scale_0 + v_scale_cfg_length
						+ v_scale_info_A;
				v_scale_info_B = v_scale_info_A
						+ Integer.parseInt(v_scale_cfg.substring(
								v_ix_delimiter_A, v_ix_delimiter_B));

				oinfo = iScaleStr.substring(v_scale_info_A, v_scale_info_B);
			} else {
				oinfo = "";
			}
		}
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
		// -- -- --
	   //设定操作完成返回值
		return oinfo;
	}

}