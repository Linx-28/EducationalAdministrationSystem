package com.example.eduadmin.filter;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class LoginFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) resp;
        
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());
        
        if (path.startsWith("/views/login.jsp") || path.equals("/login") || path.equals("/home")
                || path.equals("/views/index.jsp") || path.startsWith("/static/")
                || path.startsWith("/views/error/")) {
            chain.doFilter(req, resp);
            return;
        }
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            chain.doFilter(req, resp);
        } else {
            response.sendRedirect(contextPath + "/views/login.jsp");
        }
    }
    
    @Override
    public void destroy() {}
}