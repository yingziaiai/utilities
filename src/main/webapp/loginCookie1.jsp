<%@ page language="java" pageEncoding="UTF-8" isErrorPage="false" %>
<jsp:directive.page import="java.security.MessageDigest"/>
<%!
	// 密钥
	private static final String KEY = ":cookie@helloweenvsfei.com";

	// MD5 加密算法
	public final static String calcMD5(String ss) {
	  
	   String s = ss==null ? "" : ss;
	  
	   char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f' };
	   try {
	    byte[] strTemp = s.getBytes();
	    MessageDigest mdTemp = MessageDigest.getInstance("MD5");
	    mdTemp.update(strTemp);
	    byte[] md = mdTemp.digest();
	    int j = md.length;
	    char str[] = new char[j * 2];
	    int k = 0;
	    for (int i = 0; i < j; i++) {
	     byte byte0 = md[i];
	     str[k++] = hexDigits[byte0 >>> 4 & 0xf];
	     str[k++] = hexDigits[byte0 & 0xf];
	    }
	    return new String(str);
	   } catch (Exception e) {
	    return null;
	   }
	}

%>


<%
	request.setCharacterEncoding("UTF-8"); 
    response.setCharacterEncoding("UTF-8");
   
    String action =request.getParameter("action");
    action = "login";
   
    if("login".equals(action)){
        String account =request.getParameter("account");
                                                    
        String password =request.getParameter("password");
                                                  
        int timeout = new Integer(request.getParameter("timeout"));
                                                 
              
        String ssid =calcMD1(account + KEY);
       
        Cookie accountCookie = new Cookie("account", account);
                                       
       accountCookie.setMaxAge(timeout); 
       
        Cookie ssidCookie =new Cookie("ssid", ssid);
       ssidCookie.setMaxAge(timeout);         
       
       response.addCookie(accountCookie); 
       response.addCookie(ssidCookie);  
       
       response.sendRedirect(request.getRequestURI() + "?" + System.currentTimeMillis());
        return;
    }
    else if("logout".equals(action)){ 
        Cookie accountCookie = new Cookie("account", "");
                                      
       accountCookie.setMaxAge(0);
              
        Cookie ssidCookie =new Cookie("ssid", "");
       ssidCookie.setMaxAge(0); 
       response.addCookie(accountCookie); 
       response.addCookie(ssidCookie);
     
       response.sendRedirect(request.getRequestURI() + "?" + System.currentTimeMillis());
        return;
    }
    boolean login = false; 
    String account = null; 
    String ssid = null;  
   
    if(request.getCookies() !=null){   
        for(Cookie cookie :request.getCookies()){ 
           if(cookie.getName().equals("account"))
                                                  
               account = cookie.getValue();  
           if(cookie.getName().equals("ssid"))
               ssid = cookie.getValue(); 
        }
    }
    if(account != null && ssid !=null){ 
        login =ssid.equals(calcMD1(account + KEY));
                               
    }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
<legend><%=login? "欢迎您回来" : "请先登录"%></legend>
<%
	if(login){
%>
欢迎您, ${cookie.account.value}. &nbsp;&nbsp;
<a href=" ${pageContext.request.requestURL}?action=logout">cancel</a>
<%
	}else {
%>
<form action="login" method="post">
	<table>
  
		<tr>
			<td>账号：</td>
			<td><input type="text" name="account" style="width: 200px;"></td>
		</tr>
		<tr>
			<td>密码：</td>
			<td><input type ="password" name="password"></td>
		</tr>
		<tr>
			<td>有效期：</td>
			<td><input type ="radio" name="timeout" value="-1">
				关闭浏览器即失效 <br />
				<input type="radio" name="timeout" value="30"  checked>
				30天 内有效 <br />
				<input type="radio" name="timeout" value="<%=Integer.MAX_VALUE%>">
				永久有效 <br /></td>
		</tr>
		<tr>
			<td></td>
			<td><input type="submit" value="登 陆" class="button"></td>
		</tr>
	</table>
</form>
<%
	}
%>
</body>
</html>


